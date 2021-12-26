package vkontakte.activity 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	import common.activity.ErrorActivity;
	import common.button.BackwardButton;
	import common.button.ClearButton;
	import common.button.FindButton;
	import common.button.HomeButton;
	import common.button.PayButton;
	import common.button.SearchButton;
	import common.dialogs.InfoDialog;
	import flash.events.ErrorEvent;
	import common.edit.FindTextEdit;
	import vkontakte.User;
	import vkontakte.edit.PasswordTextEdit;
	import vkontakte.edit.UsernameTextEdit;
	import vkontakte.button.EnterButton;
	import flash.app.Activity;
	import flash.app.Application;
	import flash.content.Context;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;

	import flash.text.TextField;
	import flash.utils.AttributeSet;
	import flash.utils.getTimer;
	import flash.view.View;
	import flash.widget.Button;	
	import flash.net.URLLoaderDataFormat;
	 
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.activity.LoginActivity")]
	public class LoginActivity extends Activity
	{
		public var _backward_btn:BackwardButton;
		public var _home_btn:HomeButton;
		public var _pay_btn:PayButton;
		public var _enter_btn:EnterButton;
		public var _search_btn:SearchButton;
		
		public var _username_textedit:UsernameTextEdit;
		public var _username_textedit_clear_btn:ClearButton;
		public var _password_textedit:PasswordTextEdit;
		public var _password_textedit_clear_btn:ClearButton;
		
		public var _total_price_txt:TextField;
		public var _count_photo_txt:TextField;

		
		public function LoginActivity(attrs:AttributeSet = null) 
		{
			super(attrs);
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
			
			_backward_btn.addEventListener("onClick", onClick);
			_home_btn.addEventListener("onClick", onClick);
			_enter_btn.addEventListener("onClick", onClick);
			_enter_btn.setEnabled(false);
			
			_search_btn.addEventListener("onClick", onClick);
			_search_btn.visible = true;
			
			_username_textedit_clear_btn.addEventListener("onClick", onClick);
			_username_textedit_clear_btn.visible = false;
			_password_textedit_clear_btn.addEventListener("onClick", onClick);
			_password_textedit_clear_btn.visible = false;
			
			_username_textedit.addEventListener("onTextChanged", function (e:TextEvent):void { _enter_btn.setEnabled(_username_textedit.getText() != "" && _password_textedit.getText() != ""); _username_textedit_clear_btn.visible = e.target.getText() != ""; } );
			_username_textedit.addEventListener("onKeyDown", function (e:KeyboardEvent):void
			{
				if (e.keyCode == 13) 
				{
					if (_username_textedit.getText() != "")
					{
						_password_textedit.setFocused(true);
					}
					else
					{
						// требуем ввода логин
					}
				}
			} );
			
			_password_textedit.setPasswordMode(true);
			_password_textedit.addEventListener("onTextChanged", function (e:TextEvent):void { _enter_btn.setEnabled(_username_textedit.getText() != "" && _password_textedit.getText() != ""); _password_textedit_clear_btn.visible = e.target.getText() != ""; } );
			_password_textedit.addEventListener("onKeyDown", function (e:KeyboardEvent):void
			{
				if (e.keyCode == 13) 
				{
					if (_password_textedit.getText() != "")
					{
						if (_username_textedit.getText() != "") 
						{
							signin(_username_textedit.getText(), _password_textedit.getText() );
						}
						else
						{
							_username_textedit.setFocused(true);
						}
					}
					else
					{
						// требуем ввода пароля
					}
				}
			} );
		}
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);

			Container.current.NotifyUserActivity("Страница авторизации vkontakte.");	
			
			Container.current.log.info("Переход на страницу авторизации ВКОНТАКТЕ.", "vkontakte.activity.LoginActivity");
			
			_pay_btn.visible = Order.current.totalCount > 0;
			
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
				case "_enter_btn":
					signin(_username_textedit.getText(), _password_textedit.getText());
					break;
				case "_search_btn":
					startActivity(new SearchActivity(), true);
					break;	
				case "_username_textedit_clear_btn":
					_username_textedit.clearText();
					break;	
				case "_password_textedit_clear_btn":
					_password_textedit.clearText();
					break;						
					
			}
		}		
		
		
		private function user_onSigninStart(e:Event):void
		{
			e.target.removeEventListener(e.type, arguments.callee );
			setEnabled(false);
		}
		
		private function user_onSigninComplete(e:Event):void
		{
			e.target.removeEventListener(e.type, arguments.callee );
			e.target.removeEventListener("onError", user_onError );
			
			startActivity(new ViewActivity( new AttributeSet ( { view_type:"@ID", view_text:e.target.data.user_id, title : "Фотографии пользователя (" + e.target.data.user.first_name + " " + e.target.data.user.last_name + ")." } )), false);
			setEnabled(true);
		}		
		
		private function user_onError(e:ErrorEvent):void
		{
			e.target.removeEventListener(e.type, arguments.callee );
			e.target.removeEventListener("onSigninComplete", user_onSigninComplete );
			
			setEnabled(true);
				
			switch (e.errorID)
			{
				case 5:
					showDialog(new InfoDialog({ caption:"Ошибка входа!!!", message:e.text } ));
					break;
				default:
					startActivity(new ErrorActivity());
					break;
			}
		}		
		
		public function signin(username:String = "@", password:String = "@"):void
		{
			User.current.addEventListener("onSigninStart", user_onSigninStart );
			User.current.addEventListener("onSigninComplete", user_onSigninComplete );
			User.current.addEventListener("onError", user_onError); 
			User.current.signin(username, password );
		}
	}

}