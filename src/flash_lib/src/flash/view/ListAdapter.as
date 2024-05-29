package flash.view
{
	import flash.errors.IllegalOperationError;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.view.events.ItemEvent;
	import flash.view.ListItem;

	public class ListAdapter extends EventDispatcher
	{
		private var mItems:Vector.<ListItem>;
		
		public function ListAdapter()
		{
			mItems = new Vector.<ListItem>();
		}		
		
		// Return the number of views available.
		public function getCount():int
		{
			return mItems.length;
		}

		// Called when the host view is attempting to determine if an item's position has changed.
		public function getItemPosition(view:View):int
		{
			for (var i:int = 0; i < mItems.length; i++)
			{
				if (mItems[i].view == view) return i;
			}
			
			return -1;
		}

		// Create the page for the given position.
		public function instantiateItem(container:ViewGroup, position:int):View
		{
			if (mItems && mItems.length > 0 && position >= 0 && position < mItems.length)
			{
			
				if (container.containsView(mItems[position].view))
				{
					return mItems[position].view;
				}
				
				return mItems[position].view ? container.addView(mItems[position].view) : null;
			}
			
			return null;
		}

		// Remove a page for the given position.
		public function destroyItem(container:ViewGroup, item:ListItem):View
		{
			if (item)
			{
				return container.removeView(item.view);
			}
			
			return null;
		}
		
		// Return the Fragment associated with a specified position.
		public function getItem(position:int):ListItem
		{
			if ((mItems.length > 0) && (position >= 0))
			{
				return mItems[position];
			}
			
			return null;
		}
		
		public function getItemByView(view:View):ListItem
		{
			return getItem(getItemPosition(view));
		}		
		
		public function addItem(view:View, colspan:Number = 1.0, rowspan:Number = 1.0):ListItem
		{
			var prevItem:ListItem = mItems.length > 0 ? mItems[mItems.length - 1] : null;
			
			var item:ListItem = new ListItem(view, colspan, rowspan);
			item.setPos((prevItem != null) ? prevItem.getPos() + prevItem.colSpan : 0);

			mItems.push(item);
			dispatchEvent(new ItemEvent("onItemAdded", item));
			
			return item;
		}
		
		public function removeItem(view:View):void
		{
			var removedItems:Vector.<ListItem> = mItems.splice(getItemPosition(view), 1);
			if (removedItems.length > 0) dispatchEvent(new ItemEvent("onItemRemoved", removedItems[0]));
		}
		
		public function clear():void
		{
			var temp:Vector.<ListItem> = mItems;
			mItems = new Vector.<ListItem>();
			
			var count:int = temp.length;
			for (var i:int = 0; i < count; i++ )
			{
				dispatchEvent(new ItemEvent("onItemRemoved", temp[i]));
			}
		}
	}
}