package vkontakte.edit 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.text.TextField;
	import flash.view.TextEdit;
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.edit.UsernameTextEdit")]
	public class UsernameTextEdit extends TextEdit
	{
		public function UsernameTextEdit() 
		{
			super();
		}
		
	}

}