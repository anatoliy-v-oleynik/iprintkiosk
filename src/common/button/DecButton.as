package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.DecButton")]
	public class DecButton extends Button
	{
		public function DecButton() 
		{
			super();
		}
	}

}