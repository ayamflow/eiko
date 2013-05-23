package eiko.screens.ui 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import eiko.screens.Screen;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Header extends Sprite 
	{
		private var background:Image;
		private var hidden:Boolean = false;
		private var isNormalMode:Boolean = true;
		private var backgroundGame:Image;
		private var menu:Sprite;
		private var logo:Image;
				
		public function Header() 
		{
			background = new Image(ScreenManager.assets.getTexture("UI/eikoHeader"));
			background.blendMode = BlendMode.MULTIPLY;
			background.alpha = 0.6;
			addChild(background);
			
			backgroundGame = new Image(ScreenManager.assets.getTexture("UI/eikoHeaderGame"));
			backgroundGame.alpha = 0.6;
			backgroundGame.blendMode = BlendMode.MULTIPLY;
			
			menu = new Sprite();
			addChild(menu);
			
			var puce:Image = new Image(ScreenManager.assets.getTexture("UI/headerMenuBG"));
			puce.blendMode = BlendMode.MULTIPLY;
			menu.addChild(puce);
			var menuBt:Image = new Image(ScreenManager.assets.getTexture("UI/menuBtHeader"));
			menuBt.x = 17;
			menuBt.y = 25;
			menu.addChild(menuBt);
			
			logo = new Image(ScreenManager.assets.getTexture("UI/eikoLogo"));
			logo.x = (Starling.current.stage.stageWidth >> 1) - (logo.width >> 1);
			logo.y = (background.height >> 1) - (logo.height >> 1);
			addChild(logo);
			
			//menu.addEventListener(TouchEvent.TOUCH, gotoMenu);
			
		}
		
		//private function gotoMenu(e:TouchEvent):void 
		//{
			//TransitionManager.changeScreen(Screen.MENU, TransitionManager.TRANSITION_IN_AND_OUT_TOGETHER);
		//}
		
		public function gameMode():void
		{
			if (isNormalMode)
			{
				show();
				TweenMax.to(logo, 0.4, { alpha: 0, ease: Expo.easeInOut } );
				TweenMax.to(menu, 0.4, { alpha: 0, ease: Expo.easeInOut } );
				TweenMax.to(background, 0.4, { alpha: 0, ease: Expo.easeInOut, onComplete: function():void
					{
						menu.y = Starling.current.stage.stageHeight;
						menu.rotation = -Math.PI / 2;
						logo.x = 0;
						logo.y = (Starling.current.stage.stageHeight >> 1) + (logo.width >> 1);
						logo.rotation = -Math.PI / 2;
						isNormalMode = false;
						removeChild(background);
						addChild(backgroundGame);
						swapChildren(logo, backgroundGame);
						TweenMax.fromTo(backgroundGame, 0.4, { alpha: 0, ease:Expo.easeInOut }, { alpha: 1 } );
						TweenMax.to(logo, 0.4, { alpha: 1, ease: Expo.easeInOut } );
						TweenMax.to(menu, 0.4, { alpha: 1, ease: Expo.easeInOut } );
					}
				});
			}
		}
		
		public function normalMode():void
		{
			if (!isNormalMode)
			{
				show();
				TweenMax.to(logo, 0.4, { alpha: 0, ease: Expo.easeInOut } );
				TweenMax.to(menu, 0.4, { alpha: 0, ease: Expo.easeInOut } );
				TweenMax.to(backgroundGame, 0.4, { alpha: 0, ease: Expo.easeInOut, onComplete: function():void
					{
						menu.y = 0;
						menu.rotation = 0;
						logo.x = (Starling.current.stage.stageWidth >> 1) - (logo.width >> 1);
						logo.y = (background.height >> 1) - (logo.height >> 1);
						logo.rotation = 0;
						isNormalMode = true;
						removeChild(backgroundGame);
						addChild(background);
						swapChildren(logo, background);
						TweenMax.fromTo(background, 0.4, { alpha: 0, ease:Expo.easeInOut },  { alpha: 1 } );
						TweenMax.to(logo, 0.4, { alpha: 1, ease: Expo.easeInOut } );
						TweenMax.to(menu, 0.4, { alpha: 1, ease: Expo.easeInOut } );
					}
				});
			}
		}
		
		public function show():void
		{
			if (hidden)
			{
				this.visible = true;
				hidden = false;
			}
		}
		
		public function hide():void
		{
			if (!hidden)
			{
				this.visible = false;
				hidden = true;
			}
		}
		
		public function setColor(color:uint):void
		{
			//background.color = 0x000000;
			//background.color = color;
		}
		
		public function setAlpha(alpha:Number):void
		{
			if(background.alpha != alpha) background.alpha = alpha
		}
	}

}