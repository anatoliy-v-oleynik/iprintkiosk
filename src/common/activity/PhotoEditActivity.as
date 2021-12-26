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
	import common.view.PhotoView;
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
	
	[Embed(source="../../../lib/assets.swf", symbol="common.activity.PhotoEditActivity")]
	public class PhotoEditActivity extends Activity
	{
		public var _backward_btn:BackwardButton;
		public var _preview:PhotoView;
		public var _captionshow_btn:CaptionShowButton;
		public var _dateshow_btn:DateShowButton;
		public var _locationshow_btn:LocationShowButton;
		public var _count_txt:TextField;
		public var _dec_count_btn:DecButton;
		public var _inc_count_btn:IncButton;
		public var _okey_btn:OkeyButton;
		public var _stretch_btn:MaxPhotoButton;
		
		private var queue:LoaderMax;
		private var texture:BitmapData;
		
		public function PhotoEditActivity() 
		{
			super();
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
			
			LoaderMax.activate([ImageLoader, SWFLoader, DataLoader]); 
			queue = new LoaderMax();
			queue.autoLoad = true;
			
			_okey_btn.addEventListener("onClick", onClick);
			_backward_btn.addEventListener("onClick", onClick);
			_dateshow_btn.addEventListener("onClick", onClick);
			_locationshow_btn.addEventListener("onClick", onClick);
			_captionshow_btn.addEventListener("onClick", onClick);
			_dec_count_btn.addEventListener("onClick", onClick);
			_inc_count_btn.addEventListener("onClick", onClick);
			_stretch_btn.addEventListener("onClick", onClick);
			_stretch_btn.visible = false;
			
			if (attributes["photo"] != null)
			{
				if (attributes["photo"].date)
				{
					var df:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT, DateTimeStyle.SHORT, DateTimeStyle.NONE);
					_preview._date_txt.text = df.format(new Date(Number(attributes["photo"].date) * 1000));
					_dateshow_btn.visible = true;
				}
				else
				{
					_dateshow_btn.visible = false;
				}

				if (attributes["photo"].location)
				{
					_preview._location_txt.text = attributes["photo"].location;
					_preview._location_txt.visible = true;
					_preview._location_txt.x = _preview._date_txt.visible ? 204 : 56;
					_preview._location_ico.visible = true;
					_preview._location_ico.x = _preview._date_txt.visible ? 178 : 30;
					_locationshow_btn.alpha = _preview._location_txt.visible ? 1.0:0.5;
					_locationshow_btn.visible = true;
				}
				else
				{
					_preview._location_txt.visible = false;
					_preview._location_txt.x = _preview._date_txt.visible ? 204 : 56;
					_preview._location_ico.visible = false;
					_preview._location_ico.x = _preview._date_txt.visible ? 178 : 30;
					_locationshow_btn.alpha = _preview._location_txt.visible ? 1.0 : 0.5;
					_locationshow_btn.visible = false;
				}

				if (attributes["photo"].caption)
				{
					_preview._caption_edit.setText(attributes["photo"].caption);
					_preview._caption_edit.setLocation(_preview._caption_edit.getX(), _preview._date_txt.visible || _preview._location_txt.visible ? 704:664);
					_preview._caption_edit.setSize(_preview._caption_edit.getWidth(), _preview._date_txt.visible || _preview._location_txt.visible ? 175:215);
				}
				else
				{
					_preview._caption_edit.visible = false;
					_preview._caption_edit.clearText();
					_preview._caption_edit.setLocation(_preview._caption_edit.getX(), _preview._date_txt.visible || _preview._location_txt.visible ? 704:664);
					_preview._caption_edit.setSize(_preview._caption_edit.getWidth(), _preview._date_txt.visible || _preview._location_txt.visible ? 175:215);					
					_captionshow_btn.alpha = _preview._caption_edit.visible ? 1.0:0.5;
				}

				_okey_btn.visible = false;
				_preview.addEventListener("onLoadComplete", function (e:Event):void { closeDialog(); _okey_btn.visible = true; _stretch_btn.visible = true; } );
				_preview.addEventListener("onLoadError", function (e:Event):void { closeDialog(); _okey_btn.visible = false; _stretch_btn.visible = false; } );
				_preview.setScaleType("fitCenter");
			
				
				var loader:XMLLoader = new XMLLoader("./textures/~list.xml", { name:"xmlDoc", maxConnections:1, estimatedBytes:5000,
					onChildComplete:
						function (e:LoaderEvent):void
						{
							var imb:ImageButton = addChild(new ImageButton( { width:81, height:81 } )) as ImageButton;
							imb.name = e.target.name;
							imb.setImageBitmap(e.target.rawContent);
							imb.setLocation(e.target.vars.x, e.target.vars.y);
							imb.setTag(e.target.vars);
							imb.setOnClickListener(onClickTexture);
						},
					onComplete:
						function ():void
						{
							showDialog(new WaitDialog());
							
							trace(attributes["photo"].url);
							
							_preview.setImageURI(attributes["photo"].url );
							
						}
				});
					
				queue.append(loader);				
			}
			
			
		}		
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);
			
			Container.current.NotifyUserActivity("Страница редактирования фотографии.");
			
			Container.current.log.info("Переход на страницу редактирования фотографии." , "common.activity.PhotoEditActivity");
		}		
		
		protected function onClickTexture(e:Event):void
		{
			var loader:ImageLoader = new ImageLoader("textures/" + e.target.name, { name:e.target.name, maxConnections:1, estimatedBytes:5000, btn:e.target, onComplete:
				function (e:LoaderEvent):void
				{
					texture = e.target.rawContent.bitmapData;
					
					_preview._date_txt.visible = e.target.vars.btn.getTag().dateTextVisible == "false" ? false : true;
					_preview._caption_edit.setTextColor(e.target.vars.btn.getTag().captionTextColor);
					_preview._caption_edit.setHintTextColor(e.target.vars.btn.getTag().captionHintTextColor);
					_preview._caption_edit.visible = e.target.vars.btn.getTag().captionTextVisible == "false" ? false : true;
					_preview._bakgraund.removeChildren()
					_preview._bakgraund.graphics.clear();
					_preview._bakgraund.graphics.beginBitmapFill(DisplayUtils.getResampledBitmapData(texture, 680, 910));
					_preview._bakgraund.graphics.drawRect(0, 0, 680, 910);
					_preview._bakgraund.graphics.endFill();		
					
					_dateshow_btn.alpha = _preview._date_txt.visible ? 1.0:0.5;
					
					_preview._location_txt.visible = e.target.vars.btn.getTag().locationVisible == "false" ? false : true;
					_preview._location_ico.visible = e.target.vars.btn.getTag().locationVisible == "false" ? false : true;
					_locationshow_btn.alpha = _preview._location_txt.visible ? 1.0:0.5;
					_preview._location_txt.x = _preview._date_txt.visible ? 204 : 56;
					_preview._location_ico.x = _preview._date_txt.visible ? 178 : 30;					
					_captionshow_btn.alpha = _preview._caption_edit.visible ? 1.0:0.5;
					_preview._caption_edit.setLocation(_preview._caption_edit.getX(), _preview._date_txt.visible || _preview._location_txt.visible ? 704:664);
					_preview._caption_edit.setSize(_preview._caption_edit.getWidth(), _preview._date_txt.visible || _preview._location_txt.visible ? 175:215);					
				} });				
			queue.append(loader);
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
				case "_dateshow_btn" :
					_preview._date_txt.visible = ! _preview._date_txt.visible;
					_dateshow_btn.alpha = _preview._date_txt.visible ? 1.0:0.5;
					_preview._location_txt.x = _preview._date_txt.visible ? 204 : 56;
					_preview._location_ico.x = _preview._date_txt.visible ? 178 : 30;
					_preview._caption_edit.setLocation(_preview._caption_edit.getX(), _preview._date_txt.visible || _preview._location_txt.visible ? 704:664);
					_preview._caption_edit.setSize(_preview._caption_edit.getWidth(), _preview._date_txt.visible || _preview._location_txt.visible ? 175:215);
					break;
				case "_locationshow_btn" :
					_preview._location_txt.visible = ! _preview._location_txt.visible;
					_preview._location_txt.x = _preview._date_txt.visible ? 204 : 56;
					_preview._location_ico.visible = _preview._location_txt.visible;
					_preview._location_ico.x = _preview._date_txt.visible ? 178 : 30;
					_locationshow_btn.alpha = _preview._location_txt.visible ? 1.0:0.5;
					_preview._caption_edit.setLocation(_preview._caption_edit.getX(), _preview._date_txt.visible || _preview._location_txt.visible ? 704:664);
					_preview._caption_edit.setSize(_preview._caption_edit.getWidth(), _preview._date_txt.visible || _preview._location_txt.visible ? 175:215);
					break;
				case "_captionshow_btn" :
					_preview._caption_edit.visible = ! _preview._caption_edit.visible;
					_captionshow_btn.alpha = _preview._caption_edit.visible ? 1.0:0.5;
					_preview._caption_edit.setLocation(_preview._caption_edit.getX(), _preview._date_txt.visible || _preview._location_txt.visible ? 704:664);
					_preview._caption_edit.setSize(_preview._caption_edit.getWidth(), _preview._date_txt.visible || _preview._location_txt.visible ? 175:215);
					break;
				case "_okey_btn" :
				
					var hit:Rectangle = _preview.getHitRect();
					var image:BitmapData = _preview.getBitmapData();
					var xImageOffset:Number =  ((hit.left + _preview.getPaddingLeft()) - _preview.content.x) / (image.width / 100);
					var yImageOffset:Number =  ((hit.top + _preview.getPaddingTop()) - _preview.content.y) / (image.height / 100);
					
					attributes["item"] = 
					{
						preview: _preview,
						bitmap: DisplayUtils.getResampledBitmapData(texture ? texture : 0xFFFFFF, 74.7 * 300 / 25.4, 101.6 * 300 / 25.4),
						photo:
						{
							url : attributes["photo"].url,
							image_source : _preview.getBitmapData(true),
							image : null,
							imageOffsetX: -xImageOffset,
							imageOffsetY: -yImageOffset,
							date : _preview._date_txt.visible ? _preview._date_txt.text : null,
							location : _preview._location_txt.visible ? _preview._location_txt.text : null,
							caption : _preview._caption_edit.visible ? _preview._caption_edit.getText() : null,
							captionTextColor : _preview._caption_edit.getTextColor(),
							rotation:_preview._rotation,
							polaroid:_preview.polaroid
						},
						price : attributes["price"],
						count: int(_count_txt.text)
					}
					
					Order.current.addItem( attributes["item"] );
				
					Activity.current.backward();
					break;
				case "_stretch_btn":
					_preview.polaroid = !_preview.polaroid;
					break;					
			}
		}
		
	}

}