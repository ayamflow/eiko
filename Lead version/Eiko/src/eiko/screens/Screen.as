package eiko.screens 
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import flash.errors.IOError;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Screen extends Sprite implements IScreen
	{
		public static const DUEL:String = "Duel";
		public static const INTERSCREEN:String = "InterScreen";
		public static const CARD_DETECTOR:String = "CardDetector";
		public static const REVELATION_OVERLAY:String = "RevelationOverlay";
		public static const REVELATION:String = "Revelation";
		public static const ERROR:String = "Error"; // TODO : une page debug qui récupère l'erreur et l'affiche
		public static const CONNECTION:String = "Connection";
		public static const HOME:String = "Home";
		public static const MENU:String = "Menu";
		public static const COMPENDIUM:String = "Compendium";
		public static const BATTLE:String = "Game";
		public static const PRIZE:String = "Prize";
		public static const END:String = "End";
		public static const TABLE:String = "CardTable";
		public static const GENERATION_SELECTOR:String = "GenerationSelector";
		public static const CARD_SELECTOR:String = "CardSelector";
		public static const CREDITS:String = "Credits";
		
		protected var transitionTl:TimelineMax;
		protected var transitionOutTl:TimelineMax;
		
		protected var options:Object;

		protected var assets:AssetsManager = new AssetsManager();
		
		public function Screen(params:Object = null) 
		{
			options = params;
			addEventListener(Event.ADDED_TO_STAGE, _load);
		}
		
		private function _load():void
		{
			//trace(this, '_load(1)');
			removeEventListener(Event.ADDED_TO_STAGE, _load);
			
			assets.addEventListener(AssetsManager.LOADED, _loaded);
			assets.load();
		}
		
		private function _loaded():void
		{
			//trace(this, '_loaded(2)');
			assets.removeEventListener(AssetsManager.LOADED, _loaded);
			added();
			_transitionIn();
		}
		
		protected function added():void
		{
			
		}
		
		private function _transitionIn():void
		{
			//trace(this, '_transitionIn(3)');
			transitionTl = new TimelineMax( { onComplete: _transitionInComplete, onReverseComplete: _transitionOutComplete } );
			transitionIn();
		}
		
		public function transitionIn():void
		{
			transitionTl.insert(TweenMax.from(this, 0.4, { alpha: 0 } ));
		}

		protected function _transitionInComplete():void
		{
			//trace('transitionInComplete', this);
			TransitionManager.transitionComplete(TransitionManager.TRANSITION_IN_COMPLETE);
			transitionInComplete();
			this._addEvents();
		}
		
		public function transitionInComplete():void
		{
			
		}

		public function _transitionOut():void
		{
			//trace('transitionOut', this);
			transitionOutTl = new TimelineMax( { onComplete: _transitionOutComplete } );
			transitionOut();
		}
		
		public function transitionOut():void
		{
			transitionOutTl.insert(TweenMax.to(this, 0.4, { alpha: 0 } ));
		}

		protected function _transitionOutComplete():void
		{
			//trace('transitionOutComplete', this);
			transitionOutComplete();
			dispose();
			_dispose();
			TransitionManager.transitionComplete(TransitionManager.TRANSITION_OUT_COMPLETE);
		}
		
		public function transitionOutComplete():void
		{
			
		}
		
		private function _addEvents():void
		{
			//trace('addEvents', this);
			addEvents();
		}
		
		public function addEvents():void
		{
			
		}
		
		public override function dispose():void
		{
			
		}
		
		private function _dispose():void
		{
			super.dispose();
			//assets.purge();
		}
		
		public function changeScreen(newScreen:String, transitionType:String, params:Object = null):void
		{
			TransitionManager.changeScreen(newScreen, transitionType, params);
		}
		
		public function getTexture(name:String):Texture
		{
			return assets.getTexture(name);
		}
		
		public function getAtlas(name:String):TextureAtlas
		{
			return assets.getAtlas(name);
		}
		
	}

}