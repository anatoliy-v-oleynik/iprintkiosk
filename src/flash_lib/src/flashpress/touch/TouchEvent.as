package flashpress.touch
{
	import flash.events.Event;

	public class TouchEvent extends Event
	{
		public static const LEFT:String = 'touchEvent_left';
		public static const UP:String = 'touchEvent_up';
		public static const RIGHT:String = 'touchEvent_right';
		public static const DOWN:String = 'touchEvent_down';
		//
		public static const TAP:String = 'touchEvent_tap';
		//
		public var touchData:TouchData;
		public function TouchEvent(type:String, touchData:TouchData=null)
		{
			super(type);
			this.touchData = touchData;
		}
	}
}