package flash.view.keyboard  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.view.View;
	import flash.ui.Keyboard;
	import flash.utils.AttributeSet;
	import flash.view.GridView;
	import flash.view.ListAdapter;
	import flash.view.ListItem;
	import flash.utils.getQualifiedClassName;
	
	public class RuLayout extends Layout
	{
		public function RuLayout(attrs:AttributeSet = null)
		{
			super();
			attributes["width"] = 900;
			attributes["height"] = 350;
			attributes["colWidth"] = Key.defaultWidth;
			attributes["rowHeight"] = Key.defaultHeight;
			attributes["numColumns"] = 13;
			attributes["shift"] = 0;
			attributes["charSet"] = Key.ru_charset;
			attributes.merge(attrs);
			setAdapter(new KeyAdapter());
		}
	}
}

import flash.view.ListAdapter;
import flash.view.keyboard.LightKey;
import flash.utils.AttributeSet;
import flash.ui.Keyboard;
import flash.view.keyboard.DarkKey;
import flash.view.View;

class KeyAdapter extends flash.view.ListAdapter
{
	public function KeyAdapter()
	{
		super();
		
		addItem(new LightKey({ keyCode:Keyboard.Q }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.W }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.E }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.R }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.T }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.Y }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.U }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.I }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.O }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.P }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.LEFTBRACKET }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.RIGHTBRACKET }), 1.0);
		addItem(new DarkKey({ keyCode:Keyboard.BACKSPACE }), 1.0);
		
		addItem(new View(), 0.5);
		addItem(new LightKey({ keyCode:Keyboard.A }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.S }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.D }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.F }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.G }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.H }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.J }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.K }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.L }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.SEMICOLON }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.QUOTE }), 1.0);
		addItem(new DarkKey({ keyCode:Keyboard.ENTER }), 1.5);
			
		addItem(new DarkKey({ keyCode:Keyboard.SHIFT }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.Z }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.X }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.C }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.V }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.B }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.N }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.M }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.COMMA }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.PERIOD }), 1.0);
		addItem(new LightKey({ keyCode:91 }), 1.0);
		addItem(new LightKey({ keyCode:92 }), 1.0);
		addItem(new DarkKey({ keyCode:Keyboard.SHIFT }), 1.0);
		
		addItem(new DarkKey({ keyCode:Keyboard.ESCAPE }), 1.0);
		addItem(new DarkKey({ keyCode:Keyboard.NUMPAD }), 1.5);
		addItem(new DarkKey({ keyCode:Keyboard.CONTROL }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.SPACE }), 7.0);
		addItem(new DarkKey({ keyCode:Keyboard.NUMPAD }), 1.5);
		addItem(new DarkKey({ keyCode:Keyboard.ESCAPE }), 1);
	}
}