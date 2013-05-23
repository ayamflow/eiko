package eiko.models.game 
{
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import starling.display.Image;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Generation 
	{
		private var _name:String; // 1950 || 1970 || 1990
		private var _cards:Object;
		private var _positionPattern:int;
		public var color:uint;
				
		public function Generation(year:String, cardsUrl:Object, position:int, _color:uint)
		{
			name = year;
			cards = new Object();
			
			positionPattern = position;
			color = _color;
			
			var cardName:String;
			for(var i:int = 1; i <= cardsUrl.length; i++)
			{
				cardName = cardsUrl[i].image.substring(cardsUrl[i].image.lastIndexOf("/") + 1).split('.jpg')[0];
				//trace(ScreenManager.assets.getAtlas("cardSprites"));
				//trace(ScreenManager.assets.getAtlas("cardSprites").getTexture(name + "/" + cardName));
				cards[cardName] = new Card(cardName, name, new Image(ScreenManager.assets.getAtlas("cardSprites").getTexture(name + "/" + cardName)), new Pattern(position, Pattern.PATTERNS[i-1]), cardsUrl[i].color);
			}
		}
		
		public function getCard(i:int):Card
		{
			var cpt:int = 0;
			var card:Card;
			for (var name:String in cards)
			{
				if (cpt == i)
				{
					card = cards[name];
					break;
				}
				else
				{
					cpt++;
				}
			}
			return card;
		}
		
		public function get cards():Object 
		{
			return _cards;
		}
		
		public function set cards(value:Object):void 
		{
			_cards = value;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get positionPattern():int 
		{
			return _positionPattern;
		}
		
		public function set positionPattern(value:int):void 
		{
			_positionPattern = value;
		}
	}

}