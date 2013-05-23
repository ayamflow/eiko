package 
{
	import eiko.screens.utils.ScreenManager;
	import eiko.server.Server;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	[SWF(frameRate="60", width="600", height="400", backgroundColor="0x000000")]
	public class Main extends Sprite 
	{
		private var context:Starling;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			context = new Starling(ScreenManager, stage);			
			context.showStatsAt("left", "top");
			
			context.start();
		}
	}
}