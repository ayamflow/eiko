package eiko.screens.game.table 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import eiko.entities.Server;
	import eiko.models.bonus.ScoreBonus;
	import eiko.screens.Screen;
	import eiko.screens.ui.Timer;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import starling.display.BlendMode;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ScoreBonusOverlay extends Screen 
	{
		private var background:Image;
		private var scoreBonusTimer:Timer;
		//private var transitionTl:TimelineMax;
		private var okButton:Sprite;
		private var cancelButton:Sprite;
		private var enAttente:TextField;
		private var autreJoueur:TextField;
		private var bonusChoice:String;
		
		public function ScoreBonusOverlay() 
		{	
			ScreenManager.assets.enqueue("Sounds/table/timer.mp3");
			ScreenManager.assets.enqueue("Sounds/cancel.mp3");
			ScreenManager.assets.enqueue("Sounds/validate.mp3");
			added();
		}
		
		protected override function added():void
		{
			// Background
			background = new Image(getTexture('UI/scoreBonus'));
			background.y = Starling.current.stage.stageHeight - background.height;
			background.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			background.blendMode = BlendMode.MULTIPLY;
			addChild(background);
						
			if (ScreenManager.gameModel.selfPlayer.bonus["score"].used)
			{
				initWithoutBonus();
			}
			else
			{
				initWithBonus();
				initWithoutBonus()
			}
			
			transitionIn();
		}
		
		private function initWithoutBonus():void
		{
			enAttente = new TextField(background.width, background.height >> 1, "EN ATTENTE DE", "Aldo", 35, 0xFFFFFF);
			enAttente.y = background.y + 20;
			addChild(enAttente);
			autreJoueur = new TextField(background.width, background.height >> 1, "L’AUTRE JOUEUR...", "Aldo", 29, 0xFFFFFF);
			autreJoueur.y = enAttente.y + (enAttente.height >> 1) + 5;
			addChild(autreJoueur);
		}
		
		private function initWithBonus():void
		{
			// Button OK
			okButton = new Sprite();
			okButton.x = 396;
			okButton.scaleX = -1;
			//okButton.alpha = 0;
			addChild(okButton);
			var okButtonBG:Image = new Image(getTexture('UI/checkBg'));
			okButtonBG.blendMode = BlendMode.MULTIPLY;
			okButtonBG.alpha = 0.7;
			okButtonBG.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			okButton.addChild(okButtonBG);
			var plus:TextField = new TextField((okButtonBG.width >> 2), okButtonBG.height, "+", "Aldo", 75, 0xFFFFFF);
			plus.x = 80;
			plus.y = -5;
			okButton.addChild(plus);
			
			var star1:Image =	new Image(getTexture('UI/cardSelectValueStar'));
			okButton.addChild(star1);
			star1.x = okButtonBG.x + 18;
			star1.y = (okButtonBG.height >> 1) - 7;
			var star2:Image =	new Image(getTexture('UI/cardSelectValueStar'));
			okButton.addChild(star2);
			star2.x = star1.x + star1.width + 10;
			star2.y = (okButtonBG.height >> 1) - 7;
			
			okButton.y =  background.y + (okButton.height >> 1) - 5;
			
			// Button NO
			cancelButton = new Sprite();
			cancelButton.x = 548;
			//cancelButton.alpha = 0;
			addChild(cancelButton);
			var cancelButtonBg:Image = new Image(getTexture('UI/checkBg'));
			cancelButtonBg.blendMode = BlendMode.MULTIPLY;
			cancelButtonBg.alpha = 0.7;
			cancelButtonBg.color = ScreenManager.gameModel.generations[ScreenManager.gameModel.selfPlayer.generation].color;
			cancelButton.addChild(cancelButtonBg);
			var non:TextField = new TextField(cancelButtonBg.width, cancelButtonBg.height, "NON", "Aldo", 50, 0xFFFFFF);
			non.y = 5;
			cancelButton.addChild(non);
			
			cancelButton.y = background.y + (cancelButton.height >> 1) - 5;
						
			// Clock
			scoreBonusTimer = new Timer();
			//scoreBonusTimer.scaleX = scoreBonusTimer.scaleY = 0.7;
			scoreBonusTimer.x = Starling.current.stage.stageWidth - 250;
			scoreBonusTimer.y = Starling.current.stage.stageHeight - 350;
			addChild(scoreBonusTimer);
		}
		
		public override function transitionIn():void
		{
			if (ScreenManager.gameModel.selfPlayer.bonus["score"].used)
			{
				transitionInWithoutBonus();
			}
			else
			{
				transitionInWithBonus();
			}
		}
		
		private function transitionInWithoutBonus():void
		{
			var time:Number = 0;
			
			transitionTl = new TimelineMax( { onComplete: timeOut } );
			transitionTl.insert(TweenMax.from(background, 0.4, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), time+= 0.2);
			transitionTl.insert(TweenMax.from(enAttente, 0.4, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), time+= 0.2);
			transitionTl.insert(TweenMax.from(autreJoueur, 0.4, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), time+= 0.2);
			transitionTl.play();
		}
		
		private function transitionInWithBonus():void
		{
			var time:Number = 0;
			
			transitionTl = new TimelineMax( { onComplete: startTimer } );
			transitionTl.insert(TweenMax.to(enAttente, 0, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), 0);
			transitionTl.insert(TweenMax.to(autreJoueur, 0, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), 0);
			transitionTl.insert(TweenMax.from(background, 0.4, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), time+= 0.2);
			transitionTl.insert(TweenMax.from(okButton, 0.4, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), time += 0.2);
			transitionTl.insert(TweenMax.from(cancelButton, 0.4, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), time += 0.2);
			transitionTl.insert(TweenMax.from(scoreBonusTimer, 0.4, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), time += 0.2);
			
			transitionTl.play();
		}
		
		public override function transitionOut():void
		{
			var time:Number = 0;
			var transitionOutTl:TimelineMax = new TimelineMax( { onComplete: transitionOutComplete } );
			if (okButton != null && cancelButton != null)
			{
				transitionOutTl.insert(TweenMax.to(okButton, 0.4, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), time += 0.2);
				transitionOutTl.insert(TweenMax.to(cancelButton, 0.4, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), time += 0.2);
				transitionOutTl.insert(TweenMax.to(scoreBonusTimer, 0.4, { y: Starling.current.stage.stageHeight, ease:Cubic.easeInOut } ), time += 0.2);
			}
			transitionOutTl.insert(TweenMax.to(enAttente, 0.4, { y: background.y + 20, ease:Cubic.easeInOut } ), time += 0.2);
			transitionOutTl.insert(TweenMax.to(autreJoueur, 0.4, { y: background.y + (enAttente.height >> 1) + 25, ease:Cubic.easeInOut } ), time += 0.2);
			transitionOutTl.play();
		}
		
		public override function transitionOutComplete():void
		{
			dispatchEventWith(Server.BONUS, false, bonusChoice);
		}
		
		private function startTimer():void
		{
			okButton.addEventListener(TouchEvent.TOUCH, useScoreBonus);
			cancelButton.addEventListener(TouchEvent.TOUCH, dontUseScoreBonus);
			scoreBonusTimer.addEventListener(Timer.DONE, timeOut);
			scoreBonusTimer.tick(5);
		}
		
		private function timeOut():void
		{
			if (!ScreenManager.gameModel.selfPlayer.bonus["score"].used) scoreBonusTimer.removeEventListener(Timer.DONE, timeOut);
			
			notifyScoreBonus(ScoreBonus.NO_SCORE);
		}
		
		private function notifyScoreBonus(score:String):void
		{
			bonusChoice = score;
			if (!ScreenManager.gameModel.selfPlayer.bonus["score"].used)
			{
				scoreBonusTimer.removeEventListener(Timer.DONE, notifyScoreBonus);
				okButton.removeEventListener(TouchEvent.TOUCH, useScoreBonus);
				cancelButton.removeEventListener(TouchEvent.TOUCH, dontUseScoreBonus);				
			}
			transitionOut();
		}
		
		private function dontUseScoreBonus(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(cancelButton, TouchPhase.ENDED);
			
			if (touch)
			{
				assets.play("cancel");
				notifyScoreBonus(ScoreBonus.NO_SCORE);
			}
		}
		
		private function useScoreBonus(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(okButton, TouchPhase.ENDED);
			
			if (touch)
			{
				dispatchEventWith("activated");
				ScreenManager.gameModel.selfPlayer.bonus["score"].used = true;
				assets.play("validate");
				notifyScoreBonus(ScoreBonus.SCORE);
			}
		}
		
		public override function dispose():void
		{
			assets.purge();
			ScreenManager.assets.removeSound("timer");
		}
		
	}

}