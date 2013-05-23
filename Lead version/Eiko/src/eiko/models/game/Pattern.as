package eiko.models.game 
{
	import eiko.models.GameModel;
	import starling.events.Touch;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Pattern 
	{
		private var _cards:Array;
		private var _generation:int;
		
		public static var NONE:int = 0;
		// Card marker
		public static var Q_LEFT:int = 1;
		public static var Q_LEFT_MIDDLE:int = 2;
		public static var Q_RIGHT_MIDDLE:int = 3;
		public static var Q_RIGHT:int = 4;
		// Generation marker
		public static var T_LEFT:int = 5;
		public static var T_CENTER:int = 6;
		public static var T_RIGHT:int = 7;
		
		private static var THIRD_CARD:Number = GameModel.CARD_WIDTH / 3;
		private static var HALF_CARD:Number = GameModel.CARD_WIDTH / 2;
		private static var QUARTER_CARD:Number = GameModel.CARD_WIDTH / 4;
		
		public static var PATTERNS:Array = [
			[Q_LEFT, Q_LEFT_MIDDLE],
			[Q_LEFT, Q_RIGHT_MIDDLE],
			[Q_LEFT, Q_RIGHT],
			[Q_LEFT_MIDDLE, Q_RIGHT_MIDDLE],
			[Q_LEFT_MIDDLE, Q_RIGHT]
		];
		
		public function Pattern(_g:int, _c:Array)
		{
			_generation = _g;
			_cards = _c;
		}
		
		public static function identify(x:Number, baseX:Number, generation:Boolean = false):int
		{			
			var markerPosition:int = NONE;
			
			if (generation)
			{
				var third:Number = GameModel.CARD_WIDTH / 3;
				if (x < baseX + third + 20) markerPosition = T_LEFT;
				else if (x + 20 > baseX + third * 2) markerPosition = T_RIGHT;
				else markerPosition = T_CENTER;
			}
			else
			{
				// left marker
				if (x < baseX + HALF_CARD)
				{
					if (x < baseX + QUARTER_CARD)
					{
						markerPosition = Q_LEFT;
					}
					else if (x > baseX + QUARTER_CARD)
					{
						markerPosition = Q_LEFT_MIDDLE;
					}
				}
				// right marker
				else if (x > baseX + HALF_CARD)
				{
					if (x < baseX + HALF_CARD + QUARTER_CARD)
					{
						markerPosition = Q_RIGHT_MIDDLE;
					}
					else if (x > baseX + HALF_CARD + QUARTER_CARD)
					{
						markerPosition = Q_RIGHT;
					}
				}
			}
			return markerPosition;
		}
		
		public function get generation():int 
		{
			return _generation;
		}
		
		public function get cards():Array 
		{
			return _cards;
		}
	}

}