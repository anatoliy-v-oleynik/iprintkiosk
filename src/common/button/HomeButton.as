package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.HomeButton")]
	public class HomeButton extends Button
	{
		public function HomeButton() 
		{
			super();
		}
	}

}