package eiko.screens 
{
	import starling.core.Starling;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Florian Morel
	 */
	public class Error extends Screen 
	{
		private var error:TextField;
		public function Error() 
		{
			//super();
		}
		
		protected override function added():void
		{
			alpha = 1;
			error = new TextField(Starling.current.stage.stageWidth, Starling.current.stage.stageWidth, options.error.text);
			addChild(error);
		}
		
	}

}