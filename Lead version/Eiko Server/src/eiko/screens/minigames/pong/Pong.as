package eiko.screens.minigames.pong 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import eiko.screens.Screen;
	import eiko.screens.utils.ImagesLoader;
	import eiko.screens.utils.ScreenManager;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Pong extends Screen 
	{
		private var background:Sprite;
		private var ball:Ball;
		private var bars:Vector.<Image>;
		private var fingerY:Number = 0;
	
		private var gameStarted:Boolean = false;
		
		private var enterFrameCount:int = 0;
		private var enterFrameLimit:int = 5;
				
		public function Pong(params:Object) 
		{
			alpha = 1;
			loader = new ImagesLoader('Background/Games/pong.jpg');
			
			bars = new Vector.<Image>(2, true);
			
			//ScreenManager.UDPServer = new FastServer();
		}
		
		protected override function loaded():void
		{			
			background = loader.getContent('Background/Games/pong.jpg');
			addChild(background);
			
			bars[0] = new Image(ScreenManager.atlas.getTexture('Games/Pong/curseur-blanc'));
			bars[1] = new Image(ScreenManager.atlas.getTexture('Games/Pong/curseur-noir'));
			
			bars[0].pivotY = (bars[0].height >> 1);
			bars[0].pivotX = (bars[0].width >> 1);
			bars[1].pivotY = (bars[1].height >> 1);
			bars[1].pivotX = (bars[1].width >> 1);

			bars[0].x = 50;
			bars[1].x = (Starling.current.stage.stageWidth) - 50;
			bars[0].y = bars[1].y = (Starling.current.stage.stageHeight >> 1) - (bars[0].height >> 1);
			
			addChild(bars[0]);
			addChild(bars[1]);

			ScreenManager.server.addEventListener("gameUpdate", onGameUpdate);
			
			updatePlayers();
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
		{	
			if (enterFrameCount++ >= enterFrameLimit)
			{
				enterFrameCount = 0;
				updatePlayers();
			}
		}
		
		private function updatePlayers():void
		{
			ScreenManager.server.sendTo(0, { type: "gameUpdate", barY: bars[1].y } );
			ScreenManager.server.sendTo(1, { type: "gameUpdate", barY: bars[0].y } );
		}
		
		private function onGameUpdate(e:Event):void 
		{
			//trace('onGameUpdate', e.data.barY);
			bars[e.data.id].y = e.data.barY;				
		}
		
		public override function dispose():void
		{
			ScreenManager.server.removeEventListener("gameUpdate", onGameUpdate);
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
	}

}