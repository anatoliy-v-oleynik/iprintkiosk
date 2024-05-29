package flash.external.devices 
{
	import flash.app.Activity;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.BaseContainer;
	import flash.external.ExternalInterface;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	 
	public class CardReader extends EventDispatcher
	{
		
		private var id:String;
		private var classid:String;		
		
		public function CardReader(id:String = "cardreader", classid:String = "clsid:34e7390f-85fb-4abd-a29c-b326834565ba") 
		{
			this.id = id;
			this.classid = classid;
			
			var interval:uint = setInterval(function():void { if (BaseContainer.isReady()) { onSetup(); clearInterval(interval) } }, 100, interval);
		}

		public function Enable():void
		{
			if (BaseContainer.isReady())
			{
				ExternalInterface.call("function(id) { document.getElementById(id).Enable = true; }", this.id);
			}
		}
		
		public function Disable():void
		{
			if (BaseContainer.isReady())
			{
				ExternalInterface.call("function(id) { document.getElementById(id).Enable = false; }", this.id);
			}
		}
		
		public function SessionComplete():void
		{
			if (BaseContainer.isReady())
			{
				ExternalInterface.call("function(id) { document.getElementById(id).SessionComplete(); }", this.id);
			}
		}
		
		public function VendRequest(summ:Number):void
		{
			if (BaseContainer.isReady())
			{
				ExternalInterface.call("function(id, summ) { document.getElementById(id).VendRequest(summ); }", this.id, summ);
			}
		}
		
		protected function onSetup():void
		{
			BaseContainer.createObject(id, classid);
			BaseContainer.registerEventHandler(id, "onVendApproved", onVendApproved);
			BaseContainer.registerEventHandler(id, "onVendDenied", onVendDenied); 
			BaseContainer.registerEventHandler(id, "onBeginSession", onBeginSession); 
			BaseContainer.registerEventHandler(id, "onEndSession", onEndSession);
			BaseContainer.registerEventHandler(id, "onData", onData, "data"); 
			BaseContainer.registerEventHandler(id, "onError", onError, "msg");
		}
		
		protected function onVendApproved():void
		{
			dispatchEvent(new Event("onVendApproved"));
		}

		protected function onVendDenied():void
		{
			dispatchEvent(new Event("onVendDenied"));
		}
		
		protected function onBeginSession():void
		{
			dispatchEvent(new Event("onBeginSession"));
		}
		
		protected function onEndSession():void
		{
			dispatchEvent(new Event("onEndSession"));
		}
		
		protected function onData(data:String):void
		{
			dispatchEvent(new Event("onData"));
		}		
		
		protected function onError(msg:String):void
		{
			dispatchEvent(new Event("onError"));
		}
	}

}