package flash.utils 
{
	/**
	 * uk.soulwire.utils.display.DisplayUtils
	 * 
	 * @version v1.0
	 * @since May 26, 2009
	 * 
	 * @author Justin Windle
	 * @see http://blog.soulwire.co.uk
	 * 
	 * About DisplayUtils
	 * 
	 * DisplayUtils is a set of static utility methods for dealing 
	 * with DisplayObjects
	 * 
	 * Licensed under a Creative Commons Attribution 3.0 License
	 * http://creativecommons.org/licenses/by/3.0/
	 */
	 
	import flash.display.IBitmapDrawable;
	import flash.display.PixelSnapping;	
	import flash.display.Bitmap;	
	import flash.display.BitmapData;	 
	import flash.display.StageQuality;
	import flash.geom.Matrix;	
	import flash.geom.Rectangle;	
	import flash.display.DisplayObject;	

	public class DisplayUtils 
	{	

		public static function fitBitmapData(o:*, w:Number, h:Number, fillBox:Boolean = false, cropped:Boolean = false, tx:Number = 0, ty:Number = 0, bestQuality:Boolean = false, rotation:Number = 0):BitmapData
		{
			var sX : Number = w / o.width;
			var sY : Number = h / o.height;
			
			var rD : Number = o.width / o.height;
			var rR : Number = w / h;
			
			var sH : Number = fillBox ? sY : sX;
			var sV : Number = fillBox ? sX : sY;
			
			var s: Number = rD >= rR ? sH : sV;
			
			var scaleBmpd:BitmapData;
			
			var image:BitmapData = o as BitmapData;
			if (o is BitmapData && bestQuality)
			{
				scaleBmpd = new BitmapData(o.width * s, o.height * s);
				var xImageFactor:Number = o.width / scaleBmpd.width;
				var yImageFactor:Number = o.height / scaleBmpd.height;					
				
				for (var xPix:Number = 0; xPix < scaleBmpd.width; xPix++)
				{
					for (var yPix:Number = 0; yPix < scaleBmpd.height; yPix++)
					{
						scaleBmpd.setPixel(xPix, yPix, InterpolatedBitmapData.getPixelBilinear(o as BitmapData, xPix * xImageFactor, yPix * yImageFactor));
					}
				}
			}
			else
			{
				scaleBmpd = new BitmapData(o.width * s, o.height * s, true, 0x00000000);
				var scaleMatrix:Matrix = new Matrix();
				scaleMatrix.rotate(rotation * (Math.PI / 180));
				scaleMatrix.scale(s, s);
				scaleBmpd.drawWithQuality( o as IBitmapDrawable, scaleMatrix, null, null, null, false, StageQuality.LOW );
			}
			
			if ((scaleBmpd.width > w || scaleBmpd.height > h) && (cropped))
			{
				var croppedBmpd:BitmapData = new BitmapData(w, h, true, 0x00000000);
				var cropMatrix:Matrix = new Matrix();
				cropMatrix.rotate(rotation * (Math.PI / 180));
				cropMatrix.translate((scaleBmpd.width / 100) * tx, (scaleBmpd.height / 100) * ty);
 				croppedBmpd.drawWithQuality(scaleBmpd, cropMatrix, null, null, new Rectangle(0, 0, w, h), false, StageQuality.LOW  );
				return croppedBmpd;
			}
			
			return scaleBmpd;
		}
		
		public static function fitImageProportionally( ARG_object:DisplayObject, ARG_width:Number, ARG_height:Number, ARG_center:Boolean = true, ARG_fillBox:Boolean = true ):Bitmap
		{
			var tempW:Number = ARG_object.width;
			var tempH:Number = ARG_object.height;
		 
			ARG_object.width = ARG_width;
			ARG_object.height = ARG_height;
		 
			var scale:Number = (ARG_fillBox) ? Math.max(ARG_object.scaleX, ARG_object.scaleY) : Math.min(ARG_object.scaleX, ARG_object.scaleY);
		 
			ARG_object.width = tempW;
			ARG_object.height = tempH;
		 
			var scaleBmpd:BitmapData = new BitmapData(ARG_object.width * scale, ARG_object.height * scale);
			var scaledBitmap:Bitmap = new Bitmap(scaleBmpd, PixelSnapping.ALWAYS, true);
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(scale, scale);
			scaleBmpd.draw( ARG_object, scaleMatrix );
		 
			if (scaledBitmap.width > ARG_width || scaledBitmap.height > ARG_height) {
		 
				var cropMatrix:Matrix = new Matrix();
				var cropArea:Rectangle = new Rectangle(0, 0, ARG_width, ARG_height);
		 
				var croppedBmpd:BitmapData = new BitmapData(ARG_width, ARG_height);
				var croppedBitmap:Bitmap = new Bitmap(croppedBmpd, PixelSnapping.ALWAYS, true);
		 
				if (ARG_center) {
					var offsetX:Number = Math.abs((ARG_width -scaleBmpd.width) / 2);
					var offsetY:Number = Math.abs((ARG_height - scaleBmpd.height) / 2);
		 
					cropMatrix.translate(-offsetX, -offsetY);
				}
		 
				croppedBmpd.draw( scaledBitmap, cropMatrix, null, null, cropArea, true );
				return croppedBitmap;
		 
			} else {
				return scaledBitmap;
			}
		 
		}	
		
		public static function getResampledBitmapData( source : Object , w : Number , h : Number ) : BitmapData {
			
			var sourceBitmapData : BitmapData;
			
			if ( source is DisplayObject ) { // if source is a DisplayObject instance
				//sourceBitmapData  = getBitmapDataFromDisplayObject( DisplayObject( source )  );
			} else if ( source is BitmapData) { // if source is a BitmapData instance
				sourceBitmapData = source as BitmapData;
			} else if (source is Number) { // break on unhandled source
				return new BitmapData(w, h, false, source as Number);
			} else {
				return null; 
			}
			
			//set the scale for the draw operation, for the new width / height
			var matrix : Matrix =  new Matrix();
			matrix.scale( w / sourceBitmapData.width  , h / sourceBitmapData.height );
			
			//create the resized bitmap data
			var ouputBitmapData : BitmapData = new BitmapData( w, h , true , 0x00000000 );
			
			//draw the source to the bitmapData instance
			ouputBitmapData.drawWithQuality( sourceBitmapData , matrix , null , null , null , true );
			
			//dispose of temporary bitmap data
			if ( source is DisplayObject ) sourceBitmapData.dispose();
			
			return ouputBitmapData;
		}


		//---------------------------------------------------------------------------
		//------------------------------------------------------------ PUBLIC METHODS
		
		/**
		 * Fits a DisplayObject into a rectangular area with several options for scale 
		 * and alignment. This method will return the Matrix required to duplicate the 
		 * transformation and can optionally apply this matrix to the DisplayObject.
		 * 
		 * @param displayObject
		 * 
		 * The DisplayObject that needs to be fitted into the Rectangle.
		 * 
		 * @param rectangle
		 * 
		 * A Rectangle object representing the space which the DisplayObject should fit into.
		 * 
		 * @param fillRect
		 * 
		 * Whether the DisplayObject should fill the entire Rectangle or just fit within it. 
		 * If true, the DisplayObject will be cropped if its aspect ratio differs to that of 
		 * the target Rectangle.
		 * 
		 * @param align
		 * 
		 * The alignment of the DisplayObject within the target Rectangle. Use a constant from 
		 * the DisplayUtils class.
		 * 
		 * @param applyTransform
		 * 
		 * Whether to apply the generated transformation matrix to the DisplayObject. By setting this 
		 * to false you can leave the DisplayObject as it is but store the returned Matrix for to use 
		 * either with a DisplayObject's transform property or with, for example, BitmapData.draw()
		 */

		public static function fitIntoRect(displayObject : DisplayObject, rectangle : Rectangle, fillRect : Boolean = true, align : String = "C", applyTransform : Boolean = true) : Matrix
		{
			var matrix : Matrix = new Matrix();
			
			var wD : Number = displayObject.width / displayObject.scaleX;
			var hD : Number = displayObject.height / displayObject.scaleY;
			
			var wR : Number = rectangle.width;
			var hR : Number = rectangle.height;
			
			var sX : Number = wR / wD;
			var sY : Number = hR / hD;
			
			var rD : Number = wD / hD;
			var rR : Number = wR / hR;
			
			var sH : Number = fillRect ? sY : sX;
			var sV : Number = fillRect ? sX : sY;
			
			var s : Number = rD >= rR ? sH : sV;
			var w : Number = wD * s;
			var h : Number = hD * s;
			
			var tX : Number = 0.0;
			var tY : Number = 0.0;
			
			switch(align)
			{
				case "LEFT" :
				case "TOP_LEFT":
				case "BOTTOM_LEFT":
					tX = 0.0;
					break;
					
				case "RIGHT":
				case "TOP_RIGHT":
				case "BOTTOM_RIGHT":
					tX = w - wR;
					break;
					
				default : 					
					tX = 0.5 * (w - wR);
			}
			
			switch(align)
			{
				case "TOP":
				case "TOP_LEFT":
				case "TOP_RIGHT":
					tY = 0.0;
					break;
					
				case "BOTTOM":
				case "BOTTOM_LEFT":
				case "BOTTOM_RIGHT":
					tY = h - hR;
					break;
					
				default : 					
					tY = 0.5 * (h - hR);
			}
			
			matrix.scale(s, s);
			matrix.translate(rectangle.left - tX, rectangle.top - tY);
			
			if(applyTransform)
			{
				displayObject.transform.matrix = matrix;
			}
			
			return matrix;
		}

		/**
		 * Creates a thumbnail of a BitmapData. The thumbnail can be any size as 
		 * the copied image will be scaled proportionally and cropped if necessary 
		 * to fit into the thumbnail area. If the image needs to be cropped in order 
		 * to fit the thumbnail area, the alignment of the crop can be specified
		 * 
		 * @param image
		 * 
		 * The source image for which a thumbnail should be created. The source 
		 * will not be modified
		 * 
		 * @param width
		 * 
		 * The width of the thumbnail
		 * 
		 * @param height
		 * 
		 * The height of the thumbnail
		 * 
		 * @param align
		 * 
		 * If the thumbnail has a different aspect ratio to the source image, although 
		 * the image will be scaled to fit along one axis it will be necessary to crop 
		 * the image. Use this parameter to specify how the copied and scaled image should 
		 * be aligned within the thumbnail boundaries. Use a constant from the Alignment 
		 * enumeration class
		 * 
		 * @param smooth
		 * 
		 * Whether to apply bitmap smoothing to the thumbnail
		 */

		public static function createThumb(image : BitmapData, width : int, height : int, align : String = "C", smooth : Boolean = true) : Bitmap
		{
			var source : Bitmap = new Bitmap(image);
			var thumbnail : BitmapData = new BitmapData(width, height, false, 0x0);
			
			thumbnail.draw(image, fitIntoRect(source, thumbnail.rect, true, align, false), null, null, null, smooth);
			source = null;
			
			return new Bitmap(thumbnail, PixelSnapping.AUTO, smooth);
		}
	}
}
