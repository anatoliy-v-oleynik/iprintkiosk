package 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import common.graphics.location_ico;
	import flash.app.Activity;
	import flash.content.Context;
	import flash.display.Bitmap;
	import flash.display.JPEGEncoderOptions;
	import flash.display.MovieClip;
	import flash.display.PNGEncoderOptions;
	import flash.events.DataEvent;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.view.TextView;
	import flash.events.EventDispatcher;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.IBitmapDrawable;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.Font;
	import flash.events.Event;
	import flash.utils.Base64;
	import flash.utils.ByteArray;
	import flash.utils.DisplayUtils;
	import flash.utils.setTimeout;
	import flash.utils.InterpolatedBitmapData;
	import flash.display.StageQuality;
	
	public final class Order extends EventDispatcher
	{
		public static var current:Order;
		
		{
			current = new Order();
		}
		
		public var pool:Array;
		private var mItems:Array;
		private var mTotalPrice:Number;
		private var mTotalCount:Number;
		private var so:SharedObject;
		
		public function Order()
		{
			super();
			
			mItems = new Array();
			mTotalPrice = 0;
			mTotalCount = 0;
			
			so = SharedObject.getLocal("order.current");
			if (!so.data.mDeposit)
			{
				so.data.mDeposit = 0;
				so.flush();
			}
		}
		
		public function get items():Array
		{
			return mItems;
		}		
		
		public function get totalPrice():Number
		{
			return mItems.length > 0 ? ((totalCount % 2 != 0) ? mTotalPrice + mItems[mItems.length - 1].price : mTotalPrice) : 0;
		}
		
		public function get totalCount():Number
		{
			return mTotalCount;
		}
		
		public function get deposit():Number
		{
			return so.data.mDeposit;
		}		
		
		public function get balance():Number
		{
			return deposit - totalPrice;
		}
		
		public function addItem(item:Object):void
		{
			Container.current.log.info("Добавлено в заказ " + item.count.toString() + " шт. - " + ((item.photo != null) ? item.photo.url : ""), "Order");
			
			mTotalPrice = mTotalPrice + (item.price ? item.price * item.count : 50 * item.count); 
			mTotalCount = mTotalCount + Number(item.count);
			mItems.push(item);
			
			dispatchEvent(new Event("onOrderChanged"));
			
			//var w : Number = (74.7 * 300 / 25.4) - (4.0 * 300 / 25.4 * 2); 76.2
			//var h : Number = (74.7 * 300 / 25.4) - (4.0 * 300 / 25.4 * 2); 101.6
			
			if (item.photo != null)
			{			
			
				var pw:Number = 149.4 * 300 / 25.4;							// ширина целой фотографии
				var ph:Number = 100 * 300 / 25.4;							// высота целой фотографии
				var pa:Number = 4.0 * 300 / 25.4;							// бордюрчик
				var sw:Number = pw / 2;										// ширина половинки фотографии
				var sh:Number = ph;											// высота половинки фотографии
				
				var vw:Number = sw - pa * 2;								// ширина области фотографии
				var vh:Number = item.photo.polaroid ? vw : sh - pa * 2;		// высота области фотографии
				var rw:Number = item.photo.rotation == 0 ? vw : vh;			// перевернутая ширина области фотографии
				var rh:Number = item.photo.rotation == 0 ? vh : vw;			// перевернутая высота области фотографии
				
				var sX : Number = rw / item.photo.image_source.width;
				var sY : Number = rh / item.photo.image_source.height;
							
				var rD : Number = item.photo.image_source.width / item.photo.image_source.height;
				var rR : Number = rw / rh;
							
				var s: Number = rD >= rR ? sY : sX;		
				
			
				trace("---");
				
				
				var process_image_func:Function = function (item:Object, scaleBmpd:BitmapData, tx:Number, ty:Number, segment:int = 0):void
				{
					if (scaleBmpd == null)
					{
						scaleBmpd = new BitmapData(item.photo.image_source.width * s, item.photo.image_source.height * s);
					}				
					
					if (segment < scaleBmpd.width)
					{
						var xImageFactor:Number = item.photo.image_source.width / scaleBmpd.width;
						var yImageFactor:Number = item.photo.image_source.height / scaleBmpd.height;
						
						var seg:Number = segment;
						
						for (var xPix:Number = seg; xPix <= scaleBmpd.width && xPix < seg + 300; xPix++)
						{
							for (var yPix:Number = 0; yPix < scaleBmpd.height; yPix++)
							{
								scaleBmpd.setPixel(xPix, yPix, InterpolatedBitmapData.getPixelBilinear(item.photo.image_source as BitmapData, xPix * xImageFactor, yPix * yImageFactor));
							}
							segment = xPix;
						}
						
						setTimeout(process_image_func, 100, item, scaleBmpd, tx, ty, segment);
					}
					else
					{
						item.photo.image = new BitmapData(vw, vh, true, 0x00000000);
						
						var matrix:Matrix = new Matrix();
						matrix.translate(-scaleBmpd.width / 2, -scaleBmpd.height / 2);	
						matrix.rotate(item.photo.rotation * (Math.PI / 180));
						matrix.translate(item.photo.rotation == 0 ? scaleBmpd.width / 2 : scaleBmpd.height / 2, item.photo.rotation == 0 ? scaleBmpd.height / 2 : scaleBmpd.width / 2);
						matrix.translate(item.photo.rotation == 0 ? scaleBmpd.width / 100 * tx : scaleBmpd.height / 100 * tx, item.photo.rotation == 0 ? scaleBmpd.height / 100 * ty : scaleBmpd.width / 100 * ty);
						
						//matrix.translate(scaleBmpd.width / 100 * tx, scaleBmpd.height / 100 * ty);
						
						item.photo.image.drawWithQuality(scaleBmpd, matrix, null, null, new Rectangle(0, 0, item.photo.image.width, item.photo.image.height), false, StageQuality.LOW  );
					}
				}
			
				process_image_func(item, null, item.photo.imageOffsetX, item.photo.imageOffsetY, 0);
			}
		}
		
		public function removeItem(item:Object, count:int = 1):void
		{
			var index:int = mItems.indexOf(item);
			if (index > -1)
			{

				var photo_url:String = "";
				
				if (item.photo != null)
				{
					photo_url = item.photo.url;
				}
				
				Container.current.log.info("Удалено из заказа " + count.toString() + " шт. - " + photo_url, "Order");
				mTotalPrice = mTotalPrice - ((item.count - count < 0) ? item.price * item.count : item.price * count);
				mTotalCount = mTotalCount - ((item.count - count < 0) ? item.count : count);
				item.count = item.count - count;
				
				if (item.count <= 0)
				{
					mItems.splice(index, 1);
				}
				dispatchEvent(new Event("onOrderChanged"));
			}
		}
		
		public function inputAmount(nominal:Number):void
		{
			so.data.mDeposit = so.data.mDeposit + nominal;
			so.flush();
		}
		
		public function clear():void
		{
			Container.current.log.info("Очистка заказа.", "Order");
			
			mItems = new Array();
			mTotalPrice = 0;
			mTotalCount = 0;
			so.data.mDeposit = 0;
			so.flush();
		}
		
		public function print():void
		{
			Container.current.log.info("Начало печати фотографий.", "Order");
			
			var print_item_func:Function = function (segment:int = 0, item:Object = null):void
			{
				if (Activity.current) Activity.current.attributes["lastActive"] = new Date();
				
				if (pool && pool.length > 0)
				{
					if (segment == 0 && pool.length > 0)
					{
						var p:Object = pool[0];
						
						if (Container.current.PrintPhoto(p.data, p.price).length > 0)
						{
							so.data.mDeposit = so.data.mDeposit - p.price;
							so.flush();
							
							setTimeout(print_item_func, 20000, 1, p);
						}
						else
						{
							print_item_func(0);
						}
						
					}
					else if (segment == 1)
					{
						pool.shift();
						dispatchEvent(new Event("onPhotoPrinted"));
						setTimeout(print_item_func, 100, 0);
					}
				}
				else
				{
					if (so.data.mDeposit)
					{
						Container.current.log.warn("$$$ ОСТАТОК СРЕДСТВ ПОСЛЕ ПЕЧАТИ (сумма:" + so.data.mDeposit.toString() + ")", "Order");
					}
					
					dispatchEvent(new Event("onPrintComplete"));
				}
			}
			
			print_item_func(0);
		}
		
		public function process():void
		{
			Container.current.log.info("Начало обработки фотографий.", "Order");
			
			if (pool && pool.length > 0)
			{
				pool.splice(0);	
				pool = null;
			}
			
			var process_item_func:Function = function (index:int, padding:Number, segment:int = 0, img:BitmapData = null):void
			{
				if (Activity.current) Activity.current.attributes["lastActive"] = new Date();
				
				var offsetX1:Number = Number(Context.base.loaderInfo.parameters["OffsetX1"] ? Context.base.loaderInfo.parameters["OffsetX1"] : 0) * 300 / 25.4;
				var offsetY1:Number = Number(Context.base.loaderInfo.parameters["OffsetY1"] ? Context.base.loaderInfo.parameters["OffsetY1"] : 0) * 300 / 25.4;
				var offsetX2:Number = Number(Context.base.loaderInfo.parameters["OffsetX2"] ? Context.base.loaderInfo.parameters["OffsetX2"] : 0) * 300 / 25.4;
				var offsetY2:Number = Number(Context.base.loaderInfo.parameters["OffsetY2"] ? Context.base.loaderInfo.parameters["OffsetY2"] : 0) * 300 / 25.4;				
				
				if (index < items.length)
				{
					if (segment == 0)
					{
						if (items[index].photo)
						{
							if (items[index].photo.image)
							{
								setTimeout(arguments.callee, 100, index, padding, 1, items[index].photo.image);
							}
							else
							{
								setTimeout(arguments.callee, 1000, index, padding, 0);
							}
						}
						else
						{
							setTimeout(arguments.callee, 100, index, padding, 3);
						}
					}
					else if (segment == 1)
					{
						(items[index].bitmap as BitmapData).drawWithQuality(img, new Matrix(1, 0, 0, 1, padding, padding), null, null, null, false,  StageQuality.LOW);
						
						setTimeout(arguments.callee, 100, index, padding, 2);
					}
					else if (segment == 2)
					{
						if (items[index].photo && items[index].photo.polaroid)
						{
							// отрисовываем надпись с датой
							if (items[index].photo.date)
							{
								var date_tf:TextField = new TextField();
								date_tf.defaultTextFormat = new TextFormat("Arial", 35, 0x254D96, false);
								date_tf.setTextFormat(date_tf.defaultTextFormat);
								date_tf.wordWrap = false;
								date_tf.autoSize = TextFieldAutoSize.LEFT;
								date_tf.text = items[index].photo.date;
								
								(items[index].bitmap as BitmapData).drawWithQuality(date_tf, new Matrix(1, 0, 0, 1, padding, items[index].bitmap.width), null, null, null, false,  StageQuality.LOW);
							}
							// отрисовываем надпись с локацией
							if (items[index].photo.location)
							{
								var location_tf:TextField = new TextField();
								location_tf.defaultTextFormat = new TextFormat("Arial", 35, 0x254D96, false);
								location_tf.setTextFormat(location_tf.defaultTextFormat);
								location_tf.wordWrap = false;
								location_tf.autoSize = TextFieldAutoSize.LEFT;
								location_tf.text = items[index].photo.location;
								
								items[index].bitmap.drawWithQuality(new location_ico(), new Matrix(1, 0, 0, 1, padding + (items[index].photo.date ? date_tf.width + 15 : 0), items[index].bitmap.width + 6), null, null, null, false,  StageQuality.HIGH);
								items[index].bitmap.drawWithQuality(location_tf, new Matrix(1, 0, 0, 1, padding + (items[index].photo.date ? date_tf.width + 45 : 30), items[index].bitmap.width), null, null, null, false,  StageQuality.LOW);
							}
							
							// отрисовываем надпись с подписью
							if (items[index].photo.caption)
							{
								var caption_tf:TextField = new TextField();
								caption_tf.defaultTextFormat = new TextFormat("Arial", 36, items[index].photo.captionTextColor, false);
								caption_tf.setTextFormat(caption_tf.defaultTextFormat);
								caption_tf.wordWrap = true;
								caption_tf.width = items[index].bitmap.width - (padding * 2);
								caption_tf.height = items[index].bitmap.height - items[index].bitmap.width - ((items[index].photo.date || items[index].photo.location) ? 70 : 30);
								caption_tf.text = items[index].photo.caption;
								
								items[index].bitmap.drawWithQuality(caption_tf, new Matrix(1, 0, 0, 1, padding, items[index].bitmap.width + ((items[index].photo.date || items[index].photo.location) ? 50 : 0) ), null, null, null, false,  StageQuality.LOW);
							}
						}
						
						setTimeout(arguments.callee, 100, index, padding, 3);
					}
					else if (segment == 3)
					{
						for (var i:int = 0; i < items[index].count; i++ )
						{
							if (!pool || pool.length == 0)
							{
								// создаем пул фотографий с первым элементом
								pool = [ { price: 0, occupancy : 0.0, bitmap : new BitmapData(152.4 * 300 / 25.4, 101.6 * 300 / 25.4, true) } ];
							}

							switch (pool[pool.length-1].occupancy)
							{
								case 1.0:
									// если предидущая фотография заполнена то создаем новый элемент
									pool.push( { price: 0, occupancy : 0.0, bitmap : new BitmapData(152.4 * 300 / 25.4, 101.6 * 300 / 25.4, true) } );
								case 0.0:
									// отрисовываем подготовленную фотографию на левой половине
									pool[pool.length - 1].price = pool[pool.length - 1].price + items[index].price;
									pool[pool.length - 1].photo_left = items[index].preview;
									pool[pool.length - 1].bitmap.drawWithQuality(items[index].bitmap, new Matrix(1, 0, 0, 1, ((pool[pool.length - 1].bitmap.width / 2) - items[items.length - 1].bitmap.width) + offsetX1, offsetY1), null, null, null, false,  StageQuality.LOW);
									pool[pool.length - 1].occupancy = 0.5;
									break;
								case 0.5:
									// отрисовываем подготовленную фотографию на правой половине
									pool[pool.length - 1].price = pool[pool.length - 1].price + items[index].price;
									pool[pool.length - 1].photo_right = items[index].preview;
									pool[pool.length - 1].bitmap.drawWithQuality(items[index].bitmap, new Matrix(1, 0, 0, 1, pool[pool.length - 1].bitmap.width / 2 + offsetX2, offsetY2), null, null, null, false,  StageQuality.LOW);
									pool[pool.length - 1].occupancy = 1.0;
									
									// конвертируем полученую фотографию в данные формата Base64 для записи в фаил
									pool[pool.length - 1].data = Base64.encode(pool[pool.length - 1].bitmap.encode(pool[pool.length - 1].bitmap.rect, new PNGEncoderOptions(true)));
									break;
							}
						}
						setTimeout(arguments.callee, 100, ++index, padding, 0);
					}
				}
				else if (items.length > 0)
				{
					if (pool.length > 0 && pool[pool.length - 1].occupancy == 0.5)
					{
						pool[pool.length - 1].price = pool[pool.length - 1].price + items[items.length - 1].price;
						pool[pool.length - 1].photo_right = items[items.length - 1].preview;
						pool[pool.length - 1].bitmap.drawWithQuality(items[items.length - 1].bitmap, new Matrix(1, 0, 0, 1, pool[pool.length - 1].bitmap.width / 2 + offsetX2, offsetY2), null, null, null, false,  StageQuality.LOW);
						pool[pool.length - 1].occupancy = 1.0;
						pool[pool.length - 1].data = Base64.encode(pool[pool.length - 1].bitmap.encode(pool[pool.length - 1].bitmap.rect, new PNGEncoderOptions(false)));
					}
					
					setTimeout(function (f:Function):void { f(new Event("onProcessComplete")); } , 100, dispatchEvent);
				}
			};
			
			process_item_func(0, 4.0 * 300 / 25.4);
		}
	}
}