package common.button 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.LoginButton")]
	public class LoginButton extends Button
	{
		public function LoginButton() 
		{
			super();
		}
		
	}

}