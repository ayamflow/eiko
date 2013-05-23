package eiko.models.bonus 
{
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Bonus 
	{
		protected var _used:Boolean = false;
		protected var _type:String;
		
		public function Bonus()
		{

		}
		
		public function utilize():void
		{
			if (this.used) return;
			this.used = true;
		}
		
		public function get used():Boolean 
		{
			return _used;
		}
		
		public function set used(value:Boolean):void 
		{
			_used = value;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
	}

}