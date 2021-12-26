package common.view 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.view.ImageView;
	import flash.view.View;
	

	[Embed(source="../../../lib/assets.swf", symbol="common.view.OrderItemPhotoPreview")]
	public class OrderItemPhotoPreview extends ImageView
	{
		public var _content:MovieClip;
		
		public function OrderItemPhotoPreview() 
		{
			super();
		}
	}

}