package eiko.models.bonus 
{
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class ScoreBonus extends Bonus 
	{	
		public static const SCORE:String = "score";
		public static const NO_SCORE:String = "noScore";
		
		public function ScoreBonus() 
		{
			super();
			_type = "score";
			//used = true;
		}
	}
}