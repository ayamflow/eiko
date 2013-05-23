package eiko.screens.ui 
{
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CardsDeck extends Sprite 
	{
		public var cardsVector:Vector.<Image>;
		
		public function CardsDeck(year:String, firstCardName:String, secondCardName:String) 
		{
			var cards:Object = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].cards;
			
			cardsVector = new Vector.<Image>(5, true);
			
			var firstCard:Image = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].cards[firstCardName].image;
			var secondCard:Image = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].cards[secondCardName].image;
			cardsVector[4] = firstCard;
			firstCard.smoothing = TextureSmoothing.NONE;
			cardsVector[3] = secondCard;
			secondCard.smoothing = TextureSmoothing.NONE;
						
			var cardX:int = 0;
			/*switch(year)
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
			}*/
			
			addChild(secondCard);
			addChild(firstCard);
			var hiddenCard:Image;
			var i:int = 0;
			for (var name:String in cards)
			{
				if (name != firstCardName && name != secondCardName)
				{
					hiddenCard = cards[name].image;
					cardsVector[i++] = hiddenCard;
					hiddenCard.pivotX = hiddenCard.width >> 1;
					hiddenCard.pivotY = hiddenCard.height >> 1;
					hiddenCard.x = cardX + (hiddenCard.width >> 1);
					hiddenCard.y = 117 + (hiddenCard.height >> 1);
					hiddenCard.smoothing = TextureSmoothing.NONE;
					addChild(hiddenCard);
				}
			}
			
			secondCard.pivotX = secondCard.width >> 1;
			secondCard.pivotY = secondCard.height >> 1;
			secondCard.x = cardX + (secondCard.width >> 1);
			secondCard.y = 117 + (secondCard.height >> 1);
			secondCard.rotation = Math.PI * -13 / 180;
			
			firstCard.pivotX = firstCard.width >> 1;
			firstCard.pivotY = firstCard.height >> 1;
			firstCard.x = cardX + (firstCard.width >> 1);
			firstCard.y = 117 + (firstCard.height >> 1);
			
			this.pivotX = firstCard.width >> 1;
			this.pivotY = firstCard.height >> 1;
		}
	}	
}