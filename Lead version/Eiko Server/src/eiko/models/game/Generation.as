package eiko.models.game 
{
	import eiko.screens.utils.ImagesLoader;
	import eiko.screens.utils.ScreenManager;
	import starling.display.Image;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Generation 
	{
		private var loader:ImagesLoader;
		private var _name:String; // 1950 || 1970 || 1990
		private var _cards:Object;
		private var _positionPattern:String;
		
		//PROTOTYPE
		public var protoCard:Card;
				
		public function Generation(year:String, cardsUrl:Object, position:String)
		{
			name = year;
			cards = new Object();
			
			positionPattern = position;
			
			//loader = new ImagesLoader(cardsUrl[1], cardsUrl[2], cardsUrl[3], cardsUrl[4], cardsUrl[5]);
			
			//loader.addEventListener(ImagesLoader.LOADING_COMPLETE, loaded);
			//loader.load();
			
			var cardName:String;
			for(var i:int = 1; i <= cardsUrl.length; i++)
			{
				cardName = cardsUrl[i].substring(cardsUrl[i].lastIndexOf("/") + 1).split('.jpg')[0];
				cards[cardName] = new Card(cardName, name, new Image(ScreenManager.atlas.getTexture('Cards/' + name + "/" + cardName)), new Pattern(i+1, positionPattern));
			}
		}
		
		/*private function loaded():void
		{
			var cardName:String;
			for(var i:int = 0; i < loader.length; i++)
			{
				cardName = loader.params[i].substring(loader.params[i].lastIndexOf("/") + 1).split('.jpg')[0];
				cards[cardName] = new Card(cardName, name, loader.getContent(loader.params[i]), new Pattern(i+2, positionPattern));
			}			
		}*/
		
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
		
		public function get positionPattern():String 
		{
			return _positionPattern;
		}
		
		public function set positionPattern(value:String):void 
		{
			_positionPattern = value;
		}
	}

}