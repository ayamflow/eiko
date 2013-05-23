package eiko.screens.minigames.pong 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author ...
	 */
	public class Impact extends Image
	{	
		public function Impact(texture:Texture) 
		{
			super(texture);
			this.pivotX = texture.width >> 1;
			this.pivotY = texture.height >> 1;
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			TweenMax.to(this, 0.8, { alpha: 0, ease: Cubic.easeIn, delay: 0.2, onComplete: removeImpact } );
		}
		
		private function removeImpact():void 
		{
			dispatchEventWith("removeImpact");
		}
		
	}

}