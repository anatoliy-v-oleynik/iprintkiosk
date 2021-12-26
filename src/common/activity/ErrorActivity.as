package common.activity 
{
	import common.button.BackwardButton;
	import flash.app.Activity;
	import flash.content.Context;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.AttributeSet;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.view.View;
	import flash.widget.Button;
	import instagram.activity.SearchActivity;
	import vkontakte.SquareButton;
	import instagram.SquareButton;
	import vkontakte.activity.LoginActivity;
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	[Embed(source="../../../lib/assets.swf", symbol="common.activity.ErrorActivity")]
	public class ErrorActivity extends Activity
	{
		public var _backward_btn:BackwardButton;
		public var _message_txt:TextField;
		
		public function ErrorActivity(attrs:AttributeSet = null) 
		{
			super(attrs);
			
			_backward_btn.addEventListener("onClick", onClick);
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
			
			_message_txt.text = attributes["message"] ?  attributes["message"] : "попробуйте вернуться назад\rи повторить попытку";
		}
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);
			
			Container.current.NotifyUserActivity("Страница ошибки iprintkiosk.");
			
			Container.current.log.info("Переход на страницу ошибки.\r***\r" + attributes["message"] + "\r***", "common.activity.ErrorActivity");
		}
		
		protected function onClick(e:Event):void
		{
			switch (e.target.name)
			{
				case "_backward_btn": 
					Activity.current.backward();
					break;
			}
		}
	}

}