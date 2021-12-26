package common.edit 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.text.TextField;
	import flash.view.TextEdit;
	import flash.view.View;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.edit.PhotoCaptionTextEdit")]
	public class PhotoCaptionTextEdit extends TextEdit
	{
		public function PhotoCaptionTextEdit() 
		{
			super();
		}
		
		
		protected override function onFocusChanged(gainFocus:Boolean, relatedFocus:View):void
		{
			super.onFocusChanged(gainFocus, relatedFocus);
			
			if (gainFocus)
			{
				(content as TextField).border = true;
				(content as TextField).borderColor = 0xD2D2D2
			}
			else
			{
				(content as TextField).border = false;
			}
		}
	}

}