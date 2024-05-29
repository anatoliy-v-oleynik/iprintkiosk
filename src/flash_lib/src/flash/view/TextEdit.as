package flash.view 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Rectangle;
	import flash.events.FocusEvent;
	import flash.content.Context;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.app.Activity;
	import flash.events.KeyboardEvent;
	import flash.view.keyboard.SoftKeyboard;
	import flash.ui.Keyboard;
	 
	public class TextEdit extends TextView
	{
		private var mCaretIndex:int = -1;
		
		public function TextEdit(attrs:Object = null)
		{
			super();
			//handler.mouseChildren = false;
			setFocusable(true);
			setClickable(true);
			requireSoftKeyboard(true);
			attributes.merge(attrs);
		}
		
		public function requireSoftKeyboard(require:Boolean):void
		{
			attributes["requireSoftKeyboard"] = require;
		}
		
		protected override function onClick(e:MouseEvent):void
		{
			mCaretIndex = content.getCharIndexAtPoint(content.mouseX, content.mouseY);
			super.onClick(e);
		}
		
		protected override function onFocusChanged(gainFocus:Boolean, relatedFocus:View):void
		{
			super.onFocusChanged(gainFocus, relatedFocus);
			
			if (gainFocus)
			{
				if (getHint() == content.text)
				{
					content.text = "";
				}
				
				if (attributes["requireSoftKeyboard"])
				{
					Activity.current.showSoftKeyboard({ lang:attributes["requireLang"] ? attributes["requireLang"] : "EN"});
				}
				else
				{
					Activity.current.hideSoftKeyboard();
				}
				
				var charBoundaries:Rectangle = (content as TextField).getCharBoundaries(mCaretIndex);
			}
			else
			{
				if (content.text == "")
				{
					content.text = getHint();
				}
				
				if ((relatedFocus == null) && attributes["requireSoftKeyboard"])
				{
					Activity.current.hideSoftKeyboard();
				}
				
				this.graphics.clear();
			}
			
			refresh();
		}
		
		protected override function onKeyDown(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.BACKSPACE:
					if (e.keyLocation > 500)
					{
						clearText();
						clearFocus();
					}
					else
					{
						if (content.text != "")
						{
							setText(content.text.substr(0, content.text.length - 1));
						}
					}
					break;
				default:
					appendText(String.fromCharCode(e.charCode));
					break;
			}
			super.onKeyDown(e);
		}
	}

}