package eiko.screens.utils 
{
	import eiko.models.GameModel;
	import eiko.models.ScreenOptions;
	import eiko.screens.minigames.Game;
	import eiko.screens.minigames.pong.Pong;
	import eiko.screens.Screen;
	import eiko.server.Server;
	import starling.display.Sprite;
	import starling.events.Event;
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
		//public static var UDPServer:FastServer;
		public static var gameModel:GameModel;
		
		private var screens:Object = { };
		private var games:Object = { };
		private var options:ScreenOptions;
		
		private var atlasLoader:AtlasLoader;
		public static var atlas:TextureAtlas;
				
		public function ScreenManager() 
		{	
			// SCREENS
			/*screens[Screen.ERROR] = Error;
			screens[Screen.HOME] = Home;
			screens[Screen.MENU] = Menu;
			screens[Screen.CARD_SELECTOR] = CardSelector;
			screens[Screen.GENERATION_SELECTOR] = GenerationSelector;
			screens[Screen.TABLE] = CardTable;
			screens[Screen.CONNECTION] = Connection;
			//screens[Screen.COMPENDIUM] = Compendium;
			screens[Screen.PRIZE] = Prize;
			screens[Screen.END] = End;
			// GAMES
			games["bilboquet"] = Bilboquet;*/
			screens[Screen.BATTLE] = Game;
			games["pong"] = Pong;
			
			TransitionManager.addEventListener(TransitionManager.SCREEN_CHANGE, changeScreen);
			
			//atlasLoader = new AtlasLoader();
			//atlasLoader.addEventListener(AtlasLoader.LOADED, loaded);
			//atlasLoader.load();
			
			loaded();
		}
		
		private function loaded():void
		{	
			//atlasLoader.removeEventListener(AtlasLoader.LOADED, loaded);
			//atlas = new TextureAtlas(Texture.fromBitmap(atlasLoader.spriteImage, true, true, 1), atlasLoader.spriteData);
			server = new Server();
			addChild(server);
			
			//TransitionManager.changeScreen(Screen.BATTLE, TransitionManager.TRANSITION_NONE, { game: "pong" } );
		}
		
		public static function resetServer():void
		{
			server = new Server();
		}
		
		private function serverStatus(e:Event):void 
		{
			trace('[Server] ' + e.data.type + ' | ' + e.data.content);
		}
		
		private function changeScreen(evt:Event):void
		{
			options = evt.data as ScreenOptions;

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
					//screenClass = Game;
				}
				catch (e:Error)
				{
					screenClass = screens[Screen.ERROR];
					trace(this, 'screenClass is null');
					options.parameters.error = e;
				}
			}
			
			switch(options.transitionType)
			{
				case TransitionManager.TRANSITION_NONE:
					currentScreen = new screenClass(options.parameters);
					addChild(currentScreen);
					swapChildren(currentScreen, server);
					if(oldScreen) oldScreen.dispose();
					removeChild(oldScreen);
					oldScreen = null;
					break;
				case TransitionManager.TRANSITION_IN_AND_AFTER_OUT:
					TransitionManager.addEventListener(TransitionManager.TRANSITION_IN_COMPLETE, transitionInCompleteAndOut);
					currentScreen = new screenClass(options.parameters);
					addChild(currentScreen);
					swapChildren(currentScreen, server);
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
					oldScreen._transitionOut();
					currentScreen = new screenClass(options.parameters);
					addChild(currentScreen);
					swapChildren(currentScreen, server);
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
				removeChild(oldScreen);
				oldScreen = null;
			}
		}
		
		private function transitionOutCompleteAndIn(evt:Event):void
		{
			TransitionManager.removeEventListener(TransitionManager.TRANSITION_OUT_COMPLETE, transitionOutCompleteAndIn);
			if (oldScreen)
			{
				removeChild(oldScreen);
				oldScreen = null;
			}
			TransitionManager.addEventListener(TransitionManager.TRANSITION_IN_COMPLETE, transitionOutAndInComplete);
			currentScreen = new screenClass(options.parameters);
			addChild(currentScreen);
			swapChildren(currentScreen, server);
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
				removeChild(oldScreen);
				oldScreen = null;
			}
			else callbackCount++;
		}
	}

}