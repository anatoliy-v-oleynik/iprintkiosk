package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.display.MovieClip;
	import flash.widget.Button;
	import flash.widget.ImageButton;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.MediaSampleButton")]
	public class MediaSampleButton extends ImageButton
	{
		public var _content:MovieClip;
		
		public function MediaSampleButton() 
		{
			super();
		}
	}

}