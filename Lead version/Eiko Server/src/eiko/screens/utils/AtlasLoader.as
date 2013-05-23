package eiko.screens.utils
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.DisplayObject;
	import starling.display.Sprite;

	public class AtlasLoader extends Sprite
	{
		private var spritesheetLoader:Loader;
		private var xmlLoader:URLLoader;
		public var spriteData:XML;
		public var spriteImage:Bitmap;
		
		public static var LOADED:String = "loaded";
		
		public function AtlasLoader()
		{	
			trace('AtlasLoader init');
			spritesheetLoader = new Loader();
			spritesheetLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIoError);
			spritesheetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlIoError);
			xmlLoader.addEventListener(Event.COMPLETE, xmlComplete);
		}
		
		public function load():void
		{
			trace('AtlasLoader loaded');
			spritesheetLoader.load(new URLRequest(new File(File.applicationDirectory.nativePath).resolvePath("assets/eikoSprites.png").url));
			xmlLoader.load(new URLRequest(new File(File.applicationDirectory.nativePath).resolvePath("assets/eikoSprites.xml").url));
		}
		
		private function notifyLoad():void
		{
			if(spriteData && spriteImage)
			{
				dispatchEventWith(LOADED);
			}
		}
		
		private function xmlComplete(evt:Event):void
		{
			spriteData = XML(xmlLoader.data);
			notifyLoad();
		}
		
		private function xmlIoError(evt:IOErrorEvent):void
		{
			trace(evt.text);
		}
		
		private function loaderComplete(evt:Event):void
		{
			spriteImage = spritesheetLoader.content as Bitmap;
			notifyLoad();
		}
		
		private function loaderIoError(evt:IOErrorEvent):void
		{
			trace(evt.text);
		}
	}
}