package eiko.models 
{
	import eiko.models.game.Card;
	import eiko.models.game.Generation;
	import eiko.models.game.Pattern;
	import eiko.models.game.Player;
	import eiko.screens.utils.ImagesLoader;
	import starling.core.Starling;
	/**
	 * ...
	 * @author ...
	 */
	public class GameModel 
	{
		private var _generations:Object;
		private var _cards:Object;
		private var _players:Vector.<Player>;
		
		public function GameModel() 
		{
			generations = new Object();
			cards = new Object();
			
			players = new Vector.<Player>(2, true);
			players[0] = new Player();
			players[1] = new Player();
			
			cards["1950"] = {
				1: 'Cards/1950/billes.jpg',
				2: 'Cards/1950/montre-gousset.jpg',
				3: 'Cards/1950/bilboquet.jpg',
				4: 'Cards/1950/toupie.jpg',
				5: 'Cards/1950/telephone.jpg'
			};
			
			cards["1970"] = {
				1: 'Cards/1970/flipper.jpg',
				2: 'Cards/1970/citroen-ds.jpg',
				3: 'Cards/1970/kiki.jpg',
				4: 'Cards/1970/television.jpg',
				5: 'Cards/1970/polaroid.jpg'
			};
			
			cards["1990"] = {
				1: 'Cards/1990/gameboy.jpg',
				2: 'Cards/1990/citroen-ds.jpg',
				3: 'Cards/1990/hippo.jpg',
				4: 'Cards/1990/flikflak.jpg',
				5: 'Cards/1990/tamagochi.jpg'
			};
			
			generations["1950"] = new Generation("1950", cards["1950"], Pattern.LEFT);
			generations["1970"] = new Generation("1970", cards["1970"], Pattern.CENTER);
			generations["1990"] = new Generation("1990", cards["1990"], Pattern.RIGHT);
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
		
		public function setPlayerCards(player:Player, cards:Object):void
		{
			for (var name:String in cards)
			{
				generation(player.generation).cards[name].value = cards[name].value;
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
		
		public function get cards():Object 
		{
			return _cards;
		}
		
		public function set cards(value:Object):void 
		{
			_cards = value;
		}
		
		public function get players():Vector.<Player> 
		{
			return _players;
		}
		
		public function set players(value:Vector.<Player>):void 
		{
			_players = value;
		}
	}

}