package eiko.screens.minigames.telephone 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import eiko.entities.Server;
	import eiko.screens.game.postgame.MinigameOverlay;
	import eiko.screens.Screen;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Telephone extends Screen
	{
		private var buttons:Vector.<Image>;
		private var buttonsHolder:Sprite;
		private var centerX:Number;
		private var centerY:Number;
		private var success:int;
		private var goalNumber:Array;
		private var rotationCount:Number;
		public function Telephone(params:Object = null)
		{
			assets.enqueue("Background/Games/telephone.jpg");
			
			buttons = new Vector.<Image>(10, true);
		}
		
		protected override function added():void
		{
			var background:Image = new Image(getTexture("telephone"));
			addChild(background);
			
			centerX = 713;
			centerY = 379;
			
	 		goalNumber = [0, 2, 5, 3, 1, 9, 4, 4, 2, 3];
			success = 0;
			
			rotationCount = 0;
			
			var goalText:TextField = new TextField(Starling.current.stage.stageHeight, 60, goalNumber.join(" "), "Aldo", 60, 0xFFFFFF);
			goalText.pivotX = goalText.width >> 1;
			goalText.pivotY = goalText.height >> 1;
			goalText.rotation = -Math.PI / 2;
			//goalText.border = true;
			goalText.x = 100;
			goalText.y = Starling.current.stage.stageHeight >> 1;
			addChild(goalText);
			
			buttonsHolder = new Sprite();
			addChild(buttonsHolder);
			buttonsHolder.x = buttonsHolder.pivotX = centerX;
			buttonsHolder.y = buttonsHolder.pivotY = centerY;
			
			//var test:Quad = new Quad(1024, 768, 0xFFFF00);
			//test.alpha = 0.3;
			//buttonsHolder.addChild(test);
			
			var buttonsBG:Image = new Image(getTexture("Games/Telephone/buttons-bg"));
			buttonsBG.pivotX = buttonsBG.width >> 1;
			buttonsBG.pivotY = buttonsBG.height >> 1;
			buttonsHolder.addChild(buttonsBG);
			buttonsBG.x = centerX;
			buttonsBG.y = centerY;
			
			//buttonsHolder.pivotX = buttonsHolder.width >> 1;
			//buttonsHolder.pivotY = buttonsHolder.height >> 1;
			//buttonsHolder.x = centerX;
			//buttonsHolder.y = centerY;
			//buttonsHolder.pivotX = 0;
			//buttonsHolder.pivotY = 0;
			
			var center:Image = new Image(getTexture("Games/Telephone/centre"));
			center.pivotX = center.width >> 1;
			center.pivotY = center.height >> 1;
			addChild(center);
			center.x = centerX;
			center.y = centerY;
						
			for (var i:int = 0; i < 10; i++)
			{
				buttons[i] = new Image(getTexture("Games/Telephone/" + i));
				buttons[i].pivotX = buttons[i].width >> 1;
				buttons[i].pivotY = buttons[i].height >> 1;
				buttonsHolder.addChild(buttons[i]);
				
				buttons[i].addEventListener(TouchEvent.TOUCH, onButton);
			}
			
			
			buttons[0].x = 878;
			buttons[0].y = 375;
			
			buttons[1].x = 859;
			buttons[1].y = 454;
			
			buttons[2].x = 809;
			buttons[2].y = 516;
			
			buttons[3].x = 736;
			buttons[3].y = 546;
			
			buttons[4].x = 659;
			buttons[4].y = 537;
			
			buttons[5].x = 592;
			buttons[5].y = 496;
			
			buttons[6].x = 554;
			buttons[6].y = 424;
			
			buttons[7].x = 551;
			buttons[7].y = 343;
			
			buttons[8].x = 592;
			buttons[8].y = 277;
			
			buttons[9].x = 656;
			buttons[9].y = 231;
			
			ScreenManager.server.addEventListener(Server.MINI_GAME_START, onGameStart);
		}
		
		private function onGameStart(e:Event):void 
		{	
			setTimeout(function():void
			{
				//TweenMax.to(gameLabel, 0.4, { alpha: 0, ease:Cubic.easeInOut } );
				ScreenManager.server.removeEventListener(Server.MINI_GAME_START, onGameStart);
				ScreenManager.server.addEventListener(Server.MINI_GAME_END, onGameEnd);
			}, 1100);
		
		}
		private function onGameEnd(e:Event):void 
		{
			setTimeout(function():void
			{
				dispose();
				var overlay:MinigameOverlay = new MinigameOverlay( { winner: e.data.content } );
				addChild(overlay);				
			}, 1000);
		}
		
		private function rotateHandler(currentPosA:Point, previousPosA:Point, currentPosB:Point, previousPosB:Point, target:DisplayObject):void
		{			
			var currentVector:Point  = currentPosA.subtract(currentPosB);
			var previousVector:Point = previousPosA.subtract(previousPosB);
			
			var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
			var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
			var deltaAngle:Number = currentAngle - previousAngle;
			
			rotationCount += deltaAngle;
			if (rotationCount < 0)
			{
				rotationCount = 0;
				return;
			}
			target.rotation = rotationCount;
			//trace('rotation', target.rotation);
			//target.rotation = Math.min(6.28, Math.max(target.rotation, 0));
			
		}
		
		private function getRotationChange(mc:DisplayObject, newRotation:Number, clockwise:Boolean):String
		{
			var dif:Number = (newRotation - mc.rotation);
			if (Boolean(dif > 0) != clockwise)
			{
				dif += (clockwise) ? 2*Math.PI : -2*Math.PI;
			}
			return String(dif);
		}
		
		private function onButton(e:TouchEvent):void 
		{
			var t:Touch = e.getTouch(buttonsHolder);
			
			if (t)
			{
				var canMove:Boolean = false;
				var button:Image = e.target as Image;
				var digit:int = buttons.indexOf(button);
				// Change color, check good number
				if (t.phase == TouchPhase.BEGAN)
				{
					if (digit === goalNumber[success])
					{
						button.alpha = 0.4;
						canMove = true;
						//success++;
						rotationCount = buttonsHolder.rotation;
					}
				}
				// rotate
				if (t.phase == TouchPhase.MOVED)// && canMove)
				{
					var currentPos:Point  = t.getLocation(parent);
					var previousPos:Point = t.getPreviousLocation(parent);
					var buttonPos:Point  = new Point(centerX, centerY);
					rotateHandler(currentPos, previousPos, buttonPos, buttonPos, buttonsHolder);
				}
				// rewind
				if (t.phase == TouchPhase.ENDED)
				{
					button.alpha = 1;
					if(rotationCount > 0) TweenMax.to(buttonsHolder, 1.2, { rotation: getRotationChange(buttonsHolder, 0, false), ease: Cubic.easeOut } );
					rotationCount = 0;
				}
			}
		}
		
		public override function dispose():void
		{
			ScreenManager.server.removeEventListener(Server.MINI_GAME_END, onGameEnd);
			assets.purge();
		}
	}

}