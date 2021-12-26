package vkontakte.edit 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.text.TextField;
	import flash.view.TextEdit;
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.edit.PasswordTextEdit")]
	public class PasswordTextEdit extends TextEdit
	{
		public function PasswordTextEdit() 
		{
			super();
		}
		
	}

}