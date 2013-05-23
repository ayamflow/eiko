package eiko.screens 
{	
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import eiko.screens.ui.Background;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Menu extends Screen 
	{	
		private var jouer:TextField;
		private var credits:TextField;
		private var selection:Image;
		
		public function Menu(params:Object = null) 
		{
			assets.enqueue("Background/menu.jpg");
		}
		
		protected override function added():void
		{
			var background:Background = new Background(getTexture("menu"));
			addChild(background);
			
			selection = new Image(getTexture("UI/titleBg"));
			selection.blendMode = BlendMode.MULTIPLY;
			selection.alpha = 0;
			selection.color = ScreenManager.gameModel.generations["1950"].color;
			addChild(selection);
			
			var textsContainer:Sprite = new Sprite();
			addChild(textsContainer);
			
			jouer = new TextField(Starling.current.stage.stageWidth, selection.height, "JOUER UNE PARTIE", "Aldo", 40, 0xFFFFFF);
			jouer.y = 330;
			//jouer.border = true;
			textsContainer.addChild(jouer);
			
			credits = new TextField(Starling.current.stage.stageWidth, selection.height, "CRÉDITS", "Aldo", 40, 0xFFFFFF);
			credits.y = 430;
			//credits.border = true;
			textsContainer.addChild(credits);
			
			selection.y = 300;
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var t:Touch = e.getTouch(stage, TouchPhase.ENDED);
			
			if (t)
			{
				var target:TextField = e.currentTarget as TextField;
				TweenMax.to(selection, 0.4, { y: target.y - 8, alpha: 0.6, ease: Cubic.easeInOut, onComplete: function():void
					{
						if (target === jouer)
						{
							changeScreen(Screen.CONNECTION, TransitionManager.TRANSITION_IN_AND_AFTER_OUT);
						}
						else if (target === credits)
						{
							changeScreen(Screen.CREDITS, TransitionManager.TRANSITION_IN_AND_AFTER_OUT);
						}
					}
				} );
			}
		}
		
		public override function addEvents():void
		{
			jouer.addEventListener(TouchEvent.TOUCH, onTouch);
			credits.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public override function transitionIn():void
		{
			transitionTl.insert(TweenMax.from(jouer, 0.2, {alpha: 0, ease: Cubic.easeInOut}), 0);
			transitionTl.insert(TweenMax.from(credits, 0.2, {alpha: 0, ease: Cubic.easeInOut}), 0.1);
			transitionTl.insert(TweenMax.from(selection, 0.2, {alpha: 0, ease: Cubic.easeInOut}), 0.3);
		}
		
		public override function transitionOut():void
		{
			transitionTl.reverse(true);
		}
		
		public override function dispose():void
		{
			jouer.removeEventListener(TouchEvent.TOUCH, onTouch);
			credits.removeEventListener(TouchEvent.TOUCH, onTouch);
			assets.purge();
		}
	}
}