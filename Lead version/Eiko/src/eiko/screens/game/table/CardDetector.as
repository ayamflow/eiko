package eiko.screens.game.table 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import eiko.entities.CardReader;
	import eiko.entities.Server;
	import eiko.models.game.Card;
	import eiko.screens.Screen;
	import eiko.screens.ui.CardValue;
	import eiko.screens.ui.CheckButton;
	import eiko.screens.ui.Header;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CardDetector extends Screen 
	{
		private var currentCard:Card;
		private var background:Image;
		private var cardReader:CardReader;
		private var currentCardHolder:Sprite;
		private var cardOkButton:CheckButton;
		private var cardCancelButton:CheckButton;
		private var header:Header;
		private var currentCardImage:Image;
		private var cardValue:CardValue;
		private var noTop:Number;
		private var okTop:Number;
		
		public function CardDetector(params:Object = null) 
		{

			assets.enqueue("Background/Generations/" + ScreenManager.gameModel.selfPlayer.generation + ".jpg");
			assets.enqueue("Spritesheets/itemsSprites.xml");
			assets.enqueue("Spritesheets/itemsSprites.png");
			
			assets.enqueue("Sounds/table/card-detector/card-recognized.mp3");
			assets.enqueue("Sounds/cancel.mp3");
			assets.enqueue("Sounds/validate.mp3");
		}
		
		protected override function added():void
		{
			// Background
			background = new Image(getTexture(ScreenManager.gameModel.selfPlayer.generation));
			background.x = 0;
			background.y = 0;
			addChild(background);
			header = new Header();
			addChild(header);
			
			// Card Detection zone
			cardReader = new CardReader(355, 368, getTexture('UI/cardReader'), getTexture("UI/cardReaderBG"));
			cardReader.x = 0;
			cardReader.y = Starling.current.stage.stageHeight - cardReader.height;
			cardReader.addEventListener(CardReader.CARD_RECOGNIZED, cardRecognized);
			addChild(cardReader);
			
			// Where the detected card will be shown
			currentCardHolder = new Sprite();
			currentCardHolder.alpha = 0;
			addChild(currentCardHolder);
			
			// Checkbox
			cardOkButton = new CheckButton(getTexture("UI/checkSymbol"));
			cardCancelButton = new CheckButton(getTexture("UI/cancelSymbol"));

			okTop = 556;
			noTop = 647;
			
			cardOkButton.x = 778;
			cardOkButton.y = okTop;
			cardOkButton.alpha = 0;
			addChild(cardOkButton);
			
			cardCancelButton.x = 778;
			cardCancelButton.y = noTop;
			cardCancelButton.alpha = 0;
			addChild(cardCancelButton);
		}
		
		//-------------------------------------------
		//		TANGIBLE EVENTS
		//-------------------------------------------
		private function cardRecognized(e:Event):void
		{
			assets.play("card-recognized");
			
			TweenMax.killAll();
			removeChild(cardValue);
			cardReader.removeEventListener(CardReader.CARD_RECOGNIZED, cardRecognized);
			currentCard = e.data as Card;
			//currentCardImage = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].cards[currentCard.name].image;
			currentCardImage = new Image(getAtlas("itemsSprites").getTexture(currentCard.name));
			//currentCardImage.scaleX = currentCardImage.scaleY = 0.85;
			currentCardImage.scaleX = currentCardImage.scaleY = 1;
			currentCardImage.x = (Starling.current.stage.stageWidth >> 1) - (currentCardImage.width >> 1);
			currentCardImage.y = (Starling.current.stage.stageHeight >> 1) - currentCardImage.height + (currentCardImage.height >> 2);

			cardValue = new CardValue(currentCard, getTexture("UI/cardReaderValueBG-small"), getTexture("UI/cardValueBorder2"), getTexture("UI/cardValueBg"), getTexture("UI/cardSelectValueStar"), getTexture("UI/cardSelectValueStarEmpty"));
			cardValue.alpha = 0;
			cardValue.y = 70.5;
			addChild(cardValue);
			
			currentCardHolder.addChild(currentCardImage);
			TweenMax.fromTo(cardOkButton, 0.2, {alpha: 0, y: okTop - 30}, { alpha: 1, y: okTop, delay: 0.1, ease: Cubic.easeInOut } );
			TweenMax.fromTo(cardCancelButton, 0.2, {alpha: 0, y: noTop - 30},{ alpha: 1, y: noTop, ease: Cubic.easeInOut } );
			TweenMax.fromTo(cardValue, 0.4, { alpha: 0, x: -cardValue.width, ease:Cubic.easeInOut }, { alpha: 1, x: 0, ease:Cubic.easeInOut } );
			TweenMax.fromTo(currentCardHolder, 0.4, { alpha: 0, x: -30, ease:Cubic.easeInOut }, { alpha: 1, x: 0, ease:Cubic.easeInOut } );
			
			cardOkButton.addEventListener(TouchEvent.TOUCH, validateCard);
			cardCancelButton.addEventListener(TouchEvent.TOUCH, cancelCard);
			TweenMax.to(cardOkButton, 0.5, { alpha: 1, ease:Cubic.easeInOut } );
		}
		
		// Checkbox onTouch
		private function validateCard(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if (touch)
			{
				assets.play("validate");
				currentCard.used = true;
				ScreenManager.server.send( { type:Server.CARD_PLAYED, content: currentCard.name } );
				cardOkButton.removeEventListener(TouchEvent.TOUCH, validateCard);
				cardCancelButton.removeEventListener(TouchEvent.TOUCH, cancelCard);
				ScreenManager.gameModel.selfPlayer.currentCard = currentCard;
				changeScreen(Screen.TABLE, TransitionManager.TRANSITION_OUT_AND_AFTER_IN);
			}
		}
		
		private function cancelCard(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if (touch)
			{
				assets.play("cancel");
				cardReader.addEventListener(CardReader.CARD_RECOGNIZED, cardRecognized);
				
				TweenMax.to(cardOkButton, 0.2, { alpha: 0, y: okTop + 30, delay: 0.1, ease: Cubic.easeInOut } );
				TweenMax.to(cardCancelButton, 0.2, { alpha: 0, y: noTop + 30, ease: Cubic.easeInOut } );
				
				TweenMax.to(cardValue, 0.4, { x: -cardValue.width, ease:Cubic.easeInOut, onComplete: function():void
					{
						removeChild(cardValue);
					}
				});
				TweenMax.to(currentCardHolder, 0.4, { alpha: 0, x: 30, ease:Cubic.easeInOut, onComplete: function():void
					{
						currentCardHolder.removeChildren();
					}
				});
			}
		}
		
		public override function transitionIn():void
		{
			transitionTl.insert(TweenMax.from(cardReader, 0.4, { alpha: 0, y: Starling.current.stage.stageHeight, ease: Cubic.easeInOut } ), 0);
			transitionTl.play();
		}
		
		public override function transitionOut():void
		{
			transitionOutTl.insert(TweenMax.to(cardReader, 0.4, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), 0);
			transitionOutTl.insert(TweenMax.to(cardOkButton, 0.3, { alpha: 0, x: cardOkButton.x + 30, ease:Cubic.easeInOut } ), 0);
			transitionOutTl.insert(TweenMax.to(cardCancelButton, 0.3, { alpha: 0, x: cardCancelButton.x + 30, ease:Cubic.easeInOut } ), 0);
			transitionOutTl.insert(TweenMax.to(currentCardImage, 0.4, { x: currentCardImage.x + 80, y: currentCard.y - 500, ease:Cubic.easeInOut } ), 0.3);
			transitionOutTl.play();
		}
		
		public override function dispose():void
		{
			cardReader.removeEventListener(CardReader.CARD_RECOGNIZED, cardRecognized);
			cardReader.dispose();
			assets.purge();
		}
	}
}