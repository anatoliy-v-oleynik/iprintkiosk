package flash.app 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.content.Context;
	import flash.view.View;
	
	public class Application extends Context
	{
		
		public static var current:Application;
		
		public function Application() 
		{
			super();
		}
		
		public function getActivityIdleTimeout():int
		{
			return 60000;
		}
	}

}