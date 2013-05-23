package eiko.screens 
{
	import com.greensock.TimelineMax;
	import eiko.screens.utils.AtlasLoader;
	import eiko.screens.utils.ImagesLoader;
	import eiko.screens.utils.TransitionManager;
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
		
		protected var loader:ImagesLoader;
		protected var transitionTl:TimelineMax;
		protected var transitionOutTl:TimelineMax;
		
		protected var options:Object;
		
		public function Screen(params:Object = null) 
		{
			this.alpha = 0;
			options = params;

			addEventListener(Event.ADDED_TO_STAGE, _load);
		}
		
		private function _load():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _load);
			
			if (loader != null)
			{
				loader.addEventListener(ImagesLoader.LOADING_COMPLETE, _loaded);
				loader.load();
			}
			else
			{
				trace(this, 'Loader is null');
				_loaded();
			}
		}
		
		private function _loaded():void
		{
			//trace('loaded', this);
			if (loader != null)
			{
				loader.removeEventListener(ImagesLoader.LOADING_COMPLETE, _loaded);
			}
			loaded();
			_transitionIn();
		}
		
		protected function loaded():void
		{
			
		}
		
		private function _transitionIn():void
		{
			//trace('transitionIn', this);
			transitionTl = new TimelineMax( { onComplete: _transitionInComplete, onReverseComplete: _transitionOutComplete } );
			transitionIn();
			
		}
		
		public function transitionIn():void
		{
			
		}

		protected function _transitionInComplete():void
		{
			//trace('transitionInComplete', this);
			TransitionManager.transitionComplete(TransitionManager.TRANSITION_IN_COMPLETE);
			this._addEvents();
			transitionInComplete();
		}
		
		public function transitionInComplete():void
		{
			
		}

		public function _transitionOut():void
		{
			//trace('transitionOut', this);
			dispose();
			transitionOutTl = new TimelineMax( { onComplete: _transitionOutComplete } );
			transitionOut();
		}
		
		public function transitionOut():void
		{
			
		}

		protected function _transitionOutComplete():void
		{
			//trace('transitionOutComplete', this);
			TransitionManager.transitionComplete(TransitionManager.TRANSITION_OUT_COMPLETE);
			transitionOutComplete();
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
		
		private function _dispose():void
		{
			//loader.removeEventListener(ImagesLoader.LOADING_COMPLETE, transitionIn);
		}
		
		public override function dispose():void
		{
			
		}
		
		public function changeScreen(newScreen:String, transitionType:String, params:Object = null):void
		{
			TransitionManager.changeScreen(newScreen, transitionType, params);
		}
		
	}

}