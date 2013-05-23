package eiko.screens.ui
{
	import eiko.screens.utils.AssetsManager;
	import starling.display.BlendMode;
	import starling.text.TextField;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class GenerationButton extends Sprite 
	{
		private var _year:String;
		public var background:Image;
		public var generationTitle:TextField;
		public var yearTitle:TextField;
		
		public function GenerationButton(_background:Texture, card1:Texture, card2:Texture, y:String) 
		{
			super();
			year = y;
			
			background = new Image(_background);
			background.blendMode = BlendMode.MULTIPLY;
			addChild(background);
			
			generationTitle = new TextField(background.width, 30, "GÉNÉRATION", "Aldo", 30, 0xFFFFFF);
			generationTitle.y = 18;
			addChild(generationTitle);
			
			yearTitle = new TextField(background.width, 60, y.substr(2, 2) + "’", "Aldo", 50, 0xFFFFFF);
			yearTitle.y = 43;
			addChild(yearTitle);
			
			var cardX:int;
			switch(year)
			{
				case "1950":
					cardX = 44;
					break;
				case "1970":
					cardX = 79;
					break;
				case "1990":
					cardX = 70;
					break;
			}
			
			var cardUnder:Image = new Image(card1);
			cardUnder.pivotX = cardUnder.width >> 1;
			cardUnder.pivotY = cardUnder.height >> 1;
			cardUnder.x = cardX + (cardUnder.width >> 1);
			cardUnder.y = 117 + (cardUnder.height >> 1);
			cardUnder.rotation = Math.PI * -13 / 180;
			addChild(cardUnder);
			
			var cardOver:Image = new Image(card2);
			cardOver.pivotX = cardOver.width >> 1;
			cardOver.pivotY = cardOver.height >> 1;
			cardOver.x = cardX + (cardOver.width >> 1);
			cardOver.y = 117 + (cardOver.height >> 1);
			addChild(cardOver);
			
			this.pivotX = _background.width >> 1;
			this.pivotY = _background.height >> 1;
		}
		
		public function get year():String 
		{
			return _year;
		}
		
		public function set year(value:String):void 
		{
			_year = value;
		}
		
	}

}