package eiko.screens.utils 
{
	import eiko.entities.Server;
	import eiko.models.GameModel;
	import eiko.screens.Credits;
	import eiko.screens.game.InterScreen;
	import eiko.screens.game.postgame.End;
	import eiko.screens.game.postgame.Prize;
	import eiko.screens.game.pregame.CardSelector;
	import eiko.screens.game.pregame.Connection;
	import eiko.screens.game.pregame.GenerationSelector;
	import eiko.screens.game.table.CardDetector;
	import eiko.screens.game.table.CardTable;
	import eiko.screens.game.table.Duel;
	import eiko.screens.game.table.Revelation;
	import eiko.screens.game.table.RevelationOverlay;
	import eiko.screens.minigames.bilboquet.Bilboquet;
	import eiko.screens.minigames.pong.Pong;
	import eiko.screens.minigames.telephone.Telephone;
	import eiko.screens.minigames.vhs.Vhs;
	import eiko.screens.Screen;
	import eiko.screens.Menu;
	import eiko.screens.ui.Header;
	import flash.display.BitmapData;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import eiko.models.ScreenOptions;
	import eiko.screens.utils.TransitionManager;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...s
	 * @author Florian Morel
	 */
	public class ScreenManager extends Sprite
	{
		private var currentScreen:Screen;
		private var oldScreen:Screen;
		private var callbackCount:int;
		private var screenClass:Class;
		
		public static var server:Server;
		public static var gameModel:GameModel;
		
		private var screens:Object = { };
		private var games:Object = { };
		private var options:ScreenOptions;
		
		public static var assets:AssetsManager;
		
		public static var header:Header;
		
		private static var support:RenderSupport;
		private static var screenShot:Image;
		private static var screenShotHolder:Sprite;
		private static var result:BitmapData;
				
		[Embed(source="/../bin/assets/Fonts/Aldo.ttf", embedAsCFF="false", fontFamily="Aldo")]
		private static const Aldo:Class;
		
		public function ScreenManager() 
		{	
			// SCREENS
			//screens[Screen.TEST] = Test;
			screens[Screen.DUEL] = Duel;
			screens[Screen.INTERSCREEN] = InterScreen;
			screens[Screen.ERROR] = Error;
			screens[Screen.MENU] = Menu;
			screens[Screen.CARD_SELECTOR] = CardSelector;
			screens[Screen.GENERATION_SELECTOR] = GenerationSelector;
			screens[Screen.TABLE] = CardTable;
			screens[Screen.CARD_DETECTOR] = CardDetector;
			screens[Screen.CONNECTION] = Connection;
			//screens[Screen.COMPENDIUM] = Compendium;
			screens[Screen.PRIZE] = Prize;
			screens[Screen.END] = End;
			screens[Screen.CREDITS] = Credits;
			screens[Screen.REVELATION_OVERLAY] = RevelationOverlay;
			screens[Screen.REVELATION] = Revelation;
			// GAMES
			games["bilboquet"] = Bilboquet;
			games["pong"] = Pong;
			games["vhs"] = Vhs;
			games["telephone"] = Telephone;

			support = new RenderSupport();
			support.setOrthographicProjection(0, 0, Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			screenShotHolder = new Sprite();
			addChild(screenShotHolder);
			
			
			assets = new AssetsManager(true);
			
			assets.enqueue("Spritesheets/eikoSprites.xml");
			assets.enqueue("Spritesheets/eikoSprites.png");
			
			assets.enqueue("Spritesheets/cardSprites.xml");
			assets.enqueue("Spritesheets/cardSprites.png");
			
			assets.enqueue('Sounds/home/intro.mp3');
			assets.enqueue("Sounds/home/intro-loop.mp3");
			
			assets.addEventListener(AssetsManager.LOADED, loaded);
			assets.load();
		}
		
		private function loaded():void
		{	
			assets.play("intro");
			
			assets.removeEventListener(AssetsManager.LOADED, loaded);
						
			gameModel = new GameModel();
			server = new Server();
			server.addEventListener(Server.STATUS, serverStatus);
			//server.addEventListener(Server.CONNECTED, function():void
			//{
				//assets.play("intro-loop");
			//});
			//server.addEventListener(Server.RESET, onReset);
			//server.addEventListener(Server.RESTART, onRestart);
			
			header = new Header();
			header.alpha = 0;
			addChild(header);
			
			TransitionManager.addEventListener(TransitionManager.SCREEN_CHANGE, changeScreen);
			
			//TransitionManager.changeScreen(Screen.MENU);
			TransitionManager.changeScreen(Screen.CONNECTION);
			//TransitionManager.changeScreen(Screen.CARD_DETECTOR);
			//TransitionManager.changeScreen(Screen.TABLE);
			//TransitionManager.changeScreen(Screen.CARD_SELECTOR);
			//TransitionManager.changeScreen(Screen.PRIZE);
			//TransitionManager.changeScreen(Screen.END);
			//TransitionManager.changeScreen(Screen.DUEL, TransitionManager.TRANSITION_OUT_AND_AFTER_IN, {game: "pong"});
			//TransitionManager.changeScreen(Screen.BATTLE, TransitionManager.TRANSITION_IN_AND_AFTER_OUT, {game: "bilboquet"});
			
			//TransitionManager.changeScreen(Screen.INTERSCREEN, TransitionManager.TRANSITION_OUT_AND_AFTER_IN, {screen: Screen.REVELATION, text: "REVELATION"});
		}
		
		private function onReset(e:Event):void 
		{
			reset(Screen.CONNECTION, TransitionManager.TRANSITION_OUT_AND_AFTER_IN);
		}
		
		private function onRestart(e:Event):void 
		{
			reset(Screen.GENERATION_SELECTOR, TransitionManager.TRANSITION_OUT_AND_AFTER_IN);
		}
		
		private function reset(to:String, transition:String):void
		{
			assets.purge();
			assets.enqueue("Spritesheets/cardSprites.xml");
			assets.enqueue("Spritesheets/cardSprites.png");
			gameModel = new GameModel();
			TransitionManager.changeScreen(to, transition);
			
		}
		
		public static function saveScreen():void
		{
			RenderSupport.clear(Starling.current.stage.color, 1.0);
			
			Starling.current.stage.render(support, 1.0);
			support.finishQuadBatch();
			 
			result = new BitmapData(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, true);
			Starling.context.drawToBitmapData(result);
			
			screenShot = new Image(Texture.fromBitmapData(result));
			screenShotHolder.addChild(screenShot);
		}
		
		public static function removeScreen():void
		{
			result = null;
			screenShotHolder.removeChildren();
		}
		
		private function serverStatus(e:Event):void 
		{
			trace('[Server] ' + e.data.type + ' | ' + e.data.content);
		}
		
		private function changeScreen(evt:Event):void
		{	
			//if (Main.splash !== null)
			//{
				//Main.splash.parent.removeChild(Main.splash);
				//Main.splash = null;
			//}
			
			options = evt.data as ScreenOptions;
			trace('[screenManager] to', options.screenName);
			
			if (currentScreen)
			{
				oldScreen = currentScreen;
			}
			
			try
			{
				screenClass = screens[options.screenName];
			}
			catch (e:Error)
			{
				screenClass = screens[Screen.ERROR];
				trace(this, 'screenClass is null');
				options.parameters.error = e;
			}
						
			if (options.screenName == Screen.BATTLE)
			{
				try
				{
					// TODO
					// Créer une classe par jeu
					screenClass = games[options.parameters.game];
					header.gameMode();
					//screenClass = Game;
				}
				catch (e:Error)
				{
					screenClass = screens[Screen.ERROR];
					trace(this, 'screenClass is null');
					options.parameters.error = e;
				}
			}
			else if(options.screenName == Screen.PRIZE) header.normalMode();
			//else if(options.screenName == Screen.PRIZE) header.hide();
			//else if(options.screenName == Screen.INTERSCREEN || options.screenName == Screen.END) header.normalMode();
			
			//currentScreen = new screenClass(options.parameters);
			
			switch(options.transitionType)
			{
				case TransitionManager.TRANSITION_NONE:
					currentScreen = new screenClass(options.parameters);
					addChild(currentScreen);
					swapChildren(currentScreen, ScreenManager.header);
					if (oldScreen)
					{
						oldScreen.dispose();
						removeChild(oldScreen);
						oldScreen = null;
					}
					break;
				case TransitionManager.TRANSITION_IN_AND_AFTER_OUT:
					TransitionManager.addEventListener(TransitionManager.TRANSITION_IN_COMPLETE, transitionInCompleteAndOut);
					currentScreen = new screenClass(options.parameters);
					addChild(currentScreen);
					swapChildren(currentScreen, ScreenManager.header);
					break;
				case TransitionManager.TRANSITION_OUT_AND_AFTER_IN:
					if (oldScreen)
					{
						TransitionManager.addEventListener(TransitionManager.TRANSITION_OUT_COMPLETE, transitionOutCompleteAndIn);
						oldScreen._transitionOut();
					}
					else transitionOutCompleteAndIn(null);
					break;
				case TransitionManager.TRANSITION_IN_AND_OUT_TOGETHER:
					callbackCount = 0;
					TransitionManager.addEventListener(TransitionManager.TRANSITION_IN_COMPLETE, transitionInAndOutTogetherComplete);
					TransitionManager.addEventListener(TransitionManager.TRANSITION_OUT_COMPLETE, transitionInAndOutTogetherComplete);
					if(oldScreen) oldScreen._transitionOut();
					currentScreen = new screenClass(options.parameters);
					addChild(currentScreen);
					swapChildren(currentScreen, ScreenManager.header);
					break;
			}
		}
		
		private function transitionInCompleteAndOut(evt:Event):void 
		{
			TransitionManager.removeEventListener(TransitionManager.TRANSITION_IN_COMPLETE, transitionInCompleteAndOut);
			if (oldScreen)
			{
				TransitionManager.addEventListener(TransitionManager.TRANSITION_OUT_COMPLETE, transitionInAndOutComplete);
				oldScreen._transitionOut();
			}
			else transitionInAndOutComplete(null);
		}
		
		private function transitionInAndOutComplete(evt:Event):void
		{
			TransitionManager.removeEventListener(TransitionManager.TRANSITION_OUT_COMPLETE, transitionInAndOutComplete);
			if (oldScreen)
			{
				oldScreen.dispose();
				removeChild(oldScreen);
				oldScreen = null;
			}
		}
		
		private function transitionOutCompleteAndIn(evt:Event):void
		{
			TransitionManager.removeEventListener(TransitionManager.TRANSITION_OUT_COMPLETE, transitionOutCompleteAndIn);
			TransitionManager.addEventListener(TransitionManager.TRANSITION_IN_COMPLETE, transitionOutAndInComplete);
			currentScreen = new screenClass(options.parameters);
			addChild(currentScreen);
			swapChildren(currentScreen, ScreenManager.header);
			if (oldScreen)
			{
				oldScreen.dispose();
				removeChild(oldScreen);
				oldScreen = null;
			}
		}
		
		private function transitionOutAndInComplete(evt:Event):void
		{
			TransitionManager.removeEventListener(TransitionManager.TRANSITION_IN_COMPLETE, transitionOutAndInComplete);
		}
		
		private function transitionInAndOutTogetherComplete(evt:Event):void
		{
			if (callbackCount == 2)
			{
				TransitionManager.removeEventListener(TransitionManager.TRANSITION_IN_COMPLETE, transitionInAndOutTogetherComplete);
				TransitionManager.removeEventListener(TransitionManager.TRANSITION_OUT_COMPLETE, transitionInAndOutTogetherComplete);
				oldScreen.dispose();
				removeChild(oldScreen);
				oldScreen = null;
			}
			else callbackCount++;
		}
	}

}