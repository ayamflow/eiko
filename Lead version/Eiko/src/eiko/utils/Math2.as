package eiko.utils 
{
	import starling.core.Starling;
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Math2 
	{
		
		public static function rand2(obj1:Object, obj2:Object):Object
		{
			return Math.random() * -2 + 1 > 0 ? obj1 : obj2;
		}
		
		public static function rand(min:Number, max:Number):Number
		{
			return Math.random() * (max - min) + min;
		}
		
		public static function compare(first:Array, second:Array):Boolean
		{
			var same:Boolean = true;
			first.sort();
			second.sort();
			
			for (var i:int = 0, l:int = first.length; i < l; i++)
			{
				if (first[i] !== second[i]) same = false;
			}
			return same;
		}
		
		public static function collision(first:DisplayObject, second:DisplayObject):Boolean
		{
			if (first.getBounds(Starling.current.stage).intersects(second.getBounds(Starling.current.stage))) return true;
			else return false;
		}
		
		public static function normalizeAngle (_angle:Number):Number
		{ 
			var angle:Number = _angle % (2 * Math.PI); 
			return angle >= 0 ? _angle : _angle + 2 * Math.PI;
			//return _angle / 2 * Math.PI * 10;
		}
		
		public static function randValueFromArray(array:Array):Object
		{
			var l:int = array.length;
			var index:int = ~~(Math.random() * l);
			return array[index];
		}
	}

}