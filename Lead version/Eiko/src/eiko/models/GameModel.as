package eiko.models 
{
	import eiko.models.game.Card;
	import eiko.models.game.GameStats;
	import eiko.models.game.Generation;
	import eiko.models.game.Pattern;
	import eiko.models.game.Player;
	import eiko.utils.Math2;
	import starling.core.Starling;
	/**
	 * ...
	 * @author ...
	 */
	public class GameModel 
	{
		private var _generations:Object;
		private var _cards:Object;
		private var _selfPlayer:Player;
		private var _otherPlayer:Player;
		
		private var _stats:GameStats;
		
		public static var CARD_WIDTH:int = 355;
		public static var DEBUG:Boolean = false;
		
		public var round:int = 1;
		
		public function GameModel() 
		{
			generations = new Object();
			cards = new Object();
			
			selfPlayer = new Player();
			otherPlayer = new Player();
			
			stats = new GameStats();
			
			cards["1950"] = {
				1: { image : 'Cards/1950/billes.jpg', color: 0x087a7b},
				2: {image : 'Cards/1950/toupie.jpg', color: 0x325b89},
				3: {image : 'Cards/1950/montre-gousset.jpg', color: 0x123123 },
				4: {image : 'Cards/1950/bilboquet.jpg', color: 0x54898d},
				5: {image : 'Cards/1950/television.jpg', color: 0x0c6782},
				length: 5
			};
			
			cards["1970"] = {
				1: {image : 'Cards/1970/flipper.jpg', color: 0xc16186},
				2: {image : 'Cards/1970/citroen-ds.jpg', color: 0x8d496e},
				3: {image : 'Cards/1970/kiki.jpg', color: 0x4a364f},
				4: {image : 'Cards/1970/telephone.jpg', color: 0xaa5a75},
				5: {image : 'Cards/1970/polaroid.jpg', color: 0x7b497e},
				length: 5
			};
			
			cards["1990"] = {
				1: {image : 'Cards/1990/gameboy.jpg', color: 0xb0272f},
				2: {image : 'Cards/1990/cassette-vhs.jpg', color: 0xdc8236},
				3: {image : 'Cards/1990/hippo.jpg', color: 0xd2922e},
				4: {image : 'Cards/1990/flikflak.jpg', color: 0xe86a30},
				5: {image : 'Cards/1990/tamagochi.jpg', color: 0xaa3b28 },
				length: 5
			};
						
			generations["1950"] = new Generation("1950", cards["1950"], Pattern.T_LEFT, 0x325968);
			generations["1970"] = new Generation("1970", cards["1970"], Pattern.T_CENTER, 0x804980);
			generations["1990"] = new Generation("1990", cards["1990"], Pattern.T_RIGHT, 0x992B1A);
			
			// TODO
			if (GameModel.DEBUG)
			{
				selfPlayer.generation = "1970";
				otherPlayer.generation = "1950";
				selfPlayer.currentCard = generations[selfPlayer.generation].cards["telephone"];
				otherPlayer.currentCard = generations[otherPlayer.generation].cards["television"];
				selfPlayer.currentCard.value = 5;
				otherPlayer.currentCard.value = 2;
				//selfPlayer.currentCard.color = 0xBD432F;
				//otherPlayer.currentCard.color = 0x739298;
			}
		}
		
		public function generation(year:String):Generation
		{
			if (generations[year]) return generations[year];
			else return null;
		}
		
		public function playerGeneration(player:Player):Generation
		{
			return generations[player.generation];
		}
		
		public function playerCards(player:Player):Object
		{
			return generation(player.generation).cards;
		}
		
		public function generationByPattern(pattern:Pattern):String
		{
			var generation:String = null;
			switch(pattern.generation)
			{
				case Pattern.T_LEFT:
					generation = "1950";
					break;
				case Pattern.T_CENTER:
					generation = "1970";
					break;
				case Pattern.T_RIGHT:
					generation = "1990";
					break;
					
			}
			return generation;
		}
		
		// TODO
		// DEBUG function, returns a random card
		public function cardDebug():Card
		{
			var cards:Object = generations[selfPlayer.generation].cards;
			var cpt:int = 0;
			for (var name:String in cards)
			{
				if (cpt++ == (round - 1)) return cards[name];
			}
			return null;
		}
		
		public function cardByPattern(pattern:Pattern, generation:String = null):Card
		{
			if (generation === null)
			{
				generation = generationByPattern(pattern);
			}
			var cards:Object = generations[generation].cards;
			var card:Card = null;
			for (var name:String in cards)
			{
				if (Math2.compare(cards[name].pattern.cards, pattern.cards)) card = cards[name];
			}
			return card;
		}
		
		public function setPlayerCards(player:Player, cards:Object):void
		{
			for (var name:String in cards)
			{
				generation(player.generation).cards[name].value = cards[name];
			}
		}
		
		public function get generations():Object 
		{
			return _generations;
		}
		
		public function set generations(value:Object):void 
		{
			_generations = value;
		}
		
		public function get selfPlayer():Player 
		{
			return _selfPlayer;
		}
		
		public function set selfPlayer(value:Player):void 
		{
			_selfPlayer = value;
		}
		
		public function get otherPlayer():Player 
		{
			return _otherPlayer;
		}
		
		public function set otherPlayer(value:Player):void 
		{
			_otherPlayer = value;
		}
		
		public function get cards():Object 
		{
			return _cards;
		}
		
		public function set cards(value:Object):void 
		{
			_cards = value;
		}
		
		public function get stats():GameStats 
		{
			return _stats;
		}
		
		public function set stats(value:GameStats):void 
		{
			_stats = value;
		}
	}

}