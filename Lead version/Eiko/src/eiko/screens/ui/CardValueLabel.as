package eiko.screens.ui 
{
	import eiko.screens.utils.ScreenManager;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CardValueLabel extends Sprite 
	{
		private var value:int;
		
		public function CardValueLabel(_value:int, _background:Texture, _border:Texture, _fullStar:Texture, _emptyStar:Texture) 
		{
			var background:Image = new Image(_background);
			background.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			background.blendMode = BlendMode.MULTIPLY;
			addChild(background);
			
			var border:Image = new Image(_border);
			addChild(border);
			
			value = _value;
			
			var emptyStarNumber:int = 5 - value;
			var starX:int = 26;
			var starY:int = 28;
			
			var spriteHolder:Sprite = new Sprite();
			spriteHolder.x = -5;
			addChild(spriteHolder);
			
			for (var i:int = 0; i < value; i++)
			{
				var fullStar:Image = new Image(_fullStar);
				fullStar.pivotX = fullStar.width >> 1;
				fullStar.pivotY = fullStar.height >> 1;
				fullStar.x = starX * (i+1);
				fullStar.y = starY;
				spriteHolder.addChild(fullStar);
			}
			
			for (var j:int = 0; j < emptyStarNumber; j++)
			{
				var emptyStar:Image = new Image(_emptyStar);
				emptyStar.x = i * starX + (j + 1) * starX;
				emptyStar.pivotX = emptyStar.width >> 1;
				emptyStar.pivotY = emptyStar.height >> 1;
				emptyStar.y = starY;
				spriteHolder.addChild(emptyStar);
			}
			
			this.flatten();
		}
		
	}

}