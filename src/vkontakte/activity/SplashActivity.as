package vkontakte.activity 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	import common.activity.CartActivity;
	import common.button.BackwardButton;
	import common.button.ClearButton;
	import common.button.HomeButton;
	import common.button.LoginButton;
	import common.button.LogoutButton;
	import common.button.PayButton;
	import common.button.SpinnerButton;
	import flash.app.Activity;
	import flash.app.Application;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.AttributeSet;
	import flash.view.View;
	import flash.widget.Button;	
	import vkontakte.User;
	import vkontakte.button.FindButton;
	import vkontakte.button.SplashLoginButton;
	import vkontakte.button.SplashSearchButton;
	import vkontakte.edit.CitiesTextEdit;
	import vkontakte.edit.CountriesTextEdit;
	import vkontakte.edit.FindTextEdit;
	import vkontakte.view.CitiesGridView;
	import vkontakte.view.CountriesGridView;
	import vkontakte.view.LoginPrompt;
	import common.view.EmptyView;
	import vkontakte.view.CountersBar;
	 
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.activity.SplashActivity")]
	public class SplashActivity extends Activity
	{
		public var _counters:CountersBar;
		public var _total_price_txt:TextField;
		public var _count_photo_txt:TextField;		
		public var _backward_btn:BackwardButton;
		public var _home_btn:HomeButton;
		public var _pay_btn:PayButton;
		public var _login_btn:SplashLoginButton;
		public var _search_btn:SplashSearchButton;

		
		public function SplashActivity(attrs:AttributeSet = null) 
		{
			super(attrs);
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
			
			_backward_btn.addEventListener("onClick", onClick);
			_home_btn.addEventListener("onClick", onClick);
			_pay_btn.addEventListener("onClick", onClick);
			_login_btn.addEventListener("onClick", onClick);
			_search_btn.addEventListener("onClick", onClick);
		}
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);

			Container.current.NotifyUserActivity("Страница заставки vkontakte.");	
			
			if (User.current.signed)
			{
				_counters.visible = !User.current.isAppUser();
				_counters._photos_btn.setText(User.current.data.user.counters.photos);
				_counters._friends_btn.setText(User.current.data.user.counters.friends);
			}
			else
			{
				_counters.visible = false;
				User.current.signin();
			}
			
			_pay_btn.visible = Order.current.items.length > 0;
			_total_price_txt.text = Order.current.totalPrice.toString();
			_count_photo_txt.text =  (Order.current.totalCount % 2 != 0) ? Order.current.totalCount.toString() + " + 1" : Order.current.totalCount.toString();
		}
		
		protected function onClick(e:Event):void
		{
			switch (e.target.name)
			{
				case "_backward_btn":
					Activity.current.backward();
					break;
				case "_home_btn":
					startActivity(Activity.list[0]);
					break;
				case "_pay_btn":
					startActivity(new CartActivity(), true);
					break;
				case "_login_btn":
					startActivity(new LoginActivity(), true);
					break;
				case "_search_btn":
					startActivity(new SearchActivity(), true);
					break;					
			}
		}
	}
}