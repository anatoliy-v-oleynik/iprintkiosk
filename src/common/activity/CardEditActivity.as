package common.activity 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;	 
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.motionPaths.RectanglePath2D;
	import common.button.BackwardButton;
	import common.button.CaptionShowButton;
	import common.button.DateShowButton;
	import common.button.DecButton;
	import common.button.IncButton;
	import common.button.LocationShowButton;
	import common.button.MaxPhotoButton;
	import common.button.OkeyButton;
	import common.dialogs.WaitDialog;
	import common.view.CardView;
	import flash.app.Activity;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.LocaleID;
	import flash.globalization.DateTimeStyle;
	import flash.text.TextField;
	import flash.system.Capabilities;
	import flash.utils.DisplayUtils;
	import flash.widget.ImageButton;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.activity.CardEditActivity")]
	public class CardEditActivity extends Activity
	{
		public var _backward_btn:BackwardButton;
		public var _preview:CardView;
		public var _count_txt:TextField;
		public var _dec_count_btn:DecButton;
		public var _inc_count_btn:IncButton;
		public var _okey_btn:OkeyButton;
		
		private var queue:LoaderMax;
		private var backgraund:BitmapData;
		
		public function CardEditActivity() 
		{
			super();
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
			
			_okey_btn.addEventListener("onClick", onClick);
			_backward_btn.addEventListener("onClick", onClick);
			_dec_count_btn.addEventListener("onClick", onClick);
			_inc_count_btn.addEventListener("onClick", onClick);
			
			_preview._bakgraund.removeChildren();
			_preview._bakgraund.graphics.clear();
			_preview._bakgraund.graphics.beginBitmapFill(DisplayUtils.getResampledBitmapData((attributes["photo"] as Bitmap).bitmapData, 667.5, 890));
			_preview._bakgraund.graphics.drawRect(0, 0, 667.5, 890);
			_preview._bakgraund.graphics.endFill();				
			_preview._content.removeChildren();
			
			//_preview.setPadding(0, 0, 0, 0);
			//_preview.setSize(667.5, 890);
			//_preview.setScaleType("fitCenter");
			//_preview.setImageBitmap(new Bitmap(DisplayUtils.getResampledBitmapData(attributes["photo"], 680, 890)));
		}		
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);
			
			Container.current.NotifyUserActivity("Страница редактироваиня открытки.");
			
			Container.current.log.info("Переход на страницу просмотра открытки." , "common.activity.CardEditActivity");
		}		
		
		protected function onClick(e:Event):void
		{
			switch (e.target.name)
			{
				case "_inc_count_btn":
					if (parseInt(_count_txt.text) < 9) _count_txt.text = (parseInt(_count_txt.text)+1).toString();
					break;
				case "_dec_count_btn":
					if (parseInt(_count_txt.text) > 1) _count_txt.text = (parseInt(_count_txt.text)-1).toString();
					break;					
				case "_backward_btn":
					Activity.current.backward();
					break;
				case "_okey_btn" :
					attributes["item"] = 
					{
						preview: _preview,
						bitmap: DisplayUtils.getResampledBitmapData((attributes["photo"] as Bitmap).bitmapData, 74.7 * 300 / 25.4, 101.6 * 300 / 25.4),
						photo: null,
						price : attributes["price"],
						count: int(_count_txt.text)
					}
					
					Order.current.addItem( attributes["item"] );
				
					Activity.current.backward();					
					
					break;
			}
		}
		
	}

}