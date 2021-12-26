package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.widget.Button;
	import flash.widget.ImageButton;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.ImageSampleButton")]
	public class ImageSampleButton extends ImageButton
	{
		public var _content:MovieClip;
		
		public function ImageSampleButton() 
		{
			super();
		}
	}

}