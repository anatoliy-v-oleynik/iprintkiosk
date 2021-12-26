package common.view 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.view.ImageView;
	import flash.view.View;
	import flashpress.touch.TouchEvent;
	import flashpress.touch.TouchManager;
	import flashpress.touch.TouchPhases;
	import flash.view.events.ItemEvent;

	[Embed(source="../../../lib/assets.swf", symbol="common.view.CardView")]
	public class CardView extends ImageView
	{
		
		public var _bakgraund:MovieClip;
		public var _mask:MovieClip;
		public var _content:MovieClip;
		
		public function CardView() 
		{
			super();
		}
	
	}
}