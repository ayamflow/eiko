package 
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	import eiko.screens.utils.ScreenManager;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	[SWF(frameRate="60", width="1024", height="768", backgroundColor="0x000000")]
	public class Main extends Sprite 
	{
		private var context:Starling;
		public static var debugSprite:Sprite;
		
		//public static var splash:Bitmap;
		//[Embed(source="/../bin/assets/Background/splash.jpg")]
		//private const splashAsset:Class;
		
		public function Main():void 
		{
			//splash = new splashAsset();
			//addChild(splash);
			
			Starling.handleLostContext = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

			context = new Starling(ScreenManager, stage);
			context.simulateMultitouch = true;
			
			context.showStatsAt("left", "bottom");
			
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);

			context.start();
        }

        private function onContextCreated(e:Event):void{
            debugSprite = new Sprite();
            addChild(debugSprite);
		}
		
		private function deactivate(e:Event):void 
		{
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}