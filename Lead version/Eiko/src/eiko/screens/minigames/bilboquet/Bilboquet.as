package eiko.screens.minigames.bilboquet 
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import eiko.entities.Server;
	import eiko.screens.game.postgame.MinigameOverlay;
	import eiko.screens.Screen;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import eiko.utils.Math2;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Bilboquet extends Screen 
	{
		private var ombre:Image;
		private var boule:Image;
		private var baton:Image;
		
		private var accelerometer:Accelerometer;
		private var accelX:Number = 0;
		private var accelY:Number = 0;
		private var prevX:Number = 0;
		private var center:Quad;
		private var goal:Quad;
		private var background:Image;
		
		private var rope:Vector.<Quad>;
		private var b2Rope:Vector.<b2Body>;
		private var b2Ball:b2Body;
		
		private var world:b2World;
		private var ropeSegments:int;
		private var groundBody:b2Body;
		private var debugQuad:Quad;
		private var b2Iterations:int = 10;
		private var b2PositionIterations:int = 10;
		private var b2TimeStep:Number = 1.0 / 60.0;
		
		private var b2MeterRatio:int = 30;
		private var body:b2Body;
		
		[Embed(source = "/../bin/assets/Particles/bilboquet.pex", mimeType = "application/octet-stream")]
		private static const Particle:Class;
		private var mParticleSystem:PDParticleSystem;
		private var gameLabel:TextField;
		
		public function Bilboquet(params:Object) 
		{
			alpha = 1;
			//loader = new ImagesLoader('Background/Games/bilboquet.jpg');
			assets.enqueue('Background/Games/bilboquet.jpg');
		}
		
		protected override function added():void
		{
			background = new Image(getTexture('bilboquet'));
			addChild(background);
			
            world = new b2World(new b2Vec2(20, 0), true);
			
			createBilboquet();
			createRope();
			swapChildren(boule, center);
			swapChildren(boule, rope[ropeSegments]);
			
			if ( Accelerometer.isSupported )
			{
				accelerometer = new Accelerometer();
				accelerometer.addEventListener( AccelerometerEvent.UPDATE, updateAccelerometer);
		 	}
			
			var psConfig:XML = XML(new Particle());
			//mParticleSystem = new PDParticleSystem(psConfig, getTexture("Games/Pong/particle"));
			mParticleSystem = new PDParticleSystem(psConfig, getTexture("Games/Pong/ball-particle-3"));

			addChild(mParticleSystem);
			Starling.juggler.add(mParticleSystem);
			mParticleSystem.emitterX = goal.x;
			mParticleSystem.emitterY = goal.y;
			
			gameLabel = new TextField(Starling.current.stage.stageHeight, Starling.current.stage.stageWidth, "Mets la boule sur le bâton pour gagner !".toUpperCase(), "Aldo", 45, 0xFFFFFF);
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
				TweenMax.to(gameLabel, 0.4, { alpha: 0, ease: Cubic.easeInOut } );
				ScreenManager.server.removeEventListener(Server.MINI_GAME_START, onGameStart);
				addEventListener(Event.ENTER_FRAME, enterFrame);
				ScreenManager.server.addEventListener(Server.MINI_GAME_END, onGameEnd);				
			}, 700);
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
		
		private function createRope():void
		{
			var chainLength:int = 12;
            //debugDraw();

			b2Rope = new Vector.<b2Body>();
			rope = new Vector.<Quad>();
			
			// Rope anchor point
            var polygonShape:b2PolygonShape = new b2PolygonShape();
         
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = 1;
            fixtureDef.friction = 1;
            fixtureDef.restitution = 0.5;
            fixtureDef.shape = polygonShape;
			fixtureDef.filter.groupIndex = -1;

            var bodyDef:b2BodyDef = new b2BodyDef();
			
            bodyDef.position.Set((goal.x + 5) / b2MeterRatio, (goal.y + (goal.height >> 1) + 5) / b2MeterRatio);
			polygonShape.SetAsBox(10 / b2MeterRatio, 5/ b2MeterRatio);
			var leftWall:b2Body = world.CreateBody(bodyDef);
            leftWall.CreateFixture(fixtureDef);
			
			bodyDef.position.Set((goal.x + 5) / b2MeterRatio, (goal.y - (goal.height >> 1) - 5) / b2MeterRatio);
			polygonShape.SetAsBox(10 / b2MeterRatio, 5/ b2MeterRatio);
			var rightWall:b2Body = world.CreateBody(bodyDef);
            rightWall.CreateFixture(fixtureDef);
			
			bodyDef.position.Set((goal.x + (goal.width >> 1) + 10) / b2MeterRatio, (baton.y - 2) / b2MeterRatio);
            polygonShape.SetAsBox(10 / b2MeterRatio, (goal.height - 10)/ b2MeterRatio);
            var wall:b2Body = world.CreateBody(bodyDef);
            wall.CreateFixture(fixtureDef);
           
			// Rope segment
            polygonShape.SetAsBox(2 / b2MeterRatio, chainLength / b2MeterRatio);

            fixtureDef.density = 3;
            fixtureDef.shape = polygonShape;

            bodyDef.type = b2Body.b2_dynamicBody;
			ropeSegments = 15;
            for (var i:int = 0; i <= ropeSegments; i++)
			{
                bodyDef.position.Set(((Starling.current.stage.stageWidth >> 1) + i * 30) / b2MeterRatio, (Starling.current.stage.stageHeight >> 1) / b2MeterRatio);
                if (i == 0)
				{
                    var link:b2Body = world.CreateBody(bodyDef);
                    link.CreateFixture(fixtureDef);
                    revoluteJoint(wall, link, new b2Vec2(130 / b2MeterRatio, 10 / b2MeterRatio), new b2Vec2(0, -chainLength / b2MeterRatio));
                }
                else
				{
                    var newLink:b2Body = world.CreateBody(bodyDef);
                    newLink.CreateFixture(fixtureDef);
                    revoluteJoint(link, newLink, new b2Vec2(0, chainLength / b2MeterRatio), new b2Vec2(0, -chainLength / b2MeterRatio));
                    link = newLink;
                }
				b2Rope[i] = link;
				rope[i] = new Quad(5, chainLength * 2, 0xDDDDDD);
				rope[i].pivotX = rope[i].width >> 1;
				rope[i].pivotY = rope[i].height >> 1;
				addChild(rope[i]);
            }
	
			// Ball body
            var circleShape:b2CircleShape = new b2CircleShape(0.3);
            fixtureDef.shape = circleShape;
			fixtureDef.density = 0.5;
			fixtureDef.filter.groupIndex = 0;
            b2Ball = world.CreateBody(bodyDef);
            b2Ball.CreateFixture(fixtureDef);
            revoluteJoint(link, b2Ball, new b2Vec2(0, chainLength / b2MeterRatio), new b2Vec2(0, 0));
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
		
		private function createBilboquet():void
		{
			ombre = new Image(getTexture('Games/Bilboquet/ombre_boule'));
			boule = new Image(getTexture('Games/Bilboquet/boule'));
			baton = new Image(getTexture('Games/Bilboquet/corps-bilboquet'));
			addChild(ombre);
			addChild(baton);
			addChild(boule);
			
			ombre.alpha = 0.7;
			ombre.pivotX = ombre.width >> 1;
			ombre.pivotY = ombre.height >> 1;
			
			boule.x = (Starling.current.stage.stageWidth >> 1) + (Starling.current.stage.stageWidth >> 2);
			boule.y = (Starling.current.stage.stageHeight >> 1) + boule.height;
			boule.pivotX = boule.width >> 1;
			boule.pivotY = boule.height >> 1;
			boule.scaleX = boule.scaleY = 0.7;
			ombre.x = Starling.current.stage.stageWidth - 110;
			ombre.y = boule.y;
			
			baton.x = (Starling.current.stage.stageWidth >> 1) - (Starling.current.stage.stageWidth >> 4);
			baton.y = (Starling.current.stage.stageHeight >> 1);
			baton.pivotX = baton.width >> 1;
			baton.pivotY = baton.height >> 1;
			baton.rotation = -90 * Math.PI / 180;
			baton.scaleX = baton.scaleY = 0.7;
						
			goal = new Quad(30, 45, 0x1111CC);
			goal.pivotX = goal.width >> 1;
			goal.pivotY = goal.height >> 1;
			goal.x = baton.x - 140;
			goal.y = baton.y - 2;
			goal.visible = false;
			addChild(goal);
			
			center = new Quad(40, 40, 0xCCCC11);
			center.pivotX = center.width >> 1;
			center.pivotY = center.height >> 1;
			center.x = boule.x;
			center.y = boule.y;
			center.visible = false;
			addChild(center);
		}
		
		private function updateAccelerometer(e:AccelerometerEvent):void 
		{
			world.SetGravity(new b2Vec2(-e.accelerationX * 80, e.accelerationY * 50));
		}
		
		private function enterFrame(e:Event):void 
		{			
			world.Step(b2TimeStep, b2Iterations * 2, b2PositionIterations);
			world.ClearForces();
			//world.DrawDebugData();
			
			for (var i:int = 0, pos:b2Vec2; i < ropeSegments; i++)
			{
				pos = b2Rope[i].GetPosition();
				rope[i].x = pos.x * b2MeterRatio;
				rope[i].y = pos.y * b2MeterRatio;
				rope[i].rotation = Math2.normalizeAngle(b2Rope[i].GetAngle());
			}
			
			var boulePos:b2Vec2 = b2Ball.GetPosition();
			boule.x = boulePos.x * b2MeterRatio;
			boule.y = boulePos.y * b2MeterRatio;
			boule.rotation = Math2.normalizeAngle(b2Rope[ropeSegments].GetAngle());
			
			center.x = boule.x;
			center.y = boule.y;
			
			ombre.y = boule.y;
			ombre.scaleX = ombre.scaleY = (boule.x / Starling.current.stage.stageWidth) + 0.3;
			
			b2Ball.ApplyForce(new b2Vec2(accelX, accelY), b2Ball.GetPosition());
			
			if (Math2.collision(center, goal))
			{
				stopEvents();
				mParticleSystem.start();
				setTimeout(function():void
				{
					mParticleSystem.stop();
				}, 700);
				TweenMax.to(boule, 1, { x: goal.x - 25, y: goal.y, ease:Cubic.easeInOut, onComplete: notifyWin});
			}
		}
		
		private function notifyWin():void
		{
			ScreenManager.server.send( { type: Server.MINI_GAME_END, content: "self" } );
		}
	
		private function stopEvents():void
		{
			if ( Accelerometer.isSupported )
			{
				accelerometer.removeEventListener( AccelerometerEvent.UPDATE, updateAccelerometer);
			}
			removeEventListener(Event.ENTER_FRAME, enterFrame);			
		}
		
		public override function dispose():void
		{
			stopEvents();
			ScreenManager.server.addEventListener(Server.MINI_GAME_END, onGameEnd);
			assets.purge();
		}
		
	}

}