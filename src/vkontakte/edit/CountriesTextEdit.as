package vkontakte.edit 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.view.ListItem;
	import flash.view.LoaderListAdapter;
	import flash.view.TextEdit;
	import flash.view.View;
	import flash.view.events.ItemEvent;
	import flash.widget.Button;
	import vkontakte.view.CountriesGridView;
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.edit.CountriesTextEdit")]
	public class CountriesTextEdit extends TextEdit
	{
		public var _selector:CountriesGridView;
		
		public function CountriesTextEdit() 
		{
			super();
			
			attributes["requireLang"] = "RU";
			attributes["requireSoftKeyboard"] = false;
		}
		
		
		private function selector_onItemClick(e:ItemEvent):void
		{
			attributes["change"] = getTag().id != (e.item.view as Button).getTag().id;
			setTag((e.item.view as Button).getTag());
			setText((e.item.view as Button).getText());
			
			clearFocus();
		}
		
		protected override function onFocusChanged(gainFocus:Boolean, relatedFocus:View):void
		{
			super.onFocusChanged(gainFocus, relatedFocus);

			if (gainFocus && _selector != null) 
			{
				attributes["change"] = false;
				_selector.addEventListener("onItemClick", selector_onItemClick);
				_selector.setAdapter(new CountriesGridView.defaultAdapterClass());
				(_selector.getAdapter() as LoaderListAdapter).load(30, true, "need_all=0"); 
			}
			else if (attributes["change"])
			{
				dispatchEvent(new Event("onChanged"));
			}
		}

	}

}