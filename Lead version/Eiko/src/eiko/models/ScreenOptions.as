package eiko.models 
{
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class ScreenOptions 
	{
		public var screenName:String;
		public var transitionType:String;
		public var parameters:Object;
		
		public function ScreenOptions(name:String, transition:String, params:Object):void
		{
			screenName = name;
			transitionType = transition;
			parameters = params || { };
			parameters.transitionIn = true;
		}
		
	}

}