package eiko.screens.minigames.pong 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
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
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Pong extends Screen 
	{
		private var background:Image;
		private var bar:Image;
		private var fingerY:Number = 0;
		
		private var firstToPlay:Boolean = false;
		private var ball:Ball;
		
		private var debugger:Quad;
		private var shadow:Image;
		private var ballShadow:Image;
		
		private var impactHolder:Sprite;
		private var impact:Impact;
		
		[Embed(source = "/../bin/assets/Particles/pong.pex", mimeType = "application/octet-stream")]
		private static const Particle:Class;
		private var mParticleSystem:PDParticleSystem;
		private var gameLabel:TextField;
		
		public function Pong(params:Object) 
		{
			assets.enqueue('Background/Games/pong.jpg');
			assets.enqueue('Sounds/games/pong/ball-wall.mp3');
			alpha = 1;
		}
		
		protected override function added():void
		{	
			background = new Image(getTexture('pong'));
			addChild(background);
			
			impactHolder = new Sprite();
			addChild(impactHolder);
			
			ballShadow = new Image(getTexture('Games/Pong/ball-shadow'));
			ballShadow.pivotX = ballShadow.width >> 1;
			ballShadow.pivotY = ballShadow.height >> 1;
			addChild(ballShadow);
			
			ball = new Ball(getTexture('Games/Pong/ball'));
			ball.pivotX = ball.width >> 1;
			ball.pivotY = ball.height >> 1;
						
			if (ScreenManager.gameModel.selfPlayer.identifier == 1)
			{
				ball.x = ball.width * 2;
				ball.velocityX = ball.velocityY = 10;
			}
			else
			{
				ball.x = - 50;
				ball.velocityX = ball.velocityY = 0;
			}
			ball.y = Starling.current.stage.stageHeight >> 1;
			addChild(ball);
			
			shadow = new Image(getTexture('Games/Pong/bar-' + (ScreenManager.gameModel.selfPlayer.identifier +1) + "-shadow"));
			shadow.pivotY = shadow.height >> 1;
			shadow.x = Starling.current.stage.stageWidth - 30 - shadow.width;
			shadow.y = (Starling.current.stage.stageHeight >> 1) - (shadow.height >> 1);
			addChild(shadow);
			
			bar = new Image(getTexture('Games/Pong/bar-' + (ScreenManager.gameModel.selfPlayer.identifier +1)));
			//bar.pivotX = 35;
			bar.pivotY = bar.height >> 1;
			bar.x = shadow.x + 14;
			bar.y = shadow.y;
			addChild(bar);
			
			var psConfig:XML = XML(new Particle());
			//mParticleSystem = new PDParticleSystem(psConfig, getTexture("Games/Pong/particle"));
			mParticleSystem = new PDParticleSystem(psConfig, getTexture("Games/Pong/ball-particle-3"));

			addChild(mParticleSystem);
			Starling.juggler.add(mParticleSystem);
			
			swapChildren(mParticleSystem, ball);
			
			ScreenManager.server.addEventListener(Server.MINI_GAME_START, onGameStart);
			ScreenManager.server.send( { type: Server.MINI_GAME_START } );

			gameLabel = new TextField(Starling.current.stage.stageHeight, Starling.current.stage.stageWidth, "Renvoie la balle à l'autre joueur !".toUpperCase(), "Aldo", 45, 0xFFFFFF);
			gameLabel.pivotX = gameLabel.width >> 1;
			gameLabel.pivotY = gameLabel.height >> 1;
			gameLabel.rotation = -Math.PI / 2;
			gameLabel.x = 200;
			gameLabel.y = Starling.current.stage.stageHeight >> 1;
			addChild(gameLabel);
        }
		
		private function onGameStart(e:Event):void 
		{	
			setTimeout(function():void
			{
				TweenMax.to(gameLabel, 0.4, { alpha: 0, ease:Cubic.easeInOut } );
				ScreenManager.server.removeEventListener(Server.MINI_GAME_START, onGameStart);
				ScreenManager.server.addEventListener(Server.GAME_UPDATE, onGameUpdate);
				ScreenManager.server.addEventListener(Server.MINI_GAME_END, onGameEnd);
				stage.addEventListener(TouchEvent.TOUCH, moveBar);
				addEventListener("removeImpact", removeImpact);
				if (ScreenManager.gameModel.selfPlayer.identifier == 1)
				{
					addEventListener(Event.ENTER_FRAME, enterFrame);				
					mParticleSystem.start();
				}
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

		private function moveBar(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			if (touch)
			{
				if (touch.phase == TouchPhase.MOVED)
				{
					bar.y = touch.globalY
					shadow.y = touch.globalY + 10;
				}
			}
		}
		
		private function enterFrame(e:Event):void 
		{			
			ball.x += ball.velocityX * ball.directionX;
			ball.y += ball.velocityY * ball.directionY;
			ballShadow.x = ball.x;
			ballShadow.y = ball.y + 5;
			
			mParticleSystem.emitterX = ball.x;
			mParticleSystem.emitterY = ball.y;
			
			if (ball.y - (ball.height >> 1) <= 0 || ball.y + (ball.height >> 1) >= Starling.current.stage.stageHeight)
			{
				assets.play("ball-wall");
				ball.directionY *= -1;
			}
			else if (ball.x + (ball.width >> 1) < 0)
			{
				ScreenManager.server.send( { type: Server.GAME_UPDATE, content: {y: ball.y, velocity: ball.velocityX, direction: ball.directionY }} );
				removeEventListener(Event.ENTER_FRAME, enterFrame);
				ball.velocityX = ball.velocityY = 0;
				mParticleSystem.stop();
				
				// DEBUG
				//ball.directionX = 1;
				//ball.velocityX++;
				//ball.velocityY++;
			}
			else if (Math2.collision(ball, bar) && ball.x - (ball.width >> 1) <= bar.x + (bar.width >> 1))
			{
				assets.play("ball-wall");
				addImpact();
				
				ball.directionX = -1;
				ball.velocityX++;
				ball.velocityY++;
			}
			else if (ball.x - (ball.width >> 1) > Starling.current.stage.stageWidth)
			{
				mParticleSystem.stop();
				ScreenManager.server.send( { type: Server.MINI_GAME_END, content:"other" } );
				removeEventListener(Event.ENTER_FRAME, enterFrame);
			}
		}
		
		private function addImpact():void
		{
			var impactId:int = Math2.rand2({value: 2}, {value: 1}).value;
			impact = new Impact(getTexture("Games/Pong/ball-particle-" + impactId));
			impact.x = ball.x - 10;
			impact.y = ball.y;
			impactHolder.addChild(impact);
		}
		
		private function removeImpact(e:Event):void
		{
			removeChild(impact);
		}
		
		private function onGameUpdate(e:Event):void 
		{
			//trace('onGameUpdate', e.data.content.velocity);
			ball.x = 2 + ball.width;
			ball.y = e.data.content.y;
			ball.velocityX = ball.velocityY = e.data.content.velocity;
			ball.directionX = 1;
			ball.directionY = e.data.content.direction;
			addEventListener(Event.ENTER_FRAME, enterFrame);
			mParticleSystem.start();
		}
		
		private function stopEvents():void
		{
			mParticleSystem.stop();
			Starling.juggler.remove(mParticleSystem);
			ScreenManager.server.removeEventListener("gameUpdate", onGameUpdate);
			if(stage) stage.removeEventListener(TouchEvent.TOUCH, moveBar);
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