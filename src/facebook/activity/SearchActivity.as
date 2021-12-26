package facebook.activity 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	import common.activity.CartActivity;
	import common.button.BackwardButton;
	import common.button.ClearButton;
	import common.button.FindButton;
	import common.button.HomeButton;
	import common.button.PayButton;
	import common.edit.FindTextEdit;
	import flash.app.Activity;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.AttributeSet;
	import flash.view.View;
	import flash.widget.Button;	
	 
	[Embed(source="../../../lib/assets.swf", symbol="facebook.activity.SearchActivity")]
	public class SearchActivity extends Activity
	{
		public var _backward_btn:BackwardButton;
		public var _home_btn:HomeButton;
		public var _pay_btn:PayButton;
		public var _clear_btn:ClearButton;
		public var _find_btn:FindButton;
		public var _find_textedit_txt:FindTextEdit;
		public var _total_price_txt:TextField;
		public var _count_photo_txt:TextField;
		
		
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
			_find_btn.addEventListener("onClick", onClick);
			_clear_btn.addEventListener("onClick", onClick);

			_find_textedit_txt.addEventListener("onTextChanged", function (e:TextEvent):void { _find_btn.visible = e.target.getText() != ""; _clear_btn.visible = e.target.getText() != ""; } );
			_find_textedit_txt.addEventListener("onKeyDown", function (e:KeyboardEvent):void { if (e.keyCode == 13) find(e.target.getText()); } );
		}
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);
			
			_pay_btn.visible = Order.current.items.length > 0
			_clear_btn.visible = _find_textedit_txt.getText() != ""; 
			_find_btn.visible = _find_textedit_txt.getText() != "";	
			
			_total_price_txt.text = Order.current.totalPrice.toString();
			_count_photo_txt.text = Order.current.totalCount.toString();
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
				case "_clear_btn":
					_find_textedit_txt.clearText();
					break;						
				case "_find_btn":
					find(_find_textedit_txt.getText());
					break;
				case "_pay_btn":
					startActivity(new CartActivity(), true);
					break;						
			}
		}		
		
		public function find(search_text:String):void
		{
			startActivity(new ViewActivity(new AttributeSet( { view_type : "@", view_data: search_text, title: "Найденные пользователи: " + search_text} )));
		}		
	}

}