package eiko.screens.game.table 
{
	import com.greensock.easing.Expo;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import eiko.entities.Server;
	import eiko.models.bonus.BattleBonus;
	import eiko.screens.Screen;
	import eiko.screens.ui.DuelButton;
	import eiko.screens.ui.Timer;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import flash.utils.setTimeout;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RevelationOverlay extends Screen 
	{
		
		private var fx:TextureAtlas;
		private var shattered:Vector.<Image>;
		private var selfBG:Quad;
		private var otherBG:Quad;
		private var overlay:Image;
		private var loseTextTop:TextField;
		private var loseTextBottom:TextField;
		private var thirdTextBottom:TextField;
		private var duelButton:DuelButton;
		private var cancelButton:DuelButton;
		
		private var cardName:String;
		private var otherCardName:String;
		private var timer:Timer;
		
		private var offsetTop:Number;
		private var battleChoice:String;
		
		public function RevelationOverlay(params:Object = null) 
		{	
			cardName = ScreenManager.gameModel.selfPlayer.currentCard.name;
			otherCardName = ScreenManager.gameModel.otherPlayer.currentCard.name;
			
			options = params;
			
			trace('REVELATION', options, options.winner);
			
			//AssetsManager.dontPurge();
			assets.enqueue("Spritesheets/fxSprites.xml");
			assets.enqueue("Spritesheets/fxSprites.png");
			
			assets.enqueue("Sounds/cancel.mp3");
			assets.enqueue("Sounds/table/use-battle-bonus.mp3");
			assets.enqueue("Sounds/table/overlay-intro.mp3");
		}
		
		protected override function added():void
		{			
			var otherColor:uint = ScreenManager.gameModel.otherPlayer.currentCard.color;
			var selfColor:uint = ScreenManager.gameModel.selfPlayer.currentCard.color;
						
			selfBG = new Quad(Starling.current.stage.stageWidth >> 1, Starling.current.stage.stageHeight, selfColor);
			selfBG.blendMode = BlendMode.MULTIPLY;
			selfBG.color = selfColor;
			selfBG.alpha = 0.3;
			addChild(selfBG);
			otherBG = new Quad(Starling.current.stage.stageWidth >> 1, Starling.current.stage.stageHeight, otherColor);
			otherBG.x = Starling.current.stage.stageWidth >> 1;
			otherBG.blendMode = BlendMode.MULTIPLY;
			otherBG.color = otherColor;
			otherBG.alpha = 0.3;
			addChild(otherBG);	
			
			fx = getAtlas("fxSprites");
			
			shattered = new Vector.<Image>(8, true);
			for (var i:int = 0, l:int = shattered.length; i < l; i++)
			{
				shattered[i] = new Image(fx.getTexture("shattered" + (i + 1)));
				addChild(shattered[i]);
			}
			
			shattered[0].y 	= 69;
			shattered[0].alpha = 0.4;
			shattered[0].blendMode = BlendMode.MULTIPLY;
			shattered[0].color = selfColor;
			
			shattered[1].y = 69;
			shattered[1].alpha = 0.6;
			shattered[1].blendMode = BlendMode.SCREEN;
			shattered[1].color = selfColor;
			
			shattered[2].y = 557;
			shattered[2].alpha = 0.3;
			shattered[2].blendMode = BlendMode.SCREEN;
			shattered[2].color = selfColor;
			
			shattered[3].x = 307;
			shattered[3].y = 79;
			shattered[3].alpha = 0.3;
			shattered[3].blendMode = BlendMode.SCREEN;
			shattered[3].color = selfColor;
			
			shattered[4].x = 540;
			shattered[4].y = 93;
			shattered[4].alpha = 0.5;
			shattered[4].blendMode = BlendMode.MULTIPLY;
			shattered[4].color = otherColor;
			
			shattered[5].x = 696;
			shattered[5].y = 93;
			shattered[5].alpha = 0.5;
			shattered[5].blendMode = BlendMode.MULTIPLY;
			shattered[5].color = otherColor;
			
			shattered[6].x = 470;
			shattered[6].y = 543;
			shattered[6].alpha = 0.4;
			shattered[6].blendMode = BlendMode.SCREEN;
			shattered[6].color = otherColor;
			
			shattered[7].x = 755;
			shattered[7].y = 410;
			shattered[7].alpha = 0.5;
			shattered[7].blendMode = BlendMode.MULTIPLY;
			shattered[7].color = otherColor;
			
			overlay = new Image(getTexture('UI/overlay'));
			overlay.x = 187;
			overlay.y = 187;
			overlay.blendMode = BlendMode.MULTIPLY;
			addChild(overlay);
			
			if (options.winner == "self")
			{
				offsetTop = 340;
				initWinner();
			}
			else
			{
				offsetTop = 248;
				initLoser();
			}
		}
		
		private function initLoser():void
		{
			loseTextTop = new TextField(220, 50, "VOUS AVEZ", "Aldo", 40, 0xFFFFFF);
			//loseTextTop.border = true;
			loseTextTop.x = 400;
			loseTextTop.y = offsetTop;
			addChild(loseTextTop);
			loseTextBottom = new TextField(220, 75, "PERDU", "Aldo", 70, 0xFFFFFF);
			//loseTextBottom.border = true;
			loseTextBottom.x = 400;
			loseTextBottom.y = offsetTop + 40;
			addChild(loseTextBottom);
			
			duelButton = new DuelButton(getTexture("UI/duelButton"), "DUEL");
			duelButton.x = 357;	
			duelButton.y = offsetTop + 275;
			addChild(duelButton);
			
			cancelButton = new DuelButton(getTexture("UI/duelButton"), "NON", true);
			cancelButton.x = 537;	
			cancelButton.y = offsetTop + 275;
			addChild(cancelButton);
			
			timer = new Timer();
			timer.x = 438;
			timer.y = offsetTop + 114;
			addChild(timer);
		}
		
		private function initWinner():void
		{
			loseTextTop = new TextField(220, 50, "EN ATTENTE DE", "Aldo", 40, 0xFFFFFF);
			//loseTextTop.border = true;
			loseTextTop.x = 400;
			loseTextTop.y = offsetTop;
			addChild(loseTextTop);
			loseTextBottom = new TextField(240, 75, "L’AUTRE", "Aldo", 50, 0xFFFFFF);
			//loseTextBottom.border = true;
			loseTextBottom.x = 400;
			loseTextBottom.y = offsetTop + 40;
			addChild(loseTextBottom);
			
			thirdTextBottom = new TextField(220, 75, "JOUEUR...", "Aldo", 50, 0xFFFFFF);
			//thirdTextBottom.border = true;
			thirdTextBottom.x = 400;
			thirdTextBottom.y = offsetTop + 95;
			addChild(thirdTextBottom);
		}
		
		public function challengeWinner(callback:Function):void
		{
			var challengeTl:TimelineMax = new TimelineMax({onComplete: callback});
			var time:Number = 0;
			
			challengeTl.insert(TweenMax.to(loseTextTop, 0.4, { alpha: 0, ease: Expo.easeInOut } ), time += 0.2);
			challengeTl.insert(TweenMax.to(loseTextBottom, 0.4, { alpha: 0, ease: Expo.easeInOut } ), time += 0.2);
			challengeTl.insert(TweenMax.to(thirdTextBottom, 0.4, { alpha: 0, ease: Expo.easeInOut } ), time += 0.2);
			challengeTl.addCallback(function():void
			{
				loseTextTop.text = "VOUS AVEZ ÉTÉ";
				loseTextBottom.text = "DEFIÉ !";
			}, time + 0.1);
			challengeTl.insert(TweenMax.to(loseTextTop, 0.4, { alpha: 1, ease: Expo.easeInOut } ), 0.1 + (time += 0.2));
			challengeTl.insert(TweenMax.to(loseTextBottom, 0.4, { alpha: 1, ease: Expo.easeInOut } ), time += 0.2);
			
			setTimeout(function():void
			{
				challengeTl.play();				
			}, 500);
		}
		
		public function notifyWinner(callback:Function):void
		{
			var notifyTl:TimelineMax = new TimelineMax({onComplete: callback});
			var time:Number = 0;
			
			notifyTl.insert(TweenMax.to(loseTextTop, 0.4, { alpha: 0, ease: Expo.easeInOut } ), time += 0.2);
			notifyTl.insert(TweenMax.to(loseTextBottom, 0.4, { alpha: 0, ease: Expo.easeInOut } ), time += 0.2);
			if(thirdTextBottom != null) notifyTl.insert(TweenMax.to(thirdTextBottom, 0.4, { alpha: 0, ease: Expo.easeInOut } ), time += 0.2);
			notifyTl.addCallback(function():void
			{
				loseTextTop.text = "VOUS GAGNEZ";
				loseTextBottom.text = "LA MANCHE !";
				loseTextBottom.vAlign = "top";
			}, time);
			notifyTl.insert(TweenMax.to(loseTextTop, 0.4, { alpha: 1, ease: Expo.easeInOut } ), 0.1 + (time += 0.2));
			notifyTl.insert(TweenMax.to(loseTextBottom, 0.4, { alpha: 1, ease: Expo.easeInOut } ), time += 0.2);
			
			setTimeout(function():void
			{			
				notifyTl.play();
			}, 500);
		}
		
		public override function transitionIn():void
		{
			var time:Number = 0;
			transitionTl.insert(TweenMax.to(this, 0, {alpha: 1}), time += 0.15);
			transitionTl.insert(TweenMax.from(selfBG, 1, {alpha: 0}), 0);
			transitionTl.insert(TweenMax.from(otherBG, 1, { alpha: 0 } ), 0);
			transitionTl.addCallback(function():void
			{
				assets.play("overlay-intro");
			}, time + 0.4);
			for (var i:int = 0, l:int = shattered.length; i < l; i++)
			{
				transitionTl.insert(TweenMax.from(shattered[i], 0.4, { scaleX: 0, scaleY: 0, x: shattered[i].x + (shattered[i].width >> 1), y: shattered[i].y + (shattered[i].height >> 1), ease:Expo.easeInOut } ), time += 0.04);
			}
			transitionTl.insert(TweenMax.from(overlay, 0.3, { scaleX: 0, scaleY: 0, x: overlay.x + (overlay.width >> 1), y: overlay.y + (overlay.height >> 1), ease:Expo.easeInOut } ), time += 0.2);
			transitionTl.insert(TweenMax.from(loseTextTop, 0.3, { y: loseTextTop.y - 30, alpha: 0, ease:Expo.easeInOut } ), time += 0.1);
			transitionTl.insert(TweenMax.from(loseTextBottom, 0.3, { y: loseTextBottom.y - 30, alpha: 0, ease:Expo.easeInOut } ), time += 0.1);
			if (options.winner == "other")
			{
				transitionTl.insert(TweenMax.from(timer, 0.3, { y: loseTextBottom.y - 30, alpha: 0, ease:Expo.easeInOut } ), time += 0.1);
				transitionTl.insert(TweenMax.from(duelButton, 0.3, { y: offsetTop + 200, alpha: 0, ease:Expo.easeInOut } ), time += 0.2);				
				transitionTl.insert(TweenMax.from(cancelButton, 0.3, { y: offsetTop + 200, alpha: 0, ease:Expo.easeInOut } ), time);				
				transitionTl.addCallback(startTimer, time);
			}
			else
			{
				transitionTl.insert(TweenMax.from(thirdTextBottom, 0.3, { y: loseTextBottom.y - 30, alpha: 0, ease:Expo.easeInOut } ), time += 0.1);
			}
			transitionTl.play();
		}
		
		public override function transitionOut():void
		{
			transitionTl.reverse(true);
		}
		
		public override function transitionOutComplete():void
		{
			dispatchEventWith(Server.BONUS, false, battleChoice);
		}
		
		private function startTimer():void
		{
			duelButton.addEventListener(TouchEvent.TOUCH, useBattleBonus);
			cancelButton.addEventListener(TouchEvent.TOUCH, cancelBattleBonus);
			timer.addEventListener(Timer.DONE, noBattleBonus);
			timer.tick(5);
		}
		
		private function noBattleBonus(e:Event):void 
		{
			notifyBattleBonus(BattleBonus.NO_BATTLE);
		}
		
		private function notifyBattleBonus(battle:String):void
		{
			duelButton.removeEventListener(TouchEvent.TOUCH, useBattleBonus);
			cancelButton.removeEventListener(TouchEvent.TOUCH, cancelBattleBonus);
			timer.removeEventListener(Timer.DONE, notifyBattleBonus);
			timer.stop();
			
			battleChoice = battle;
			
			this.transitionOut();
		}
		
		private function cancelBattleBonus(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(cancelButton, TouchPhase.ENDED);
			
			if (touch)
			{
				assets.play("cancel");
				notifyBattleBonus(BattleBonus.NO_BATTLE);
			}
		}
		
		private function useBattleBonus(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(duelButton, TouchPhase.ENDED);
			
			if (touch)
			{
				assets.play("use-battle-bonus");
				notifyBattleBonus(BattleBonus.BATTLE);
			}
		}
		
		public override function dispose():void
		{
			assets.purge();
		}
	}

}