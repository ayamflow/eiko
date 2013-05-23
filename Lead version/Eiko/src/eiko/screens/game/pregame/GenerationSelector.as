package eiko.screens.game.pregame 
{
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import eiko.entities.Server;
	import eiko.models.game.Generation;
	import eiko.models.game.Player;
	import eiko.screens.Screen;
	import eiko.screens.ui.GenerationButton;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ClippedSprite;
	import starling.text.TextField;
	/**
	 * ...
	 * @author ...
	 * 
	 */
	public class GenerationSelector extends Screen 
	{
		private var background:Image;
		private var check:Image;
		private var button1950:GenerationButton;
		private var button1970:GenerationButton;
		private var button1990:GenerationButton;
		private var year:String;
		private var locked:GenerationButton;
		private var selected:GenerationButton
		
		private var generationReadyCpt:Vector.<String>;
		private var buttonLayer:Sprite;
		private var titleBg:Image;
		private var title:TextField;
				
		public function GenerationSelector(params:Object = null) 
		{
			assets.enqueue('Background/Generations/generationSelector.jpg');
			assets.enqueue('Background/Generations/1950.jpg');
			assets.enqueue('Background/Generations/1970.jpg');
			assets.enqueue('Background/Generations/1990.jpg');
			
			assets.enqueue("Sounds/generation-selector/select.mp3");
			
			generationReadyCpt = new Vector.<String>();
		}
		
		protected override function added():void
		{
			background = new Image(getTexture('generationSelector'));
			addChild(background);
			
			buttonLayer = new Sprite();
			addChild(buttonLayer);
			
			button1950 = new GenerationButton(getTexture("UI/generationBg1950"), ScreenManager.assets.getAtlas("cardSprites").getTexture("1950/toupie"), ScreenManager.assets.getAtlas("cardSprites").getTexture('1950/bilboquet'), "1950");
			button1970 = new GenerationButton(getTexture("UI/generationBg1970"), ScreenManager.assets.getAtlas("cardSprites").getTexture("1970/kiki"), ScreenManager.assets.getAtlas("cardSprites").getTexture('1970/telephone'), "1970");
			button1990 = new GenerationButton(getTexture("UI/generationBg1990"), ScreenManager.assets.getAtlas("cardSprites").getTexture("1990/gameboy"), ScreenManager.assets.getAtlas("cardSprites").getTexture('1990/hippo'), "1990");
			
			var baseTop:int = 292;
			
			button1950.x = 41 + (button1950.width >> 1);
			button1950.y = baseTop + (button1950.height >> 1);
			button1970.x = 356 + (button1970.width >> 1);
			button1970.y = baseTop + (button1970.height >> 1);
			button1990.x = 705 + (button1990.width >> 1);
			button1990.y = baseTop + (button1990.height >> 1);
			
			buttonLayer.addChild(button1950);
			buttonLayer.addChild(button1970);
			buttonLayer.addChild(button1990);
			
			titleBg = new Image(getTexture("UI/titleBg"));
			titleBg.y = 107;
			titleBg.blendMode = BlendMode.MULTIPLY;
			titleBg.alpha = 0.6;
			titleBg.color = ScreenManager.gameModel.generations["1950"].color;
			buttonLayer.addChild(titleBg);
			
			title = new TextField(Starling.current.stage.stageWidth, titleBg.height, "Choisissez votre génération !", "Aldo", 30, 0xFFFFFF);
			title.y = 118;
			buttonLayer.addChild(title);
			
			ScreenManager.header.setColor(ScreenManager.gameModel.generations["1950"].color);
			
			ScreenManager.server.addEventListener(Server.GENERATION, otherGenerationChanged);
		}
		
		public override function addEvents():void 
		{
			button1950.addEventListener(TouchEvent.TOUCH, touchHandler);
			button1970.addEventListener(TouchEvent.TOUCH, touchHandler);
			button1990.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		private function touchHandler(evt:TouchEvent):void
		{
			var touch:Touch = evt.getTouch(stage);
			
			if (touch && touch.phase == TouchPhase.ENDED)
			{	
				button1950.removeEventListener(TouchEvent.TOUCH, touchHandler);
				button1970.removeEventListener(TouchEvent.TOUCH, touchHandler);
				button1990.removeEventListener(TouchEvent.TOUCH, touchHandler);
				
				var clipRect:Rectangle;
				var duration:int = 2;
				
				var otherBT1:GenerationButton;
				var otherBT2:GenerationButton;
				
				if (selected == null) assets.play("select");
				
				selected = evt.currentTarget as GenerationButton;				
				
				switch(selected.year)
				{
					case "1950":
						clipRect = new Rectangle(0, 0, 10, Starling.current.stage.stageHeight);
						otherBT1 = button1970;
						otherBT2 = button1990;
						break;
					case "1970":
						clipRect = new Rectangle(355, 0, 300, Starling.current.stage.stageHeight);
						duration = 1;
						otherBT1 = button1950;
						otherBT2 = button1990;
						break;
					case "1990":
						clipRect = new Rectangle(Starling.current.stage.stageWidth - 10, 0, 10, Starling.current.stage.stageHeight);
						otherBT1 = button1950;
						otherBT2 = button1970;
						break;
				}
				
				var generationMask:ClippedSprite = new ClippedSprite();
				addChild(generationMask);
				swapChildren(generationMask, buttonLayer);
				
				generationMask.clipRect = clipRect;
				
				var generationBackground:Image = new Image(getTexture(selected.year));
				generationMask.addChild(generationBackground);
				
				var generationTl:TimelineMax = new TimelineMax( { onComplete: registerGeneration } );
				
				generationTl.insert(TweenMax.to(selected, 0.6, { y: selected.y - 30, ease: Cubic.easeInOut } ), 0);
				
				generationTl.insert(TweenMax.to(selected.generationTitle, 0.6, { alpha: 0, ease: Cubic.easeInOut } ), 0.2);
				generationTl.insert(TweenMax.to(selected.yearTitle, 0.6, { alpha: 0, ease: Cubic.easeInOut } ), 0.3);
				generationTl.insert(TweenMax.to(selected.background, 0.6, { alpha: 0, ease: Cubic.easeInOut } ), 0.4);
				
				generationTl.insert(TweenMax.to(evt.currentTarget as GenerationButton, 0.4, { scaleX: 1.05, scaleY: 1.05, yoyo: true, ease: Cubic.easeInOut } ), 0);
				generationTl.insert(TweenMax.to(otherBT1, 0.4, { scaleX: 0.8, scaleY: 0.8, alpha: 0, ease: Cubic.easeIn } ), 0.2);
				generationTl.insert(TweenMax.to(otherBT2, 0.4, { scaleX: 0.8, scaleY: 0.8, alpha: 0, ease: Cubic.easeIn } ), 0.2);
				generationTl.insert(TweenMax.to(clipRect, duration, { width: Starling.current.stage.stageWidth, x: 0, ease: Cubic.easeInOut, onUpdate: function():void
					{
						generationMask.clipRect = clipRect;
					}
				} ), 0.2);
				generationTl.insert(TweenMax.to(selected, 0.6, { x: Starling.current.stage.stageWidth >> 1, /*y: Starling.current.stage.stageHeight >> 1,*/ ease: Cubic.easeInOut } ), (duration >> 1));
			}
		}
		
		private function otherGenerationChanged(e:Event):void 
		{
			onGenerationReady("other");
		}
		
		private function registerGeneration():void 
		{
			var year:String = selected.year;
			ScreenManager.gameModel.selfPlayer.generation = year;
			onGenerationReady("self");
			ScreenManager.server.send( { type: Server.GENERATION, content: year, action: "set" } );
		}
		
		public function onGenerationReady(who:String):void 
		{
			trace('onGenerationReady', who);
			generationReadyCpt.push(who);
			if (generationReadyCpt.indexOf("self") > -1 && generationReadyCpt.indexOf("other") > -1)
			{
				changeScreen(Screen.CARD_SELECTOR, TransitionManager.TRANSITION_OUT_AND_AFTER_IN);		
				/*if (ScreenManager.gameModel.selfPlayer.generation != ScreenManager.gameModel.otherPlayer.generation)
				{
					changeScreen(Screen.CARD_SELECTOR, TransitionManager.TRANSITION_OUT_AND_AFTER_IN);					
				}
				else // if both players choose the same generation, they have to start over
				{
					changeScreen(Screen.GENERATION_SELECTOR, TransitionManager.TRANSITION_OUT_AND_AFTER_IN);					
				}*/
			}
		}
		
		public override function transitionIn():void
		{
			var time:Number = 0;
			transitionTl.insert(TweenMax.to(ScreenManager.header, 0.4, { alpha: 1, ease:Cubic.easeInOut } ), time+= 0.2);
			transitionTl.insert(TweenMax.from(button1950, 0.4, { y: button1950.y + 100, alpha: 0, ease:Cubic.easeInOut } ), time+=0.15);
			transitionTl.insert(TweenMax.from(button1970, 0.4, { y: button1970.y + 100, alpha: 0, ease:Cubic.easeInOut } ), time +=0.15);
			transitionTl.insert(TweenMax.from(button1990, 0.4, { y: button1990.y + 100, alpha: 0, ease:Cubic.easeInOut } ), time+=0.15);
			transitionTl.insert(TweenMax.from(titleBg, 0.3, { y: 0, alpha: 0, ease:Cubic.easeInOut } ), time);
			transitionTl.insert(TweenMax.from(title, 0.3, { y: 0, alpha: 0, ease:Cubic.easeInOut } ), time);
			transitionTl.play();
		}
		
		public override function transitionOut():void
		{
			transitionOutTl.insert(TweenMax.to(titleBg, 0.4, { x: Starling.current.stage.stageWidth, alpha: 0 , ease:Expo.easeInOut } ), 0);
			transitionOutTl.insert(TweenMax.to(title, 0.4, { alpha: 0 , ease:Expo.easeInOut } ), 0);
			transitionOutTl.insert(TweenMax.to(selected.generationTitle, 0.4, { alpha: 0 , ease:Expo.easeInOut } ), 0.2);
			transitionOutTl.insert(TweenMax.to(selected.yearTitle, 0.4, { alpha: 0 , ease:Expo.easeInOut } ), 0.3);
			//transitionOutTl.insert(TweenMax.to(selected.background, 0.4, { alpha: 0 , ease:Expo.easeInOut } ), 0.4);
			transitionOutTl.play();
		}
		
		public override function transitionOutComplete():void
		{
			ScreenManager.saveScreen();
		}
		
		public override function dispose():void
		{
			assets.purge();
			ScreenManager.server.removeEventListener(Server.GENERATION, otherGenerationChanged);
		}
	}

}