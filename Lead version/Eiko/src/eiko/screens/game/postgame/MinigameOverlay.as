package eiko.screens.game.postgame 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import eiko.models.bonus.BattleBonus;
	import eiko.screens.Screen;
	import eiko.screens.ui.Timer;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ClippedSprite;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;

	/**
	 * ...
	 * @author ...
	 */
	public class MinigameOverlay extends Screen 
	{
		private var fx:TextureAtlas;
		private var shattered:Vector.<Image>;
		private var loseTextTop:TextField;
		private var loseTextBottom:TextField;
				
		public function MinigameOverlay(params:Object = null) 
		{						
			assets.enqueue("Spritesheets/gameFxSprites.xml");
			assets.enqueue("Spritesheets/gameFxSprites.png");
			
			assets.enqueue('Sounds/games/victory.mp3');
			assets.enqueue('Sounds/games/defeat.mp3');
			
			options = params;
		}
		
		protected override function added():void
		{	
			var selfColor:uint = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			
			fx = getAtlas("gameFxSprites");
			
			shattered = new Vector.<Image>(9, true);
			for (var i:int = 0, l:int = shattered.length; i < l; i++)
			{
				shattered[i] = new Image(fx.getTexture("shatter" + (i + 1)));
				addChild(shattered[i]);
				shattered[i].color = selfColor;
			}			
			
			shattered[0].x 	= 90;
			shattered[0].y 	= 151;
			//shattered[0].alpha = 0.4;
			shattered[0].blendMode = BlendMode.SCREEN;
			
			shattered[1].x 	= 100;
			shattered[1].y 	= 7;
			//shattered[0].alpha = 0.4;
			shattered[1].blendMode = BlendMode.MULTIPLY;
			
			shattered[2].x = 198;
			shattered[2].y = 7;
			//shattered[1].alpha = 0.6;
			shattered[2].blendMode = BlendMode.MULTIPLY;
			
			shattered[3].x = 554;
			shattered[3].y = 13;
			//shattered[2].alpha = 0.3;
			shattered[3].blendMode = BlendMode.SCREEN;
			
			shattered[4].x = 544;
			shattered[4].y = 13;
			//shattered[3].alpha = 0.3;
			shattered[4].blendMode = BlendMode.MULTIPLY;
			
			shattered[5].x = 524;
			shattered[5].y = 346;
			//shattered[4].alpha = 0.5;
			shattered[5].blendMode = BlendMode.MULTIPLY;
			
			shattered[6].x = 493;
			shattered[6].y = 513;
			//shattered[5].alpha = 0.5;
			shattered[6].blendMode = BlendMode.SCREEN;
			
			shattered[7].x = 446;
			shattered[7].y = 632;
			//shattered[6].alpha = 0.4;
			shattered[7].blendMode = BlendMode.MULTIPLY;
			
			shattered[8].x = 118;
			shattered[8].y = 225;
			//shattered[7].alpha = 0.5;
			shattered[8].blendMode = BlendMode.MULTIPLY;
			
			if (options.winner == "self")
			{
				loseTextTop = new TextField(300, 80, "TU GAGNES", "Aldo", 75, 0xFFFFFF);
				loseTextTop.pivotX = loseTextTop.width >> 1;
				loseTextTop.pivotY = loseTextTop.height >> 1;
				loseTextTop.rotation = -Math.PI / 2;
				//loseTextTop.border = true;
				loseTextTop.x = 230 + (loseTextTop.width >> 1);
				loseTextTop.y = 348 + (loseTextTop.height >> 1);
				addChild(loseTextTop);
				loseTextBottom = new TextField(300, 60, "LA MANCHE", "Aldo", 64, 0xFFFFFF);
				loseTextBottom.pivotX = loseTextBottom.width >> 1;
				loseTextBottom.pivotY = loseTextBottom.height >> 1;
				loseTextBottom.rotation = -Math.PI / 2;
				//loseTextBottom.border = true;
				loseTextBottom.x = 230 + loseTextBottom.width + 50;
				loseTextBottom.y = 348 + (loseTextTop.height >> 1);
				addChild(loseTextBottom);
				
				assets.play("victory");
			}
			else
			{
				loseTextTop = new TextField(260, 80, "TU PERDS", "Aldo", 75, 0xFFFFFF);
				loseTextTop.pivotX = loseTextTop.width >> 1;
				loseTextTop.pivotY = loseTextTop.height >> 1;
				loseTextTop.rotation = -Math.PI / 2;
				//loseTextTop.border = true;
				loseTextTop.x = 230 + (loseTextTop.width >> 1);
				loseTextTop.y = 368 + (loseTextTop.height >> 1);
				addChild(loseTextTop);
				loseTextBottom = new TextField(260, 60, "LA MANCHE", "Aldo", 64, 0xFFFFFF);
				loseTextBottom.pivotX = loseTextBottom.width >> 1;
				loseTextBottom.pivotY = loseTextBottom.height >> 1;
				loseTextBottom.rotation = -Math.PI / 2;
				//loseTextBottom.border = true;
				loseTextBottom.x = 230 + loseTextBottom.width + 50;
				loseTextBottom.y = 368 + (loseTextTop.height >> 1);
				addChild(loseTextBottom);

				assets.play("defeat");
			}
		}
		
		public override function transitionIn():void
		{
			var time:Number = 0;
			transitionTl.insert(TweenMax.to(this, 0, {alpha: 1}), time += 0.15);
			for (var i:int = 0, l:int = shattered.length; i < l; i++)
			{
				transitionTl.insert(TweenMax.from(shattered[i], 0.4, { scaleX: 0, scaleY: 0, x: shattered[i].x + (shattered[i].width >> 1), y: shattered[i].y + (shattered[i].height >> 1), ease:Expo.easeInOut } ), time += 0.04);
			}
			transitionTl.insert(TweenMax.from(loseTextTop, 0.3, { y: loseTextTop.y - 30, alpha: 0, ease:Expo.easeInOut } ), time += 0.1);
			transitionTl.insert(TweenMax.from(loseTextBottom, 0.3, { y: loseTextTop.y - 30, alpha: 0, ease:Expo.easeInOut } ), time += 0.1);
			transitionTl.play();
		}
		
		public override function transitionOut():void
		{
			transitionTl.reverse(true);
		}
		
		public override function transitionInComplete():void
		{
			setTimeout(function():void
			{
				changeScreen(Screen.PRIZE, TransitionManager.TRANSITION_OUT_AND_AFTER_IN, { winner: options.winner } );
			}, 1500);
		}
		
		public override function dispose():void
		{
			assets.purge();
		}
	}
}