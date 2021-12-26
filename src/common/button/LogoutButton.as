package common.button 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.LogoutButton")]
	public class LogoutButton extends Button
	{
		public function LogoutButton() 
		{
			super();
		}
		
	}

}