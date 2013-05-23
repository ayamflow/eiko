package eiko.screens.ui 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import eiko.models.GameModel;
	import eiko.screens.utils.ScreenManager;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TouchEvent;
	import flash.filesystem.File;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NativeVideo extends Sprite 
	{
		private var videoObject:Video;
		private var ns:NetStream;
		private var nc:NetConnection;
		private var maskLoader:Loader;
		private var itemVideo:String;
		
		public function NativeVideo(item:String) 
		{
			addEventListener(Event.ADDED_TO_STAGE, added);

			//if (GameModel.DEBUG) item = "bilboquet";
			item = "bilboquet";
			itemVideo = new File(File.applicationDirectory.nativePath).resolvePath("assets/Videos/" + item + ".flv").url;
			//trace(itemVideo);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
						
			maskLoader = new Loader();
			maskLoader.load(new URLRequest(new File(File.applicationDirectory.nativePath).resolvePath("assets/Background/Prize/video-mask.png").url));
			maskLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
		}
		
		private function loaded(e:Event):void
		{
			maskLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaded);
			
			var videoContainer:Sprite = new Sprite();
			addChild(videoContainer);
			videoContainer.cacheAsBitmap = true;
			
			videoObject = new Video();
			videoObject.x = -20;
			videoObject.y = 30;
			videoContainer.addChild(videoObject);
			
			nc = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			ns.addEventListener(NetStatusEvent.NET_STATUS, statusChanged);
			var customClient:Object = new Object();
			customClient.onMetaData = metaDataHandler;
			ns.client = customClient;

			videoObject.attachNetStream(ns);
			ns.play(itemVideo);

			var mask:Bitmap = maskLoader.content as Bitmap;
			addChild(mask);
			mask.cacheAsBitmap = true;
			videoContainer.mask = mask;
			mask.x = 504 - (mask.width >> 1);
			mask.y = 400 - (mask.height >> 1);
			videoContainer.x = 512 - (videoContainer.width);
			videoContainer.y = 384 - (videoContainer.height);
			
			stage.addEventListener(TouchEvent.TOUCH_TAP, onTap);
			stage.addEventListener(MouseEvent.MOUSE_UP, onTap);
			
			transitionIn();
		}
		
		private function onTap(e:Event):void 
		{
			stage.removeEventListener(TouchEvent.TOUCH_TAP, onTap);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onTap);
			finishVideo();
		}
		
		private function statusChanged(stats:NetStatusEvent):void {
			if (stats.info.code == "NetStream.Buffer.Empty") {
				finishVideo();				
			}
		}
		
		private function finishVideo():void
		{
			TweenMax.to(videoObject, 0.2, { alpha: 0, ease: Cubic.easeInOut, onComplete: function():void
				{
					stage.removeEventListener(TouchEvent.TOUCH_TAP, onTap);
					stage.removeEventListener(MouseEvent.MOUSE_UP, onTap);
					ScreenManager.server.send( { type: "prize" } );
				}
			} );
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void 
		{
			//trace(event.text);
		}
		 
		private function metaDataHandler(infoObject:Object):void
		{
			videoObject.width = 650;
			videoObject.height = 650/infoObject.width*infoObject.height;
		}
		
		public function transitionIn():void
		{
			TweenMax.from(this, 0.4, { alpha: 0, ease: Cubic.easeInOut } );
		}
		
		public function transitionOut():void
		{
			TweenMax.to(this, 0.4, { alpha: 0, ease: Cubic.easeInOut } );
		}
		
		public function dispose():void
		{
			nc.close();
			ns.close();
			ns.dispose();
		}
		
	}

}