package eiko.screens.game.table 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import eiko.models.game.Card;
	import eiko.screens.Screen;
	import eiko.screens.ui.CardValue;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import starling.events.Event;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.extensions.ClippedSprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class PlayerView extends Screen 
	{
		private var player:String;
		private var currentCardHolder:Sprite;
		private var cardName:TextField;
		private var cardLabel:TextField;
		private var cardValueBG:Image;
		private var cardValue:TextField;
		private var illustration:Image;
		private var cardValidatedTl:TimelineMax;
		private var currentCard:Card;
		private var otherBGHolder:ClippedSprite;
		private var otherBG:Image;
		private var cardValueDisplay:CardValue;
		
		public function PlayerView(who:String) 
		{
			player = who;
			if (player == "self") currentCard = ScreenManager.gameModel.selfPlayer.currentCard;
			else if (player == "other") currentCard = ScreenManager.gameModel.otherPlayer.currentCard;
			added();
		}
		
		protected override function added():void
		{
			//trace('added PlayerView');
			// Where the card is shown
			currentCardHolder = new Sprite();
			addChild(currentCardHolder);
			
			if (player == "self") initSelfPlayer();
			else if (player == "other") initOtherPlayer();
		}
		
		/*public function addBackground(_bg:Texture):void
		{
			currentCardHolder = new Sprite();
			addChild(currentCardHolder);
			if (player == "self") initSelfPlayer(_bg);
			else if (player == "other") initOtherPlayer(_bg);
		}*/
		
		private function initSelfPlayer(_bg:Texture = null):void
		{			
			//var background:Image = new Image(_bg);
			//addChild(background);
			
			cardValueDisplay = new CardValue(ScreenManager.gameModel.selfPlayer.currentCard, getTexture("UI/cardReaderValueBG"), getTexture("UI/cardValueBorder2"), getTexture("UI/cardValueBg"), getTexture("UI/cardSelectValueStar"), getTexture("UI/cardSelectValueStarEmpty"));
			cardValueDisplay.y = 182;
			addChild(cardValueDisplay);
			
			var round:String;
			if (ScreenManager.gameModel.round == 1) round = "1ERE MANCHE";
			else round = ScreenManager.gameModel.round + "E MANCHE";
			var roundTitleBg:Image = new Image(getTexture("UI/titleBg"));
			roundTitleBg.y = 108;
			roundTitleBg.alpha = 0.6;
			roundTitleBg.blendMode = BlendMode.MULTIPLY;
			roundTitleBg.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			addChild(roundTitleBg);
			var roundTitle:TextField = new TextField(roundTitleBg.width, roundTitleBg.height, round, "Aldo", 33, 0xFFFFFF);
			roundTitle.y = roundTitleBg.y + 10;
			addChild(roundTitle);
			
			var scoreTitleBG:Image = new Image(getTexture("UI/scoreTitleBG"));
			scoreTitleBG.x = 751;
			scoreTitleBG.y = 184;
			scoreTitleBG.blendMode = BlendMode.MULTIPLY;
			scoreTitleBG.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			addChild(scoreTitleBG);
			var scoreTitle:TextField = new TextField(scoreTitleBG.width, scoreTitleBG.height, "Score de la partie", "Aldo", 20, 0XFFFFFFF);
			scoreTitle.x = scoreTitleBG.x;
			scoreTitle.y = scoreTitleBG.y;
			addChild(scoreTitle);
			var otherScoreBG:Image = new Image(getTexture("UI/scoreBG"));
			otherScoreBG.x = Starling.current.stage.stageWidth - otherScoreBG.width;
			otherScoreBG.y = scoreTitleBG.y + scoreTitleBG.height;
			otherScoreBG.alpha = 0.5;
			otherScoreBG.blendMode = BlendMode.MULTIPLY;
			otherScoreBG.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			addChild(otherScoreBG);
			var otherScore:TextField = new TextField(otherScoreBG.width, otherScoreBG.height, "" + ScreenManager.gameModel.otherPlayer.score, "Aldo", 30, 0xFFFFFF);
			otherScore.x = 852;// otherScoreBG.x;
			otherScore.y = 237;// otherScoreBG.y;
			addChild(otherScore);
			var otherLabel:TextField = new TextField(otherScoreBG.width, otherScoreBG.height >> 1, "GÉNÉRATION " + ScreenManager.gameModel.otherPlayer.generation.slice(2) +"’", "Aldo", 20, 0xFFFFFF);
			otherLabel.x = otherScoreBG.x;
			otherLabel.y = otherScoreBG.y;
			addChild(otherLabel);
			var selfScoreBG:Image = new Image(getTexture("UI/scoreBG"));
			selfScoreBG.scaleX = -1;
			selfScoreBG.x = Starling.current.stage.stageWidth - selfScoreBG.width;
			selfScoreBG.y = scoreTitleBG.y + scoreTitleBG.height;
			selfScoreBG.alpha = 0.7;
			selfScoreBG.blendMode = BlendMode.SCREEN;
			selfScoreBG.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			addChild(selfScoreBG);
			var selfScore:TextField = new TextField(selfScoreBG.width, selfScoreBG.height, "" + ScreenManager.gameModel.selfPlayer.score, "Aldo", 30, 0xFFFFFF);
			selfScore.x = 817;// selfScoreBG.x - selfScoreBG.width;
			selfScore.y = 237;// selfScoreBG.y;
			addChild(selfScore);
			var selfLabel:TextField = new TextField(selfScoreBG.width, selfScoreBG.height >> 1, "GÉNÉRATION " + ScreenManager.gameModel.selfPlayer.generation.slice(2) +"’", "Aldo", 20, 0xFFFFFF);
			selfLabel.x = selfScoreBG.x - selfScoreBG.width;
			selfLabel.y = selfScoreBG.y;
			addChild(selfLabel);
		}
		
		public function showScoreBonus():void
		{
			//cardValue.text = "" + currentCard.value + "";
			
			// No illustration for each card ATM
			//var illuTexture:Texture = AssetsManager.getAtlas("itemsSprites").getTexture(currentCard.name);
			//if(illuTexture !== null)
				//illustration = new Image(illuTexture);
			//else
				illustration = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].cards[currentCard.name].image;
			//illustration.x = 355;
			//illustration.y = currentCard.y + 150;
			illustration.x = (Starling.current.stage.stageWidth >> 1) - (illustration.width >> 1);
			illustration.x = (Starling.current.stage.stageHeight >> 1) - (illustration.height >> 1);
			//illustration.alpha = 0;
			currentCardHolder.addChild(illustration);

			/*cardValidatedTl = new TimelineMax();
			cardValidatedTl.insert(TweenMax.to(cardName, 0.4, { x: 20, ease:Cubic.easeInOut } ), 0.3);
			cardValidatedTl.insert(TweenMax.to(cardLabel, 0.4, { x: 20, ease:Cubic.easeInOut } ), 0.3);
			cardValidatedTl.insert(TweenMax.to(cardValueBG, 0.4, { x: 75 + cardValueBG.width - 5, ease:Cubic.easeInOut } ), 0.3);
			cardValidatedTl.insert(TweenMax.to(cardValue, 0.4, { x: -10, ease:Cubic.easeInOut } ), 0.3);
			cardValidatedTl.insert(TweenMax.to(illustration, 0.4, { alpha: 1, y: 135, ease:Cubic.easeInOut } ), 0.3);
			cardValidatedTl.insert(TweenMax.to(currentCard, 0.2, { alpha: 0, x: currentCard.y - 60, ease:Cubic.easeInOut } ), 0.3);
			
			cardValidatedTl.play();*/
		}
		
		public function showRevelation(otherBG:Image = null):void
		{
			if (player == "self") revelationSelfPlayer();
			else if (player == "other") revelationOtherPlayer(otherBG);
		}
		
		private function revelationSelfPlayer():void
		{
			var revelationTl:TimelineMax = new TimelineMax(/*{ onComplete: maskBackground}*/);
			revelationTl.insert(TweenMax.to(cardName, 0.4, { x: 30 - 75, ease:Cubic.easeInOut } ), 0);
			revelationTl.insert(TweenMax.to(cardLabel, 0.4, { x: 25 - 75, ease:Cubic.easeInOut } ), 0);
			revelationTl.insert(TweenMax.to(cardValueBG, 0.4, { x: 5 + cardValueBG.width - 5, ease:Cubic.easeInOut } ), 0);
			revelationTl.insert(TweenMax.to(cardValueDisplay, 0.4, { x: 5 - 75, ease:Cubic.easeInOut } ), 0);
			revelationTl.insert(TweenMax.to(illustration, 0.4, { x:10, y: 220, ease:Cubic.easeInOut } ), 0);
			
			revelationTl.play();			
		}
		
		private function revelationOtherPlayer(otherBG:Image):void
		{
			otherBGHolder = new ClippedSprite();
			addChild(otherBGHolder);
			otherBGHolder.clipRect = new Rectangle(Starling.current.stage.stageWidth >> 1, 0, Starling.current.stage.stageWidth >> 1, Starling.current.stage.stageHeight);
			otherBGHolder.x = Starling.current.stage.stageWidth;
			otherBGHolder.addChild(otherBG);
			swapChildren(otherBGHolder, currentCardHolder);
			swapChildren(cardName, currentCardHolder);
			var revelationTl:TimelineMax = new TimelineMax(/*{ onComplete: maskBackground}*/);
			//revelationTl.insert(TweenMax.to(otherBG, 0.4, { x: Starling.current.stage.stageWidth - otherBG.width, ease:Cubic.easeInOut } ), 0);
			revelationTl.insert(TweenMax.to(otherBGHolder, 0.4, { x: 0, ease:Cubic.easeInOut } ), 0);
			revelationTl.insert(TweenMax.to(cardName, 0.4, { x: Starling.current.stage.stageWidth - cardName.width, ease:Expo.easeInOut } ), 0);
			revelationTl.insert(TweenMax.to(cardLabel, 0.4, { x: Starling.current.stage.stageWidth - cardLabel.width + 5, ease:Expo.easeInOut } ), 0);
			revelationTl.insert(TweenMax.to(cardValueBG, 0.4, { x: Starling.current.stage.stageWidth - 35 - (cardValueBG.width << 1) - 5, ease:Expo.easeInOut } ), 0);
			revelationTl.insert(TweenMax.to(cardValue, 0.4, { x: Starling.current.stage.stageWidth - cardValue.width - 20, ease:Expo.easeInOut } ), 0);
			revelationTl.insert(TweenMax.to(illustration, 0.4, { x:543, y: 250, ease:Expo.easeInOut } ), 0);
			//revelationTl.insert(TweenMax.to(otherBG, 0.4, { x: (Starling.current.stage.stageWidth >> 1), ease:Expo.easeInOut } ), 0);
			
			revelationTl.play();
		}
		
		public function changeCardValue(value:int):void
		{
			var prevCardValue:int;

			prevCardValue = ScreenManager.gameModel.selfPlayer.currentCard.value;
			ScreenManager.gameModel.selfPlayer.currentCard.value = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].cards[ScreenManager.gameModel.selfPlayer.currentCard.name].value = Math.min(5, ScreenManager.gameModel.selfPlayer.currentCard.value + 2);
			
			cardValueDisplay.addStar(prevCardValue,  ScreenManager.gameModel.selfPlayer.currentCard.value, 0.4, 0.15);
		}
		
		/*private function maskBackground():void
		{
			if (player == "self")
			{
				
			}
			else if (player == "other")
			{
				
			}
		}*/
		
		private function initOtherPlayer(_bg:Texture = null):void
		{
			//var background:Image = new Image(_bg);
			//addChild(background);
			
			cardName = new TextField(500, 100, currentCard.name.toUpperCase(), "Aldo", 65, 0xFFFFFF, true);
			cardName.x = Starling.current.stage.stageWidth + 350;
			cardName.y = 130;
			cardName.vAlign = "top";
			//otherCardName.border = true;
			addChild(cardName);
			cardLabel = new TextField(500, 80, "Valeur", "Aldo", 45, 0xFFFFFF, true);
			cardLabel.x = Starling.current.stage.stageWidth + 500;
			cardLabel.y = 210;
			//otherCardLabel.border = true;
			addChild(cardLabel);
			cardValueBG = new Image(getTexture('UI/cardValue'));
			cardValueBG.x = Starling.current.stage.stageWidth + 500;
			cardValueBG.y = 300;
			addChild(cardValueBG);
			cardValue = new TextField(500, 150, "" + currentCard.value + "", "Aldo", 98, 0xFFFFFF, true);
			cardValue.x = Starling.current.stage.stageWidth;
			cardValue.y = 277;
			//otherCardValue.border = true;
			addChild(cardValue);
			//otherCurrentCardHolder.addChild(otherCurrentCard);
			//otherCurrentCard.x = Starling.current.stage.stageWidth;
			//otherCurrentCard.y = currentCard.y;
			
			// No illus ATM
			var illuTexture:Texture = getTexture("Items/" + currentCard.name);
			if(illuTexture !== null)
				illustration = new Image(illuTexture);
			else
				illustration = ScreenManager.gameModel.generations[ScreenManager.gameModel.otherPlayer.generation].cards[currentCard.name].image;
			illustration.x = 355;
			illustration.x = Starling.current.stage.stageWidth + 350;
			illustration.y = currentCard.y + 150;// 223;
			currentCardHolder.addChild(illustration);
		}
		
		public override function dispose():void
		{
			assets.purge();
		}
	}

}