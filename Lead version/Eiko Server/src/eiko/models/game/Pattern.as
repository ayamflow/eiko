package eiko.models.game 
{
	import starling.events.Touch;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Pattern 
	{
		private var _pointsNumber:int;
		private var _identifierPosition:String;
		
		public static var LEFT:String = "Left";
		public static var CENTER:String = "Center";
		public static var RIGHT:String = "Right";
		
		public function Pattern(number:int, position:String)
		{
			//Model that identifies a card (conductive ink)
			pointsNumber = number;
			identifierPosition = position;
		}
		
		public function get pointsNumber():int 
		{
			return _pointsNumber;
		}
		
		public function set pointsNumber(value:int):void 
		{
			_pointsNumber = value;
		}
		
		public function get identifierPosition():String 
		{
			return _identifierPosition;
		}
		
		public function set identifierPosition(value:String):void 
		{
			_identifierPosition = value;
		}
		
	}

}