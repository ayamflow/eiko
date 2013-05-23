package eiko.screens.ui 
{
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Background extends Image 
	{
		
		public function Background(_texture:Texture) 
		{
			super(_texture);
			blendMode = BlendMode.NONE;
		}
		
	}

}