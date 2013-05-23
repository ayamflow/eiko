package eiko.screens.minigames 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import eiko.screens.Screen;
	import eiko.screens.utils.ImagesLoader;
	import eiko.screens.utils.ScreenManager;
	import starling.display.Sprite;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Bilboquet extends Screen 
	{
		private var boule:Image;
		private var baton:Image;
		
		private var accelerometer:Accelerometer;
		private var accelX:Number = 0;
		private var accelY:Number = 0;
		private var prevX:Number = 0;
		private var center:Quad;
		private var goal:Quad;
		private var background:Sprite;
		
		public function Bilboquet(params:Object) 
		{
			alpha = 1;
			loader = new ImagesLoader('Background/bilboquet.jpg');
		}
		
		protected override function loaded():void
		{
			background = loader.getContent('Background/bilboquet.jpg');
			addChild(background);
			
			boule = new Image(ScreenManager.atlas.getTexture('Minigames/Bilboquet/boule'));
			baton = new Image(ScreenManager.atlas.getTexture('Minigames/Bilboquet/corps-bilboquet'));
			addChild(baton);
			addChild(boule);
			
			boule.x = (Starling.current.stage.stageWidth >> 1) + (Starling.current.stage.stageWidth >> 2);
			boule.y = (Starling.current.stage.stageHeight >> 1);
			boule.pivotX = boule.width >> 1;
			boule.pivotY = boule.height >> 1;
			
			baton.x = (Starling.current.stage.stageWidth >> 1) + (Starling.current.stage.stageWidth >> 2);
			baton.y = (Starling.current.stage.stageHeight >> 1);
			baton.pivotX = baton.width >> 1;
			baton.pivotY = baton.height >> 1;
			baton.rotation = -90 * Math.PI / 180;
			
			center = new Quad(50, 1, 0xCCCC11);
			center.pivotX = center.width >> 1;
			center.pivotY = center.height >> 1;
			center.x = boule.x;
			center.y = boule.y;
			center.visible = false;
			addChild(center);
			
			goal = new Quad(1, 40, 0x1111CC);
			goal.pivotX = goal.width >> 1;
			goal.pivotY = goal.height >> 1;
			goal.x = baton.x - 250;
			goal.y = baton.y;
			goal.visible = false;
			addChild(goal);
			
			if ( Accelerometer.isSupported )
			{
				accelerometer = new Accelerometer();
				listenAccelerometer();
		 	}
		}
		
		private function listenAccelerometer():void 
		{
			accelerometer.addEventListener( AccelerometerEvent.UPDATE, updateAccelerometer);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function stopAccelerometer():void 
		{
			accelerometer.removeEventListener( AccelerometerEvent.UPDATE, updateAccelerometer);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function updateAccelerometer(e:AccelerometerEvent):void 
		{
			accelX = e.accelerationX * 100;
			accelY = e.accelerationY * 70;
			
			if (accelX > 20)
			{
				stopAccelerometer();
				TweenMax.to(boule, 1, { x: 0, y: accelY, ease:Expo.easeOut, onComplete: listenAccelerometer});
			}
		}
		
		private function enterFrame(e:Event):void 
		{			
			prevX = boule.x;
			
			if(accelX > 50) boule.x -= accelX;
			{
				boule.y += accelY;
				//boule.rotation += accelY;
				
				// Gravity
				boule.x += 30;
				
				boule.x = Math.max((boule.width >> 1), Math.min(boule.x, Starling.current.stage.stageWidth));
				boule.y = Math.max((boule.height >> 1), Math.min(boule.y, Starling.current.stage.stageHeight));
				
				center.x = boule.x;
				center.y = boule.y;
			}
			
			if(center.getBounds(stage).intersects(goal.getBounds(stage)) && prevX < boule.x)
			{
				removeEventListener(Event.ENTER_FRAME, enterFrame);
			}
		}
		
	}

}