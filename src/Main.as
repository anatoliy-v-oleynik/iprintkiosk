package
{
	import common.activity.HomeActivity;
	import flash.app.Application;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import instagram.activity.SearchActivity;
	import instagram.SquareButton;
	import vkontakte.SquareButton;
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	public class Main extends Application
	{
		public function Main() 
		{
			super();
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
			
			trace("TEST");
			
			Container.current.log.info("Запуск приложения." , "Main");
			
			startActivity(new HomeActivity());
		}
	}
}