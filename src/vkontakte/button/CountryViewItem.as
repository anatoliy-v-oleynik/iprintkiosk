package vkontakte.button 
{
	import flash.text.TextField;
	import flash.utils.AttributeSet;
	import flash.widget.Button;
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.button.CountryViewItem")]
	public class CountryViewItem extends Button
	{
		public function CountryViewItem() 
		{
			super({ textHorizontalAlign:"left", textVerticalAlign:"center" });
		}
	}

}