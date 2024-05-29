package flash.external.logging 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.events.EventDispatcher;
	import flash.external.BaseContainer;
	import flash.external.ExternalInterface;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	 
	public class Log extends EventDispatcher
	{
		private var id:String;
		private var classid:String;
		
		public function Log(id:String = "log", classid:String = "clsid:aec53aeb-7d30-4ec4-b1bf-f6c4cecec666" )
		{
			this.id = id;
			this.classid = classid;
			
			var interval:uint = setInterval(function():void { if (BaseContainer.isReady()) { onSetup(); clearInterval(interval) } }, 100, interval);
		}
		
		public function info(message:String, name:String):void
		{
			if (BaseContainer.isReady())
			{
				ExternalInterface.call(" function(id, message, name) { document.getElementById(id).Name = name; document.getElementById(id).Info(message); }", id, message, name);
			}
			else
			{
				trace("[" + name + "]", message);
			}
		}
		
		public function warn(message:String, name:String):void
		{
			if (BaseContainer.isReady())
			{
				ExternalInterface.call(" function(id, message, name) { document.getElementById(id).Name = name; document.getElementById(id).Warn(message); }", id, message, name);
			}
			else
			{
				trace("[" + name + "]", message);
			}
		}		
		
		public function error(message:String, name:String):void
		{
			if (BaseContainer.isReady())
			{		
				ExternalInterface.call(" function(id, message, name) { document.getElementById(id).Name = name; document.getElementById(id).Error(message); }", message, name);
			}
			else
			{
				trace("[" + name + "]", message);
			}		
		}
		
		protected function onSetup():void
		{
			//BaseContainer.createObject(id, classid);
			info("Настройка (" + this.id +  ") выполнена.", "Log");
		}
	}

}