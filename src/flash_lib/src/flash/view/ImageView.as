package flash.view  {
	
	//public namespace ns_imageview = "http://www.iprintkiosk.ru/ns_imageview";
	
	import com.greensock.loading.core.DisplayObjectLoader;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	import flash.utils.AttributeSet;
	import flash.display.DisplayObjectContainer;
	import flash.display.BitmapData;
	import fl.display.ProLoader;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.utils.Base64;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.ImageLoader;
	import com.greensock.events.LoaderEvent;
	import flash.events.MouseEvent;
	import flash.utils.DisplayUtils;
	import flash.events.IOErrorEvent;
	
	
	public class ImageView extends View
	{
		public static const preloader_ico:ByteArray = Base64.decode("Q1dTD3YJAAB4nKVWXWzbVBQ+dhK7TbqtWdu0PExYGRKCNbGTJulqdVnbpIGCoo6uEj+iNK5905o5trHdNpWYmECgTQNpQgLBQGhszwiJPW0gdU+gSRVkgBBIQ8BLgQc0QDxOlHttt822bh1w4+ie755zvnvuOcc3qUC8Qp6ee6AY7QGAFzraQwCDllIVJ4olrl7TdFvE6EB8znFMkecXFxeTi31Jw5rlUwMDA7yQ5tPpBLZI2Eu6I9UTur03nudchiKyZUs1HdXQOYKlGWPeORCP+7T1mrlBq9tJSTFmUFI2anxdMvlUUuAJDzYSCxaSHMOaNAwtP0ysuJIm2XPcIcuoItvG9JLGFQ7nuAQ3M69qCpfZnxrkb/Zs4kJF/M2nhVQ2IeQSKWEylRWzKfzsE/pEQWjy9Sw91zJyJEVypFuc+8XMfrEv0+x8g63vbihqdemunDctuUH+pkzedW7L5Ttnt1bj161tZwJV72xtTy6ZiJ9AtjFvyQib7/WrUy6LY7rtSLqMxop5vJBUVUUsFlOpgVQm018SSqNZLJf6+wqZbHoki4+eHR5xD3qj6zpb0ZDna0h3fDblX7A1ua6zjVvqrIr7YwvWkcwoJh7O5HJ3Zt2CYiNWZKkLSClZRs2tgilZNiKZOhBfTxVJk5tfUd0iTSPbHewW13U25dYDFdKlXH9xZDi3DZvSfBBvyfg/abotBbdRmM08/eeWVuSNDjXnLc29ghSZRxoiu9m4S1PujaHIYtWwapKTl0xTU2WJEPL1hD1nyEcWpQWUqJLbY5DfNNwyJN6/BPMcFOiVlZXlrhi+ICmQl2QNpadxQWYRUBHNMEw42LLP1U0VH38j+gwEYA0PqK5VgUgAXNf87rNHw398+eGeruhXjwG8wjAUtofliIIdaRh98Pv4t9kTXx8/6PKseYNYbI5oonP5+pnE6csPfHL52CNvUecm3tlP9Z7pQNmk/OaxR+eYp19fXaEbAMFvjr770ee/zT53/u3v/rr6Z27pSH4Vh7gXcwSAbEJ5UbV3fjA9+Np7T31x4efe8x8/eVVbXTiagbXWOjYMQpsXJA0wBC8zUQpK3b7watIXroz6QveUL0w5vnDupC/8etYX+Iu+4FzxhYu/DAHNUt4+AbIPwAmGofHm3devDS13fkqBl4J2SJJp972mhTRDUpA1rcqGPt1ci2lc1raypOqTag1pqo52uHXGPWybmrTUWjYWVFTQVLN3GxKxmYStWlINpbMQmTUcY1hXDmGuICn6TknBDY2Vh92mYcZnnkWy0+ZtihZIT+4aJVMRByA58hyydhS9WDzT6JjuIEuSHfxqeCuxG/QFA/+g4hAs5rBpqQ5iY1Qs0BPqpmJsrA3aWIpm6SAbZNhQCxsKs6EIy+xg6Z0svYul21k6GoSbB0XRLQGgqYDbe3iighRONkW1hgMN4SG8RFPhSLghTAV7W8eDFF6hA3ilvSE0xmAqdF9PoxoYD9F4PUBjr/sbAoIKI1RYodIiVFqFSlioRIQKjZ8nYI835gjNwY4UeLXcJvnJ5uTjjjjJxII4xM4XP8PeLmQIvFap0B5swTD20qVTAQ+GifaH948FPdjm+l4YCnlwJ2mtv0/9zniwHcOu+gCwHtxN4J44tHiwkxg/f+l4qwdjRNv5049hDNfC+F8SuK8+1vQQjfMwRLDm9h+AfwAK87ko");
		
		private var bitmapdata:BitmapData;
		
		public function ImageView(attrs:Object = null)
		{
			attributes.merge(attrs);
			attributes["scaleType"] = "center";
		}
		
		// Sets the content of this ImageView to the specified Uri.
		public function setImageURI(uri:String, loader:LoaderMax = null):void
		{
			if (loader != null)
			{
				loader.append(new ImageLoader(uri, {name:"photo", noCache:true, onComplete:function (e:LoaderEvent):void { setImageBitmap(e.target.rawContent); } } ));
				
			}
			else
			{
				var imageLoader:ProLoader = new ProLoader();
				imageLoader.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {  } );
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event):void
															{
																setImageBitmap(e.target.content);
																dispatchEvent(new Event("onLoadComplete"));
															});
				imageLoader.load(new URLRequest(uri));
			}
		}

		// Sets a Bitmap as the content of this ImageView.
		public function setImageBitmap(image:DisplayObject):void
		{
			var bounds:Rectangle = getLocalVisibleRect();
			
			if (image as Bitmap)
			{
				attributes["sourceBitmapData"] = (image as Bitmap).bitmapData;
			}
			else
			{
				attributes["sourceBitmapData"] = new BitmapData(image.width, image.height);
				attributes["sourceBitmapData"].drawWithQuality(image as IBitmapDrawable );
			}
			
			bounds.top += getPaddingTop();
			bounds.bottom -= getPaddingBottom();
			bounds.left += getPaddingLeft();
			bounds.right -= getPaddingRight();			
			
			//var contentX:Number = bounds.left + (((bounds.right - bounds.left) - (content.getBounds(null).right - content.getBounds(null).left)) / 2);
			//var contentY:Number = bounds.top + (((bounds.bottom - bounds.top) - (content.getBounds(null).bottom - content.getBounds(null).top)) / 2);			
			
			switch (attributes["scaleType"])
			{
				// Center the image in the view, but perform no scaling. 
				case "center":
					setContentView(new Bitmap(DisplayUtils.fitBitmapData(( image is Bitmap ) ? (image as Bitmap).bitmapData : image, image.width, image.height, false, false)));
					content.x = bounds.left + (((bounds.right - bounds.left) - (content.getBounds(null).right - content.getBounds(null).left)) / 2);
					content.y = bounds.top + (((bounds.bottom - bounds.top) - (content.getBounds(null).bottom - content.getBounds(null).top)) / 2);						
					break;
				// Scale the image uniformly (maintain the image's aspect ratio) so that both dimensions (width and height) of the image will be equal to or larger than the corresponding dimension of the view (minus padding). 
				case "centerCrop":
					setContentView(new Bitmap(DisplayUtils.fitBitmapData(( image is Bitmap ) ? (image as Bitmap).bitmapData : image, bounds.width, bounds.height, true, true)));
					content.x = bounds.left + (((bounds.right - bounds.left) - (content.getBounds(null).right - content.getBounds(null).left)) / 2);
					content.y = bounds.top + (((bounds.bottom - bounds.top) - (content.getBounds(null).bottom - content.getBounds(null).top)) / 2);					
					break;
				// Scale the image uniformly (maintain the image's aspect ratio) so that both dimensions (width and height) of the image will be equal to or less than the corresponding dimension of the view (minus padding). 
				case "centerInside":
					setContentView(new Bitmap(DisplayUtils.fitBitmapData(( image is Bitmap ) ? (image as Bitmap).bitmapData : image, bounds.width, bounds.height, false, false)));
					content.x = bounds.left + (((bounds.right - bounds.left) - (content.getBounds(null).right - content.getBounds(null).left)) / 2);
					content.y = bounds.top + (((bounds.bottom - bounds.top) - (content.getBounds(null).bottom - content.getBounds(null).top)) / 2);							
					break;
				case "fitCenter":
					setContentView(new Bitmap(DisplayUtils.fitBitmapData(( image is Bitmap ) ? (image as Bitmap).bitmapData : image, bounds.width, bounds.height, true, false)));
					content.x = bounds.left + (((bounds.right - bounds.left) - (content.getBounds(null).right - content.getBounds(null).left)) / 2);
					content.y = bounds.top + (((bounds.bottom - bounds.top) - (content.getBounds(null).bottom - content.getBounds(null).top)) / 2);
					break;
				default:
					setContentView(new Bitmap(DisplayUtils.fitBitmapData(( image is Bitmap ) ? (image as Bitmap).bitmapData : image, image.width, image.height, false, false)));
					break;
			}
		}
		
		public function setScaleType(scaleType:String):void
		{
			attributes["scaleType"] = scaleType;
			
			switch (scaleType)
			{
				// Center the image in the view, but perform no scaling. 
				case "center":
					break;
				// Scale the image uniformly (maintain the image's aspect ratio) so that both dimensions (width and height) of the image will be equal to or larger than the corresponding dimension of the view (minus padding). 
				case "centerCrop":
					break;
				// Scale the image uniformly (maintain the image's aspect ratio) so that both dimensions (width and height) of the image will be equal to or less than the corresponding dimension of the view (minus padding). 
				case "centerInside":
					break;
				case "fitCenter":
					break;
				case "fitEnd":
					break;
				case "fitStart":
					break;
			}
		}
		
		public function getBitmapData(source:Boolean = false):BitmapData
		{
			return source ? attributes["sourceBitmapData"] as BitmapData : content.bitmapData;
		}

	}
}
