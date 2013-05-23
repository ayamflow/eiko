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
	public class CheckButton extends Sprite 
	{
		
		public function CheckButton(_symbol:Texture) 
		{
			var background:Image = new Image(ScreenManager.assets.getTexture("UI/checkBg"));
			background.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			background.blendMode = BlendMode.MULTIPLY;
			addChild(background);
			var symbol:Image = new Image(_symbol);
			symbol.x = (background.width >> 1) - (symbol.width >> 1);
			symbol.y = (background.height >> 1) - (symbol.height >> 1);
			addChild(symbol);
		}
		
	}

}