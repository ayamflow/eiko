package eiko.screens.ui 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import eiko.models.game.Card;
	import eiko.screens.utils.ScreenManager;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CardValue extends Sprite 
	{
		private var starX:int;
		private var starY:int;
		private var starFullTexture:Texture;
		private var spriteHolder:Sprite;
		private var textValue:TextField;
		
		private var margin:Number;
		
		public function CardValue(_card:Card, _background:Texture, _border:Texture, _valueBackground:Texture, _starFull:Texture, _starEmpty: Texture, _margin:Number = 0)
		{
			var background:Image = new Image(_background);
			background.blendMode = BlendMode.MULTIPLY;
			background.alpha = 0.3;
			background.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			addChild(background);
			if (_margin > 0) background.x = 10;
			
			var valueBG:Image = new Image(_valueBackground);
			valueBG.x = 69 + _margin;
			valueBG.y = 171;
			valueBG.blendMode = BlendMode.MULTIPLY;
			valueBG.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			addChild(valueBG);
			
			var border:Image = new Image(_border);
			border.x = 69 + _margin;
			border.y = 171;
			addChild(border);
			
			var emptyStarNumber:int = 5 - _card.value;
			starX = 25;
			starY = 300;
			
			spriteHolder = new Sprite();
			spriteHolder.x = 64;
			addChild(spriteHolder);
			
			var nameFontSize:int = _card.name.length > 9 ? 30 : 50;
			var cardName:TextField = new TextField(background.width, 120, _card.name.toUpperCase(), "Aldo", nameFontSize, 0xFFFFFF);
			cardName.x = -5 + (_margin > 0) ? 20 : 0;
			cardName.y = 20;
			addChild(cardName);
			
			var cardValueText:TextField = new TextField(background.width, 120, "Valeur de la carte", "Aldo", 28, 0xFFFFFF);
			cardValueText.x = -5 + (_margin > 0) ? 20 : 0;
			cardValueText.y = 70;
			addChild(cardValueText);
			
			margin = _margin;
			
			textValue = new TextField(valueBG.width, valueBG.height, "" + _card.value, "Aldo", 85, 0xFFFFFF);
			textValue.pivotX = textValue.width >> 1;
			textValue.pivotY = textValue.height >> 1;
			textValue.x = 70 + (textValue.width >> 1) + _margin;
			textValue.y = 195 + (textValue.height >> 1) - (valueBG.height >> 2);
			addChild(textValue);
			
			starFullTexture = _starFull;
			
			addStar(0, _card.value);
			
			for (var j:int = 0; j < emptyStarNumber; j++)
			{
				var emptyStar:Image = new Image(_starEmpty);
				emptyStar.x = _card.value * starX + (j + 1) * starX + _margin;
				emptyStar.pivotX = emptyStar.width >> 1;
				emptyStar.pivotY = emptyStar.height >> 1;
				emptyStar.y = starY;
				spriteHolder.addChild(emptyStar);
			}
		}
		
		public function scaleValue(to:Number, duration:Number, callback: Function):void
		{
			TweenMax.to(textValue, duration, { scaleX: to, scaleY: to, ease: Cubic.easeInOut, onComplete: callback} );
		}
		
		public function addStar(from:int, to:int, duration:Number = 0, delay:Number = 0):void
		{
			var starTl:TimelineMax = new TimelineMax();
			var time:Number = 0;
			for (from; from < to; from++)
			{
				var fullStar:Image = new Image(starFullTexture);
				fullStar.pivotX = fullStar.width >> 1;
				fullStar.pivotY = fullStar.height >> 1;
				fullStar.x = starX * (from+1) + margin;
				fullStar.y = starY;
				spriteHolder.addChild(fullStar);	
				starTl.insert(TweenMax.from(fullStar, duration, { alpha: 0, scaleX: 7, scaleY: 7, ease: Expo.easeInOut } ), time += delay);
			}
			if (duration > 0)
			{
				starTl.addCallback(function():void
				{
					textValue.text = "" + to;
				}, time);
				starTl.insert(TweenMax.from(textValue, duration, { fontSize: 130, immediateRender: false, ease: Expo.easeOut } ), time);
			}
			starTl.play();
		}
		
	}

}