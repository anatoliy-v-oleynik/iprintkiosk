package flash.view
{
	import flash.errors.IllegalOperationError;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	public class PagerAdapter extends ListAdapter
	{
		private var mPrimaryItem:View;		
		
		public function PagerAdapter()
		{
			super();
		}		

		// This method may be called by the ViewPager to obtain a title string to describe the specified page.
		public function getPageTitle(position:int):String
		{
			throw new IllegalOperationError('this method should be overriden in a subclass');
		}
	}
}