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
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.TagSampleButton")]
	public class TagSampleButton extends ImageButton
	{
		public var _content:MovieClip;
		public var _tag_name_txt:TextField;
		public var _media_count_txt:TextField;
		
		public function TagSampleButton() 
		{
			super();
		}
	}

}