package eiko.models.bonus 
{
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class BattleBonus extends Bonus 
	{		
		public static const BATTLE:String = "battle";
		public static const NO_BATTLE:String = "noBattle";
		
		public function BattleBonus() 
		{
			super();
			type = "battle";
			//used = true;
		}
	}

}