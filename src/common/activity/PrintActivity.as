package common.activity 
{
	import com.greensock.*;
	import common.view.OrderItemPhotoPreview;
	import flash.app.Activity;
	import flash.content.Context;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.getTimer;
	import flash.view.View;
	import flash.widget.Button;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	[Embed(source="../../../lib/assets.swf", symbol="common.activity.PrintActivity")]
	public class PrintActivity extends Activity
	{
		public var _photo_left:OrderItemPhotoPreview;
		public var _photo_right:OrderItemPhotoPreview;
		public var _process:MovieClip;
		public var _title_txt:TextField;
		public var _info_txt:TextField;
		
		public function PrintActivity() 
		{
			super();
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
			
			_photo_left.alpha = 0;
			_photo_right.alpha = 0;
			_process.visible = false;
			
			Order.current.addEventListener("onProcessComplete", onProcessComplete );
			Order.current.addEventListener("onPrintComplete", onPrintComplete );
			Order.current.addEventListener("onPhotoPrinted", onPhotoPrinted );
			
			setTimeout(Order.current.process, 1000);
		}
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);
			
			Container.current.NotifyUserActivity("Обработка и печать фотографии.");
			
			mouseEnabled = false;
			mouseChildren = false;
			
		}
		
		protected function onProcessComplete(e:Event):void
		{
			if (Activity.current) Activity.current.attributes["lastActive"] = new Date();
			
			Order.current.removeEventListener("onProcessComplete", arguments.callee);
			
			_process.visible = true;
			_info_txt.text = "(: Печатаем Ваши фотографии :)";
			
			if (Order.current.pool.length > 0)
			{
				_photo_left.setScaleType("centerCrop");
				_photo_left.setImageBitmap(Order.current.pool[0].photo_left);
						
				_photo_right.setScaleType("centerCrop");
				_photo_right.setImageBitmap(Order.current.pool[0].photo_right);
						
				new TimelineLite({tweens:[TweenLite.fromTo(_photo_right, 2, {alpha:0}, {alpha:1}) , TweenLite.fromTo(_photo_left, 2, {alpha:0}, {alpha:1})  ], align:TweenAlign.START, onComplete:function():void { Order.current.print(); } });
			}			
			
			//TweenLite.to(_process, 1,
			//{
				//y:1560,
				//scaleX:0.5,
				//scaleY:0.5,
				//onComplete:
				//function():void
				//{
					//if (Order.current.pool.length > 0)
					//{
						//_photo_left.setScaleType("centerCrop");
						//_photo_left.setImageBitmap(Order.current.pool[0].photo_left);
						//
						//_photo_right.setScaleType("centerCrop");
						//_photo_right.setImageBitmap(Order.current.pool[0].photo_right);
						//
						//new TimelineLite({tweens:[TweenLite.fromTo(_photo_right, 2, {alpha:0}, {alpha:1}) , TweenLite.fromTo(_photo_left, 2, {alpha:0}, {alpha:1})  ], align:TweenAlign.START, onComplete:function():void { Order.current.print(); } });
					//}
				//}
			//});
		}
		
		protected function onPhotoPrinted(e:Event):void
		{
			if (Activity.current) Activity.current.attributes["lastActive"] = new Date();
			
			new TimelineLite({tweens:[TweenLite.fromTo(_photo_left, 1, {x:230, alpha:1}, {x: -680, alpha:0} ) , TweenLite.fromTo(_photo_right, 1, {x:560, alpha:1}, {x: -350, alpha:0})], align:TweenAlign.START,
			onComplete:function():void
			{
				if (Order.current.pool.length > 0)
				{
					_photo_left.setScaleType("centerCrop");
					_photo_left.setImageBitmap(Order.current.pool[0].photo_left);
						
					_photo_right.setScaleType("centerCrop");
					_photo_right.setImageBitmap(Order.current.pool[0].photo_right);					
					
					new TimelineLite({tweens:[TweenLite.fromTo(_photo_left, 1, {x:1140, alpha:0}, {x: 230, alpha:1} ) , TweenLite.fromTo(_photo_right, 1, {x:1470, alpha:0}, {x: 560, alpha:1})], align:TweenAlign.START, onComplete:function():void { } });
				}
			} });

		}
		
		protected function onPrintComplete(e:Event):void
		{
			if (Activity.current) Activity.current.attributes["lastActive"] = new Date();
			
			Container.current.NotifyUserActivity("Фотографии напечатаны.");
			
			_title_txt.text = "Печать фотографий завершена...";
			_info_txt.text = "Незабудьте забрать свои фотографии.";
			_process.visible = false;
			
			mouseEnabled = true;
			mouseChildren = true;		
			
			setTimeout(function ():void { startActivity(Activity.list[0]); }, 20000);
			
			
		}
	}
}