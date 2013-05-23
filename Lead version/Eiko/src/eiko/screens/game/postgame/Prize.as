package eiko.screens.game.postgame 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import eiko.entities.Server;
	import eiko.models.GameModel;
	import eiko.screens.Screen;
	import eiko.screens.ui.NativeVideo;
	import eiko.screens.ui.StartGameButton;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import starling.display.BlendMode;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Prize extends Screen 
	{33
		private var item:String;
		private var background:Image;
		private var exitButton:Quad;
		private var playersReady:Vector.<String>;
		private var video:NativeVideo;
		private var shattered:Vector.<Image>;
		private var titleBg:Image;
		private var winnerText:TextField;
		private var bottomBorder:Image;
		private var button:StartGameButton;
		
		public function Prize(params:Object) 
		{						
			if (GameModel.DEBUG)
			{
				params.winner = "self";
			}
			
			options = params;
			if (params.winner == "self")
			{
				trace('winner: self');
				ScreenManager.gameModel.selfPlayer.score++;
				item = ScreenManager.gameModel.selfPlayer.currentCard.name;
			}
			else if (params.winner == "other")
			{
				trace('winner: other');
				ScreenManager.gameModel.otherPlayer.score++;
				item = ScreenManager.gameModel.otherPlayer.currentCard.name;
			}
			
			playersReady = new Vector.<String>();
			
			assets.enqueue('Background/Items/' + item + '.jpg');
			assets.enqueue('Spritesheets/prizeSprites.xml');
			assets.enqueue('Spritesheets/prizeSprites.png');
			
			ScreenManager.gameModel.stats.updateStats(ScreenManager.gameModel.round, ScreenManager.gameModel.selfPlayer.currentCard.name, ScreenManager.gameModel.otherPlayer.currentCard.name, options.winner);
			ScreenManager.gameModel.round++;
			
			ScreenManager.server.addEventListener(Server.PRIZE, nextRound);
		}
		
		private function nextRound(e:Event):void 
		{
			ScreenManager.server.removeEventListener(Server.PRIZE, nextRound);
			decompose();
		}
		
		protected override function added():void
		{
			background = new Image(getTexture(item));
			addChild(background);
			
			var fx:TextureAtlas = getAtlas("prizeSprites");
			var selfColor:uint = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			
			shattered = new Vector.<Image>(10, true);
			for (var i:int = 0, l:int = shattered.length; i < l; i++)
			{
				shattered[i] = new Image(fx.getTexture("shatter-" + i));
				addChild(shattered[i]);
				shattered[i].color = selfColor;
				shattered[i].pivotX = shattered[i].width >> 1;
				shattered[i].pivotY = shattered[i].height >> 1
			}
			
			shattered[0].x = 389 + (shattered[0].width >> 1);
			shattered[0].y = 84 + (shattered[0].height >> 1);
			shattered[0].blendMode = BlendMode.SCREEN;
			shattered[0].alpha = 0.3;
			
			shattered[1].x = 0 + (shattered[1].width >> 1);
			shattered[1].y = 70 + (shattered[1].height >> 1);
			shattered[1].blendMode = BlendMode.MULTIPLY;
			shattered[1].alpha = 0.3;
			
			shattered[2].x = 0 + (shattered[2].width >> 1);
			shattered[2].y = 70 + (shattered[2].height >> 1);
			shattered[2].blendMode = BlendMode.SCREEN;
			shattered[2	].alpha = 0.4;
			
			shattered[3].x = 0 + (shattered[3].width >> 1);
			shattered[3].y = 295 + (shattered[3].height >> 1);
			shattered[3].blendMode = BlendMode.MULTIPLY;
			shattered[3].alpha = 0.3;
			
			shattered[4].x = 0 + (shattered[4].width >> 1);
			shattered[4].y = 464 + (shattered[4].height >> 1);
			shattered[4].blendMode = BlendMode.SCREEN;
			shattered[4].alpha = 0.3;
			
			shattered[5].x = 231 + (shattered[5].width >> 1);
			shattered[5].y = 577 + (shattered[5].height >> 1);
			shattered[5].blendMode = BlendMode.MULTIPLY;
			shattered[5].alpha = 0.3;
			
			shattered[6].x = 623 + (shattered[6].width >> 1);
			shattered[6].y = 578 + (shattered[6].height >> 1);
			shattered[6].blendMode = BlendMode.MULTIPLY;
			shattered[6].alpha = 0.4;
			
			shattered[7].x = 703 + (shattered[7].width >> 1);
			shattered[7].y = 577 + (shattered[7].height >> 1);
			shattered[7].blendMode = BlendMode.SCREEN;
			shattered[7].alpha = 0.3;
			
			shattered[8].x = 771 + (shattered[8].width >> 1);
			shattered[8].y = 409 + (shattered[8].height >> 1);
			shattered[8].blendMode = BlendMode.MULTIPLY;
			shattered[8].alpha = 0.4;
			
			shattered[9].x = 677 + (shattered[9].width >> 1);
			shattered[9].y = 93 + (shattered[9].height >> 1);
			shattered[9].blendMode = BlendMode.SCREEN;
			shattered[9].alpha = 0.4;
			
			bottomBorder = new Image(getTexture('UI/scoreBonus'));
			bottomBorder.y = Starling.current.stage.stageHeight - bottomBorder.height;
			bottomBorder.color = selfColor;
			bottomBorder.blendMode = BlendMode.MULTIPLY;
			addChild(bottomBorder);
			
			titleBg = new Image(getTexture("UI/titleBg"));
			titleBg.y = 104;
			titleBg.blendMode = BlendMode.MULTIPLY;
			titleBg.alpha = 0.6;
			titleBg.color = selfColor;
			addChild(titleBg);
			
			winnerText = new TextField(Starling.current.stage.stageWidth, 76, ("Vainqueur: " + item).toUpperCase(), "Aldo", 33, 0xFFFFFF);
			winnerText.y = titleBg.y + 10;
			addChild(winnerText);
			
			var text1:String;
			var text2:String;
			if (ScreenManager.gameModel.round <= 5)
			{
				text1 = "ACCEDER A LA";
				text2 = ScreenManager.gameModel.round + "E MANCHE";
			}
			else
			{
				text1 = "VOIR LES";
				text2 = "RESULTATS";
			}
			
			button = new StartGameButton(getTexture('UI/cardSelectValueOk'), text1, text2, 30, 30);
			button.x = 422;
			button.y = 660;
			button.scaleX = button.scaleY = 0.8;
			addChild(button);
		}
		
		public override function transitionIn():void
		{
			transitionTl.insert(TweenMax.from(titleBg, 0.4, { alpha: 0, x: Starling.current.stage.stageWidth, ease: Expo.easeInOut } ), 0);
			transitionTl.insert(TweenMax.from(winnerText, 0.4, { alpha: 0, ease: Expo.easeInOut } ), 0.3);
			transitionTl.insert(TweenMax.from(bottomBorder, 0.4, { alpha: 0, y: Starling.current.stage.stageHeight, ease: Expo.easeInOut } ), 0.5);
			transitionTl.insert(TweenMax.from(button, 0.4, { alpha: 0, y: Starling.current.stage.stageHeight, ease: Expo.easeInOut } ), 0.7);
			
			for (var i:int = 0, l:int = shattered.length; i < l; i++)
			{
				transitionTl.insert(TweenMax.from(shattered[i], 0.3, {alpha: 0, scaleX: 0, scaleY: 0, ease: Expo.easeInOut}), 0.6 + Math.random() * ((l-1) * 0.08));
			}
		}
		
		public override function transitionInComplete():void
		{
			video = new NativeVideo(item)
			video.mouseEnabled = false;
			Starling.current.nativeOverlay.addChild(video);
		}
		
		public override function transitionOut():void
		{
			
		}
		
		private function decompose():void 
		{
			video.transitionOut();
			transitionTl.gotoAndStop(transitionTl.totalDuration);
			transitionTl.reverse(true);			
		}
		
		public override function transitionOutComplete():void
		{
			if (ScreenManager.gameModel.selfPlayer.score + ScreenManager.gameModel.otherPlayer.score == 5)
			{
				changeScreen(Screen.END, TransitionManager.TRANSITION_OUT_AND_AFTER_IN);
			}
			else
			{
				changeScreen(Screen.INTERSCREEN, TransitionManager.TRANSITION_OUT_AND_AFTER_IN, {screen: Screen.CARD_DETECTOR, text: "MANCHE " + ScreenManager.gameModel.round, transition: TransitionManager.TRANSITION_OUT_AND_AFTER_IN});
			}
		}
		
		public override function dispose():void
		{
			video.dispose();
			Starling.current.nativeOverlay.removeChildren();
			assets.purge();
		}
	}

}