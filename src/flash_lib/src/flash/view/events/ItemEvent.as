package flash.view.events  {
	
	import flash.events.Event;
	import flash.view.View;
	import flash.events.MouseEvent;
	import flash.view.ListItem;
	
	public class ItemEvent extends Event
	{
		public var item:ListItem;
		public var delta:int;
		public var relatedObject:Object;
		
		public function ItemEvent(type:String, item:ListItem, relatedObject:Object = null, bubbles:Boolean = false, cancelable:Boolean = false, delta:int = 0)
		{
			super(type, bubbles, cancelable);
			this.item = item;
			this.delta = delta;
			this.relatedObject = relatedObject;
		}
	}
}
