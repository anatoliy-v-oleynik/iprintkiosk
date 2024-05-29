package flash.view.keyboard  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.view.View;
	import flash.ui.Keyboard;
	import flash.utils.AttributeSet;
	import flash.display.Graphics;
	import flash.view.ViewGroup;
	import flash.view.GridView;
	import flash.view.ListAdapter;
	import flash.view.ListItem;
	import flash.utils.getQualifiedClassName;
	
	public class Layout extends GridView
	{
		private var mShift:int;
		private var mCharset:Vector.<Vector.<Object>>;
		
		public function Layout(attrs:Object = null)
		{
			super();
		}
		
		private function update():void
		{
			var adapter:ListAdapter = getAdapter();
			if (adapter && attributes["charSet"])
			{
				for (var i:int = 0; i < adapter.getCount(); i++)
				{
					var item:ListItem = adapter.getItem(i);
					if (item.view is Key)
					{
						var o:* = attributes["charSet"][getShift()][(item.view as Key).getKeyCode()];
						switch (getQualifiedClassName(o))
						{
							case "flash.utils::ByteArray":
								(item.view as Key).setIcon(o);
								break;
							case "String":
								(item.view as Key).setText(o);
								break;
						}
					}
				}
			}
		}
		
		protected override function onAdapterChanged(oldAdapter:ListAdapter, newAdapter:ListAdapter):void
		{
			update();
		}		
		
		public function setShift(shift:int):void
		{
			if (attributes["shift"] != shift)
			{
				attributes["shift"] = shift;
				update();
			}
		}
		
		public function getShift():int
		{
			if (attributes["shift"])
			{			
				return attributes["shift"];
			}
			return 0;
		}
		
		public function setCharset(charset:Vector.<Vector.<Object>>):void
		{
			if (attributes["charSet"] != charset)
			{
				attributes["charSet"] = charset;
				update();
			}
		}
		
		public function getCharset():Vector.<Vector.<Object>>
		{
			if (attributes["charSet"])
			{			
				return attributes["charSet"];
			}
			
			return null;
		}

		protected override function onDraw(canvas:Graphics):void
		{
			super.onDraw(canvas);
		}		

	}
}

