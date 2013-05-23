package eiko.server 
{
	import air.net.SocketMonitor;
	import eiko.models.game.Card;
	import eiko.models.game.Player;
	import eiko.models.GameModel;
	import eiko.screens.Screen;
	import eiko.screens.utils.ScreenManager;
	import eiko.screens.utils.TransitionManager;
	import eiko.utils.Math2;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.globalization.LocaleID;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Server extends Sprite 
	{
		private var serverSocket:ServerSocket;
		
		private var sockets:Vector.<Socket>;
		public static var IP:Vector.<String>;
		
		private var debug:TextField;
		private var background:Quad;
		
		// Game phase
		private var gameModel:GameModel;
		private var playedCardsCount:Array;
		private var scoreBonus:Array;
		private var waitingGameStart:int = 0;
		private var restartCpt:Array;
		
		private var playersOrder:Vector.<Socket>;
		private var playersConnected:Array;
		private var minigameStart:Array;
		
		public static var PORT:int = 3000;
		
		private var minigames:Array = ["vhs", "pong", "bilboquet"];
		private var availablesMinigames:Array = ["vhs", "pong", "bilboquet"];
		private var prizeCount:Array;
		private var file:File;
		private var stream:FileStream;
		
		public function Server() 
		{
			addEventListener(Event.ADDED_TO_STAGE, added);
			IP = new Vector.<String>();
			playersConnected = new Array();
			
			file = new File(File.applicationDirectory.nativePath).resolvePath("assets/log.txt");
			stream = new FileStream();
		}
		
		private function added():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			// UI
			background = new Quad(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, 0xFF9100);
			addChild(background);
			debug = new TextField(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight, "Server listening...", "Arial", 20, 0xFFFFFF);
			debug.vAlign = "bottom";
			addChild(debug);
			
			var netInterfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			var addresses:Vector.<InterfaceAddress> = netInterfaces[2].addresses;
			var ipAddress:String = addresses[0].address;
			traceDebug("IP du serveur: " + ipAddress);
			
			// Model
			gameModel = new GameModel();
			
			// Sockets
			sockets = new Vector.<Socket>(2, true);
			serverSocket = new ServerSocket();
			serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
			serverSocket.bind(3000, "0.0.0.0");
			serverSocket.listen();
		}
		
		private function onConnect(e:ServerSocketConnectEvent):void
		{
			var socketAdded:int = -1;
			if (sockets[0] && sockets[0].connected === false || sockets[0] === null || sockets[0] === undefined)
			{
				socketAdded = 0;
				sockets[0] = e.socket;
				IP[0] = e.socket.remoteAddress;
			}
			else if (sockets[1] && sockets[1].connected === false || sockets[1] === null || sockets[1] === undefined)
			{
				socketAdded = 1;
				sockets[1] = e.socket;
				IP[1] = e.socket.remoteAddress;
			}
			else
			{
				trace('Already two sockets connected.');
				traceDebug("Already two sockets connected.");
			}
			if(socketAdded > -1)
			{
				trace('socket added');
				traceDebug("Socket added.");
				e.socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
				e.socket.addEventListener(Event.CLOSE, onConnectionClosed);
				playersConnected.push(socketAdded);
				send(e.socket as Socket, {type:"serverAck", content:socketAdded});
			}
		}

		private function onData(e: ProgressEvent):void {
			var currentSocket:Socket = e.currentTarget as Socket;
			var p:Object = currentSocket.readObject();
			var otherSocket:Socket = sockets[int(!p.id)];
			traceDebug("[received] " + p.type + ", " + p.content + ", from p" + p.id);
			//trace("\n[received] " + p.type + ", " + p.content + ", from p" + p.id);
			
			switch(p.type)
			{
				case "restart":
					restartCpt.push(p.id);
					if (restartCpt.indexOf(1) > -1 && restartCpt.indexOf(0) > -1)
					{
						resetGame("restart");						
					}
					break;
				case "gameStart":
					playersConnected.push(p.id);
					traceDebug("Player ready: " + p.id);
					if (playersConnected.indexOf(1) > -1 && playersConnected.indexOf(0) > -1)
					{
						// Initialize counters and log
						playersOrder = new Vector.<Socket>();
						prizeCount = new Array();
						playedCardsCount = new Array();
						scoreBonus = new Array();
						restartCpt = new Array();
						traceDebug("Game start!");
						playersConnected = new Array();
						minigameStart = new Array();
						clearLog();
						
						send(currentSocket, { type: "gameStart" } );
						send(otherSocket, { type: "gameStart" } );
					}
					break;
				case "generation":
					send(otherSocket, p );
					gameModel.players[p.id].generation = p.content;
					break;
				case "cardsValue":
				case "gameUpdate":
				case "bonus":
				case "getBattleBonus":
					send(otherSocket, p );
					//gameModel.setPlayerCards(gameModel.players[p.id], p.content);
					break;
				case "prize":
					traceDebug("received prize from " + p.id);
					prizeCount.push(p.id);
					if (prizeCount.indexOf(1) > -1 && prizeCount.indexOf(0) > -1)
					{
						traceDebug("Send prize to both players");
						send(currentSocket, p);
						send(otherSocket, p);
						prizeCount.splice(0, prizeCount.length);
						scoreBonus.splice(0, scoreBonus.length);
					}
					break;
				case "minigameStart":
						minigameStart.push(p.id);
						if (minigameStart.indexOf(1) > -1 && minigameStart.indexOf(0) > -1)
						{
							minigameStart.splice(0, minigameStart.length);
							setTimeout(function():void
							{
								send(otherSocket, p);
								send(currentSocket, p);
							}, 700);
						}
						break;
				case "cardPlayed":
					debug.text = "";
					send(otherSocket, p);
					gameModel.players[p.id].currentCard = p.content as Card;
					break;
				case "getScoreBonus":
					playedCardsCount.push(p.id);
					scoreBonus[p.id] = p.content;
					traceDebug("REVELATION " + p.id);
					if (playedCardsCount.indexOf(1) > -1 && playedCardsCount.indexOf(0) > -1)
					{
						playedCardsCount.splice(0, playedCardsCount.length);
						playersOrder.splice(0, playersOrder.length);
						//debug.text += "\revelation";
						send(currentSocket, { type: "revelation", content: scoreBonus[int(!p.id)] } );
						send(otherSocket, { type: "revelation", content: scoreBonus[p.id] } );
					}
					break;
				case "battleRequest":
					if (p.content == "solo")
					{
						chooseMinigame(currentSocket, otherSocket);
					}
					else
					{
						waitingGameStart++;
						if (waitingGameStart == 2)
						{
							waitingGameStart = 0;
							chooseMinigame(currentSocket, otherSocket);
							//TransitionManager.changeScreen(Screen.BATTLE, TransitionManager.TRANSITION_NONE, { game: "pong"} );
						}
					}
					break;
				case "minigameEnd":
					if (playersOrder.length === 0)
					{
						playersOrder.push(currentSocket);
						if (p.content == "self")
						{
							send(currentSocket, { type: "minigameEnd", content: "self" } );
							send(otherSocket, { type: "minigameEnd", content: "other" } );
						}
						else if (p.content == "other")
						{
							send(currentSocket, { type: "minigameEnd", content: "other" } );
							send(otherSocket, { type: "minigameEnd", content: "self" } );
						}
						debug.text = "";
					}
					break;
				default:
					traceDebug("[onData] Pas de comportement prévu pour " + p.type);
					break;
			}
		}
		
		private function chooseMinigame(currentSocket:Socket, otherSocket:Socket):void 
		{
			if (availablesMinigames.length == 0) availablesMinigames = minigames;
			var game:String = Math2.randValueFromArray(availablesMinigames) as String;
			availablesMinigames.splice(availablesMinigames.indexOf(game), 1);
			send(currentSocket, { type: "battle", content: game } );
			send(otherSocket, { type: "battle", content: game } );
		}

		private function onConnectionClosed(e:Event):void {
			var target:Socket = e.currentTarget as Socket;
			traceDebug("A player has disconnected.");
			resetGame("reset");
			//sockets.splice(sockets.indexOf(target), 1);
			//getPlayer(target.ipadID).ready = false;
			//send(sockets[sockets.length], { type:"otherPlayer", content: "disconnected" } );
		}
		
		public function sendClients(params:Object):void 
		{
			traceDebug("[sent] " + params.type + ", " + params.content);
			for (var i:int = 0, l:int = sockets.length; i < l; i++)
			{
				sockets[i].writeObject(params);
				sockets[i].flush();
			}
		}
		
		public function getPlayersOrder():int
		{
			var firstToPlayID:int = Math2.rand2(0, 1) as int;
			send(sockets[firstToPlayID], { type:"minigame", content: "firstToPlay" } );
			send(sockets[int(!firstToPlayID)], { type: "minigame", content: "secondToPlay" } );
			return firstToPlayID;
		}
		
		public function sendTo(clientID:int, params:Object):void
		{
			//debug.text += "\n[sent] " + params.type + ", " + params.content;
			if (sockets[clientID])
			{
				sockets[clientID].writeObject(params);
				sockets[clientID].flush();
			}
		}
		
		private function send(toClient:Socket, params:Object):void 
		{
			if (toClient)
			{
				traceDebug("[sent] " + params.type + ", " + params.content);
				toClient.writeObject(params);
				toClient.flush();
			}
		}
		
		private function traceDebug(text:String):void
		{
			text = "\n" + text;
			debug.text += text;
			
			/*stream.open(file, FileMode.READ);
			var log:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(log + text.replace("\n", File.lineEnding));
			stream.close();*/
		}
		
		private function resetGame(type:String):void
		{
			ScreenManager.resetServer();
			playersOrder = new Vector.<Socket>();
			prizeCount = new Array();
			playedCardsCount = new Array();
			scoreBonus = new Array();
			playersConnected = new Array();
			minigameStart = new Array();
			restartCpt = new Array();
			clearLog();
			
			sendClients( { type: type } );
		}
		
		private function clearLog():void
		{
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes("");
			stream.close();
		}
	}
}