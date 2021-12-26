package 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import com.greensock.loading.LoaderMax;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.external.BaseContainer;
	import flash.external.ExternalInterface;
	import flash.external.devices.BillAcceptor;
	import flash.external.logging.Log;
	import flash.utils.Base64;
	import flash.utils.Timer;
	import flash.utils.ByteArray;
	import flash.system.System;
	import flash.utils.setInterval;
	import flash.app.Activity;
	import flash.app.Application;
	import flash.utils.getTimer;
	import flash.utils.getQualifiedClassName;
	import flash.globalization.DateTimeFormatter;
	import flash.utils.Base64;
	
	
	public class Container extends BaseContainer
	{
		public static var current:Container;
		
		{
			current = new Container();
		}
		
		public const acceptor:BillAcceptor = new BillAcceptor();
		
		public function Container() 
		{
			System.useCodePage = true;
		
			setInterval(
			function():void
			{
				if (BaseContainer.isReady())
				{
					ExternalInterface.call("NotifyFlashAlive", getQualifiedClassName(Activity.current));
				}
				
			}, 5 * 60 * 1000);
			
			super();
		}
		
		public function GetFiles(path:String, ext:String):String
		{
			log.info("Получить список файлов (" + path + ")" , "Container");
			
			if (BaseContainer.isReady())
			{
				var files:String = ExternalInterface.call("GetFiles", path, ext);
				
				log.info(files, "Container");
				
				return files;
			}
			
			return "";
		}		
		
		public function SaveToFile(data:String, filename:String):void
		{
			log.info("Запись в фаил (" + filename + ")" , "Container");
			
			if (BaseContainer.isReady())
			{
				ExternalInterface.marshallExceptions = true;
				
				try
				{
					ExternalInterface.call("SaveFile", data, filename);
				}
				catch (e:Error)
				{
					log.error("SaveToFile ERROR:" + e.message , "Container");
				}
				
				ExternalInterface.marshallExceptions = false;
			}
		}
		
		public function PrintPhoto(data:String, price:Number):String
		{
			if (BaseContainer.isReady())
			{
				var filename:String = ExternalInterface.call("PrintPhoto", data, price);
				log.info("Фотография записана в фаил \"" + (filename.length > 0 ? filename : "ОШИБКА") + "\"", "Container");
				return filename;
			}
			return "";
		}		
		
		public function UsePromo(code:String):Object
		{
			if (BaseContainer.isReady())
			{
				return JSON.parse(ExternalInterface.call("UsePromo", code));
			}
			return JSON.parse("{ error : { message: \"Ошибочка вышла, нужно позвонить в техническую поддержку.\" } }");
		}	
		
		public function Logging(message:String, section:String = ""):void
		{
			if (BaseContainer.isReady())
			{
				ExternalInterface.call("Logging", encodeURIComponent(message), section);
			}
		}			
		
		
		public function NotifyUserActivity(note:String):void
		{
			if (BaseContainer.isReady())
			{
				ExternalInterface.call("NotifyUserActivity", encodeURIComponent(note));
			}
		}			
		
		public function Shutdown(note:String):void
		{
			if (BaseContainer.isReady())
			{
				ExternalInterface.call("Shutdown", encodeURIComponent(note));
			}
		}
		
		protected function GetSystemInfo():String
		{
			return "<System><freeMemory>" + System.freeMemory.toString() + "</freeMemory><privateMemory>" + System.privateMemory.toString() + "</privateMemory><totalMemory>" + System.totalMemory.toString() + "</totalMemory><totalMemoryNumber>" + System.totalMemoryNumber.toString() + "</totalMemoryNumber><processCPUUsage>" + System.processCPUUsage.toString() + "</processCPUUsage></System>" ;
		}

		
		override protected function onSetup():void 
		{
			super.onSetup();
			
			ExternalInterface.addCallback("GetSystemInfo", GetSystemInfo);
		}
		
	}
}

