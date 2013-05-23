package eiko.screens.game.table 
{
	import com.greensock.easing.Bounce;
	import com.greensock.TweenMax;
	import eiko.entities.Server;
	import eiko.models.bonus.BattleBonus;
	import eiko.models.GameModel;
	import eiko.screens.Screen;
	import eiko.screens.ui.CardValue;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.ClippedSprite;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Revelation extends Screen 
	{
		private var selfContainer:ClippedSprite;
		private var otherContainer:ClippedSprite;
		private var revelationOverlay:RevelationOverlay;
		private var selfCardValueDisplay:CardValue;
		private var otherCardValueDisplay:CardValue;
		
		public function Revelation(params:Object = null) 
		{			
			// TODO
			// DEBUG
			//ScreenManager.gameModel.selfPlayer.generation = "1990";
			//ScreenManager.gameModel.otherPlayer.generation = "1970";
			//ScreenManager.gameModel.selfPlayer.currentCard = ScreenManager.gameModel.generations["1990"].cards["gameboy"];
			//ScreenManager.gameModel.otherPlayer.currentCard = ScreenManager.gameModel.generations["1970"].cards["kiki"];
			//ScreenManager.gameModel.selfPlayer.currentCard.value = 3;
			//ScreenManager.gameModel.otherPlayer.currentCard.value = 2;
			
			options = params || { };

			
			assets.enqueue("Background/Items/" + ScreenManager.gameModel.selfPlayer.currentCard.name + ".jpg");
			assets.enqueue("Background/Items/" + ScreenManager.gameModel.otherPlayer.currentCard.name + ".jpg");
						
			assets.enqueue("Spritesheets/itemsSprites.xml");
			assets.enqueue("Spritesheets/itemsSprites.png");
			
			assets.enqueue("Sounds/table/revelation/shock.mp3");
			
			ScreenManager.server.addEventListener(Server.GET_BATTLE_BONUS, onBonus);
			ScreenManager.server.addEventListener(Server.BATTLE, goToBattleScreen);
		}

		protected override function added():void
		{
			otherContainer = new ClippedSprite();
			otherContainer.clipRect = new Rectangle(Starling.current.stage.stageWidth >> 1, 0, Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			var otherBackground:Image = new Image(getTexture(ScreenManager.gameModel.otherPlayer.currentCard.name));
			otherBackground.pivotX = otherBackground.width >> 2;
			otherBackground.pivotY = otherBackground.height >> 1;
			otherBackground.scaleX = otherBackground.scaleY = 0.75;
			otherBackground.rotation = Math.PI / 2;
			otherBackground.x = Starling.current.stage.stageWidth >> 2;
			otherBackground.y = Starling.current.stage.stageHeight >> 2;
			otherCardValueDisplay = new CardValue(ScreenManager.gameModel.otherPlayer.currentCard, getTexture("UI/cardValueBgRight"), getTexture("UI/cardValueBorder2"), getTexture("UI/cardValueBg"), getTexture("UI/cardSelectValueStar"), getTexture("UI/cardSelectValueStarEmpty"), 60);
			otherCardValueDisplay.x = (Starling.current.stage.stageWidth >> 1) - otherCardValueDisplay.width + 10;
			otherCardValueDisplay.y = 70;
			var otherIllustration:Image = new Image(getAtlas("itemsSprites").getTexture(ScreenManager.gameModel.otherPlayer.currentCard.name));
			otherIllustration.pivotX = otherIllustration.width >> 1;
			otherIllustration.pivotY = otherIllustration.height >> 1;
			otherIllustration.x = Starling.current.stage.stageWidth >> 2;
			otherIllustration.y = /*(Starling.current.stage.stageHeight >> 2) +*/ (Starling.current.stage.stageHeight >> 1) + (Starling.current.stage.stageHeight >> 3);
			otherContainer.addChild(otherBackground);
			otherContainer.addChild(otherIllustration);
			otherContainer.addChild(otherCardValueDisplay);
			otherContainer.x = Starling.current.stage.stageWidth;
			addChild(otherContainer);
			
			selfContainer = new ClippedSprite();
			selfContainer.clipRect = new Rectangle(0, 0, Starling.current.stage.stageWidth >> 1, Starling.current.stage.stageHeight);
			var selfBackground:Image = new Image(getTexture(ScreenManager.gameModel.selfPlayer.currentCard.name));
			selfBackground.pivotX = selfBackground.width >> 2;
			selfBackground.pivotY = selfBackground.height >> 1;
			selfBackground.scaleX = selfBackground.scaleY = 0.75;
			selfBackground.rotation = Math.PI / 2;
			selfBackground.x = Starling.current.stage.stageWidth >> 2;
			selfBackground.y = Starling.current.stage.stageHeight >> 2;
			selfCardValueDisplay = new CardValue(ScreenManager.gameModel.selfPlayer.currentCard, getTexture("UI/cardReaderValueBG-small"), getTexture("UI/cardValueBorder2"), getTexture("UI/cardValueBg"), getTexture("UI/cardSelectValueStar"), getTexture("UI/cardSelectValueStarEmpty"));
			selfCardValueDisplay.y = 70;
			var selfIllustration:Image = new Image(getAtlas("itemsSprites").getTexture(ScreenManager.gameModel.selfPlayer.currentCard.name));
			selfIllustration.pivotX = selfIllustration.width >> 1;
			selfIllustration.pivotY = selfIllustration.height >> 1;
			selfIllustration.x = Starling.current.stage.stageWidth >> 2;
			selfIllustration.y = /*(Starling.current.stage.stageHeight >> 2) +*/ (Starling.current.stage.stageHeight >> 1) + (Starling.current.stage.stageHeight >> 3);
			selfContainer.addChild(selfBackground);
			selfContainer.addChild(selfIllustration);
			selfContainer.addChild(selfCardValueDisplay);
			selfContainer.x = - selfContainer.width;
			addChild(selfContainer);
		}
		
		// Listen for self player choice (battle bonus)
		private function onBattleBonus(e:Event):void
		{
			revelationOverlay.removeEventListener(Server.BONUS, onBattleBonus);
			trace(e.data, 'self player battle bonus:', ScreenManager.gameModel.selfPlayer.bonus["battle"].used);
			ScreenManager.server.send( { type: Server.GET_BATTLE_BONUS, content: e.data } );
			if (e.data == BattleBonus.BATTLE)
			{
				ScreenManager.gameModel.selfPlayer.bonus["battle"].used = true;
				setTimeout(function():void
				{
					requestMiniGame(true);
				}, 500);
			}
			else
			{
				trace('I choose battle bonus, go to prize');
				changeScreen(Screen.PRIZE, TransitionManager.TRANSITION_OUT_AND_AFTER_IN, { winner: "other" } );
			}
		}
		
		// Listen for other player choice (battle bonus)
		private function onBonus(e:Event):void
		{
			trace(e.data.content, 'other player battle bonus:', ScreenManager.gameModel.otherPlayer.bonus["battle"].used);
			ScreenManager.server.removeEventListener(Server.GET_BATTLE_BONUS, onBonus);
			if (e.data.content == BattleBonus.BATTLE)
			{
				options.challenged = true;
			}
			else
			{
				revelationOverlay.notifyWinner(function():void
				{
					changeScreen(Screen.PRIZE, TransitionManager.TRANSITION_IN_AND_AFTER_OUT, { winner: "self" } );
				});
			}
		}
		
		// CHECK IF PLAYER WON/LOSE
		private function checkWinOrBattle(delay:int = 0):void
		{	
			trace('CheckWinOrBattle');
			setTimeout(function():void
			{
				//trace('CheckWin:', ScreenManager.gameModel.selfPlayer.currentCard.value, "vs", ScreenManager.gameModel.otherPlayer.currentCard.value);
				if (ScreenManager.gameModel.selfPlayer.currentCard.value > ScreenManager.gameModel.otherPlayer.currentCard.value)
				{
					// selfPlayer wins
					if (ScreenManager.gameModel.otherPlayer.bonus["battle"].used)
					{
						changeScreen(Screen.PRIZE, TransitionManager.TRANSITION_IN_AND_AFTER_OUT, { winner: "self" } );
					}
					else
					{
						initBattleBonusOverlay("self");						
					}
				}
				else if (ScreenManager.gameModel.selfPlayer.currentCard.value < ScreenManager.gameModel.otherPlayer.currentCard.value)
				{
					// selfPlayer loses
					if (ScreenManager.gameModel.selfPlayer.bonus["battle"].used)
					{
						changeScreen(Screen.PRIZE, TransitionManager.TRANSITION_IN_AND_AFTER_OUT, { winner: "other" } );
					}
					else
					{
						initBattleBonusOverlay("other");						
					}
				}
				else if (ScreenManager.gameModel.selfPlayer.currentCard.value == ScreenManager.gameModel.otherPlayer.currentCard.value)
				{
					// Battle !
					requestMiniGame();
				}
			}, delay);
		}
		
		// SHOW "USE BATTLE BONUS" OVERLAY
		private function initBattleBonusOverlay(winner:String):void
		{
			revelationOverlay = new RevelationOverlay({winner: winner});
			revelationOverlay.addEventListener(Server.BONUS, onBattleBonus);
			addChild(revelationOverlay);
		}
		
		// Show the minigame
		private function goToBattleScreen(e:Event):void 
		{
			var game:String = e.data.content;
			//trace("goToBattleScreen", game);
			if (options.challenged)
			{
				revelationOverlay.challengeWinner(function():void
				{
					changeScreen(Screen.DUEL, TransitionManager.TRANSITION_OUT_AND_AFTER_IN, {game: game});
				});
			}
			else
			{
				changeScreen(Screen.DUEL, TransitionManager.TRANSITION_OUT_AND_AFTER_IN, {game: game});
			}
		}
		
		// Request the server to chose a minigame
		private function requestMiniGame(solo:Boolean = false):void
		{
			if (solo) ScreenManager.server.send( { type: "battleRequest", content: "solo" } );
			else ScreenManager.server.send( { type: "battleRequest" } );
		}
		
		public override function transitionIn():void
		{
			transitionTl.insert(TweenMax.to(selfContainer, 1, { x: 0, ease:Bounce.easeOut } ), 0);
			transitionTl.insert(TweenMax.to(otherContainer, 1, {  x: Starling.current.stage.stageWidth >> 1, ease:Bounce.easeOut } ), 0);
			transitionTl.addCallback(function():void
			{
				assets.play("shock");
			}, 0.5);
		}
		
		public override function transitionInComplete():void
		{
			ScreenManager.removeScreen();
			checkWinOrBattle(600);
		}
		
		public override function transitionOut():void
		{
			transitionTl.reverse(true);
		}
		
		public override function dispose():void
		{
			if (revelationOverlay)
			{
				removeChild(revelationOverlay);
				revelationOverlay.dispose();
			}
			selfContainer.dispose();
			otherContainer.dispose();
			removeChild(selfCardValueDisplay);
			removeChild(otherCardValueDisplay);
			selfCardValueDisplay.dispose();
			otherCardValueDisplay.dispose();
			ScreenManager.server.removeEventListener(Server.BATTLE, goToBattleScreen);
			ScreenManager.server.removeEventListener(Server.GET_BATTLE_BONUS, onBonus);
			//revelationOverlay.removeEventListener(Server.BONUS, onBattleBonus);
			assets.purge();
		}
	}

}