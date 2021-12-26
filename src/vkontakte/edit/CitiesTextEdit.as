package vkontakte.edit 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.view.LoaderListAdapter;
	import flash.view.TextEdit;
	import flash.view.View;
	import flash.view.events.ItemEvent;
	import flash.widget.Button;
	import vkontakte.view.CitiesGridView;
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.edit.CitiesTextEdit")]
	public class CitiesTextEdit extends TextEdit
	{
		public var _selector:CitiesGridView;
		public var adapter:LoaderListAdapter;
		
		public function CitiesTextEdit() 
		{
			super();
			
			attributes["requireLang"] = "RU";
			
			adapter = new CitiesGridView.defaultAdapterClass();			
			adapter.addEventListener("onLoadComplete",
				function (e:Event):void
				{
					if (e.target.getItem(0))
					{
						attributes["change"] = ((getTag() == null) || (getTag() && getTag().id != e.target.getItem(0).view.getTag().id));
						if ((_selector == null) && (attributes["change"]))
						{
							attributes["change"] = true;
							setTag(e.target.getItem(0).view.getTag());
							setText(e.target.getItem(0).view.getTag().title);
						}
						else if ((_selector != null) && (attributes["change"]))
						{
							attributes["change"] = false;
							setTag(e.target.getItem(0).view.getTag());
							
						}
						else
						{
							attributes["change"] = false;
						}
					}
					else
					{
						attributes["change"] = false;
					}
				} );			
		}
		
		private function selector_onItemClick(e:ItemEvent):void
		{
			e.target.removeEventListener(e.type, arguments.callee);

			if (e.item == null) return;
			//attributes["change"] = ((getTag() == null) || (getTag() && getTag().id != e.item.view.getTag().id));
			attributes["change"] = true;
			if (attributes["change"]) setTag(e.item.view.getTag()); 
			clearFocus();

		}		
		
		protected override function onFocusChanged(gainFocus:Boolean, relatedFocus:View):void
		{
			super.onFocusChanged(gainFocus, relatedFocus);
			
			if (gainFocus && _selector != null) 
			{
				attributes["change"] = false;
				_selector.setAdapter(adapter);
				_selector.addEventListener("onItemClick", selector_onItemClick);
				clearText();
			}
			else if (attributes["change"])
			{
				attributes["change"] = false;
				setText(getTag().title);
				dispatchEvent(new Event("onChanged"));
			}
			else
			{
				setText(getTag().title);
			}
		}
		
		protected override function onTextChanged(text:String, start:int, lengthAfter:int):void
		{
			super.onTextChanged(text, start, lengthAfter);
			
			if (!attributes["change"]) 
			{
				adapter.load(_selector ? 4 : 1, true, attributes["country_id"] ? "country_id=" + attributes["country_id"] : "country_id=1", getText() != "" ? "need_all=0" : "need_all=1", getText() != "" ? "q=" + encodeURI(getText()) : "qq="); 
			}
		}
	}

}

