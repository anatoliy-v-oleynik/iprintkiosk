package common.view 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import common.button.ItemDeleteButton;
	import common.button.ItemEditButton;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.view.ImageView;
	import flash.view.View;
	

	[Embed(source="../../../lib/assets.swf", symbol="common.view.CardItemView")]
	public class CardItemView extends View
	{
		public var _preview:OrderItemPhotoPreview;
		
		public function CardItemView() 
		{
			super();
		}
	}

}