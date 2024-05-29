package flash.external 
{
	import flash.events.EventDispatcher;
	import flash.external.logging.Log;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	public class BaseContainer extends EventDispatcher
	{
	
		public const log:Log = new Log();
		
		public function BaseContainer() 
		{
			super();
			
			var interval:uint = setInterval(function():void { if (BaseContainer.isReady()) { onSetup(); clearInterval(interval) } }, 100, interval);
		}
		
		public static function isReady():Boolean
		{
			return ExternalInterface.available && ExternalInterface.call("isContainerReady");
			
			//return ExternalInterface.available && ExternalInterface.call("function() { return document.readyState === 'complete'; }");
		}
		
		public static function createObject(id:String, classid:String, ...rest):void
		{
			//ExternalInterface.call("function (id, classid)  { var obj  = document.createElement(\"<object id='\" + id + \"' classid='\" + classid + \"'>\"); document.body.appendChild(obj); } ", id, classid);
		}
		
		public static function registerEventHandler(id:String, name:String, handler:Function, params:String = ""):void
		{
			//ExternalInterface.call("function (id, o, event)  { var obj  = document.createElement(\"<script language='javascript' for='\" + id + \"' event='\" + event + \"'>\"); obj.text = o + \".\" + id + \"_\" + event + \";\"; document.body.appendChild(obj); } ", id, ExternalInterface.objectID, name + "(" + params + ")");
			ExternalInterface.addCallback(id + "_" + name, handler);
		}
		
		protected function onSetup():void
		{
			ExternalInterface.addCallback("KeepAlive", KeepAlive);
		}
		
		protected function KeepAlive():Boolean
		{
			return true;
		}		
		
	}

}