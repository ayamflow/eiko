package eiko.entities 
{
	import eiko.models.game.Card;
	import eiko.models.game.Pattern;
	import eiko.models.GameModel;
	import eiko.screens.utils.ScreenManager;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class CardReader extends Sprite 
	{
		private var area:Quad;
		private var background:Image;
		private var color:Image;
		private var contactPoints:Vector.<Touch>;
		private var w:int;
		private var h:int;
		private var traces:Sprite;
				
		public static const CARD_RECOGNIZED:String = "cardRecognized";
		
		public function CardReader(xPos:Number, he:int, image:Texture, _background:Texture)
		{
			w = GameModel.CARD_WIDTH;
			h = he;
			
			color = new Image(_background);
			color.alpha = 0.8;
			color.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			color.blendMode = BlendMode.MULTIPLY;
			addChild(color);
			
			area = new Quad(w, h, uint("0x" + "#1B7EE0".substr(1)));
			area.x = xPos;

			// DEBUG
			/*traces = new Sprite();
			addChild(traces);*/
			
			background = new Image(image);
			background.x = GameModel.CARD_WIDTH;
			background.y = h - background.height;
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			
			//var line1:Quad = new Quad(1, h, 0xFFFFFF);
			//var line2:Quad = new Quad(1, h, 0xFFFFFF);
			//var line3:Quad = new Quad(1, h, 0xFFFF00);
			//var line4:Quad = new Quad(1, h, 0xFFFF00);
			//var line5:Quad = new Quad(1, h, 0xFFFF00);
			//line1.x = area.x + GameModel.CARD_WIDTH / 3;
			//line2.x = area.x + GameModel.CARD_WIDTH / 1.5;
			//line3.x = area.x + GameModel.CARD_WIDTH / 4;
			//line4.x = area.x + GameModel.CARD_WIDTH / 2;
			//line5.x = area.x + GameModel.CARD_WIDTH / 4 + GameModel.CARD_WIDTH / 2;
			//addChild(line1);
			//addChild(line2);
			//addChild(line3);
			//addChild(line4);
			//addChild(line5);
		}
		
		private function added():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			addChild(background);
			
			area.addEventListener(TouchEvent.TOUCH, readCard);
			area.alpha = 0;
			addChild(area);
		}
		
		private function readCard(e:TouchEvent):void 
		{
			contactPoints = e.getTouches(area, TouchPhase.BEGAN);
			
			if(contactPoints.length === 2)
			{				
				var pattern:Pattern;
				var position:int;
				var lowest:Touch = contactPoints[0];
				
				/*traces.removeChildren();
				
				// Get lowest point (identifier from pattern)
				contactPoints.forEach(function(p:Touch, i:int, ps:Vector.<Touch>):void
				{
					if (p.globalY > lowest.globalY) lowest = p;
					var traceQuad:Quad = new Quad(30, 30, 0xFFFFFF * Math.random());
					traceQuad.x = p.globalX - (traceQuad.width >> 1);
					traceQuad.y = p.globalY - area.height - traceQuad.height - (traceQuad.height >> 1);
					traces.addChild(traceQuad);
				});*/
				
				//contactPoints.splice(contactPoints.indexOf(lowest), 1);
				
				
				position = Pattern.identify(lowest.globalX, area.x, true);
				
				var markers:Array = new Array();
				contactPoints.forEach(function(p:Touch, i:int, ps:Vector.<Touch>):void
				{
					markers.push(Pattern.identify(p.globalX, area.x));
				});

				var cardPattern:Pattern = new Pattern(position, markers);
				var recognizedCard:Card;
				
				recognizedCard = ScreenManager.gameModel.cardByPattern(cardPattern, ScreenManager.gameModel.selfPlayer.generation);
				if (recognizedCard == null) return;
				if (recognizedCard.used) return;
				dispatchEventWith(CARD_RECOGNIZED, false, recognizedCard);
			}
			/*else
			{
				dispatchEventWith(CARD_RECOGNIZED, false, ScreenManager.gameModel.cardDebug());
			}*/
			//if (contactPoints.length !== 3) return;
		}
		
		public override function dispose():void
		{
			area.removeEventListener(TouchEvent.TOUCH, readCard);
			super.dispose();
		}
		
	}

}