package eiko.screens.utils
{
	import flash.filesystem.File;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	/**
	 * AssetManager Wrapper 
	 * @author Florian Morel
	 * 
	 */	
	public class AssetsManager
	{
		// unique assets of AssetManager
		private var assets:AssetManager;
		// var usefull for AssetsManager
		public var scaleFactor:Number = 1;
		public var useMipmaps:Boolean = false;
		private var dispatcher:EventDispatcher;
		private var fromScreenManager:Boolean = false;
				
		public static var LOADED:String = "Loaded";
		
		public function AssetsManager(_fromScreenManager:Boolean = false):void
		{
			dispatcher = new EventDispatcher();
			assets = new AssetManager(scaleFactor, useMipmaps);
			//assets.verbose = true;
			
			this.fromScreenManager = _fromScreenManager;
		}
		
		public function enqueue(fileName:String):void
		{
			assets.enqueue(new File(File.applicationDirectory.nativePath).resolvePath("assets/" + fileName));
		}
		
		public function load():void
		{
			//trace('[AssetsManager] load');
			assets.loadQueue( function(ratio:Number):void
			{
				if( ratio == 1.0 )
				{
					dispatcher.dispatchEventWith(LOADED);
				}
			});
		}
		
		public function addAtlas(fileName:String, atlas:TextureAtlas):void
		{
			assets.addTextureAtlas(fileName, atlas);
		}
		
		public function getAtlas(fileName:String):TextureAtlas
		{
			return assets.getTextureAtlas(fileName);
		}
		
		public function addEventListener(type:String, listener:Function):void
		{
			dispatcher.addEventListener(type, listener);
		}
		
		public function removeEventListener(type:String, listener:Function):void
		{
			dispatcher.removeEventListener(type, listener);
		}
		
		/*public function enqueue(... rawAssets):void
		{
			assets.enqueue(rawAssets);
		}*/
	
		public function purge():void
		{
			//trace('[AssetsManager] PURGE');
			assets.purge();
		}
		
		public function getTexture(name:String):Texture
		{
			var texture:Texture = assets.getTexture(name);
			if (texture == null && !fromScreenManager) texture = ScreenManager.assets.getTexture(name);
			
			return texture;
		}
		
		public function getTextures(prefix:String = "", result:Vector.<Texture> = null):Vector.<Texture>
		{
			return assets.getTextures(prefix, result);
		}
		
		public function removeTexture(name:String):void
		{
			assets.removeTexture(name, true);
		}
		
		public function removeTextureAtlas(name:String):void
		{
			assets.removeTextureAtlas(name);
		}

		public function play(name:String, loops:int = 0, volume:Number = 1, pan:Number = 0):SoundChannel
		{
			return assets.playSound(name, 0, loops, new SoundTransform(volume, pan));	
		}
		
		public function removeSound(name:String):void
		{
			assets.removeSound(name);
		}
	}
}