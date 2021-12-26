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
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.view.UserPrompt")]
	public class UserPrompt extends View
	{

		public function UserPrompt() 
		{
			super();
		}
		
	}

}