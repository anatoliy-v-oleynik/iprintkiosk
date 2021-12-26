package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.FindButton")]
	public class FindButton extends Button
	{
		public function FindButton() 
		{
			super();
		}
	}

}