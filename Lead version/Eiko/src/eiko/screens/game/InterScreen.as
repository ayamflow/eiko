package eiko.screens.game 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import eiko.screens.Screen;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	public class InterScreen extends Screen 
	{
		private var polygon:Image;
		private var triangle:Image;
		private var text:TextField;
		private var header:Image;
		
		public function InterScreen(params:Object) 
		{
			options = params;
			
			assets.enqueue("Background/Generations/" + ScreenManager.gameModel.selfPlayer.generation + "_inter.jpg");
		}
		
		protected override function added():void
		{
			var background:Image = new Image(getTexture(ScreenManager.gameModel.selfPlayer.generation + "_inter"));
			addChild(background);
			
			header = new Image(getTexture("UI/interHeader"));
			header.y = 302;
			header.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			header.blendMode = BlendMode.MULTIPLY;
			header.alpha = 0.6;
			addChild(header);
			
			polygon = new Image(getTexture("UI/interPolygon"));
			polygon.pivotX = polygon.width >> 1;
			polygon.pivotY = polygon.height >> 1;
			polygon.x = 250 + 200 + (polygon.width >> 1);
			polygon.y = 253 + (polygon.height >> 1);
			polygon.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			polygon.blendMode = BlendMode.SCREEN;
			polygon.alpha = 0.7;
			addChild(polygon);
			
			triangle = new Image(getTexture("UI/interTriangleFront"));
			triangle.pivotX = triangle.width >> 1;
			triangle.pivotY = triangle.height >> 1;
			triangle.x = 300 + 200 + (triangle.width >> 1);
			triangle.y = 213 + (triangle.height >> 1);
			triangle.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			triangle.blendMode = BlendMode.MULTIPLY;
			triangle.alpha = 0.4;
			addChild(triangle);
			
			text = new TextField(Starling.current.stage.stageWidth, background.height, options.text, "Aldo", 55, 0xFFFFFF);
			text.y = background.y;
			addChild(text);
		}
		
		public override function transitionIn():void
		{
			var time:Number = 0;
			transitionTl.insert(TweenMax.from(header, 0.4, {x: -header.width, ease:Expo.easeInOut}), time += 0.2);
			//transitionTl.insert(TweenMax.from(polygon, 0.7, {x: Starling.current.stage.stageWidth, y: 0, alpha: 0, ease:Cubic.easeInOut}), time += 0.1);
			//transitionTl.insert(TweenMax.from(triangle, 0.7, { x: Starling.current.stage.stageWidth, y: Starling.current.stage.stageHeight, alpha: 0, ease:Cubic.easeInOut }), time += 0.1);
			transitionTl.insert(TweenMax.from(polygon, 0.7, { x: -750, y: -200, rotation: -1.2, alpha: 0, ease:Expo.easeIn } ), time);
			transitionTl.insert(TweenMax.from(triangle, 0.5, { x: Starling.current.stage.stageWidth, y: Starling.current.stage.stageHeight - 200, rotation: -0.8, alpha: 0, ease:Expo.easeIn }), time += 0.5);
			transitionTl.insert(TweenMax.from(text, 0.3, { y: 100, alpha: 0, ease:Cubic.easeInOut } ), time);
			
			//transitionTl.insert(TweenMax.to(triangle, 1.4, { x: 250 + (triangle.width >> 1), rotation: 0.3, ease:Cubic.easeOut}), time);
			//transitionTl.insert(TweenMax.to(polygon, 1.4, { x: 200 + (polygon.width >> 1), rotation: 0.5, ease:Cubic.easeOut } ), time);
			transitionTl.insert(TweenMax.to(triangle, 1.4, { x: Starling.current.stage.stageWidth >> 1, y: 400, rotation: 0.3, ease:Cubic.easeOut}), time);
			transitionTl.insert(TweenMax.to(polygon, 1.4, { x: Starling.current.stage.stageWidth >> 1, y: 400, rotation: 0.5, ease:Cubic.easeOut } ), time);
			
			transitionTl.insert(TweenMax.to(text, 0.2, { alpha: 0, ease:Cubic.easeInOut } ), time + 1.4);
			transitionTl.insert(TweenMax.to(triangle, 0.6, { x: -550, alpha: 0, rotation: 1.8, y: -500, ease:Cubic.easeIn } ), time + 1.2);
			transitionTl.insert(TweenMax.to(polygon, 0.6, {x: Starling.current.stage.stageWidth - 100, y: Starling.current.stage.stageHeight + 400, rotation: 1.6, alpha: 0, ease:Cubic.easeIn}), time + 0.05 + 1.2);

		}
		
		public override function transitionInComplete():void
		{
			assets.purge();
			//ScreenManager.saveScreen();
			changeScreen(options.screen, options.transition);
		}

	}

}