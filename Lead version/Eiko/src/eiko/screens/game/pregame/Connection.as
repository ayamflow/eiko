package eiko.screens.game.pregame 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import eiko.entities.Server;
	import eiko.screens.Screen;
	import eiko.screens.utils.AssetsManager;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;
	import feathers.themes.MetalWorksMobileTheme;
	import flash.media.SoundChannel;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Connection extends Screen 
	{
		private var background:Image;
		private var debug:TextField;
		private var ipInput:TextInput;
		private var theme:MetalWorksMobileTheme;
		
		public function Connection(params:Object)
		{
			assets.enqueue('Background/splash.jpg');
		}
		
		protected override function added():void
		{
			background = new Image(getTexture('splash'));
			addChild(background);
			debug = new TextField(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, "\n\n\n\n\n\n\n\nEntrez l'IP du serveur Eiko.", "Zag Bold", 40, 0xFFFFFF);
			addChild(debug);
			//
			this.theme = new MetalWorksMobileTheme(this.stage);
			ipInput = new TextInput();
			ipInput.addEventListener(FeathersEventType.ENTER, onIpInputOK);
			ipInput.text = Server.SERVER_IP;
			addChild(ipInput);
			ipInput.width = Starling.current.stage.stageWidth >> 2;
			ipInput.x = (Starling.current.stage.stageWidth >> 1) - (ipInput.width >> 1);
			ipInput.y = (Starling.current.stage.stageHeight) - 130;
			ipInput.height = 45;
			ipInput.textEditorProperties.align = "center";
			ipInput.textEditorProperties.fontSize = 30;
			
			ScreenManager.server.addEventListener(Server.GAME_START, gameStart);
			
			// Autoconnect
			onIpInputOK(null);
		}
		
		private function onIpInputOK(e:Event):void
		{
			Server.SERVER_IP = ipInput.text;
			ScreenManager.server.addEventListener(Server.CONNECTED, onConnect);
			ScreenManager.server.connect();
		}
		
		private function onConnect(e:Event):void
		{
			ScreenManager.server.removeEventListener(Server.CONNECTED, onConnect);
			ipInput.text = "";
			TweenMax.to(ipInput, 0.4, { alpha: 0, ease:Expo.easeInOut, onComplete: function():void
				{
					removeChild(ipInput);
				}
			});
			debug.text = "\n\n\n\n\n\n\n\nAttente de l'autre joueur...";
		}
		
		private function gameStart(e:Event):void
		{
			changeScreen(Screen.GENERATION_SELECTOR, TransitionManager.TRANSITION_OUT_AND_AFTER_IN);
		}
		
		public override function transitionIn():void
		{
			transitionTl.insert(TweenMax.from(debug, 0.4, { alpha: 0, y: debug.y + 30, ease:Expo.easeOut } ), 0);
			transitionTl.insert(TweenMax.from(ipInput, 0.4, { alpha: 0, y: ipInput.y + 30, ease:Expo.easeOut } ), 0.2);
			transitionTl.play();
		}
		
		public override function transitionOut():void
		{
			transitionTl.reverse();
		}
		
		public override function dispose():void
		{
			assets.purge();
		}
	}

}