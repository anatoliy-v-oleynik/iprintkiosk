package flashpress.touch
{
	public class TouchData
	{
		public var phase:String;
		public var event:String;
		public var delta:Number;
		public var shift:Number;
		public var startGlobal:Number;
		public var startLocal:Number;
		public function TouchData(phase:String)
		{
			this.phase = phase;
		}
		
		public var stopTouch:Boolean;
		
		public function toString():String
		{
			return '[Touch event:'+event+', phase:'+phase+', delta:'+delta+']';
		}
	}
}