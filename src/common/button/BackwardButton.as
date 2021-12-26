package common.button 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.BackwardButton")]
	public class BackwardButton extends Button
	{
		public function BackwardButton() 
		{
			super();
		}
		
	}

}