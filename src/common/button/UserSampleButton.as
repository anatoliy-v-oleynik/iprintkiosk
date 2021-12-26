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
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.UserSampleButton")]
	public class UserSampleButton extends ImageButton
	{
		public var _content:MovieClip;
		
		public var _full_name_txt:TextField;
		public var _user_name_txt:TextField;
		
		public function UserSampleButton() 
		{
			super();
		}
	}

}