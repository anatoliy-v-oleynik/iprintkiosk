package flash.view 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.fonts.Arial;
	import flash.geom.Rectangle;
	import flash.events.FocusEvent;
	import flash.content.Context;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.app.Activity;
	import flash.utils.AttributeSet;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.FontType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.sampler.NewObjectSample;
	import flash.utils.getDefinitionByName;
	import flash.system.ApplicationDomain;
	
	public class TextView extends View
	{
		
		public static var DefaultFont:Font;
	
		{
			DefaultFont = Font.enumerateFonts(true).filter(function (item:*, index:int, array:Array):Boolean { return item.fontName == "Arial" && item.fontType == FontType.EMBEDDED && item.fontStyle == FontStyle.REGULAR; })[0];
			
			if (DefaultFont == null)
			{
				DefaultFont = Font.enumerateFonts(true).filter(function (item:*, index:int, array:Array):Boolean { return item.fontName == "Arial" && item.fontType == FontType.DEVICE && item.fontStyle == FontStyle.REGULAR; })[0];
				
				if (DefaultFont == null)
				{
					DefaultFont = Font.enumerateFonts(true).filter(function (item:*, index:int, array:Array):Boolean { return item.fontName == "_sans" })[0];
				}
			}
		}
	
		public var _content:TextField;

		public function TextView(attrs:Object = null)
		{
			super();
			
			if (_content)
			{
				_content.mouseEnabled = false;
				attributes["hint"] = _content.text;
				attributes["singleLine"] = !_content.multiline;
				attributes["textColor"] = _content.textColor;
				attributes["hintTextColor"] = _content.textColor;
				attributes["textSize"] = _content.defaultTextFormat.size;
				attributes["textHorizontalAlign"] = _content.defaultTextFormat.align;
				attributes["textVerticalAlign"] = "none";
			}
			else
			{
				setContentView(new TextField());
			}
			
			attributes.merge(attrs);
			refresh();
		}

		public function refresh():void
		{

		}

		public function appendText(text:String):void
		{
			content.appendText(text);
			attributes["text"] = content.text;
			onTextChanged(attributes["text"], 0, attributes["text"].length);
		}

		public function setText(text:String):void
		{
			if (attributes["text"] != text)
			{
				attributes["text"] = text;
				onTextChanged(attributes["text"], 0, attributes["text"].length);
			}
		}
		
		public function getText():String
		{
			if (attributes["text"] == null)
			{
				return "";
			}
			
			return attributes["text"];
		}
		
		public function setHint(hint:String):void
		{
			if (attributes["hint"] != hint)
			{
				attributes["hint"] = hint;
			}
		}
		
		public function getHint():String
		{
			if (attributes["hint"] == null)
			{
				return "";
			}
			
			return attributes["hint"];
		}		
		
		public function clearText():void
		{
			if (attributes["text"])
			{	
				var old_text:String = attributes["text"];
				attributes["text"] = "";
				onTextChanged(attributes["text"], 0, old_text.length);
			}
		}
		
		public function setTextFormat(textFormat:TextFormat, asDefault:Boolean = true, beginIndex:int = -1, endIndex:int = -1):void
		{
//			if (asDefault)
//			{
//				content.defaultTextFormat = textFormat;
//			}
//			content.setTextFormat(textFormat, beginIndex, endIndex);
		}
		
		public function getFont():Font
		{
			if (attributes["font"] == null)
			{
				attributes["font"] = TextView.DefaultFont;
			}

			return attributes["font"];
		}
		
		public function setFont(font:Font):void
		{
			if (attributes["font"] != font)
			{
				attributes["font"] = font;
			}
		}		
		
		public function getHintTextColor():int
		{
			if (attributes["hintTextColor"] != null)
			{
				return attributes["hintTextColor"];
			}
			
			return 0x000000;
		}
		
		public function setHintTextColor(color:int, beginIndex:int = -1, endIndex:int = -1):void
		{
			if (attributes["hintTextColor"] != color)
			{
				attributes["hintTextColor"] = color;
				refresh();
			}
		}		
		
		public function getTextColor():int
		{
			if (attributes["textColor"] != null)
			{
				return attributes["textColor"];
			}
			
			return 0x000000;
		}
		
		public function setTextColor(color:int, beginIndex:int = -1, endIndex:int = -1):void
		{
			if (attributes["textColor"] != color)
			{
				attributes["textColor"] = color;
				refresh();
			}
		}
		
		public function getTextSize():int
		{
			if (attributes["textSize"])
			{
				return attributes["textSize"];
			}
			
			return 12;
		}		
		
		public function setTextSize(size:int, beginIndex:int = -1, endIndex:int = -1):void
		{
			if (attributes["textSize"] != size)
			{
				attributes["textSize"] = size;
			}
		}		
		
		public function getTextHorizontalAlign():String
		{
			if (attributes["textHorizontalAlign"])
			{
				return attributes["textHorizontalAlign"];
			}
			
			return "left";
		}
		
		public function setTextHorizontalAlign(align:String):void
		{
			if (attributes["textHorizontalAlign"] != align)
			{
				attributes["textHorizontalAlign"] = align;
			}
		}
		
		public function getTextVerticalAlign():String
		{
			if (attributes["textVerticalAlign"])
			{
				return attributes["textVerticalAlign"];
			}
			
			return "none";
		}		
		
		public function setTextVerticalAlign(align:String):void
		{
			if (attributes["textVerticalAlign"] != align)
			{
				attributes["textVerticalAlign"] = align;
			}
		}
		
		public function setSingleLine(singleLine:Boolean):void
		{
			if (attributes["singleLine"] != singleLine)
			{
				attributes["singleLine"] = singleLine;
			}
		}
		
		public function getSingleLine():Boolean
		{
			if (attributes["singleLine"])
			{
				return attributes["singleLine"];
			}
			return false;
		}
		
		public function setPasswordMode(value:Boolean):void
		{
			if (attributes["password"] != value)
			{
				attributes["password"] = value;
			}
		}
		
		// This method is called when the text is changed, in case any subclasses would like to know.
		protected function onTextChanged(text:String, start:int, lengthAfter:int):void
		{
			invalidate();
			dispatchEvent(new TextEvent("onTextChanged", false, false, text));
		}
		
		protected override function onDraw(canvas:Graphics):void
		{
			super.onDraw(canvas);
			
			content.multiline = !attributes["singleLine"];
			content.selectable = false;
			content.text = getText() == "" && isFocused() != true ? getHint() : getText();
			content.displayAsPassword = getText() == "" && isFocused() != true ? false : attributes["password"];
			
			var font:Font = getFont();
			var bold:Boolean = (font.fontStyle == FontStyle.BOLD || font.fontStyle == FontStyle.BOLD_ITALIC) ? true : false;
			var italic:Boolean = (font.fontStyle == FontStyle.ITALIC || font.fontStyle == FontStyle.BOLD_ITALIC) ? true : false;
			content.defaultTextFormat = new TextFormat(font.fontName, getTextSize(), (getText() == "" && isFocused() != true) ? getHintTextColor() : getTextColor(), bold, italic, null, null, null);
			content.setTextFormat(content.defaultTextFormat);
			content.embedFonts = font.fontType == FontType.EMBEDDED ? true : false;
			
			content.autoSize = TextFieldAutoSize.LEFT;
			var localVisibleRect:Rectangle = getLocalVisibleRect();
			var contentBounds:Rectangle = content.getBounds(null);
			switch (getTextVerticalAlign())
			{
				case "none":
					content.y = localVisibleRect.top + getPaddingTop();
					content.height = localVisibleRect.height - getPaddingTop() - getPaddingBottom();
					break;
				case "center":
					content.y = ((localVisibleRect.height - contentBounds.height) / 2) + localVisibleRect.y;
					content.height = contentBounds.height;
					break;
			}
			
			content.autoSize = TextFieldAutoSize.NONE;
			content.x = localVisibleRect.left + getPaddingLeft();
			content.width = localVisibleRect.width - getPaddingLeft() - getPaddingRight();	
			content.setTextFormat(new TextFormat(null, null, null, null, null, null, null, null, getTextHorizontalAlign()));
		}		
		
		protected override function onLayout():void
		{
			super.onLayout();
		}
	}

}
