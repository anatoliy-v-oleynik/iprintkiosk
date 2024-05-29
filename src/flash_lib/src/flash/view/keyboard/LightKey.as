package flash.view.keyboard  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.view.TextView;
	import flash.widget.Button;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.AttributeSet;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	
	public class LightKey extends Key
	{
		public function LightKey(attrs:Object = null)
		{
			super();
			attributes["textColor"] = 0xFFFFFF;
			attributes["textSize"] = 30;
			attributes["font"] = TextView.DefaultFont;			
			setTextFormat(new TextFormat("Arial", 30, 0xFFFFFF, true, false, false, null, null, TextFormatAlign.CENTER, 0, 0, 0, 0));
			attributes.merge(attrs);
		}

		protected override function onDraw(canvas:Graphics):void
		{
			super.onDraw(canvas);
			
			canvas.beginFill(0x222125, 1);        
			canvas.drawRoundRect(0, 2, getWidth(), getHeight(), 15, 15);
			canvas.endFill();
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(getWidth(), getHeight(), Math.PI / 2, 0, 0);			
			
			canvas.beginGradientFill(GradientType.LINEAR, [0x6E6E70, 0x6E6E70], [1, 1], [0x00, 0xFF], matrix, SpreadMethod.PAD);        
			canvas.drawRoundRect(0, 0, getWidth(), getHeight(), 15, 15);
			canvas.endFill();
		}
	}
}
