package flash.widget
{
	import fl.display.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.utils.AttributeSet;
	import flash.utils.Base64;
	import flash.view.ImageView;
	import com.greensock.TimelineMax;
	import com.greensock.plugins.TransformMatrixPlugin;
	import com.greensock.plugins.TweenPlugin;
	import fl.motion.MatrixTransformer;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	
	public class ImageButton extends ImageView
	{
		private var mClickCounter:int;
		
		public function ImageButton(attrs:Object = null)
		{
			handler.mouseChildren = false;
			attributes.merge(attrs);
			
			resetClickCounter();
			setClickable(true);				
		}
		
		protected override function onClick(e:MouseEvent):void
		{
			setClickable(false);
			
			mClickCounter++;

			var internalBounds:Rectangle = this.getBounds(null);
			var externalBounds:Rectangle = this.getBounds(this.parent);
			
			var internalCenter:Point=new Point(internalBounds.width / 2 + internalBounds.x, internalBounds.height / 2 + internalBounds.y);
			var externalCenter:Point = new Point(externalBounds.width / 2 + externalBounds.x, externalBounds.height / 2 + externalBounds.y);

//			var c:DisplayObject = this.parent.addChild(new CC());
//			c.x = externalCenter.x;
//			c.y = externalCenter.y;
//			
//			var b:DisplayObject = this.addChild(new BB());
//			b.x = internalCenter.x;
//			b.y = internalCenter.y;
			
			var upMatrix:Matrix = this.transform.matrix.clone();
			var downMatrix:Matrix = this.transform.matrix.clone();
			downMatrix.scale(0.5, 0.5);
			MatrixTransformer.matchInternalPointWithExternal(downMatrix, internalCenter, externalCenter); 

			var f:Function = super.onClick;

			TweenPlugin.activate([TransformMatrixPlugin]);
			var myTimeline:TimelineMax = new TimelineMax({tweens:[new TweenMax(this, 0.1, {transformMatrix:{tx:downMatrix.tx, ty:downMatrix.ty, a:downMatrix.a, b:downMatrix.b, c:downMatrix.c, d:downMatrix.d }}), new TweenMax(this, 0.1, {transformMatrix:{tx:upMatrix.tx, ty:upMatrix.ty, a:upMatrix.a, b:upMatrix.b, c:upMatrix.c, d:upMatrix.d }}) ], align:TweenAlign.SEQUENCE, onComplete: function (f:Function, e:MouseEvent):void { setClickable(true); f(e); } , onCompleteParams:[f, e] });

		}
		
		public function resetClickCounter():void
		{
			mClickCounter = 0;
		}		
	}
}
