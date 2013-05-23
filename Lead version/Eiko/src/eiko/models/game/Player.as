package eiko.models.game 
{
	import eiko.models.bonus.BattleBonus;
	import eiko.models.bonus.Bonus;
	import eiko.models.bonus.ScoreBonus;
	import eiko.screens.utils.ScreenManager;
	import flash.net.Socket;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Player 
	{
		private var _generation:String;
		private var _score:int;
		private var _bonus:Object;
		
		private var _socket:Socket;
		private var _identifier:int;
		//private var _fastSocket:Socket;
		private var _ready:Boolean = false;
		
		private var _currentCard:Card;
		
		public function Player() 
		{
			score = 0;
			
			bonus = { };
			bonus["score"] = new ScoreBonus();
			bonus["battle"] = new BattleBonus();
		}
				
		public function get score():int 
		{
			return _score;
		}
		
		public function set score(value:int):void 
		{
			if (value >= 0 && value <= 5)
			{
				_score = value;
			}
		}
		
		public function get generation():String 
		{
			return _generation;
		}
		
		public function set generation(value:String):void 
		{
			_generation = value;
		}
		
		public function get ready():Boolean 
		{
			return _ready;
		}
		
		public function set ready(value:Boolean):void 
		{
			_ready = value;
		}

		public function get socket():Socket 
		{
			return _socket;
		}
		
		public function set socket(value:Socket):void 
		{
			_socket = value;
		}
		
		public function get currentCard():Card 
		{
			return _currentCard;
		}
		
		public function set currentCard(value:Card):void 
		{
			_currentCard = value;
		}
		
		public function get bonus():Object 
		{
			return _bonus;
		}
		
		public function set bonus(value:Object):void 
		{
			_bonus = value;
		}
		
		public function get identifier():int 
		{
			return _identifier;
		}
		
		public function set identifier(value:int):void 
		{
			_identifier = value;
		}
		
	}

}