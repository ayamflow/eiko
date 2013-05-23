package eiko.screens.game.pregame 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quad;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import eiko.entities.Server;
	import eiko.models.game.Card;
	import eiko.models.game.Generation;
	import eiko.models.game.Pattern;
	import eiko.models.game.Player;
	import eiko.screens.Screen;
	import eiko.screens.ui.CardBorder;
	import eiko.screens.ui.CardsDeck;
	import eiko.screens.ui.CardValueLabel;
	import eiko.screens.ui.StartGameButton;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import eiko.utils.Math2;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 * 
	 */
	public class CardSelector extends Screen 
	{
		private var labels:Vector.<CardValueLabel>;
		private var borders:Vector.<CardBorder>;
		private var cards:Object;
		
		private var background:Image;
		private var check:StartGameButton;
		private var previousBorder:CardBorder;
		//private var cardsSetNumber:int = 0;
		
		private var bottomGap:int = 80;
		
		private var cardsReadyCpt:Vector.<String>;
		private var deck:CardsDeck;
		private var title:TextField;
		private var cardBackground:Image;
		private var titleBg:Image;
		
		public function CardSelector(params:Object) 
		{
			assets.enqueue('Background/Generations/' + ScreenManager.gameModel.selfPlayer.generation + '.jpg');

			assets.enqueue("Sounds/card-selector/select.mp3");
			assets.enqueue("Sounds/card-selector/pick-card.mp3");
			assets.enqueue("Sounds/card-selector/drop-card.mp3");
			assets.enqueue("Sounds/cancel.mp3");
			
			cards = ScreenManager.gameModel.playerCards(ScreenManager.gameModel.selfPlayer);
			labels = new Vector.<CardValueLabel>(5, true);
			borders = new Vector.<CardBorder>(5, true);
						
			cardsReadyCpt = new Vector.<String>();
		}
		
		protected override function added():void
		{
			background = new Image(getTexture(ScreenManager.gameModel.selfPlayer.generation));
			addChild(background);
			
			cardBackground = new Image(getTexture("UI/cardReaderBG"));
			cardBackground.y = 577;
			cardBackground.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			cardBackground.blendMode = BlendMode.MULTIPLY;
			cardBackground.alpha = 0.8;
			addChild(cardBackground);
			
			for (var i:int = 0; i < 5; i++)
			{
				labels[i] = new CardValueLabel(i+1, getTexture("UI/cardSelectValueBg"), getTexture("UI/cardSelectValueBorder"), getTexture("UI/cardSelectValueStar"), getTexture("UI/cardSelectValueStarEmpty"));
				labels[i].x = 84 + ((labels[i].width + 28) * i);
				labels[i].y = 466;
				addChild(labels[i]);
				borders[i] = new CardBorder(getTexture("UI/cardValueBorder"), i);
				borders[i].x = labels[i].x;
				borders[i].y = 256;
				addChild(borders[i]);
			}
			
			check = new StartGameButton(getTexture('UI/cardSelectValueOk'), "COMMENCER", "LA PARTIE");
			check.x = 412;
			check.y = 618;
			check.alpha = 0;
			addChild(check);
			
			switch(ScreenManager.gameModel.selfPlayer.generation)
			{
				case "1950":
					deck = new CardsDeck("1950", "bilboquet", "toupie");
					break;
				case "1970":
					deck = new CardsDeck("1970", "telephone", "kiki");					
					break;
				case "1990":
					deck = new CardsDeck("1990", "hippo", "gameboy");					
					break;
			}
			//deck.x = Starling.current.stage.stageWidth >> 1;
			deck.x = 507;
			deck.y = 478;
			//deck.y = (Starling.current.stage.stageHeight >> 1) - 50;
			addChild(deck);
			
			titleBg = new Image(getTexture("UI/titleBg"));
			titleBg.y = 107;
			titleBg.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			titleBg.blendMode = BlendMode.MULTIPLY;
			titleBg.alpha = 0.6;
			addChild(titleBg);
			
			title = new TextField(Starling.current.stage.stageWidth, titleBg.height, "Définis les valeurs de tes cartes !", "Aldo", 30, 0xFFFFFF);
			title.y = 118;
			addChild(title);
			
			ScreenManager.server.addEventListener(Server.CARDS_VALUE, updateCardsValue);
		}
		
		private function updateCardsValue(e:Event):void
		{
			onCardsReady("other");
		}
		
		private function dragAndDropValue(evt:TouchEvent):void 
		{
			var touch:Touch = evt.getTouch(stage);
			var touchBegan:Touch = evt.getTouch(stage, TouchPhase.BEGAN);
			var touchMoved:Touch = evt.getTouch(stage, TouchPhase.MOVED);
			var touchEnded:Touch = evt.getTouch(stage, TouchPhase.ENDED);
			var multiTouch:Vector.<Touch> = evt.getTouches(stage);
			var target:Image;
			if (multiTouch.length > 1)
			{
				target = evt.currentTarget as Image;
				target.x = 317 + deck.cardsVector.indexOf(target) * 90;
				target.y = 678.5;
				target.scaleX = target.scaleY = 0.5;
				target = null;
				return;
			}
			
			if (touchBegan || touchMoved || touchEnded)
			{
				target = evt.currentTarget as Image;
				var key:String;
				var p:Point = touch.getLocation(stage);
				addChild(target);
				
				if (touchBegan)
				{
					previousBorder = null;
					for (var i:int = 0, l:int = borders.length; i < l; i++)
					{
						if (Math2.collision(target, borders[i])) // Move a card already positioned
						{
							previousBorder = borders[i];
							TweenMax.to(previousBorder, 0, { alpha:1, ease:Expo.easeOut } );
							borders[i].occupied = false;
							break;
						}
						
						// Too much fruit ninja
						//AssetsManager.play("pick-card");
					}
					TweenMax.to(target, 0, { scaleX:0.8, scaleY:0.8, ease: Expo.easeOut } );
				}
				
				if (touchMoved)
				{
					target.x = p.x;
					target.y = p.y;
					for (i = 0, l = borders.length; i < l; i++)
					{
						if (Math2.collision(target, borders[i]) && !borders[i].occupied)
						{
							TweenMax.to(borders[i], 0, { alpha:0.5, ease:Expo.easeOut } );
						}
						else if (!borders[i].occupied)
						{
							TweenMax.to(borders[i], 0, { alpha:1, ease:Expo.easeOut } );
						}
						//if (borders[i].alpha >= 0.5)
						//{
							//if (Math2.collision(target, borders[i]))
							//{
								//TweenMax.to(borders[i], 0.2, { alpha:0.5, ease:Expo.easeOut } );
							//}
						//}
						//else (borders[i].alpha == 0.5)
						//{
							//if (!Math2.collision(target, borders[i]))
							//{
								//TweenMax.to(borders[i], 0.2, { alpha:1, ease:Expo.easeOut } );
							//}
						//}
					}
				}
				
				if (touchEnded)
				{
					var isCollide:Boolean = false;
					var currentBorder:CardBorder;
					var prevCard:Image;
					
					for (i = 0, l = borders.length; i < l; i++)
					{
						if (Math2.collision(target, borders[i]))
						{
							isCollide = true;
							currentBorder = borders[i];
							borders[i].occupied = true;
							break;
						}
					}
					if (isCollide) // Card is dropped on a border
					{
						var newValue:int = currentBorder.value + 1;
						TweenMax.to(target, 0, { scaleX: 1, scaleY: 1 } );
						for (var name:String in cards)
						{
							if (cards[name].value == newValue && cards[name].image !== target) // overlap
							{
								prevCard = cards[name].image;
								if (previousBorder) // card swapping
								{
									TweenMax.to(prevCard, 0.2, { x: ~~(previousBorder.x + (target.width >> 1)), y: ~~(previousBorder.y + (target.height >> 1)), ease:Expo.easeOut } );
									setCardValue(previousBorder.value + 1, prevCard);
									break;
								}
								else
								{
									TweenMax.to(prevCard, 0.2, { x: 317 + deck.cardsVector.indexOf(prevCard) * 90, y: 678.5, scaleX: 0.5, scaleY: 0.5, ease:Expo.easeOut } );
									setCardValue(0, prevCard);
									break;
								}
							}
						}
						assets.play("drop-card");
						setCardValue(newValue, target);
						TweenMax.to(target, 0.2, { x: ~~(currentBorder.x + (target.width >> 1)), y: ~~(currentBorder.y + (target.height >> 1)), ease:Expo.easeOut } );
						TweenMax.to(currentBorder, 0.2, { alpha:0, ease:Expo.easeOut } );
					}
					else
					{
						var index:int = deck.cardsVector.indexOf(target);
						setCardValue(0, target);
						assets.play("cancel");
						TweenMax.to(target, 0.2, { x: 317 + index * 90, y: 678.5, scaleX: 0.5, scaleY: 0.5, ease:Expo.easeOut } );
					}
					
					checkIfCardsReady();
				}
			}
		}
		
		private function checkIfCardsReady():void 
		{
			var cardsSetNumber:int = 0;
			for (var name:String in cards)
			{
				if (cards[name].value > 0) cardsSetNumber++;
			}
			if (cardsSetNumber == 5) validateCardsOrder();
			else devalidateCardsOrder();
		}
		
		private function setCardValue(value:int, image:Image):void
		{
			var cardsFull:Object = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].cards;
			
			for (var name:String in cards)
			{
				if (image == cards[name].image)
				{
					cards[name].value = value;
					return;
				}
			}
		}
		
		private function getCardFromValue(value:int):Image
		{
			var image:Image;
			for (var name:String in cards)
			{
				if (cards[name].value == value)
				{
					//image = cards[name].image;
					//return image;
					return cards[name].image;
				}
			}
			return image;
		}
		
		public override function addEvents():void 
		{
			for (var i:int = 0; i < labels.length; i++)
			{
				deck.cardsVector[i].addEventListener(TouchEvent.TOUCH, dragAndDropValue);
			}
		}
		
		private function validateCardsOrder():void
		{
			TweenMax.to(check, 0.5, { alpha: 1, ease:Quad.easeInOut } );
			check.addEventListener(TouchEvent.TOUCH, registerCardsOrder);
		}
		
		private function devalidateCardsOrder():void
		{
			TweenMax.to(check, 0.2, { alpha: 0, ease:Quad.easeInOut } );
			check.removeEventListener(TouchEvent.TOUCH, registerCardsOrder);
		}
		
		private function registerCardsOrder(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				assets.play("select");
				
				var cardsValues:Object = { };
				for (var name:String in cards)
				{
					cardsValues[name] = cards[name].value;
				}
				ScreenManager.server.send( { type: Server.CARDS_VALUE, content: cardsValues } );
				onCardsReady("self");
				check.removeEventListener(TouchEvent.TOUCH, registerCardsOrder);
				TweenMax.to(check, 0.5, { alpha: 0, ease:Quad.easeInOut } );
			}
		}
		
		private function onCardsReady(who:String):void 
		{
			trace('onCardReady', who);
			cardsReadyCpt.push(who);
			if (cardsReadyCpt.indexOf("self") > -1 && cardsReadyCpt.indexOf("other") > -1)
			{
				//changeScreen(Screen.CARD_DETECTOR, TransitionManager.TRANSITION_OUT_AND_AFTER_IN);
				changeScreen(Screen.INTERSCREEN, TransitionManager.TRANSITION_OUT_AND_AFTER_IN, {screen: Screen.CARD_DETECTOR, text: "MANCHE " + ScreenManager.gameModel.round, transition: TransitionManager.TRANSITION_OUT_AND_AFTER_IN});
			}
		}
		
		public override function transitionIn():void
		{
			var time:Number = 0;
			var ad:Number = 0.2;
			
			transitionTl.insert(TweenMax.from(background, 0.4, { alpha: 0, ease:Cubic.easeInOut } ), time += 0.1);
			transitionTl.insert(TweenMax.from(titleBg , 0.4, { x: -titleBg.width, alpha: 0, ease:Cubic.easeInOut } ), time += 0.1);
			transitionTl.insert(TweenMax.from(title, 0.4, { alpha: 0, ease:Cubic.easeInOut } ), time += ad);
			transitionTl.insert(TweenMax.from(cardBackground, 0.4, { x: Starling.current.stage.stageWidth, ease:Cubic.easeInOut } ), time += ad);
			
			var card:Image;
			for (var i:int = 0, l:int = deck.cardsVector.length; i < l; i++)
			{
				card = deck.cardsVector[i];
				
				card.scaleX = card.scaleY = 0.5;
				card.parent.removeChild(card);
				addChild(card);
				card.x = 317 + i * (card.width + 15);
				card.y = 678.5;
				
				transitionTl.insert(TweenMax.from(card, 0.4, { x: deck.x, y: deck.y, scaleX:1, scaleY: 1, ease:Cubic.easeInOut } ), time += ad);
				transitionTl.addCallback(function():void
				{
					assets.play("pick-card");
				}, time);
				// card with rotation
				if (i == 3) transitionTl.insert(TweenMax.to(card, 0.4, { x: card.x + 82, rotation: 0, ease:Cubic.easeInOut } ), time);
				
				transitionTl.insert(TweenMax.from(labels[i], 0.4, {alpha: 0, ease:Cubic.easeInOut}), 2 + i*0.1);
				transitionTl.insert(TweenMax.from(borders[i], 0.4, { alpha: 0, ease:Cubic.easeInOut } ), 2 + i * 0.1);
			}
		}
		
		public override function transitionInComplete():void
		{
			ScreenManager.removeScreen();
		}
		
		public override function transitionOut():void
		{
			var ad:Number = 0.4;
			var card:Image;
			
			for (var i:int = 0, l:int = deck.cardsVector.length; i < l;  i++)
			{
				borders[i].alpha = 1;
				card = getCardFromValue(i + 1);
				transitionOutTl.insert(TweenMax.to(card, 0.5, { alpha: 0, y: 200, ease:Expo.easeInOut } ), ad += 0.1);
			}
			transitionOutTl.insert(TweenMax.to(this, 0.4, { alpha: 0 , ease:Quad.easeInOut}), ad + 0.4);
			transitionOutTl.play();
		}
		
		public override function transitionOutComplete():void
		{
			ScreenManager.assets.removeTextureAtlas("cardSprites");
		}
		
		public override function dispose():void
		{
			ScreenManager.server.removeEventListener(Server.CARDS_VALUE, updateCardsValue);
			for (var i:int = 0; i < labels.length; i++)
			{
				deck.cardsVector[i].addEventListener(TouchEvent.TOUCH, dragAndDropValue);
			}
			assets.purge();
		}
	}

}