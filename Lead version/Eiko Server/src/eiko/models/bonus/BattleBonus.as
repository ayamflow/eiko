package eiko.models.bonus 
{
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class BattleBonus extends Bonus 
	{		
		public function BattleBonus() 
		{
			type = "battle";
		}
		
		public override function utilize():void
		{
			
			super.utilize();
		}
		
	}

}