package eiko.screens.game.postgame 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import eiko.models.GameModel;
	import eiko.screens.Screen;
	import eiko.screens.ui.Background;
	import eiko.screens.ui.StartGameButton;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class End extends Screen
	{
		private var newGameButton:StartGameButton;
		private var headerBg:Image;
		private var title:TextField;
		private var darkBg:Vector.<Image>;
		private var lightBg:Vector.<Image>;
		private var darkOverlay:Image;
		private var lightOverlay:Image;
		private var bottomBorder:Image;
		private var otherTitle:TextField;
		private var selfTitle:TextField;
		private var selfStatsText:Vector.<TextField>;
		private var selfValues:Vector.<TextField>;
		private var otherValues:Vector.<TextField>;
		private var otherStatsText:Vector.<TextField>;
		private var selfScore:TextField;
		private var otherScore:TextField;
		
		public function End(params:Object) 
		{
			if (GameModel.DEBUG)
			{
				ScreenManager.gameModel.selfPlayer.generation = "1950";
				ScreenManager.gameModel.otherPlayer.generation = "1990";
				ScreenManager.gameModel.stats.updateStats(1, "bilboquet", "gameboy", "self");
				ScreenManager.gameModel.stats.updateStats(2, "toupie", "tamagochi", "other");
				ScreenManager.gameModel.stats.updateStats(3, "television", "vhs", "self");
				ScreenManager.gameModel.stats.updateStats(4, "montre à gousset", "hippo", "self");
				ScreenManager.gameModel.stats.updateStats(5, "billes", "flikflak", "other");
				ScreenManager.gameModel.selfPlayer.score = 3;
				ScreenManager.gameModel.otherPlayer.score = 2;
			}

			assets.enqueue("Background/Generations/" + ScreenManager.gameModel.selfPlayer.generation + ".jpg");
		}
		
		override protected function added():void 
		{
			// Visual aspect
			var background:Image = new Background(getTexture(ScreenManager.gameModel.selfPlayer.generation));
			addChild(background);
			
			headerBg = new Image(getTexture("UI/titleBg"));
			headerBg.y = 107;
			headerBg.blendMode = BlendMode.MULTIPLY;
			headerBg.alpha = 0.7;
			headerBg.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			addChild(headerBg);
			
			title = new TextField(Starling.current.stage.stageWidth, headerBg.height, "Résultat de la partie".toUpperCase(), "Aldo", 30, 0xFFFFFF);
			title.y = headerBg.y + 10;
			addChild(title);
			
			darkBg = new Vector.<Image>(3, true);
			for (var i:int = 0; i < 3; i++)
			{
				darkBg[i] = new Image(getTexture("UI/resultsDark"));
				darkBg[i].x = 200;
				darkBg[i].y = 285 + i * 2 * darkBg[i].height - 10;
				darkBg[i].color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
				darkBg[i].blendMode = BlendMode.MULTIPLY;
				darkBg[i].alpha = 0.7;
				addChild(darkBg[i]);
			}
			darkBg[0].y += 10;
			darkBg[2].y -= 10;
			
			lightBg = new Vector.<Image>(2, true);
			for (i = 0; i < 2; i++)
			{
				lightBg[i] = new Image(getTexture("UI/resultsLight"));
				lightBg[i].x = 200;
				lightBg[i].y = 285 + darkBg[i].height + i * 2 * lightBg[i].height - 10;
				lightBg[i].color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
				lightBg[i].blendMode = BlendMode.SCREEN;
				lightBg[i].alpha = 0.4;
				addChild(lightBg[i]);
			}
			lightBg[0].y += 10;
			
			darkOverlay = new Image(getTexture("UI/resultsTopDark"));
			darkOverlay.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			darkOverlay.blendMode = BlendMode.MULTIPLY;
			darkOverlay.alpha = 0.3;
			darkOverlay.x = 200;
			darkOverlay.y = 220;
			addChild(darkOverlay);
			
			lightOverlay = new Image(getTexture("UI/resultsTopLight"));
			lightOverlay.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			lightOverlay.blendMode = BlendMode.SCREEN;
			lightOverlay.alpha = 0.7;
			lightOverlay.x = darkOverlay.x + darkOverlay.width - 45.5;
			lightOverlay.y = 217;
			addChild(lightOverlay);
			
			// Displaying the stats
			var stats:Array = ScreenManager.gameModel.stats.getStats();
			
			selfTitle = new TextField(350, 50, "génération ".toUpperCase() + ScreenManager.gameModel.selfPlayer.generation.slice(2) + "’", "Aldo", 30, 0xFFFFFF);
			selfTitle.x = 170;
			selfTitle.y = 240;
			addChild(selfTitle);
			
			otherTitle = new TextField(350, 50, "génération ".toUpperCase() + ScreenManager.gameModel.otherPlayer.generation.slice(2) + "’", "Aldo", 30, 0xFFFFFF);
			otherTitle.x = 475;
			otherTitle.y = 240;
			addChild(otherTitle);
			
			bottomBorder = new Image(getTexture('UI/scoreBonus'));
			bottomBorder.y = Starling.current.stage.stageHeight - bottomBorder.height;
			bottomBorder.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			bottomBorder.blendMode = BlendMode.MULTIPLY;
			addChild(bottomBorder);
			
			newGameButton = new StartGameButton(getTexture('UI/cardSelectValueOk'), "NOUVELLE", "PARTIE");
			newGameButton.scaleX = newGameButton.scaleY = 0.8;
			newGameButton.x = 412;
			newGameButton.y = 660;
			//newGameButton.alpha = 1;
			addChild(newGameButton);
			
			selfStatsText = new Vector.<TextField>(5, true);
			selfValues = new Vector.<TextField>(5, true);
			otherStatsText = new Vector.<TextField>(5, true);
			otherValues = new Vector.<TextField>(5, true);
			
			for (i = 0; i < 5; i++)
			{
				// Self player
				selfStatsText[i] = new TextField(350, 49, stats[i].selfCard.toUpperCase(), "Aldo", 22, 0xFFFFFF);
				selfStatsText[i].x = 170;
				selfStatsText[i].y = 290 + i * 49;
				addChild(selfStatsText[i]);
				
				selfValues[i] = new TextField(10, 49, stats[i].winner == "self" ? "1" : "0" , "Aldo", 22, 0xFFFFFF);
				selfValues[i].x = 440;
				selfValues[i].y = 290 + i * 49;
				addChild(selfValues[i]);
				
				// Other player
				otherStatsText[i] = new TextField(350, 49, stats[i].otherCard.toUpperCase(), "Aldo", 22, 0xFFFFFF);
				otherStatsText[i].x = 475;
				otherStatsText[i].y = 290 + i * 49;
				addChild(otherStatsText[i]);

				otherValues[i] = new TextField(10, 49, stats[i].winner == "other" ? "1" : "0" , "Aldo", 22, 0xFFFFFF);
				otherValues[i].x = 550;
				otherValues[i].y = 290 + i * 49;
				addChild(otherValues[i]);
			}
			
			selfScore = new TextField(20, 40, "" + ScreenManager.gameModel.selfPlayer.score, "Aldo", 40, 0xFFFFFF);
			selfScore.x = 436;
			selfScore.y = 542;
			addChild(selfScore);
			
			otherScore = new TextField(20, 40, "" + ScreenManager.gameModel.otherPlayer.score, "Aldo", 40, 0xFFFFFF);
			otherScore.x = 547;
			otherScore.y = 542;
			addChild(otherScore);
		}
		
		public override function addEvents():void
		{
			newGameButton.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var t:Touch = e.getTouch(stage, TouchPhase.ENDED);
			
			if (t)
			{
				newGameButton.removeEventListener(TouchEvent.TOUCH, onTouch);
				ScreenManager.server.send( { type: "reset" } );
				changeScreen(Screen.GENERATION_SELECTOR, TransitionManager.TRANSITION_OUT_AND_AFTER_IN);
			}
		}
		
		public override function transitionIn():void
		{
			var time:Number = 0;
			var duration:Number = 0.3;
			
			transitionTl.insert(TweenMax.from(headerBg, duration, {x: Starling.current.stage.stageWidth, ease: Expo.easeInOut}),  time);
			transitionTl.insert(TweenMax.from(title, duration, { alpha: 0, ease: Expo.easeInOut } ),  time + duration / 2);
			
			transitionTl.insert(TweenMax.from(darkOverlay, duration / 2, { y: darkOverlay.y + 50, alpha: 0, ease: Expo.easeInOut } ),  time + duration /2);
			transitionTl.insert(TweenMax.from(lightOverlay, duration / 2, { y: lightOverlay.y + 50, alpha: 0, ease: Expo.easeInOut } ),  time + duration);
			
			
			transitionTl.insert(TweenMax.from(selfTitle, duration / 2, { y: selfTitle.y + 50, alpha: 0, ease: Expo.easeInOut } ),  time + duration * 4);
			transitionTl.insert(TweenMax.from(otherTitle, duration / 2, { y: otherTitle.y + 50, alpha: 0, ease: Expo.easeInOut } ),  time + 2 + duration * 2);
			
			time += duration * 3;
			for (var i:int = 0; i < 5; i++)
			{
				if(i < darkBg.length) transitionTl.insert(TweenMax.from(darkBg[i], duration, { y: darkBg[i].y + 30, alpha: 0, ease: Expo.easeInOut } ),  time - duration);
				if(i < lightBg.length) transitionTl.insert(TweenMax.from(lightBg[i], duration, { y: lightBg[i].y + 30, alpha: 0, ease: Expo.easeInOut } ),  time - duration / 2);
				
				transitionTl.insert(TweenMax.from(selfStatsText[i], duration, { y: selfStatsText[i].y + 30, alpha: 0, ease: Expo.easeInOut } ),  time + duration);
				transitionTl.insert(TweenMax.from(selfValues[i], duration, { y: selfValues[i].y + 30, alpha: 0, ease: Expo.easeInOut } ),  time + duration);
				
				transitionTl.insert(TweenMax.from(otherStatsText[i], duration, { y: otherStatsText[i].y + 30, alpha: 0, ease: Expo.easeInOut } ),  time + 2 - duration);
				transitionTl.insert(TweenMax.from(otherValues[i], duration, { y: otherValues[i].y + 30, alpha: 0, ease: Expo.easeInOut } ),  time + 2 - duration);

				time += duration /2;
			}
			
			transitionTl.insert(TweenMax.from(selfScore, duration, { scaleX: 4, scaleY: 4, x: selfScore.x - 30, y: selfScore.y - 30, alpha: 0, ease: Expo.easeInOut } ),  time + duration * 1.5);
			transitionTl.insert(TweenMax.from(otherScore, duration, { scaleX: 4, scaleY: 4, x: otherScore.x - 30, y: otherScore.y - 30, alpha: 0, ease: Expo.easeInOut } ), time + 2);
			
			if (ScreenManager.gameModel.selfPlayer.score > ScreenManager.gameModel.otherPlayer.score)
			{
				transitionTl.insert(TweenMax.to(selfTitle, duration / 2, { fontSize: 45, ease: Expo.easeInOut } ),  time + 3);
				transitionTl.insert(TweenMax.to(otherTitle, duration / 2, { fontSize: 20, ease: Expo.easeInOut } ),  time + 3);
			}
			else if (ScreenManager.gameModel.selfPlayer.score < ScreenManager.gameModel.otherPlayer.score)
			{
				transitionTl.insert(TweenMax.to(otherTitle, duration / 2, { fontSize: 45, ease: Expo.easeInOut } ),  time + 3);
				transitionTl.insert(TweenMax.to(selfTitle, duration / 2, { fontSize: 20, ease: Expo.easeInOut } ),  time + 3);
			}
			
		}
		
		public override function transitionOut():void
		{
			
		}
		
		public override function dispose():void
		{
			newGameButton.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
	}

}