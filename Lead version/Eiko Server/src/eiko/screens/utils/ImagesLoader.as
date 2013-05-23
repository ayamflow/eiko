package eiko.screens.utils 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import flash.display.Bitmap;
	import flash.filesystem.File;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class ImagesLoader extends Sprite 
	{
		public static var LOADING_COMPLETE:String = "Complete";
		
		private var backgroundImage:Image;
		private var backgroundFile:File;
		private var loader:LoaderMax;
		public var length:int = 0;
		public var params:Array;
		
		
		public function ImagesLoader(... args) 
		{
			loader = new LoaderMax( { onComplete:loadComplete } );

			args.forEach(function(url:String, index:int, collection:Array):void
			{
				//trace('Loading ' + url);
				//trace(File.applicationDirectory.nativePath);
				backgroundFile = new File(File.applicationDirectory.nativePath).resolvePath("assets/Images/" + url);
				loader.append(new ImageLoader(backgroundFile.url, { name: url } ));
			});
			
			length = args.length;
			params = args;
		}
		
		public function load():void
		{
			loader.load();
		}
		
		public function getContent(url:String):Sprite
		{
			//trace('getContent', url);
			var sp:Sprite = new Sprite();
			sp.addChild(Image.fromBitmap(loader.getLoader(url).rawContent));
			sp.flatten();
			return sp;
		}
		
		private function loadComplete(e:LoaderEvent):void 
		{
			//trace('load Complete', this);
			dispatchEvent(new Event(LOADING_COMPLETE, true));
		}
	}

}