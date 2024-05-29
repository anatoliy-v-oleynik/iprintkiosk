package flash.widget 
{
	
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import fl.display.ProLoader;
	import fl.display.ProLoaderInfo;
	import fl.motion.Animator;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.AttributeSet;
	import flash.utils.ByteArray;
	import flash.view.TextView;
	import fl.motion.MatrixTransformer;
	import com.greensock.TimelineMax;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.TransformMatrixPlugin;
	import com.greensock.TweenMax;
	import com.greensock.TweenAlign;
	 
	public class Button extends TextView
	{
		private var mAnimator:Animator;
		private var mIcon:DisplayObject;
		private var mClickCounter:int;

		public function Button(attrs:Object = null)
		{
			super();
			handler.mouseChildren = false;
			attributes["singleLine"] = true;
			attributes["textHorizontalAlign"] = "center";
			attributes["textVerticalAlign"] = "center";
			attributes.merge(attrs);
			
			resetClickCounter();
			setClickable(true);	
		}

		public function getClickCounter():int
		{
			return mClickCounter;
		}

		public function resetClickCounter():void
		{
			mClickCounter = 0;
		}

		public function setIcon(icon:ByteArray):void
		{
			if (mIcon != null)
			{
				mIcon.parent.removeChild(mIcon);
			}
			
			var loader:ProLoader = new ProLoader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
													  function (e:Event):void
													  {

														  	mIcon = self.addChild((e.target as ProLoaderInfo).content);
															
//															var bounds:Rectangle = self.getLocalVisibleRect();
//															var contentBounds:Rectangle = (e.target as ProLoaderInfo).content.getBounds(null);															
//															mIcon.x = bounds.left + (((bounds.right - bounds.left) - (contentBounds.right - contentBounds.left)) / 2);
//															mIcon.y = bounds.top + (((bounds.bottom - bounds.top) - (contentBounds.bottom - contentBounds.top)) / 2);
															var bounds:Rectangle = mIcon.getBounds(null);
															mIcon.x = (self.getWidth() / 2 - (bounds.width / 2 + bounds.x));
															mIcon.y = (self.getHeight() / 2 - (bounds.height / 2 + bounds.y));
													  });
			loader.loadBytes(icon);
		}

		protected override function onClick(e:MouseEvent):void
		{
			mClickCounter++;
			super.onClick(e);
		}
		
		override protected function onPress(e:MouseEvent):void 
		{
			super.onPress(e);
			
			trace(e);
			
			if (handler.currentLabels.some(function (item:*, index:int, array:Array):Boolean { return (item.name == "pressed"); }, this))
			{
				handler.gotoAndStop("pressed");
			}
		}
		
		override protected function onRelease(e:MouseEvent):void 
		{
			super.onRelease(e);
			
			trace(e);
			
			if (handler.currentLabels.some(function (item:*, index:int, array:Array):Boolean { return (item.name == "pressed"); }, this))
			{
				handler.gotoAndStop(1);
			}
			else
			{
				setClickable(false);
				
				var internalBounds:Rectangle = this.getBounds(null);
				var externalBounds:Rectangle = this.getBounds(this.parent);
				
				var internalCenter:Point=new Point(internalBounds.width / 2 + internalBounds.x, internalBounds.height / 2 + internalBounds.y);
				var externalCenter:Point = new Point(externalBounds.width / 2 + externalBounds.x, externalBounds.height / 2 + externalBounds.y);

				var upMatrix:Matrix = this.transform.matrix.clone();
				var downMatrix:Matrix = this.transform.matrix.clone();
				downMatrix.scale(0.5, 0.5);
				MatrixTransformer.matchInternalPointWithExternal(downMatrix, internalCenter, externalCenter); 

				TweenPlugin.activate([TransformMatrixPlugin]);
				var myTimeline:TimelineMax = new TimelineMax({tweens:[new TweenMax(this, 0.1, {transformMatrix:{tx:downMatrix.tx, ty:downMatrix.ty, a:downMatrix.a, b:downMatrix.b, c:downMatrix.c, d:downMatrix.d }}), new TweenMax(this, 0.1, {transformMatrix:{tx:upMatrix.tx, ty:upMatrix.ty, a:upMatrix.a, b:upMatrix.b, c:upMatrix.c, d:upMatrix.d }}) ], align:TweenAlign.SEQUENCE, onComplete:setClickable, onCompleteParams:[true] });
			}
		}
		
		override protected function onReleaseOutside(e:MouseEvent):void 
		{
			super.onReleaseOutside(e);
			if (handler.currentLabels.some(function (item:*, index:int, array:Array):Boolean { return (item.name == "pressed"); }, this))
			{
				handler.gotoAndStop(1);
			}			
		}
		
		override protected function onSizeChanged(w:Number, h:Number, oldWidth:Number, oldHeight:Number):void
		{
			super.onSizeChanged(w, h, oldWidth, oldHeight);
		}		
	}
}