package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.view.ImageView;
	import flash.view.View;
	import flash.widget.Button;
	
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.OrderItemAddViewButton")]
	public class OrderItemAddViewButton extends Button
	{
		public function OrderItemAddViewButton() 
		{
			super();
		}
	}

}