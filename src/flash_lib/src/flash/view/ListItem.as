package flash.view  {
	
	import flash.events.Event;
	import flash.view.View;
	
	public class ListItem
	{
		private var mView:View;
		private var mColSpan:Number;
		private var mRowSpan:Number;
		private var mPos:Number;
		
		public function ListItem(view:View, colspan:Number = 1.0, rowspan:Number = 1.0)
		{
			mView = view;
			mColSpan = colspan;
			mRowSpan = rowspan;
		}
		
		public function get view():View
		{
			return mView;
		}
		
		public function get colSpan():Number
		{
			return mColSpan;
		}
		
		public function get rowSpan():Number
		{
			return mRowSpan;
		}
		
		public function setPos(pos:Number):void
		{
			mPos = pos;
		}
		
		public function getPos():Number
		{
			return mPos;
		}
	}
}
