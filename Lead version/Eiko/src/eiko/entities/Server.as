package eiko.entities 
{
	import eiko.models.bonus.BattleBonus;
	import eiko.models.bonus.ScoreBonus;
	import eiko.models.game.Card;
	import eiko.screens.Screen;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.setTimeout;
	import starling.events.Event;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Florian Morele
	 */
	public class Server extends Sprite
	{
		public static const MINI_GAME_START:String = "minigameStart";
		public static const MINI_GAME_END:String = "minigameEnd";
		public static const GAME_UPDATE:String = "gameUpdate";
		public static const GAME_START:String = "gameStart";
		public static const BATTLE:String = "battle";
		public static const BONUS:String = "bonus";
		public static const GET_SCORE_BONUS:String = "getScoreBonus";
		public static const GET_BATTLE_BONUS:String = "getBattleBonus";
		public static const PRIZE:String = "prize";
		public static const CARD_PLAYED:String = "cardPlayed";
		public static const REVELATION:String = "revelation";
		public static const CARDS_VALUE:String = "cardsValue";
		public static const GENERATION:String = "generation";
		public static const CONNECTED:String = "connected";
		public static const IO_ERROR:String = "io_error";
		public static const STATUS:String = "status";
		public static const SERVER_ACK:String = "serverAck";
		public static const PLAYERS_READY:String = "playersReady";
		public static const RESTART:String = "restart";
		public static const RESET:String = "reset";
		
		public static var PORT:int = 3000;
		//public static var SERVER_IP:String = "192.168.0.13";
		//public static var SERVER_IP:String = "localhost";
		//public static var SERVER_IP:String = "192.168.1.14"; // maison
		//public static var SERVER_IP:String = "10.0.6.53"; // school
		public static var SERVER_IP:String = "10.0.6.150"; // school2
		//public static var SERVER_IP:String = "172.18.33.72"; // elise
		
		public function Server()
		{
			ScreenManager.gameModel.selfPlayer.socket = new Socket();
			ScreenManager.gameModel.selfPlayer.socket.addEventListener(flash.events.Event.CONNECT, onConnect);
			ScreenManager.gameModel.selfPlayer.socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			ScreenManager.gameModel.selfPlayer.socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			
			//connect();
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			trace('Le serveur ne répond pas ! Reconnexion dans 2 secondes...');
			setTimeout(connect, 2000);
		}
		
		public function connect():void
		{			
			ScreenManager.gameModel.selfPlayer.socket.connect(SERVER_IP, PORT);
		}
		
		private function onData(e: ProgressEvent):void {
			var p:Object = ScreenManager.gameModel.selfPlayer.socket.readObject();
			status(p, "get");
			
			switch(p.type)
			{
				case SERVER_ACK:
					ScreenManager.gameModel.selfPlayer.identifier = p.content;
					ScreenManager.server.send( { type: Server.GAME_START } );
					break;
				//case GAME_START:
					//TransitionManager.changeScreen(Screen.GENERATION_SELECTOR, TransitionManager.TRANSITION_IN_AND_AFTER_OUT);
					//break;
				//case PLAYERS_READY:
					//TransitionManager.changeScreen(Screen.GENERATION_SELECTOR, TransitionManager.TRANSITION_IN_AND_AFTER_OUT);
					//break;
				case CARDS_VALUE:
					var otherCardsValue:Object = p.content;
					ScreenManager.gameModel.setPlayerCards(ScreenManager.gameModel.otherPlayer, otherCardsValue);
					ScreenManager.gameModel.setPlayerCards(ScreenManager.gameModel.otherPlayer, otherCardsValue);
					break;
				case GENERATION:
					ScreenManager.gameModel.otherPlayer.generation = p.content;
					break;
				case CARD_PLAYED:
					ScreenManager.gameModel.otherPlayer.currentCard = ScreenManager.gameModel.generations[ScreenManager.gameModel.otherPlayer.generation].cards[p.content];
					//ScreenManager.gameModel.otherPlayer.currentCard.value = p.content.value;
					ScreenManager.gameModel.otherPlayer.currentCard.used = true;
					break;
				case BONUS:
				case GET_BATTLE_BONUS:
				case GET_SCORE_BONUS:
					switch(p.content)
					{
						case ScoreBonus.SCORE:
							//otherCurrentCard.value += 2;
							ScreenManager.gameModel.otherPlayer.bonus["score"].used = true;
							ScreenManager.gameModel.otherPlayer.currentCard.value = ScreenManager.gameModel.generations[ScreenManager.gameModel.otherPlayer.generation].cards[ScreenManager.gameModel.otherPlayer.currentCard.name].value = Math.min(5, ScreenManager.gameModel.otherPlayer.currentCard.value + 2);
							break;
						case BattleBonus.BATTLE:
							ScreenManager.gameModel.otherPlayer.bonus["battle"].used = true;
							break;
					}
				case REVELATION:
					if (p.content == ScoreBonus.SCORE)
					{
						ScreenManager.gameModel.otherPlayer.bonus["score"].used = true;
						ScreenManager.gameModel.otherPlayer.currentCard.value = ScreenManager.gameModel.generations[ScreenManager.gameModel.otherPlayer.generation].cards[ScreenManager.gameModel.otherPlayer.currentCard.name].value = Math.min(5, ScreenManager.gameModel.otherPlayer.currentCard.value + 2);
					}
					break;
				case GAME_UPDATE:
					
					break;
				case MINI_GAME_END:
					
					break;
			}
		}
		
		private function onConnect(e:flash.events.Event):void
		{
			status( { type: CONNECTED, content: SERVER_IP} );
			ScreenManager.gameModel.selfPlayer.socket.addEventListener(flash.events.Event.CLOSE, onClose);
			ScreenManager.gameModel.selfPlayer.ready = true;
		}
		
		private function onClose(e:flash.events.Event):void
		{
			ScreenManager.gameModel.selfPlayer.ready = false;
		}

		public function send(params:Object):void
		{
			params.id = ScreenManager.gameModel.selfPlayer.identifier;
			//trace('[Player sending]', params.type, params.content);
			// DEBUG SOLO
			//status({ type: params.type, content: params.content, action: params.action, id: ScreenManager.gameModel.selfPlayer.identifier }, "send" );
			if (ScreenManager.gameModel.selfPlayer.socket.connected)
			{
				trace('[Player sent]', params.type, params.content);
				ScreenManager.gameModel.selfPlayer.socket.writeObject(params);
				ScreenManager.gameModel.selfPlayer.socket.flush();
			}
		}
		
		private function status(message:Object, type:String = ""):void
		{
			trace('[Player ' + type + '] ' + message.type + " | " + message.content + ' | ' + message.action);
			dispatchEvent(new Event(message.type, false, message));
		}
	}

}