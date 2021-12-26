package vkontakte 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	import flash.app.Activity;
	import flash.net.*;
	import flash.events.*;
	import flash.content.Context;
	import flash.utils.getTimer;
	 
	public class User extends EventDispatcher
	{
		public static const current:User = new User();
		
		private var mLoader:URLLoader;
		private var mKid:String;
		private var mSigned:Boolean;
		private var mUsername:String;
		private var mPassword:String;
		private var mData:Object;
		
		public function User() 
		{
			super();
			mKid = Context.base.loaderInfo.parameters["kid"] ? Context.base.loaderInfo.parameters["kid"] : "iprintkiosk";
			mSigned = false;
			mUsername = "";
			mPassword = "";
		}
		
		public function get data():Object
		{
			return mData;
		}
		
		public function get signed():Boolean
		{
			return mSigned;
		}
		
		public function get username():String
		{
			return mUsername;
		}		
		
		public function isAppUser():Boolean
		{
			return mUsername == Context.base.loaderInfo.parameters["vk_username"] ? Context.base.loaderInfo.parameters["vk_username"] : "iprintkiosk@mail.ru";
		}
		
		public function signin(username:String = "@", password:String = "@"):void
		{
			try
			{
				if (!mLoader)
				{
					mUsername = username == "@" ? (Context.base.loaderInfo.parameters["vk_username"] ? Context.base.loaderInfo.parameters["vk_username"] : "iprintkiosk@mail.ru") : username;
					mPassword = password == "@" ? (Context.base.loaderInfo.parameters["vk_password"] ? Context.base.loaderInfo.parameters["vk_password"] : "@A77315419z") : password;
					
					mLoader = new URLLoader();
					mLoader.dataFormat = URLLoaderDataFormat.TEXT;			
					mLoader.addEventListener(Event.COMPLETE, onLoaderComplete);
					mLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
					mLoader.addEventListener(ProgressEvent.PROGRESS, function ():void { Activity.current.attributes["lastActive"] = new Date(); } );
					var request:URLRequest = new URLRequest("http://iprintkiosk.ru/vkontakte/login.php?username=" + mUsername + "&password=" + mPassword + "&kid=" + mKid + "&r=" + (Math.random() * getTimer()).toString());
					request.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));				
					mLoader.load(request);
					onSigninStart();
				}
			}
			catch (ex:Error)
			{
				onError(ex.message, ex.errorID);
			}
		}
		
		public function signout():void
		{
			mData = null;
			mLoader = null;
			mUsername = "";
			mSigned = false;
		}
		
		private function onLoaderError(e:IOErrorEvent):void
		{
			onError(e.text, e.errorID);
		}
		
		private function onLoaderComplete(e:Event):void
		{
			e.target.removeEventListener(e.type, arguments.callee);
			e.target.close();
			
			trace(URLLoader(e.target).data);
			
			try
			{
				mData = JSON.parse(URLLoader(e.target).data);

				if (mData.access_token)
				{
					onSigninComplete();
				}
				else
				{
					if (mData.meta && mData.meta.error_type)
					{
						switch (mData.meta.error_type)
						{
							case "OAuthException":
								throw new Error("Пожалуйста, проверьте правильность \rнаписания логина и пароля.\r- Возможно, нажата клавиша CAPS-lock?\r- Может быть, у Вас включена неправильная раскладка? (русская или английская)", 5);
								break;
							default:
								throw new Error(URLLoader(e.target).data);
								break;
						}
					}
					else
					{
						throw new Error(URLLoader(e.target).data);
					}
				}
			}
			catch (ex:Error)
			{
				onError(ex.message, ex.errorID);
			}
		}
		
		protected function onSigninStart():void
		{
			dispatchEvent(new Event("onSigninStart"));
		}		
		
		protected function onSigninComplete():void
		{
			mLoader = null;
			mSigned = true;
			dispatchEvent(new Event("onSigninComplete"));
		}
		
		protected function onError(message:String, id:* = 0):void
		{
			mData = null;
			mLoader = null;
			mUsername = "";
			mSigned = false;
			
			dispatchEvent(new ErrorEvent("onError", false, false, message, id));
		}
	}

}