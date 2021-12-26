package common.view 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import common.edit.PhotoCaptionTextEdit;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.DisplayUtils;
	import flash.view.ImageView;
	import flash.view.View;
	import flashpress.touch.TouchEvent;
	import flashpress.touch.TouchManager;
	import flashpress.touch.TouchPhases;
	import flash.view.events.ItemEvent;

	[Embed(source="../../../lib/assets.swf", symbol="common.view.PhotoView")]
	public class PhotoView extends ImageView
	{
		
		public var _bakgraund:MovieClip;
		public var _mask:MovieClip;
		public var _content:MovieClip;
		public var _date_txt:TextField;
		public var _location_txt:TextField;
		public var _caption_edit:PhotoCaptionTextEdit;
		public var _location_ico:MovieClip;
		public var _rotation:Number;	
		
		private var _polaroid:Boolean;
		
		public function PhotoView() 
		{
			super();
	
			_rotation = 0;
			_polaroid = true;
			
			TouchManager.register(this);
			handler.addEventListener(TouchEvent.UP, onTouchVertical);
			handler.addEventListener(TouchEvent.DOWN, onTouchVertical);	
			handler.addEventListener(TouchEvent.LEFT, onTouchHorizontal);
			handler.addEventListener(TouchEvent.RIGHT, onTouchHorizontal);
			
			_caption_edit.setHintTextColor(0xCCCCCC);
		}
		
		public function canScrollVertically(direction:int):Boolean
		{
			return content.height > 0 ? ((direction < 0) ? Math.floor(content.y) > 0 : (Math.floor(content.y + content.height) > Math.floor(getClipBounds().height))) : false;
		}		
		
		private function onTouchHorizontal(e:TouchEvent):void
		{
			var newPos:Number = content.x + e.touchData.shift;

			switch (e.touchData.phase)
			{
				case TouchPhases.BEGIN:
					break;
				case TouchPhases.UPDATE:
				case TouchPhases.END:
					var rect:Rectangle = getHitRect();
					if ((newPos < rect.left + getPaddingLeft()) && (newPos + content.width > rect.right - getPaddingRight()))
					{
						content.x = newPos;
					}
					break;
			}
		}		
		
		private function onTouchVertical(e:TouchEvent):void
		{
			var newPos:Number = content.y + e.touchData.shift;

			switch (e.touchData.phase)
			{
				case TouchPhases.BEGIN:
					break;
				case TouchPhases.UPDATE:
				case TouchPhases.END:
					var rect:Rectangle = getHitRect();
					if ((newPos < rect.top + getPaddingTop()) && (newPos + content.height > rect.bottom - getPaddingBottom()))
					{
						content.y = newPos;
					}
					break;
			}
		}
		
		public function get polaroid():Boolean
		{
			return _polaroid;
		}
		
		public function set polaroid(value:Boolean):void
		{
			if (value) setPadding(30, 30, 30, 260); else setPadding(30, 30, 30, 30);
			
			_polaroid = value;
			
			var o:BitmapData = getBitmapData(true);
			
			var bounds:Rectangle = getLocalVisibleRect();
			bounds.top += getPaddingTop();
			bounds.bottom -= getPaddingBottom();
			bounds.left += getPaddingLeft();
			bounds.right -= getPaddingRight();
			
			_rotation = bounds.width >= bounds.height ? 0 : (o.width > o.height ? 90 : 0);
			
			var rW:Number = 0;
			var rH:Number = 0;			
			
			switch (_rotation)
			{
				case 0:
				case 180:
					rW = o.width;
					rH = o.height;
					break;
				case 90:
				case 270:
					rW = o.height;
					rH = o.width;
					break;
			}

			var sX : Number = bounds.width / rW;
			var sY : Number = bounds.height / rH;
	
			var rD : Number = rW / rH;
			var rR : Number = bounds.width / bounds.height;
	
			var s: Number = rD >= rR ? sY : sX;
	
			var matrix:Matrix = new Matrix();
			matrix.translate(-o.width / 2, -o.height / 2);	
			matrix.rotate(_rotation * (Math.PI / 180));
			matrix.scale(s, s);	
			matrix.translate(rW * s / 2, rH * s / 2);	
	
			var img:BitmapData = new BitmapData(rW * s, rH * s, false, 0xFF0000);
			img.draw(o, matrix);
	
			setContentView(new Bitmap(img));				
			content.x = bounds.left + ((bounds.width - content.width) / 2);
			content.y = bounds.top + ((bounds.height - content.height) / 2);
			
			_mask.removeChildren();
			_mask.x = 0;
			_mask.y = 0;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xFFFFFF, 1)
			_mask.graphics.drawRect(bounds.left, bounds.top, bounds.width, bounds.height);
			_mask.graphics.endFill();
		}		
	}
}