package eiko.screens.ui 
{
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CardBorder extends Image 
	{
		private var _value:int;
		private var _occupied:Boolean = false;
		
		public function CardBorder(_texture:Texture, _value:int) 
		{
			this._value = _value;
			super(_texture);
		}
		
		public function get value():int 
		{
			return _value;
		}
		
		public function get occupied():Boolean 
		{
			return _occupied;
		}
		
		public function set occupied(value:Boolean):void 
		{
			_occupied = value;
		}
		
	}

}