package eiko.screens.game.table 
{
	import adobe.utils.CustomActions;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import eiko.screens.Screen;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ClippedSprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Duel extends Screen 
	{
		private var selfBackground:Image;
		private var otherBackground:Image;
		private var stageMask:ClippedSprite;
		
		private var shards:Vector.<Image>;
		private var slash:Image;
		private var selfIllustration:Image;
		private var otherIllustration:Image;
		private var titleBg:Image;
		private var title:TextField;
		private var selfTitleBg:Image;
		private var selfTitle:TextField;
		private var otherTitleBg:Image;
		private var otherTitle:TextField;
		
		public function Duel(params:Object = null) 
		{
			options = params;
			
			assets.enqueue("Background/Items/" + ScreenManager.gameModel.selfPlayer.currentCard.name + ".jpg");
			assets.enqueue("Background/Items/" + ScreenManager.gameModel.otherPlayer.currentCard.name + ".jpg");
			assets.enqueue("Spritesheets/itemsSprites.xml");
			assets.enqueue("Spritesheets/itemsSprites.png");
			assets.enqueue("Spritesheets/duelFx.xml");
			assets.enqueue("Spritesheets/duelFx.png");
			
			assets.enqueue("Sounds/ecran-duel.mp3");
		}
		
		protected override function added():void
		{
			stageMask = new ClippedSprite();
			stageMask.clipRect = new Rectangle(0, 0, Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			addChild(stageMask);
			
			selfBackground = new Image(getTexture(ScreenManager.gameModel.selfPlayer.currentCard.name));
			selfBackground.pivotX = selfBackground.width >> 1;
			selfBackground.pivotY = selfBackground.height >> 1;
			selfBackground.rotation = 1.8;
			selfBackground.scaleX = selfBackground.scaleY = 0.9;
			selfBackground.x = 174;
			selfBackground.y = 337;
			stageMask.addChild(selfBackground);
						
			otherBackground = new Image(getTexture(ScreenManager.gameModel.otherPlayer.currentCard.name));
			otherBackground.pivotX = otherBackground.width >> 1;
			otherBackground.pivotY = otherBackground.height >> 1;
			otherBackground.rotation = 1.8;
			otherBackground.scaleX = otherBackground.scaleY = 0.9;
			otherBackground.x = 858;
			otherBackground.y = 424;
			stageMask.addChild(otherBackground);
			
			slash = new Image(getAtlas("duelFx").getTexture("slash"));
			slash.x = 390;
			slash.y = 89;
			slash.blendMode = BlendMode.SCREEN;
			slash.color = ScreenManager.gameModel.selfPlayer.currentCard.color;
			slash.alpha = 0.8;
			addChild(slash);
			
			selfIllustration = new Image(getAtlas("itemsSprites").getTexture(ScreenManager.gameModel.selfPlayer.currentCard.name));
			selfIllustration.pivotX = selfIllustration.width >> 1;
			selfIllustration.pivotY = selfIllustration.height >> 1;
			selfIllustration.x = (Starling.current.stage.stageWidth >> 2) - 50;
			selfIllustration.y = (Starling.current.stage.stageHeight) - (selfIllustration.height >> 1) - 90;
			addChild(selfIllustration);
			
			otherIllustration = new Image(getAtlas("itemsSprites").getTexture(ScreenManager.gameModel.otherPlayer.currentCard.name));
			otherIllustration.pivotX = otherIllustration.width >> 1;
			otherIllustration.pivotY = otherIllustration.height >> 1;
			otherIllustration.x = Starling.current.stage.stageWidth - (Starling.current.stage.stageWidth >> 2);
			otherIllustration.y = (Starling.current.stage.stageHeight) - (otherIllustration.height >> 1) - 90;
			addChild(otherIllustration);
			
			titleBg = new Image(getTexture("UI/titleBg"));
			titleBg.y = 104;
			titleBg.color = ScreenManager.gameModel.selfPlayer.currentCard.color;
			titleBg.blendMode = BlendMode.MULTIPLY;
			titleBg.alpha = 0.6;
			addChild(titleBg);
			title = new TextField(titleBg.width, titleBg.height, "DUEL", "Aldo", 45, 0xFFFFFF);
			title.y = titleBg.y + 10;
			addChild(title);
			
			selfTitleBg = new Image(getTexture("UI/duelBg"));
			selfTitleBg.color = ScreenManager.gameModel.selfPlayer.currentCard.color;
			selfTitleBg.blendMode = BlendMode.MULTIPLY;
			selfTitleBg.alpha = 0.8;
			selfTitleBg.x = 1;
			selfTitleBg.y = 178.5;
			addChild(selfTitleBg);
			selfTitle = new TextField(selfTitleBg.width, selfTitleBg.height, ScreenManager.gameModel.selfPlayer.currentCard.name.toUpperCase(), "Aldo", 40, 0xFFFFFF);
			selfTitle.y = selfTitleBg.y;
			addChild(selfTitle);
			
			otherTitleBg = new Image(getTexture("UI/duelBg"));
			otherTitleBg.color = ScreenManager.gameModel.otherPlayer.currentCard.color;
			otherTitleBg.blendMode = BlendMode.MULTIPLY;
			otherTitleBg.alpha = 0.8;
			otherTitleBg.scaleX = -1;
			otherTitleBg.x = 649 + otherTitleBg.width - 10;
			otherTitleBg.y = 178.5;
			addChild(otherTitleBg);
			otherTitle = new TextField(otherTitleBg.width, otherTitleBg.height, ScreenManager.gameModel.otherPlayer.currentCard.name.toUpperCase(), "Aldo", 40, 0xFFFFFF);
			otherTitle.x = 629;
			otherTitle.y = otherTitleBg.y;
			addChild(otherTitle);
			
			this.shards = new Vector.<Image>(12, true);
			for (var i:int = 0; i < 12; i++) {
				this.shards[i] = new Image(getAtlas("duelFx").getTexture("shard" + (i + 1)));
				this.shards[i].pivotX = this.shards[i].width >> 1;
				this.shards[i].pivotY = this.shards[i].height >> 1;
				this.shards[i].alpha = 0.3;
				this.shards[i].x = this.shards[i].width >> 1;
				this.shards[i].y = this.shards[i].height >> 1;
				addChild(this.shards[i]);
			}
			
			this.shards[0].y += 179;
			this.shards[0].blendMode = BlendMode.SCREEN;
			this.shards[0].color = ScreenManager.gameModel.selfPlayer.currentCard.color;
			
			this.shards[1].x += 62;
			this.shards[1].y += 260;
			this.shards[1].blendMode = BlendMode.MULTIPLY;
			this.shards[1].color = ScreenManager.gameModel.selfPlayer.currentCard.color;
			
			this.shards[2].y += 179;
			this.shards[2].blendMode = BlendMode.MULTIPLY;
			this.shards[2].color = ScreenManager.gameModel.selfPlayer.currentCard.color;
			
			this.shards[3].y += 592;
			this.shards[3].blendMode = BlendMode.SCREEN;
			this.shards[3].color = ScreenManager.gameModel.selfPlayer.currentCard.color;
			
			this.shards[4].y += 633;
			this.shards[4].blendMode = BlendMode.NORMAL;
			this.shards[4].color = ScreenManager.gameModel.selfPlayer.currentCard.color;
			
			this.shards[5].x += 272;
			this.shards[5].y += 701;
			this.shards[5].blendMode = BlendMode.NORMAL;
			this.shards[5].color = ScreenManager.gameModel.selfPlayer.currentCard.color;
			
			this.shards[6].x += 590;
			this.shards[6].y += 669;
			this.shards[6].blendMode = BlendMode.MULTIPLY;
			this.shards[6].color = ScreenManager.gameModel.otherPlayer.currentCard.color;
			
			this.shards[7].x += 738;
			this.shards[7].y += 633;
			this.shards[7].blendMode = BlendMode.MULTIPLY;
			this.shards[7].color = ScreenManager.gameModel.otherPlayer.currentCard.color;
			
			this.shards[8].x += 863;
			this.shards[8].y += 469;
			this.shards[8].blendMode = BlendMode.SCREEN;
			this.shards[8].color = ScreenManager.gameModel.selfPlayer.currentCard.color;
			
			this.shards[9].x += 924;
			this.shards[9].y += 354;
			this.shards[9].blendMode = BlendMode.NORMAL;
			this.shards[9].color = ScreenManager.gameModel.otherPlayer.currentCard.color;
			this.shards[9].alpha = 0;
			
			this.shards[10].x += 924;
			this.shards[10].y += 180;
			this.shards[10].blendMode = BlendMode.MULTIPLY;
			this.shards[10].color = ScreenManager.gameModel.selfPlayer.currentCard.color;
			
			this.shards[11].x += 888;
			this.shards[11].y += 180;
			this.shards[11].blendMode = BlendMode.SCREEN;
			this.shards[11].color = ScreenManager.gameModel.selfPlayer.currentCard.color;
		}
		
		public override function transitionIn():void
		{
			var time:Number = 0;
			var ad:Number = 0.1;
			
			transitionTl.insert(TweenMax.from(selfBackground, 0.4, {x: -300, y: -300, ease: Cubic.easeInOut}), time += ad);
			transitionTl.insert(TweenMax.from(otherBackground, 0.4, { x: Starling.current.stage.stageWidth + 300, y: Starling.current.stage.stageHeight + 300, ease: Cubic.easeInOut } ), time += ad*2);
			
			transitionTl.insert(TweenMax.from(titleBg, 0.4, { x: 0, ease: Expo.easeInOut } ), time += ad);
			transitionTl.insert(TweenMax.from(title, 0.4, { alpha: 0, ease: Expo.easeInOut } ), time += ad);
			
			transitionTl.insert(TweenMax.from(selfIllustration, 0.4, {y: Starling.current.stage.stageHeight, alpha : 0, ease: Expo.easeInOut}), time += ad);
			transitionTl.insert(TweenMax.from(otherIllustration, 0.4, { y: 0, alpha : 0, ease: Expo.easeInOut } ), time += ad);
			transitionTl.addCallback(function():void
			{
				assets.play('ecran-duel');
			}, time);
			
			transitionTl.insert(TweenMax.from(selfTitleBg, 0.4, { y: selfTitleBg.y - 50, alpha: 0, ease: Expo.easeInOut } ), time += ad);
			transitionTl.insert(TweenMax.from(selfTitle, 0.4, { y: selfTitle.y - 50, alpha:0, ease: Expo.easeInOut } ), time += ad);
			transitionTl.insert(TweenMax.from(otherTitleBg, 0.4, { y: otherTitleBg.y - 50, alpha: 0, ease: Expo.easeInOut } ), time += ad);
			transitionTl.insert(TweenMax.from(otherTitle, 0.4, { y: otherTitle.y - 50, alpha: 0, ease: Expo.easeInOut } ), time += ad);
			
			for (var i:int = 0; i < 12; i++) {
				transitionTl.insert(TweenMax.from(shards[i], 0.3, {scaleX: 0, scaleY: 0, ease:Expo.easeInOut}), Math.random() * (time - 0.02) + time);
				//transitionTl.insert(TweenMax.from(shards[i], 0.3, {scaleX: 0, scaleY: 0, ease:Expo.easeInOut}), time += 0.02);
			}
			
			transitionTl.insert(TweenMax.from(slash, 0.4, { x : slash.x - slash.width, y: Starling.current.stage.stageHeight, alpha: 0, ease: Expo.easeInOut } ), time += ad);			
		}
		
		public override function transitionInComplete():void
		{
			setTimeout(function():void
			{
				transitionTl.timeScale = 2;
				transitionTl.reverse(true);
			}, 1100);
		}
		
		public override function transitionOut():void
		{	
		}
		
		public override function transitionOutComplete():void
		{
			changeScreen(Screen.BATTLE, TransitionManager.TRANSITION_NONE, { game: options.game } );
		}
	}

}