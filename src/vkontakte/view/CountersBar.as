package vkontakte.view 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.view.TextEdit;
	import flash.view.View;
	import vkontakte.button.CounterButton;
	import vkontakte.view.LoginButton;
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.view.CountersBar")]
	public class CountersBar extends View
	{
		public var _photos_btn:CounterButton;
		public var _friends_btn:CounterButton;
		
		public function CountersBar() 
		{
			super();
			
			_photos_btn._label.text = "МОИ ФОТО";
			_friends_btn._label.text = "МОИ ДРУЗЬЯ";
		}
		
	}

}