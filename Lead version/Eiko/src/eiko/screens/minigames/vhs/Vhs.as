package eiko.screens.minigames.vhs 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import eiko.entities.Server;
	import eiko.screens.game.postgame.MinigameOverlay;
	import eiko.screens.Screen;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import eiko.utils.Math2;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ClippedSprite;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Vhs extends Screen 
	{
		private var background:Image;
		
		private var film:Vector.<Image>;
		private var b2Film:Vector.<b2Body>;
		private var body:b2Body;
		private var wall:b2Body;
		
		private var filmTop:Vector.<Image>;
		private var b2FilmTop:Vector.<b2Body>;
		private var bodyTop:b2Body;
		private var wallTop:b2Body;
		
		private var world:b2World;
		private var filmSegments:int;
		private var groundBody:b2Body;
		private var b2Iterations:int = 10;
		private var b2PositionIterations:int = 10;
		private var b2TimeStep:Number = 1.0 / 30.0;
		
		private var b2MeterRatio:int = 30;
		private var bobineTopQuad:Quad;
		private var bobineBottomQuad:Quad;
		private var bobineTop:Image;
		private var bobineBottom:Image;
		private var vhs:Image;
		private var filmsHolder:ClippedSprite;
		
		private var isRewinding:Boolean = false;
		private var gameLabel:TextField;
		
		private var completion:int = 0;
		
		[Embed(source = "/../bin/assets/Particles/bilboquet.pex", mimeType = "application/octet-stream")]
		private static const Particle:Class;
		private var mParticleSystem:PDParticleSystem;
		
		public function Vhs(params:Object = null) 
		{
			assets.enqueue('Background/Games/vhs-bg.jpg');
			assets.enqueue('Background/Games/vhs.png');
			assets.enqueue('Sounds/games/vhs/rewind.mp3');
		}
		
		protected override function added():void
		{
			background = new Image(getTexture('vhs-bg'));
			addChild(background);
			
            world = new b2World(new b2Vec2(0, 0), true);

			var psConfig:XML = XML(new Particle());
			mParticleSystem = new PDParticleSystem(psConfig, getTexture("Games/Pong/ball-particle-3"));
			addChild(mParticleSystem);
			mParticleSystem.emitterX = 800;
			mParticleSystem.emitterY = Starling.current.stage.stageHeight >> 1;
			mParticleSystem.emitterY = Starling.current.stage.stageHeight >> 1;
			
			createVHS();
			createFilm();
			
			// place the touch area on top of the films
			//swapChildren(bobineBottomQuad, film[filmSegments]);
			//swapChildren(bobineTopQuad, filmTop[filmSegments]);
			//swapChildren(bobineBottom, film[filmSegments-1]);
			//swapChildren(bobineTop, filmTop[filmSegments-1]);
			
			swapChildren(bobineBottomQuad, filmsHolder);
			swapChildren(bobineTopQuad, filmsHolder);
			swapChildren(bobineBottom, filmsHolder);
			swapChildren(bobineTop, filmsHolder);
			swapChildren(filmsHolder, vhs);

			gameLabel = new TextField(Starling.current.stage.stageHeight, Starling.current.stage.stageWidth, "Rembobine la cassette le plus vite possible !".toUpperCase(), "Aldo", 40, 0xFFFFFF);
			gameLabel.pivotX = gameLabel.width >> 1;
			gameLabel.pivotY = gameLabel.height >> 1;
			gameLabel.rotation = -Math.PI / 2;
			gameLabel.x = 200;
			gameLabel.y = Starling.current.stage.stageHeight >> 1;
			addChild(gameLabel);
			
			ScreenManager.server.addEventListener(Server.MINI_GAME_START, onGameStart);
			ScreenManager.server.send( { type: Server.MINI_GAME_START } );
        }
		
		private function onGameStart(e:Event):void 
		{
			setTimeout(function():void
			{
				TweenMax.to(gameLabel, 0.4, { alpha : 0, ease: Cubic.easeInOut } );
				ScreenManager.server.removeEventListener(Server.MINI_GAME_START, onGameStart);
				addEventListener(Event.ENTER_FRAME, enterFrame);
				ScreenManager.server.addEventListener(Server.MINI_GAME_END, onGameEnd);
		
				bobineBottomQuad.addEventListener(TouchEvent.TOUCH, touchHandler);
				bobineTopQuad.addEventListener(TouchEvent.TOUCH, touchHandler);				
			}, 1100);
        }
		
		private function onGameEnd(e:Event):void 
		{
			setTimeout(function():void
			{
				stopEvents();
				var overlay:MinigameOverlay = new MinigameOverlay( { winner: e.data.content } );
				addChild(overlay);
			}, 1000);
		}
		
		private function debugDraw():void {
            var debugDraw:b2DebugDraw = new b2DebugDraw();
            var debugSprite:Sprite = new Sprite();
            addChild(debugSprite);
            debugDraw.SetSprite(Main.debugSprite);
            debugDraw.SetDrawScale(b2MeterRatio);
            debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
            debugDraw.SetFillAlpha(0.5);
            world.SetDebugDraw(debugDraw);
        }			
		
		private function createFilm():void
		{
			var chainLength:int = 12;
            //debugDraw();

			b2Film = new Vector.<b2Body>();
			b2FilmTop = new Vector.<b2Body>();
			film = new Vector.<Image>();
			filmTop = new Vector.<Image>();
			
			// Film anchor point
            var polygonShape:b2PolygonShape = new b2PolygonShape();
         
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = 1;
            fixtureDef.friction = 1;
            fixtureDef.restitution = 0.5;
            fixtureDef.shape = polygonShape;
			
            var bodyDef:b2BodyDef = new b2BodyDef();
			
			var wallSize:int = 35;
			
			// Top node
			bodyDef.position.Set((bobineBottom.x - bobineBottom.width) / b2MeterRatio, bobineBottom.y / b2MeterRatio);
            polygonShape.SetAsBox(wallSize / b2MeterRatio, wallSize/ b2MeterRatio);
            wall = world.CreateBody(bodyDef);
            wall.CreateFixture(fixtureDef);
			// Bottom node
			bodyDef.position.Set((bobineTop.x - bobineTop.width) / b2MeterRatio, bobineTop.y / b2MeterRatio);
            polygonShape.SetAsBox(wallSize / b2MeterRatio, wallSize/ b2MeterRatio);
            wallTop = world.CreateBody(bodyDef);
            wallTop.CreateFixture(fixtureDef);
           
			// Film guides
			bodyDef.position.Set((bobineTop.x) / b2MeterRatio, (bobineTop.y - (bobineTop.height >> 1) + 15) / b2MeterRatio);
			polygonShape.SetAsBox(bobineTop.width / b2MeterRatio, 5/ b2MeterRatio);
			var guideTop:b2Body = world.CreateBody(bodyDef);
            guideTop.CreateFixture(fixtureDef);
			bodyDef.position.Set((bobineTop.x) / b2MeterRatio, (bobineTop.y + (bobineTop.height >> 1) - 15) / b2MeterRatio);
			polygonShape.SetAsBox(bobineTop.width / b2MeterRatio, 5/ b2MeterRatio);
			var guideTop2:b2Body = world.CreateBody(bodyDef);
            guideTop2.CreateFixture(fixtureDef);
			
			bodyDef.position.Set((bobineBottom.x) / b2MeterRatio, (bobineBottom.y - (bobineBottom.height >> 1) + 15) / b2MeterRatio);
			polygonShape.SetAsBox(bobineBottom.width / b2MeterRatio, 5/ b2MeterRatio);
			var guideBottom:b2Body = world.CreateBody(bodyDef);
            guideBottom.CreateFixture(fixtureDef);
			bodyDef.position.Set((bobineBottom.x) / b2MeterRatio, (bobineBottom.y + (bobineBottom.height >> 1) - 15) / b2MeterRatio);
			polygonShape.SetAsBox(bobineBottom.width / b2MeterRatio, 5/ b2MeterRatio);
			var guideBottom2:b2Body = world.CreateBody(bodyDef);
            guideBottom2.CreateFixture(fixtureDef);
			
			// Film segment
			fixtureDef.filter.groupIndex = -1;
			bodyDef.allowSleep = false;
            polygonShape.SetAsBox(2 / b2MeterRatio, chainLength / b2MeterRatio);

            fixtureDef.density = 1;
            fixtureDef.shape = polygonShape;

            bodyDef.type = b2Body.b2_dynamicBody;
			filmSegments = 40;
            for (var i:int = 0; i <= filmSegments; i++)
			{
                bodyDef.position.Set(i * 15 / b2MeterRatio, Math2.rand(0, Starling.current.stage.stageHeight) / b2MeterRatio);
                if (i == 0)
				{
                    var link:b2Body = world.CreateBody(bodyDef);
                    link.CreateFixture(fixtureDef);
                    revoluteJoint(wall, link, new b2Vec2(wallSize / b2MeterRatio, 0), new b2Vec2(0, -chainLength / b2MeterRatio));
					var linkTop:b2Body = world.CreateBody(bodyDef);
                    link.CreateFixture(fixtureDef);
                    revoluteJoint(wallTop, linkTop, new b2Vec2(0, 0), new b2Vec2(0, -chainLength / b2MeterRatio));
                }
                else
				{
                    var newLink:b2Body = world.CreateBody(bodyDef);
                    newLink.CreateFixture(fixtureDef);
                    revoluteJoint(link, newLink, new b2Vec2(0, chainLength / b2MeterRatio), new b2Vec2(0, -chainLength / b2MeterRatio));
                    link = newLink;
					var newLinkTop:b2Body = world.CreateBody(bodyDef);
                    newLinkTop.CreateFixture(fixtureDef);
                    revoluteJoint(linkTop, newLinkTop, new b2Vec2(0, chainLength / b2MeterRatio), new b2Vec2(0, -chainLength / b2MeterRatio));
                    linkTop = newLinkTop;
                }
				b2Film[i] = link;
				film[i] = new Image(getTexture('Games/VHS/tape'));
				film[i].pivotX = film[i].width >> 1;
				film[i].pivotY = film[i].height >> 1;
				//film[i].x = link.GetPosition().x;
				//film[i].y = link.GetPosition().y;
				//film[i].blendMode = BlendMode.NONE;
				filmsHolder.addChild(film[i]);
				
				b2FilmTop[i] = linkTop;
				filmTop[i] = new Image(getTexture('Games/VHS/tape'));
				filmTop[i].pivotX = filmTop[i].width >> 1;
				filmTop[i].pivotY = filmTop[i].height >> 1;
				//filmTop[i].x = linkTop.GetPosition().x;
				//filmTop[i].y = linkTop.GetPosition().y;
				//filmTop[i].blendMode = BlendMode.NONE;
				filmsHolder.addChild(filmTop[i]);
				
				//film[i].scaleX = filmTop[i].scaleX = 0.2;
			}
			// link the two films together
			var lastLink:b2Body = world.CreateBody(bodyDef);
			lastLink.CreateFixture(fixtureDef);
			revoluteJoint(b2FilmTop[filmSegments], lastLink, new b2Vec2(0, chainLength / b2MeterRatio), new b2Vec2(0, -chainLength / b2MeterRatio));
			revoluteJoint(b2Film[filmSegments], lastLink, new b2Vec2(0, chainLength / b2MeterRatio), new b2Vec2(0, -chainLength / b2MeterRatio));
		}
		
		private function createVHS():void
		{
			vhs = new Image(getTexture('vhs'));
			vhs.x = Starling.current.stage.stageWidth - vhs.width;
			addChild(vhs);
			
			// Bobine's images
			bobineTop = new Image(getTexture("Games/VHS/bobine"));
			bobineTop.x = 870;
			bobineTop.y = 213;
			bobineTop.pivotX = bobineTop.width >> 1;
			bobineTop.pivotY = bobineTop.height >> 1;
			addChild(bobineTop);
			
			bobineBottom = new Image(getTexture("Games/VHS/bobine"));
			bobineBottom.pivotX = bobineTop.width >> 1;
			bobineBottom.pivotY = bobineTop.height >> 1;
			bobineBottom.x = 870;
			bobineBottom.y = 565;
			addChild(bobineBottom);
			
			// Area for touch detection
			bobineBottomQuad = new Quad(350, 350, 0xFFFF00);
			bobineBottomQuad.x = bobineBottom.x;
			bobineBottomQuad.y = bobineBottom.y;
			bobineBottomQuad.pivotX = bobineBottomQuad.width >> 1;
			bobineBottomQuad.pivotY = bobineBottomQuad.height >> 1;
			addChild(bobineBottomQuad);
			
			bobineTopQuad = new Quad(350, 350, 0xFFFF00);
			bobineTopQuad.x = bobineTop.x;
			bobineTopQuad.y = bobineTop.y;
			bobineTopQuad.pivotX = bobineTopQuad.width >> 1;
			bobineTopQuad.pivotY = bobineTopQuad.height >> 1;
			addChild(bobineTopQuad);
			
			bobineTopQuad.alpha = bobineBottomQuad.alpha = 0;
			
			filmsHolder = new ClippedSprite();
			addChild(filmsHolder);
			filmsHolder.clipRect = new Rectangle(0, 0, bobineTop.x, Starling.current.stage.stageHeight);
		}
		
		private function revoluteJoint(bodyA:b2Body, bodyB:b2Body, anchorA:b2Vec2, anchorB:b2Vec2):void
		{
            var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
            revoluteJointDef.localAnchorA.Set(anchorA.x,anchorA.y);
            revoluteJointDef.localAnchorB.Set(anchorB.x,anchorB.y);
            revoluteJointDef.bodyA = bodyA;
            revoluteJointDef.bodyB = bodyB;
			revoluteJointDef.lowerAngle = 270 / (180/Math.PI);
			revoluteJointDef.upperAngle = 90 / (180/Math.PI);
            world.CreateJoint(revoluteJointDef);
        }
		
		private function touchHandler(e:TouchEvent):void 
		{
			var touches:Vector.<Touch> = e.getTouches(e.currentTarget as Quad, TouchPhase.MOVED);
			
			if (touches)
			{
				assets.play("rewind");
				
				if (touches.length == 1)
				{
					// One finger rotate
					var currentPos:Point  = touches[0].getLocation(parent);
					var previousPos:Point = touches[0].getPreviousLocation(parent);
					var bobine:Image = getBobine(e.currentTarget as Quad);
					var bobinePos:Point  = new Point(bobine.x, bobine.y);
					rotateHandler(currentPos, previousPos, bobinePos, bobinePos, bobine, getSolid(e.currentTarget as Quad));
					completion += 2;
				}
				
				else if (touches.length == 2)
				{
					// Two fingers rotate
					var currentPosA:Point  = touches[0].getLocation(parent);
					var previousPosA:Point = touches[0].getPreviousLocation(parent);
					var currentPosB:Point  = touches[1].getLocation(parent);
					var previousPosB:Point = touches[1].getPreviousLocation(parent);
					rotateHandler(currentPosA, previousPosA, currentPosB, previousPosB, getBobine(e.currentTarget as Quad), getSolid(e.currentTarget as Quad));
					completion += 1;
				}
				
				else if (touches.length == 0)
				{
					isRewinding = false;
				}
			}
		}
		
		private function getBobine(bobineQuad:Quad):Image
		{
			if (bobineQuad == bobineBottomQuad) return bobineBottom;
			else if (bobineQuad == bobineTopQuad) return bobineTop;
			return null;
		}
		
		private function getSolid(bobineQuad:Quad):b2Body
		{
			if (bobineQuad == bobineBottomQuad) return wall;
			else if (bobineQuad == bobineTopQuad) return wallTop;
			return null;
		}
		
		private function rotateHandler(currentPosA:Point, previousPosA:Point, currentPosB:Point, previousPosB:Point, target:DisplayObject, solid:b2Body):void
		{			
			var currentVector:Point  = currentPosA.subtract(currentPosB);
			var previousVector:Point = previousPosA.subtract(previousPosB);
			
			var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
			var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
			var deltaAngle:Number = currentAngle - previousAngle;
			
			//solid.SetAngle(wall.GetAngle() + deltaAngle);
			solid.SetPosition(new b2Vec2(solid.GetPosition().x + 0.5, solid.GetPosition().y));
			target.rotation += deltaAngle;
		}
		
		private function notifyWin():void
		{
			ScreenManager.server.send( { type: Server.MINI_GAME_END, content: "self" } );
		}
		
		private function enterFrame(e:Event):void 
		{
			world.Step(b2TimeStep, b2Iterations, b2PositionIterations);
			world.ClearForces();
			//world.DrawDebugData();
			
			for (var i:int = 0, pos:b2Vec2; i <= filmSegments; i++)
			{
				pos = b2Film[i].GetPosition();
				film[i].x = pos.x * b2MeterRatio;
				film[i].y = pos.y * b2MeterRatio;
				film[i].rotation = Math2.normalizeAngle(b2Film[i].GetAngle());
				
				pos = b2FilmTop[i].GetPosition();
				filmTop[i].x = pos.x * b2MeterRatio;
				filmTop[i].y = pos.y * b2MeterRatio;
				filmTop[i].rotation = Math2.normalizeAngle(b2FilmTop[i].GetAngle());
			}

			if (completion > 550)
			{
				stopEvents();
				mParticleSystem.start();
				Starling.juggler.add(mParticleSystem);
				ScreenManager.server.send( { type: Server.MINI_GAME_END, content: "self" } );
			}
		}
	
		
		public override function transitionIn():void
		{
			transitionTl.insert(TweenMax.to(this, 0.4, { alpha: 1, ease:Linear.easeNone } ), 0);
		}
		
		private function stopEvents():void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			bobineBottomQuad.removeEventListener(TouchEvent.TOUCH, touchHandler);
			bobineTopQuad.removeEventListener(TouchEvent.TOUCH, touchHandler);		
		}
		
		public override function dispose():void
		{
			stopEvents();
			mParticleSystem.stop();
			Starling.juggler.remove(mParticleSystem);
			ScreenManager.server.removeEventListener(Server.MINI_GAME_END, onGameEnd);
			assets.purge();
		}
	}

}