package vkontakte.edit 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.text.TextField;
	import flash.view.TextEdit;
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.edit.FindTextEdit")]
	public class FindTextEdit extends TextEdit
	{
		public function FindTextEdit() 
		{
			super();
			attributes["requireLang"] = "RU";
			
		}
	}
}