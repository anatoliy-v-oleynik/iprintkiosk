package common.view 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import common.button.OrderItemAddViewButton;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.view.ImageView;
	import flash.view.View;
	

	[Embed(source="../../../lib/assets.swf", symbol="common.view.OrderItemAddView")]
	public class OrderItemAddView extends View
	{
		public var _add_btn:OrderItemAddViewButton;
		
		public function OrderItemAddView() 
		{
			super();
		}
	}

}