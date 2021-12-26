package vkontakte.button 
{
	import flash.text.TextField;
	import flash.utils.AttributeSet;
	import flash.widget.Button;
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.button.CityViewItem")]
	public class CityViewItem extends Button
	{
		public var _region_txt:TextField;
		
		public function CityViewItem() 
		{
			super({ textHorizontalAlign:"left", textVerticalAlign:"none" });
		}
	}

}