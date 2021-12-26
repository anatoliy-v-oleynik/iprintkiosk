package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.ClearButton")]
	public class ClearButton extends Button
	{
		public function ClearButton() 
		{
			super();
		}
	}

}