package common.activity 
{
	import common.dialogs.DepositDialog;
	import flash.app.Activity;
	import flash.content.Context;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.AttributeSet;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.view.View;
	import flash.widget.Button;
	import instagram.SquareButton;
	import instagram.activity.SearchActivity;
	import vkontakte.SquareButton;
	import vkontakte.activity.LoginActivity;
	import vkontakte.activity.SplashActivity;
	import wifi.SquareButton;
	import wifi.activity.SplashActivity;
	import cards.SquareButton;
	import cards.activity.ViewActivity;
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	[Embed(source="../../../lib/assets.swf", symbol="common.activity.HomeActivity")]
	public class HomeActivity extends Activity
	{
		public var _instagram_btn:instagram.SquareButton;
		public var _vkontakte_btn:vkontakte.SquareButton;
		public var _cards_btn:cards.SquareButton;
		//public var _wifi_btn:wifi.SquareButton;
		
		public function HomeActivity() 
		{
			super();
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
			
			_instagram_btn.addEventListener("onClick", onClick);
			_vkontakte_btn.addEventListener("onClick", onClick);
			_cards_btn.addEventListener("onClick", onClick);
			//_wifi_btn.addEventListener("onClick", onClick);
			
		}
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);
			
			Container.current.NotifyUserActivity("Основная страница iprintkiosk.");
			
			Container.current.log.info("Переход на главную страницу." , "common.activity.HomeActivity");
			
			if (Order.current.deposit > 0)
			{
				showDialog(new DepositDialog( {clear:function():void { Container.current.log.warn("$$$ Обнуление остатка средств (сумма:" + Order.current.deposit + ").", "common.activity.HomeActivity"); Order.current.clear(); } } ));
			}
			else
			{
				Order.current.clear();
			}
		}			
		
		protected function onClick(e:Event):void
		{
			switch (e.target.name)
			{
				case "_instagram_btn":
					startActivity(new instagram.activity.SearchActivity());
					break;
				case "_vkontakte_btn":
					startActivity(new vkontakte.activity.SplashActivity());
					break;
				case "_wifi_btn":
					startActivity(new wifi.activity.SplashActivity());
					break;
				case "_cards_btn":
					startActivity(new cards.activity.ViewActivity());
					break;
			}
		}
		
	}

}