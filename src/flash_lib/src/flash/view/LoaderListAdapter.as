package flash.view
{
	import flash.errors.IllegalOperationError;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.view.events.ItemEvent;
	import flash.view.ListItem;

	public class LoaderListAdapter extends ListAdapter
	{
		public function LoaderListAdapter()
		{
			super();
		}		
		
		public function getTotalCount():int
		{
			return -1;
		}

		public function load(count:int = 20, clearList:Boolean = false, ... rest):void
		{
	
		}

		public function loadNext(count:int = 20):Boolean
		{
			return false;
		}

	}
}