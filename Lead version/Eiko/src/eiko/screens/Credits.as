package eiko.screens 
{	
	import eiko.screens.ui.Background;
	import eiko.screens.utils.TransitionManager;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Credits extends Screen 
	{	
		private var background:Background;
		public function Credits(params:Object = null) 
		{
			assets.enqueue("Background/credits.jpg");
		}
		
		protected override function added():void
		{
			background = new Background(getTexture("credits"));
			addChild(background);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var t:Touch = e.getTouch(stage, TouchPhase.ENDED);
			
			if (t)
			{
				changeScreen(Screen.MENU, TransitionManager.TRANSITION_OUT_AND_AFTER_IN);
			}
		}
		
		public override function addEvents():void
		{
			background.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public override function transitionIn():void
		{
			
		}
		
		public override function transitionOut():void
		{
			
		}
		
		public override function dispose():void
		{
			background.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
	}
}