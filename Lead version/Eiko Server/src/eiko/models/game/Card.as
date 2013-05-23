package eiko.models.game 
{
	import eiko.screens.utils.ImagesLoader;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Card extends Sprite 
	{
		private var _name:String;
		private var _value:int;
		private var _generation:String;
		public var image:Image; // DEBUG PUBLIC
		private var url:String;
		public var used:Boolean = false;
		private var _pattern:Pattern;
		private var loader:ImagesLoader;
		
		public function Card(nam:String, gene:String, img:Image, patt:Pattern) 
		//public function Card(nam:String, gene:String, img:String, patt:Pattern) 
		{
			name = nam;
			generation = gene;
			image = img;
			pattern = patt;
			value = NaN;
			
			addChild(image);
		}
		
		public function get generation():String 
		{
			return _generation;
		}
		
		public function set generation(value:String):void 
		{
			_generation = value;
		}
		
		public function get value():int 
		{
			return _value;
		}
		
		public function set value(value:int):void 
		{
			_value = value;
		}
		
		public function get pattern():Pattern 
		{
			return _pattern;
		}
		
		public function set pattern(value:Pattern):void 
		{
			_pattern = value;
		}
		
		public override function get name():String 
		{
			return _name;
		}
		
		public override function set name(value:String):void 
		{
			_name = value;
		}
	}

}