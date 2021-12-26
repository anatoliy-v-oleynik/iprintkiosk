package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.PayButton")]
	public class PayButton extends Button
	{
		public function PayButton() 
		{
			super();
		}
	}

}