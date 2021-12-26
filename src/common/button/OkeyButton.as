package common.button 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.OkeyButton")]
	public class OkeyButton extends Button
	{
		public function OkeyButton() 
		{
			super();
		}
		
	}

}