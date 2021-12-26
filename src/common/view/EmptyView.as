package common.view 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.view.TextEdit;
	import flash.view.View;
	import vkontakte.view.LoginButton;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.view.EmptyView")]
	public class EmptyView extends View
	{
		public function EmptyView() 
		{
			super();
		}
	}

}