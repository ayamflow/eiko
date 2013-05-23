package eiko.screens.minigames.pong 
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Ball extends Image 
	{
		private var _velocityX:Number = 0;
		private var _velocityY:Number = 0;
		
		private var _directionX:int = 1;
		private var _directionY:int = 1;
		
		public function Ball(_texture:Texture) 
		{
			super(_texture);			
		}
		
		public function get velocityX():Number 
		{
			return _velocityX;
		}
		
		public function set velocityX(value:Number):void 
		{
			_velocityX = value;
		}
		
		public function get velocityY():Number 
		{
			return _velocityY;
		}
		
		public function set velocityY(value:Number):void 
		{
			_velocityY = value;
		}
		
		public function get directionX():int 
		{
			return _directionX;
		}
		
		public function set directionX(value:int):void 
		{
			_directionX = value;
		}
		
		public function get directionY():int 
		{
			return _directionY;
		}
		
		public function set directionY(value:int):void 
		{
			_directionY = value;
		}
	}

}