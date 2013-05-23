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
	 * @author Florian Morel
	 */
	public class DuelButton extends Sprite 
	{
		
		public function DuelButton(_texture:Texture, _text:String, _facing:Boolean = false) 
		{
			var background:Image = new Image(_texture);
			background.pivotX = background.width >> 1;
			background.x = background.width >> 1;
			background.scaleX = _facing ? -1 : 1;
			background.blendMode = BlendMode.MULTIPLY;
			background.alpha = 0.8;
			background.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			addChild(background);
			
			var label:TextField = new TextField(background.width, background.height, _text, "Aldo", 45, 0xFFFFFF);
			addChild(label);
		}
		
	}

}