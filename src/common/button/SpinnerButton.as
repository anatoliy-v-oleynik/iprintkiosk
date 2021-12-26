package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.SpinnerButton")]
	public class SpinnerButton extends Button
	{
		public function SpinnerButton() 
		{
			super();
		}
	}

}