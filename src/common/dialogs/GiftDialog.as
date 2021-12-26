package common.dialogs 
{
	import common.button.ClearButton;
	import common.dialogs.button.CancelButton;
	import common.dialogs.button.CloseButton;
	import common.dialogs.button.OkeyButton;
	import common.edit.TextEdit;
	import flash.app.Activity;
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.view.View;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	[Embed(source="../../../lib/assets.swf", symbol="common.dialogs.GiftDialog")]
	public class GiftDialog extends View
	{
		public var _close_btn:CloseButton;
		public var _caption_txt:TextField;
		public var _message_txt:TextField;
		public var _okey_btn:OkeyButton;
		public var _cancel_btn:CancelButton;
		public var _code_edit:TextEdit;
		public var _clear_btn:ClearButton;
		public var _preloader_mc:MovieClip;
		public var _info_txt:TextField;
		
		private var mLoader:URLLoader;
		
		public function GiftDialog(attrs:Object = null) 
		{
			super(attrs);

			Container.current.NotifyUserActivity("Страница использования подарочного сертификата.");
			
			_caption_txt.text = "Погашение подарочных кодов.";

			_close_btn.addEventListener("onClick", onButtonClick);
			_okey_btn.addEventListener("onClick", onButtonClick);
			_cancel_btn.addEventListener("onClick", onButtonClick);
			_clear_btn.addEventListener("onClick", onButtonClick);
			
			_preloader_mc.visible = false;
			_info_txt.visible = false;
		}
		
		protected function onButtonClick(e:Event):void
		{
			switch (e.target.name)
			{
				case "_cancel_btn":
					if (attributes["close"]) attributes["close"]();
					Activity.current.closeDialog();
					break;				
				case "_close_btn":
					if (attributes["close"]) attributes["close"]();
					Activity.current.closeDialog();
					break;
				case "_okey_btn":
					setEnabled(false);
					_preloader_mc.visible = true;
					_info_txt.visible = false;
					
					var data:Object = Container.current.UsePromo(_code_edit.getText());
					
					if (data.response)
					{
						if (attributes["ok"]) attributes["ok"](data.response);
						Activity.current.closeDialog();
					}
					else if (data.error)
					{
						_info_txt.text = "Подарочный код ненайден или уже был использован. Проверьте правильность ввода и повторите попытку.";
						_info_txt.visible = true;
					}
					else
					{
						_info_txt.text = "Непредвиденная ошибка. Попробуйте повторить попытку.";
						_info_txt.visible = true;
					}
					
					_preloader_mc.visible = false;
					setEnabled(true);
					
					//mLoader = new URLLoader();
					//mLoader.dataFormat = URLLoaderDataFormat.BINARY;
					//mLoader.addEventListener(Event.COMPLETE,
					//function (e:Event):void
					//{
						//var data:Object = JSON.parse(e.target.data);
						//if (data.response)
						//{
							//if (attributes["ok"]) attributes["ok"](data.response);
							//Activity.current.closeDialog();
						//}
						//else if (data.error)
						//{
							//_info_txt.text = "Подарочный код ненайден или уже был использован. Проверьте правильность ввода и повторите попытку.";
							//_info_txt.visible = true;
						//}
						//else
						//{
							//_info_txt.text = "Непредвиденная ошибка. Попробуйте повторить попытку.";
							//_info_txt.visible = true;
						//}
						//
						//_preloader_mc.visible = false;
						//setEnabled(true);
					//});
					//mLoader.addEventListener(IOErrorEvent.IO_ERROR,
					//function (e:IOError):void
					//{
						//_info_txt.text = "Непредвиденная ошибка. Попробуйте повторить попытку.";
						//_info_txt.visible = true;
						//_preloader_mc.visible = false;
					//} );
					//mLoader.addEventListener(ProgressEvent.PROGRESS, function (e:ProgressEvent):void { Activity.current.attributes["lastActive"] = new Date(); } );			
					//var request:URLRequest = new URLRequest("http://iprintkiosk.ru/gift.php?code=" + _code_edit.getText() + "&rank_token=" + (Math.random() * getTimer()).toString());
					//request.method = URLRequestMethod.GET;
					//request.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));
					//mLoader.load(request);					
					break;
				case "_clear_btn":
					_code_edit.clearText();
					break;					
			}
		}
	}
}