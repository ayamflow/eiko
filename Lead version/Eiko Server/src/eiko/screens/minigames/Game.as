package eiko.screens.minigames 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import eiko.screens.Screen;
	import eiko.screens.utils.ImagesLoader;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Game extends Screen 
	{
		private var background:Sprite;
		
		public function Game(params:Object) 
		{
			loader = new ImagesLoader('Background/bilboquetProto.jpg');
		}
		
		protected override function loaded():void
		{
			this.x = Starling.current.stage.stageWidth;
			background = loader.getContent('Background/bilboquetProto.jpg');
			addChild(background);
		}
		
		public override function transitionIn():void
		{
			transitionTl.insert(TweenMax.to(this, 1, {alpha: 1, x: 0, ease: Expo.easeInOut}), 0);
			transitionTl.play();
		}
		
		public override function transitionOut():void
		{
			transitionTl.reverse();
		}
	}

}