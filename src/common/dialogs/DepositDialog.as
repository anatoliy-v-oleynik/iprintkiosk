package common.dialogs 
{
	import common.dialogs.button.CloseButton;
	import common.dialogs.button.OkeyButton;
	import flash.app.Activity;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.view.View;
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	[Embed(source="../../../lib/assets.swf", symbol="common.dialogs.DepositDialog")]
	public class DepositDialog extends View
	{
		public var _close_btn:CloseButton;
		public var _caption_txt:TextField;
		public var _message_txt:TextField;
		public var _okey_btn:OkeyButton;
		
		
		private var timer:uint;
		
		public function DepositDialog(attrs:Object = null) 
		{
			super(attrs);

			_caption_txt.text = "Внимание!!!";

			_close_btn.addEventListener("onClick", onButtonClick);
			_okey_btn.addEventListener("onClick", onButtonClick);
			
			timer = setTimeout(function ():void {if (attributes["clear"]) attributes["clear"](); Activity.current.closeDialog(); } , 1000 * 60 * 1);
		}
		
		protected function onButtonClick(e:Event):void
		{
			switch (e.target.name)
			{
				case "_close_btn":
					clearTimeout(timer);
					if (attributes["close"]) attributes["close"]();
					Activity.current.closeDialog();
					break;
				case "_okey_btn":
					clearTimeout(timer);
					if (attributes["ok"]) attributes["ok"]();
					Activity.current.closeDialog();
					break;
			}
		}
		
	}

}