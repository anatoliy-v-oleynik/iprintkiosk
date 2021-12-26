package common.edit 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.text.TextField;
	import flash.view.TextEdit;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.edit.TextEdit")]
	public class TextEdit extends flash.view.TextEdit
	{
		public function TextEdit() 
		{
			super();
		}
		
	}

}