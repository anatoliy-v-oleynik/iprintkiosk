package flash.external.devices 
{
	import flash.app.Activity;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TextEvent;
	import flash.external.BaseContainer;
	import flash.external.ExternalInterface;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	 
	public class BillAcceptor extends EventDispatcher
	{
		
		private var id:String;
		private var classid:String;		
		
		public function BillAcceptor(id:String = "acceptor", classid:String = "clsid:2c2dee90-a750-49c0-a29c-622b4debe0ae") 
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
		
		public function Reset():void
		{
			if (BaseContainer.isReady())
			{
				ExternalInterface.call("function(id) { document.getElementById(id).Reset(); }", this.id);
			}
		}
		
		public function Polling(summ:Number, timeout:int):void
		{
			if (BaseContainer.isReady())
			{
				ExternalInterface.call("function(id, summ, timeout) { document.getElementById(id).Polling(summ, timeout); }", this.id, summ, timeout);
			}
		}
		
		protected function onSetup():void
		{
			BaseContainer.createObject(id, classid);
			BaseContainer.registerEventHandler(id, "OnAccepted", onAccepted);
			BaseContainer.registerEventHandler(id, "OnStacked", onStacked, "valuta, nominal"); 
			BaseContainer.registerEventHandler(id, "OnReturned", onReturned, "valuta, nominal"); 
			BaseContainer.registerEventHandler(id, "OnError", onError, "number, description"); 
			BaseContainer.registerEventHandler(id, "OnData", onData, "data"); 
			
			Enable();
			Reset();
			Disable();
		}
		
		protected function onAccepted():void
		{
			dispatchEvent(new Event("onAccepted"));
		}
		
		protected function onStacked(valuta:String, nominal:Number):void
		{
			dispatchEvent(new AcceptorEvent("onStacked", valuta, nominal));
		}
		
		protected function onReturned(valuta:String, nominal:Number):void
		{
			dispatchEvent(new AcceptorEvent("onReturned", valuta, nominal));
		}
		
		protected function onError(number:int, description:String):void
		{
			dispatchEvent(new ErrorEvent("onError", false, false, description, number));
		}

		protected function onData(data:String):void
		{
			dispatchEvent(new TextEvent("onData", false, false, data));
		}		
		
	}

}