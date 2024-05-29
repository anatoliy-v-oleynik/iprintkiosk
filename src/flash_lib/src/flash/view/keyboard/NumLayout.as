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
	
	public class NumLayout extends Layout
	{
		public function NumLayout(attrs:AttributeSet = null)
		{
			super();
			attributes["width"] = 795;
			attributes["height"] = 350;
			attributes["colWidth"] = Key.defaultWidth;
			attributes["rowHeight"] = Key.defaultHeight;
			attributes["numColumns"] = 11.5;
			attributes["shift"] = 0;
			attributes["charSet"] = Key.num_charset;
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
		
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.Q })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.W })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.E })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.R })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.T })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.Y })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.U })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.I })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.O })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.P })), 1.0);
		addItem(new DarkKey(new AttributeSet({ keyCode:Keyboard.BACKSPACE })), 1.5);
		
		addItem(new View(), 0.5);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.A })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.S })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.D })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.F })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.G })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.H })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.J })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.K })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.L })), 1.0);
		addItem(new DarkKey(new AttributeSet({ keyCode:Keyboard.ENTER })), 2.0);
			
		addItem(new DarkKey(new AttributeSet({ keyCode:Keyboard.SHIFT })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.Z })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.X })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.C })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.V })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.B })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.N })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.M })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.COMMA })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.PERIOD })), 1.0);
		addItem(new DarkKey(new AttributeSet({ keyCode:Keyboard.SHIFT })), 1.5);
		
		addItem(new DarkKey(new AttributeSet({ keyCode:Keyboard.ESCAPE })), 1.0);
		addItem(new DarkKey(new AttributeSet({ keyCode:Keyboard.NUMPAD })), 1.5);
		addItem(new LightKey(new AttributeSet({ keyCode:94 })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:Keyboard.SPACE })), 5.0);
		addItem(new LightKey(new AttributeSet({ keyCode:91 })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:92 })), 1.0);
		addItem(new LightKey(new AttributeSet({ keyCode:93 })), 1.0);
	}
}