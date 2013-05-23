package eiko.screens 
{	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public interface IScreen 
	{	
		public function IScreen(params:Object = null)
		
		function changeScreen(newScreen:String, transitionType:String, params:Object = null):void
		
		function transitionIn():void
		
		function transitionInComplete():void
		
		function transitionOut():void
		
		function transitionOutComplete():void
	
		function addEvents():void
		
		function dispose():void
	}
	
}