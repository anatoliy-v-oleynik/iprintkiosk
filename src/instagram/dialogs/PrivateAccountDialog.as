package instagram.dialogs 
{
	import common.dialogs.button.CancelButton;
	import common.dialogs.button.CloseButton;
	import common.dialogs.button.OkeyButton;
	import flash.app.Activity;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.view.View;
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	[Embed(source="../../../lib/assets.swf", symbol="instagram.dialogs.PrivateAccountDialog")]
	public class PrivateAccountDialog extends View
	{
		public var _close_btn:CloseButton;
		public var _caption_txt:TextField;
		public var _message_txt:TextField;
		public var _okey_btn:OkeyButton;
		public var _cancel_btn:CancelButton;
		
		public function PrivateAccountDialog(attrs:Object = null) 
		{
			super(attrs);

			if (attributes["caption"])
			{
				_caption_txt.text = attributes["caption"];
			}
			
			if (attributes["message"])
			{
				_message_txt.text = attributes["message"];
			}
			
			_close_btn.addEventListener("onClick", onButtonClick);
			_okey_btn.addEventListener("onClick", onButtonClick);
			_cancel_btn.addEventListener("onClick", onButtonClick);
		}
		
		protected function onButtonClick(e:Event):void
		{
			switch (e.target.name)
			{
				case "_close_btn":
					if (attributes["close"]) attributes["close"]();
					Activity.current.closeDialog();
					break;
				case "_okey_btn":
					if (attributes["ok"]) attributes["ok"]();
					Activity.current.closeDialog();
					break;
				case "_cancel_btn":
					if (attributes["cancel"]) attributes["cancel"]();
					Activity.current.closeDialog();
					break;					
			}
		}
		
	}

}