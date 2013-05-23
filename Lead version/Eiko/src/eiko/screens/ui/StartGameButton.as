package eiko.screens.ui 
{
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
	public class StartGameButton extends Sprite 
	{
		
		public function StartGameButton(_background:Texture, _text1:String, _text2:String, _size1:int = -1, _size2:int = -1) 
		{
			var background:Image = new Image(_background);
			background.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			background.blendMode = BlendMode.MULTIPLY;
			background.alpha = 0.8;
			addChild(background);
			
			var textSize1:int = ~~(30 + (30 - (30*_text1.length/9)));
			var textSize2:int = ~~(39 + (39 - (39 * _text2.length / 9)));
			
			if (_size1 > 0) textSize1 = _size1;
			if (_size2 > 0) textSize2 = _size2;
			
			//trace(ScreenManager.gameModel.selfPlayer.generation, background.color);
			var text1:TextField = new TextField(background.width, (background.height >> 1), _text1, "Aldo", textSize1, 0xFFFFFF);
			text1.y = textSize1 > 30 ? 5 : 10;
			addChild(text1);
			var text2:TextField = new TextField(background.width, background.height >> 1, _text2, "Aldo", textSize2, 0xFFFFFF);
			text2.y = text1.height - 10;
			addChild(text2);
		}
	}
}