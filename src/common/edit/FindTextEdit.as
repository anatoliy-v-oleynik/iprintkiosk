package common.edit 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.text.TextField;
	import flash.view.TextEdit;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.edit.FindTextEdit")]
	public class FindTextEdit extends TextEdit
	{
		public function FindTextEdit() 
		{
			super();
		}
		
	}

}