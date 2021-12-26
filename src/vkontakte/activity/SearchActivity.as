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
	import vkontakte.edit.CitiesTextEdit;
	import vkontakte.edit.CountriesTextEdit;
	import vkontakte.edit.FindTextEdit;
	import vkontakte.view.CitiesGridView;
	import vkontakte.view.CountriesGridView;
	import vkontakte.view.LoginPrompt;
	import common.view.EmptyView;
	import vkontakte.view.CountersBar;
	 
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.activity.SearchActivity")]
	public class SearchActivity extends Activity
	{
		public var _counters:CountersBar;
		public var _total_price_txt:TextField;
		public var _count_photo_txt:TextField;		
		public var _backward_btn:BackwardButton;
		public var _home_btn:HomeButton;
		public var _pay_btn:PayButton;
		public var _login_btn:LoginButton;
		public var _logout_btn:LogoutButton;
		
		public var _find_btn:FindButton;
		public var _find_textedit:FindTextEdit;
		public var _find_textedit_clear_btn:MovieClip;
		public var _countries_textedit:CountriesTextEdit;
		public var _cities_textedit:CitiesTextEdit;
		
		public function SearchActivity(attrs:AttributeSet = null) 
		{
			super(attrs);
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
			
			_backward_btn.addEventListener("onClick", onClick);
			_home_btn.addEventListener("onClick", onClick);
			_pay_btn.addEventListener("onClick", onClick);
			_login_btn.visible = false;
			_login_btn.addEventListener("onClick", onClick);
			_logout_btn.visible = false;
			_logout_btn.addEventListener("onClick", onClick);
			_find_btn.setEnabled(false);
			_find_btn.addEventListener("onClick", onClick);
			_find_textedit.addEventListener("onTextChanged", function (e:TextEvent):void { _find_btn.setEnabled(e.target.getText() != ""); _find_textedit_clear_btn.visible = e.target.getText() != ""; } );
			_find_textedit.addEventListener("onKeyDown", function (e:KeyboardEvent):void { if (e.keyCode == 13) find(_find_textedit.getText(), _countries_textedit.getTag().id, _cities_textedit.getTag().id); } );
			_find_textedit_clear_btn.addEventListener("onClick", onClick);
			
			_countries_textedit.setText("Россия");
			_countries_textedit.setTag( { id:1, title:"Россия" } );
			_countries_textedit.addEventListener("onChanged", function (e:Event):void { _cities_textedit.attributes["country_id"] = e.target.getTag().id; _cities_textedit.clearText(); } );
			
			_cities_textedit.attributes["country_id"] = 1;
			_cities_textedit.setText("Мурманск");
		}
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);

			Container.current.NotifyUserActivity("Страница поиска в vkontakte.");		
			
			if (User.current.signed)
			{
				_counters.visible = !User.current.isAppUser();
				_counters._photos_btn.setText(User.current.data.user.counters.photos);
				_counters._friends_btn.setText(User.current.data.user.counters.friends);
				_login_btn.visible = User.current.isAppUser();
				_logout_btn.visible = !User.current.isAppUser();
			}
			else
			{
				_counters.visible = false;
				_login_btn.visible = true;
				_logout_btn.visible = false;
					
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
				case "_find_textedit_clear_btn":
					_find_textedit.clearText();
					break;
				case "_find_btn":
					find(_find_textedit.getText(), _countries_textedit.getTag().id, _cities_textedit.getTag().id);
					break;
				case "_login_btn":
					startActivity(new LoginActivity(), true);
					break;
			}
		}
		
		public function find(text:String, country_id:int, city_id:int):void
		{
			startActivity(new ViewActivity( new AttributeSet ( { view_type : "@SEARCH", view_text : text, view_country_id : country_id, view_city_id : city_id, title : "Результат поиска ( " + text + " )." } )), false);
		}
	}
}