package eiko.screens.utils 
{
	import eiko.models.ScreenOptions;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class TransitionManager
	{
		public static const SCREEN_CHANGE:String = "screenChange";
		
		public static var TRANSITION_NONE:String = "transitionNone";
		public static var TRANSITION_OUT_AND_AFTER_IN:String = "transitionOutAndAfterIn";
		public static var TRANSITION_IN_AND_AFTER_OUT:String = "transitionInAndAfterOut";
		public static var TRANSITION_IN_AND_OUT_TOGETHER:String = "transitionInAndOutTogether";
		
		public static var TRANSITION_IN_COMPLETE:String = "transitionInComplete";
		public static var TRANSITION_OUT_COMPLETE:String = "transitionOutComplete";
		
		/* TRANSITIONS */
		
		/* SCREEN CHANGE EVENT DISPATCHER */
		
		private static var dispatcher:EventDispatcher = new EventDispatcher();

		public static function changeScreen(screenName:String, transition:String = "transitionInAndAfterOut", params:Object = null):void
		{
			dispatchEventWith(SCREEN_CHANGE, true, new ScreenOptions(screenName, transition, params));
		}
		
		public static function transitionComplete(inOrOut:String):void
		{
			dispatchEventWith(inOrOut, true);
		}
		
		public static function addEventListener(type:String, listener:Function):void
		{
			dispatcher.addEventListener(type, listener);
		}
		
		public static function removeEventListener(type:String, listener:Function):void {
			dispatcher.removeEventListener(type, listener);
		}
		
		private static function dispatchEventWith(type:String, bubble:Boolean =  false, data:Object = null):void
		{
			dispatcher.dispatchEventWith(type, bubble, data);
		}
	}

}