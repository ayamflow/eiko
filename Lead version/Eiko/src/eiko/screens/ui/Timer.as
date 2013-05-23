package eiko.screens.ui 
{
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.ClippedSprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Timer extends Sprite 
	{
		private var timerRight:Image;
		private var timerLeft:Image;
		private var text:TextField;
		private var timerValue:int;
		private var timeline:TimelineMax;
		private var assets:AssetsManager;
		
		public static const DONE:String = "Done";
		
		public function Timer()
		{
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
				
		private function added():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);

			var border:Image = new Image(ScreenManager.assets.getTexture("UI/timerBorder"));
			addChild(border);
			var borderGlobal:Point = border.localToGlobal(new Point(0, 0));
			if (borderGlobal.y >= 768) borderGlobal.y -= 350;
			
			// Left side
			var leftMask:ClippedSprite = new ClippedSprite();
			addChild(leftMask);
			//leftMask.clipRect = new Rectangle(x, y, ~~(scaleX * (border.width >> 1)), border.height);
			leftMask.clipRect = new Rectangle(borderGlobal.x, borderGlobal.y, ~~(scaleX * (border.width >> 1)), border.height);
			
			timerLeft = new Image(ScreenManager.assets.getTexture("UI/timerHalf"));
			timerLeft.pivotX = timerLeft.width;
			timerLeft.pivotY = timerLeft.height >> 1;
			timerLeft.x = timerLeft.x + timerLeft.width;
			timerLeft.y = timerLeft.y + timerLeft.height >> 1;
			leftMask.addChild(timerLeft);
			
			// Right side
			var rightMask:ClippedSprite = new ClippedSprite();
			addChild(rightMask);
			rightMask.x = leftMask.width;
			rightMask.y = 0;
			rightMask.clipRect = new Rectangle(~~(borderGlobal.x + (scaleX * leftMask.width)), borderGlobal.y, border.width >> 1,  border.height);
			//rightMask.clipRect = new Rectangle(~~(x + (scaleX * leftMask.width)), y, border.width >> 1,  border.height);
			timerRight = new Image(ScreenManager.assets.getTexture("UI/timerHalf"));
			timerRight.pivotX = rightMask.x;
			timerRight.pivotY = timerRight.height >> 1;
			timerRight.scaleX = -1;
			timerRight.x = leftMask.x;
			timerRight.y = timerRight.height >> 1;
			rightMask.addChild(timerRight);
			
			timerValue = 3;
			text = new TextField(border.width, border.height, "" + timerValue, "Aldo", 130, 0xFFFFFF, true);
			text.pivotX = text.width >> 1;
			text.pivotY = text.height >> 1;
			text.scaleX = text.scaleY = 0.8;
			text.x = border.x + (border.width >> 1);
			text.y = border.y + border.height >> 1;
			addChild(text);			
		}
		
		public function tick(duration:Number):void
		{
			timeline = new TimelineMax({onComplete: onTimerEnd});
			timeline.insert(TweenMax.from(text, duration / 4, { alpha: 0, scaleX: 1, scaleY: 1, repeat: 3, ease:Expo.easeOut, onRepeat:function():void
				{
					ScreenManager.assets.play("timer");
					text.text = "" + --timerValue;
				}
			}), 0);
			timeline.insert(TweenMax.to(timerRight, duration >> 1, { rotation: Math.PI, ease:Linear.easeNone, onComplete:function():void
				{
					timerRight.visible = false;
				}
			} ), 0);
			timeline.insert(TweenMax.to(timerLeft, duration >> 1, { rotation: Math.PI, ease:Linear.easeNone } ), duration >> 1);
		}
		
		public function stop():void
		{
			timeline.stop();
		}
		
		private function onTimerEnd():void
		{
			dispatchEventWith(DONE);
		}
		
	}

}