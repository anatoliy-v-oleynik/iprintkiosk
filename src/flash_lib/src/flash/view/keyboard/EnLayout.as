package flash.view.keyboard  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.view.View;
	import flash.ui.Keyboard;
	import flash.utils.AttributeSet;
	import flash.view.GridView;
	
	public class EnLayout extends Layout
	{
		public function EnLayout(attrs:AttributeSet = null)
		{
			super();
			attributes["width"] = 795;
			attributes["height"] = 350;
			attributes["colWidth"] = Key.defaultWidth;
			attributes["rowHeight"] = Key.defaultHeight;
			attributes["numColumns"] = 11.5;
			attributes["shift"] = 0;
			attributes["charSet"] = Key.en_charset;
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

class KeyAdapter extends ListAdapter
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
		addItem(new DarkKey({ keyCode:Keyboard.BACKSPACE }), 1.5);
		
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
		addItem(new DarkKey({ keyCode:Keyboard.ENTER }), 2.0);
			
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
		addItem(new DarkKey({ keyCode:Keyboard.SHIFT }), 1.5);
		
		addItem(new DarkKey({ keyCode:Keyboard.ESCAPE }), 1.0);
		addItem(new DarkKey({ keyCode:Keyboard.NUMPAD }), 1.5);
		addItem(new DarkKey({ keyCode:Keyboard.CONTROL }), 1.0);
		addItem(new LightKey({ keyCode:Keyboard.SPACE }), 5.0);
		addItem(new LightKey({ keyCode:91 }), 1.0);
		addItem(new LightKey({ keyCode:92 }), 1.0);
		addItem(new LightKey({ keyCode:93 }), 1.0);
	}
}