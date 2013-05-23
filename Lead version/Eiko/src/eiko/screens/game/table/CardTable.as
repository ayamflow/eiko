package eiko.screens.game.table 
{
	import com.greensock.easing.Quad;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import eiko.entities.Server;
	import eiko.models.bonus.Bonus;
	import eiko.models.bonus.ScoreBonus;
	import eiko.models.game.Card;
	import eiko.screens.Screen;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	
	/**
	 * ...
	 * ...
	 * @author Florian Morel
	 */
	public class CardTable extends Screen 
	{		
		private var background:Image;
						
		private var cardPlayedCpt:Vector.<String>;
		private var selfPlayerView:PlayerView;
		private var scoreBonusOverlay:ScoreBonusOverlay;
		private var currentCard:Card;
		private var otherCurrentCard:Card;
		
		public function CardTable(params:Object = null) 
		{	
			// Load the backgrounds for each card (mine and the other player's)
			assets.enqueue("Background/Generations/" + ScreenManager.gameModel.selfPlayer.generation + ".jpg");
			assets.enqueue("Spritesheets/itemsSprites.xml");
			assets.enqueue("Spritesheets/itemsSprites.png");
			
			assets.enqueue("Sounds/cancel.mp3");
			assets.enqueue("Sounds/validate.mp3");
			assets.enqueue("Sounds/table/timer.mp3");
			
			ScreenManager.server.addEventListener(Server.REVELATION, revelation);
			//ScreenManager.server.addEventListener(Server.BONUS, onBonus);
			//ScreenManager.server.addEventListener(Server.CARD_PLAYED, updateOtherCard);
						
			cardPlayedCpt = new Vector.<String>();
		}
		
		protected override function added():void
		{
			background = new Image(getTexture(ScreenManager.gameModel.selfPlayer.generation));
			addChild(background); 
			
			currentCard = ScreenManager.gameModel.selfPlayer.currentCard;
			
			var illustration:Image = new Image(getAtlas("itemsSprites").getTexture(currentCard.name));
			illustration.x = (Starling.current.stage.stageWidth >> 1) - (illustration.width >> 1);
			illustration.y = (Starling.current.stage.stageHeight >> 1) - (illustration.height >> 1);
			addChild(illustration);
			
			selfPlayerView = new PlayerView("self");
			addChild(selfPlayerView);
			selfPlayerView.showScoreBonus();
			
			scoreBonusOverlay = new ScoreBonusOverlay();
			scoreBonusOverlay.addEventListener(Server.BONUS, onScoreBonus);
			scoreBonusOverlay.addEventListener("activated", activateScoreBonus);
			addChild(scoreBonusOverlay);
		}
		
		private function activateScoreBonus(e:Event):void 
		{
			scoreBonusOverlay.addEventListener("activated", activateScoreBonus);
			selfPlayerView.changeCardValue(2);
		}
		
		// Other player just played his card
		//private function updateOtherCard(e:Event):void 
		//{
			//trace('updateOtherCard', e.data.content.name);
			//otherCurrentCard = e.data as Card;
			//waitOtherCard("other");
		//}
		
		//-------------------------------------------
		//		SELF PLAYER BONUS EVENTS
		//-------------------------------------------
		private function onScoreBonus(e:Event):void
		{
			scoreBonusOverlay.removeEventListener(Server.BONUS, onScoreBonus);
			
			//if (e.data == ScoreBonus.SCORE)
			//{
				//selfPlayerView.changeCardValue(2);
			//}
//
			//ScreenManager.server.send( { type:Server.CARD_PLAYED, content: currentCard } );
			ScreenManager.server.send( { type: Server.GET_SCORE_BONUS, content: e.data } );
			//waitOtherCard("self");
		}
		
		// OTHER PLAYER SCORE BONUS EVENT
		//private function onBonus(e:Event):void 
		//{
			//ScreenManager.server.removeEventListener(Server.BONUS, onBonus);
			//waitOtherCard("other");
		//}
		
		// check if both players have played
		//private function waitOtherCard(who:String):void 
		//{
			//trace('#waitOtherCard', who);
			//cardPlayedCpt.push(who);
			//if (cardPlayedCpt.indexOf("self") > -1 && cardPlayedCpt.indexOf("other") > -1)
			//{
				//cardPlayedCpt.splice(0, cardPlayedCpt.length);
				//ScreenManager.server.send( { type: Server.REVELATION } );
			//}
		//}
		
		//-------------------------------------------
		//		REVELATION
		//-------------------------------------------
		// show both played cards
		private function revelation():void
		{	
			ScreenManager.server.removeEventListener(Server.REVELATION, revelation);
			
			//ScreenManager.saveScreen();
			changeScreen(Screen.INTERSCREEN, TransitionManager.TRANSITION_OUT_AND_AFTER_IN, {screen: Screen.REVELATION, text: "REVELATION", transition: TransitionManager.TRANSITION_OUT_AND_AFTER_IN});
			//changeScreen(Screen.REVELATION, TransitionManager.TRANSITION_IN_AND_AFTER_OUT);
		}
		
		public override function transitionIn():void
		{
			//transitionTl.insert(TweenMax.to(this, 0.4, { alpha: 1 , ease:Cubic.easeInOut}), 0);
			//transitionTl.play();
		}
		
		public override function transitionOut():void
		{
			TweenMax.to(this, 1, {x: - Starling.current.stage.stageWidth, ease: Cubic.easeInOut, onComplete:this._transitionOutComplete } );
		}
		
		public override function dispose():void
		{
			assets.purge();
			scoreBonusOverlay.addEventListener("activated", activateScoreBonus);
			scoreBonusOverlay.dispose();
			//ScreenManager.server.removeEventListener(Server.BONUS, onBonus);
			ScreenManager.server.removeEventListener(Server.REVELATION, revelation);
			//ScreenManager.server.removeEventListener(Server.CARD_PLAYED, updateOtherCard);
		}	
	}
}