package vkontakte.view 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.text.TextField;
	import flash.view.TextEdit;
	import flash.view.View;
	import vkontakte.view.LoginButton;
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.view.LoginPrompt")]
	public class LoginPrompt extends View
	{
		public var _login_btn:LoginButton;
		
		public function LoginPrompt() 
		{
			super();
		}
		
	}

}