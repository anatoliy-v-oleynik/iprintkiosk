package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.IncButton")]
	public class IncButton extends Button
	{
		public function IncButton() 
		{
			super();
		}
	}

}