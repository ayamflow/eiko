package eiko.models.bonus 
{
	import eiko.models.game.Player;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class ScoreBonus extends Bonus 
	{
		private var target:Player;
		private var value:int;
		
		public function ScoreBonus(tar:Player, val:int) 
		{
			target = tar;
			value = val;
			type = "score";
		}
		
		public override function utilize():void
		{
			target.currentCard.value += value;
			super.utilize();
		}
		
	}

}