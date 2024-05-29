package flash.view  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flashpress.touch.TouchEvent;
	import flashpress.touch.TouchManager;
	import flashpress.touch.TouchPhases;
	import flash.view.events.ItemEvent;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.AttributeSet;
	import flash.view.keyboard.Key;
	import flash.events.MouseEvent;
	
	public class GridView extends ViewGroup implements IListView
	{
		private var mAdapter:ListAdapter;
		
		public function GridView(attrs:Object = null)
		{
			attributes["colWidth"] = -1;
			attributes["rowHeight"] = -1;
			attributes["verticalSpacing"] = 10;
			attributes["horizontalSpacing"] = 10;
			attributes["numColumns"] = 4;
			attributes.merge(attrs);
			
			TouchManager.register(this);
			handler.addEventListener(TouchEvent.UP, onTouchVertical);
			handler.addEventListener(TouchEvent.DOWN, onTouchVertical);	
		}
		
		public function setAdapter(adapter:ListAdapter):void
		{
			var oldAdapter:ListAdapter = mAdapter;
			
			if (adapter)
			{
				adapter.addEventListener("onItemAdded", onItemAdded);
				adapter.addEventListener("onItemRemoved", onItemRemoved);
				adapter.addEventListener("onRefresh", function (e:Event):void { requestLayout(); });
				for (var i1:int = 0; i1 < adapter.getCount(); i1++)
				{
					if (adapter.getItem(i1).view) adapter.getItem(i1).view.addEventListener("onClick", function (e:MouseEvent):void { e.stopPropagation(); onItemClick(e.currentTarget as View, e.target != e.currentTarget ? e.target : null, e.delta); });
				}
				
				mAdapter = adapter;
				removeViews();
				requestLayout();
			}
			else
			{
				mAdapter = null;
				removeViews();
				requestLayout();
			}
			
			onAdapterChanged(oldAdapter, mAdapter);
		}
		
		public function getAdapter():ListAdapter
		{
			return mAdapter;
		}
		
		// Set the number of columns in the grid
		public function setNumColumns(numColumns:Number):void
		{
			attributes["numColumns"] = numColumns;
		}
		
		public function setRowHeight(rowHeight:int):void
		{
			attributes["rowHeight"] = rowHeight;
		}
		
		public function setColWidth(colWidth:int):void
		{
			attributes["colWidth"] = colWidth;
		}		
		
		// Set the amount of vertical (y) spacing to place between each item in the grid.
		public function setVerticalSpacing(verticalSpacing:int):void
		{
			attributes["verticalSpacing"] = verticalSpacing;
		}
		
		// Set the amount of horizontal (x) spacing to place between each item in the grid.
		public function setHorizontalSpacing(horizontalSpacing:int):void
		{
			attributes["horizontalSpacing"] = horizontalSpacing;
		}
		
		protected function onItemAdded(e:ItemEvent):void
		{
			var i1:int = mAdapter.getItemPosition(e.item.view);
			var view:View = mAdapter.instantiateItem(this, i1);
			
			var i2:int = e.item.getPos();
			var row:int = i2 / attributes["numColumns"];
			var col:Number = i2 % attributes["numColumns"];
			
			if (view is View)
			{
				var bounds:Rectangle = view.getBounds(null);
				view.setSize((attributes["colWidth"] * mAdapter.getItem(i1).colSpan) + ((mAdapter.getItem(i1).colSpan-1) * attributes["horizontalSpacing"]), attributes["rowHeight"]);
				view.addEventListener("onClick", function (e:MouseEvent):void { e.stopPropagation(); onItemClick(e.currentTarget as View, e.target != e.currentTarget ? e.target : null, e.delta); });
				view.y = ((row * attributes["rowHeight"]) + (row * attributes["verticalSpacing"])) + Math.abs(bounds.height + bounds.y - bounds.height);
				view.x = ((col * attributes["colWidth"])  + (col * attributes["horizontalSpacing"])) + Math.abs(bounds.width + bounds.x - bounds.width);
				mAdapter.getItem(i1).setPos(i2);
			}
			
		}
		
		protected function onItemRemoved(e:ItemEvent):void
		{
			mAdapter.destroyItem(this, e.item);
			requestLayout();
		}
		
		protected function onItemClick(view:View, relatedObject:Object, delta:int):void
		{
			dispatchEvent(new ItemEvent("onItemClick", mAdapter.getItemByView(view), relatedObject, false, false, delta));
		}
		
		protected override function onSizeChanged(w:Number, h:Number, oldWidth:Number, oldHeight:Number):void
		{
			super.onSizeChanged(w, h, oldWidth, oldHeight);
		}
		
		protected override function onLayout():void
		{
			if (mAdapter != null)
			{
				var i2:Number = 0;
				for (var i1:int = 0; i1 < mAdapter.getCount(); i1++)
				{
					var row:int = i2 / attributes["numColumns"];
					var col:Number = i2 % attributes["numColumns"];					
					var view:View = mAdapter.instantiateItem(this, i1);
					if (view is View)
					{
						var bounds:Rectangle = view.getBounds(null);
						view.setSize((attributes["colWidth"] * mAdapter.getItem(i1).colSpan) + ((mAdapter.getItem(i1).colSpan-1) * attributes["horizontalSpacing"]), attributes["rowHeight"]);
						var top:Number = ((row * attributes["rowHeight"]) + (row * attributes["verticalSpacing"])) + Math.abs(bounds.height + bounds.y - bounds.height);
						var left:Number = ((col * attributes["colWidth"])  + (col * attributes["horizontalSpacing"])) + Math.abs(bounds.width + bounds.x - bounds.width);
						view.setLocation(left, top);
					}
					mAdapter.getItem(i1).setPos(i2);
					i2 += mAdapter.getItem(i1).colSpan;
				}
			}
		}
		
		protected override function onDraw(canvas:Graphics):void
		{
			super.onDraw(canvas);
			setClipBounds(new Rectangle(0, 0, getWidth(), getHeight()));
		}
		
		protected function onAdapterChanged(oldAdapter:ListAdapter, newAdapter:ListAdapter):void
		{
			
		}
		
		private function onTouchVertical(e:TouchEvent):void
		{
			var newPos:Number = content.y + e.touchData.shift;
			
			switch (e.touchData.phase)
			{
				case TouchPhases.BEGIN:
					break;
				case TouchPhases.UPDATE:
				case TouchPhases.END:
					var rect:Rectangle = getLocalVisibleRect();
					
					if (newPos < content.y)
					{
						if (newPos > Math.ceil(-content.height + rect.height) - getPaddingBottom())
						{
							content.y = newPos;
							dispatchEvent(new Event("onScroll"));
						}
						else
						{
							if (canScrollVertically(1))
							{
								content.y = Math.ceil(-content.height + rect.height);
								dispatchEvent(new Event("onScroll"));
							}
							else
							{
								dispatchEvent(new Event("onScrollDownEnd"));
							}
						}
					}
					else if (newPos > content.y)
					{
						if (newPos < 0 + getPaddingTop())
						{
							content.y = newPos;
							dispatchEvent(new Event("onScroll"));
						}
						else
						{
							if (canScrollVertically(-1))
							{
								content.y = 0;
								dispatchEvent(new Event("onScroll"));
							}
							else
							{
								dispatchEvent(new Event("onScrollUpEnd"));
							}
						}
					}
					break;
			}
		}
	}
}
