package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.PrintButton")]
	public class PrintButton extends Button
	{
		public function PrintButton() 
		{
			super();
		}
	}

}