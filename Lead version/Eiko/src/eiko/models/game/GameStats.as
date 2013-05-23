package eiko.models.game 
{
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class GameStats 
	{
		private var stats:Array;
		public function GameStats() 
		{
			stats = new Array();
		}
		
		public function updateStats(round:int, selfCurrentCard:String, otherCurrentCard:String, winner:String):void
		{
			stats[round - 1] = {
				selfCard: selfCurrentCard,
				otherCard: otherCurrentCard,
				winner: winner
			};
		}
		
		public function getStats():Array
		{
			return stats;
		}
		
	}

}