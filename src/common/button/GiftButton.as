package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.GiftButton")]
	public class GiftButton extends Button
	{
		public function GiftButton() 
		{
			super();
		}
	}

}