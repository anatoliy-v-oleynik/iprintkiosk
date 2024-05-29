package flash.view.keyboard
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.view.View;
	import flash.view.GridView;
	import flash.display.Graphics;
	import flash.utils.AttributeSet;
	import flash.ui.Keyboard;
	import flash.view.ViewPager;
	import flash.view.ViewGroup;
	import flash.view.events.ItemEvent;
	import flash.events.KeyboardEvent;
	import flash.app.Activity;
	
	public class SoftKeyboard extends ViewGroup
	{
		private var mLayouts:Vector.<Vector.<Layout>>;
		private var mCurrentLayoutIndex:uint = 0;
		private var mCurrentShiftIndex:int = 0;
		private var mNumLock:Boolean = false;
		
		public function SoftKeyboard(attrs:AttributeSet = null)
		{
			super();
			attributes["width"] = 1080;
			attributes["height"] = 330;			
			addLayout(new EnLayout( new AttributeSet({ lang:"EN" })));
			addLayout(new RuLayout( new AttributeSet({ lang:"RU" })));
			addLayout(new NumLayout(), true);
			
			switch (attrs["lang"])
			{
				case "RU":
					mCurrentLayoutIndex = 1;
					break;
				case "EN":
					mCurrentLayoutIndex = 0;
					break;
			}
			
			setContentView(mLayouts[int(mNumLock)][mCurrentLayoutIndex]);
			content.x = (getWidth() - mLayouts[int(mNumLock)][mCurrentLayoutIndex].getWidth()) / 2;
			content.y = 10;
			invalidate();
		}
		
		protected function onItemClick(e:ItemEvent):void
		{
			switch ((e.item.view as Key).getKeyCode())
			{
				case Keyboard.CONTROL:
					mCurrentLayoutIndex = mCurrentLayoutIndex+1 < mLayouts[int(mNumLock)].length ? ++mCurrentLayoutIndex : 0;
					mCurrentShiftIndex = mLayouts[int(mNumLock)][mCurrentLayoutIndex].getShift();
					setContentView(mLayouts[int(mNumLock)][mCurrentLayoutIndex]);
					break;
				case Keyboard.SHIFT:
					mCurrentShiftIndex = mCurrentShiftIndex+1 < mLayouts[int(mNumLock)][mCurrentLayoutIndex].getCharset().length ? ++mCurrentShiftIndex : 0;
					mLayouts[int(mNumLock)][mCurrentLayoutIndex].setShift(mCurrentShiftIndex);
					break;
				case Keyboard.NUMPAD:
					mNumLock = !mNumLock;
					mCurrentLayoutIndex = 0;
					mCurrentShiftIndex = mLayouts[int(mNumLock)][mCurrentLayoutIndex].getShift();
					setContentView(mLayouts[int(mNumLock)][mCurrentLayoutIndex]);
					break;
				case Keyboard.BACKSPACE:
					Activity.focused.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.BACKSPACE, e.delta));
					break;					
				case Keyboard.ESCAPE:
					Activity.focused.clearFocus();
					break;
				case Keyboard.ENTER:
					Activity.focused.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.ENTER));
					break;
				case Keyboard.SPACE:
					Activity.focused.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, Keyboard.SPACE, Keyboard.SPACE));
					break;							
				default:
					var charset:Vector.<Vector.<Object>> = mLayouts[int(mNumLock)][mCurrentLayoutIndex].getCharset();
					Activity.focused.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, charset[mCurrentShiftIndex][(e.item.view as Key).getKeyCode()].charCodeAt()));
					break;
			}
			content.x = (getWidth() - mLayouts[int(mNumLock)][mCurrentLayoutIndex].getWidth()) / 2;
			content.y = 10;
			invalidate();
		}
		
		public function addLayout(layout:Layout, numpad:Boolean = false):void
		{
			if (mLayouts == null)
			{
				mLayouts = new <Vector.<Layout>> [new Vector.<Layout>(), new Vector.<Layout>() ];
			}
			layout.addEventListener("onItemClick", onItemClick);
			mLayouts[int(numpad)].push(layout);
		}
		
		public function currentLayout():Layout
		{
			return content as Layout;
		}
		
		protected override function onDraw(canvas:Graphics):void
		{
			super.onDraw(canvas);

			canvas.clear();
			canvas.beginFill(0x29282E);
			canvas.drawRect(0, 0, getWidth(), getHeight());
			canvas.endFill();	
		}		
	}
}