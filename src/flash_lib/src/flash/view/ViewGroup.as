package flash.view  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	import flash.utils.AttributeSet;
	import flash.display.DisplayObjectContainer;
	
	public class ViewGroup extends View implements IViewManager
	{
		public var _content:MovieClip;
		
		public function ViewGroup(attrs:Object = null)
		{
			super();
			
			if (content is DisplayObjectContainer && content != this)
			{
				
			}
			else
			{
				setContentView(new View());
			}
			
			attributes.merge(attrs);
		}
		
		public function canScrollVertically(direction:int):Boolean
		{
			return content.height > 0 ? ((direction < 0) ? Math.floor(content.y) > 0 + getPaddingTop() : (Math.floor(content.y + content.height) > Math.floor(getLocalVisibleRect().height - getPaddingBottom()))) : false;
		}
		
		
		public function addView(child:View):View
		{
			if (content is DisplayObjectContainer && child is View)
			{
				return content.addChild(child) as View;
			}
			
			return null;
		}
		
		public function containsView(child:View):Boolean
		{
			if (content is DisplayObjectContainer && child is View)
			{
				return content.contains(child) as View;
			}
			
			return false;
		}
		
		public function indexOfChild(child:View):int
		{
			if (!this.contains(child))
			{
				return int.MIN_VALUE;
			}
			
			return this.getChildIndex(child);
		}
		
		public function removeView(child:View):View
		{
			if ((content is DisplayObjectContainer) && (content == child.parent))
			{
				return content.removeChild(child) as View;
			}
			
			return null;
		}
		
		public function removeViews():void
		{
			if (content is DisplayObjectContainer)
			{
				content.removeChildren();
			}			
		}
		
		// By default, children are clipped to their bounds before drawing. This allows view groups to override this behavior for animations, etc.
		public function setClipChildren(clipChildren:Boolean):void
		{
			
		}
		
		// Sets whether this ViewGroup will clip its children to its padding, if padding is present.
		public function setClipToPadding(clipToPadding:Boolean):void
		{
			
		}
		
		protected override function onDraw(canvas:Graphics):void
		{
			super.onDraw(canvas);
		}		
	}
}
