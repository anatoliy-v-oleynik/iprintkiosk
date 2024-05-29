package flash.app 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import com.greensock.*;
	import flash.display.*;
	import flash.content.Context;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.AttributeSet;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.view.View;	 
	import flash.view.keyboard.SoftKeyboard;
	 
	public class Activity extends Context
	{
		{
			list = new Array();
		}		
		
		public static var focused:View;
		public static var previouslyFocused:View;
		public static var list:Array;
		public static var current:Activity;
		
		//public static function get current():Activity
		//{
			//return (list.length > 0) ? list[list.length-1] : null;
		//}

		private var timer:uint;
		private var mDialog:View;
		private var mKeyboard:SoftKeyboard;
		
		public var lastActive:Number;
		
		
		public function Activity(attrs:AttributeSet = null)
		{
			super(attrs);
			
			this.addEventListener("onStart", onStart);
			this.addEventListener("onStop", onStop);			
		}
		
		public function get keyboard():SoftKeyboard
		{
			return mKeyboard;
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
		}

		protected override function onDestroy(e:Event):void
		{
			if (Activity.list.indexOf(this) != -1)
			{
				Activity.list.splice(Activity.list.indexOf(this), 1);
			}
			
			super.onDestroy(e);
		}
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);
			
			attributes["lastActive"] = new Date();

			if ((attributes["idleTimeout"] ? attributes["idleTimeout"] : Application.current.getActivityIdleTimeout()) > 0 && Activity.list[0] != this)
			{
				attributes["idleTimeoutTimer"] = new Timer(1000)
				attributes["idleTimeoutTimer"].addEventListener(TimerEvent.TIMER,
				function (e:TimerEvent):void
				{
					if (attributes["lastActive"] != null)
					{
						var idleTimeout:Number = attributes["idleTimeout"] ? attributes["idleTimeout"] : Application.current.getActivityIdleTimeout();
						if ((new Date().getTime() - attributes["lastActive"].getTime()) > idleTimeout)
						{
							startActivity(Activity.list[0]);
							e.target.removeEventListener(TimerEvent.TIMER, arguments.callee);
						}
					}
				});
				attributes["idleTimeoutTimer"].start();
			}
		}
		
		protected override function onStop(e:Event):void
		{
			super.onStop(e);
			
			attributes["lastActive"] = null;
			if (attributes["idleTimeoutTimer"])
			{			
				attributes["idleTimeoutTimer"].stop();
			}
		}
	
		public function findViewByIndex(index:int):View
		{
			return this.getChildAt(index) as View;
		}
		
		public function findViewByName(name:String):View
		{
			return this.getChildByName(name) as View;
		}		
	
		public function getApplication():*
		{
			return Application.current;
		}
	
		public function get canBack():Boolean
		{
			return list.length > 1;
		}
	
		public function setEnabled(value:Boolean):void
		{
			if (attributes["enabled"] != value)
			{
				var enabler:MovieClip;
				
				if (value)
				{
					enabler = getChildByName("enabler") as MovieClip;
					if (enabler) removeChild(enabler); 
				}
				else
				{
					enabler = new MovieClip();
					enabler.name = "enabler";
					enabler.graphics.beginFill(0x000000, 0.8);
					enabler.graphics.drawRect(0, 0, Context.base.stageWidth, Context.base.stageHeight);
					enabler.graphics.endFill();
					addChild(enabler);
				}
				attributes["enabled"] = value;
			}

		}
		
		public function showDialog(dialog:View, callback:Function = null):void
		{
			setEnabled(false);
			if (mDialog && mDialog.parent) mDialog.parent.removeChild(mDialog);
			mDialog = addChild(dialog) as View;
			mDialog.setLocation((Context.base.stageWidth - mDialog.getWidth()) / 2, (Context.base.stageHeight - mDialog.getHeight()) / 2);
		}
		
		public function closeDialog():void
		{
			if (mDialog && mDialog.parent) mDialog.parent.removeChild(mDialog);
			setEnabled(true);
		}
		
		public function showSoftKeyboard(attr:Object = null):SoftKeyboard
		{
			if (mKeyboard == null)
			{
				mKeyboard = new SoftKeyboard(new AttributeSet(attr));
				TweenLite.fromTo(addChild(mKeyboard), 0.2, { y:1920 }, { y:1920-mKeyboard.getHeight() });
			}
			return null;
		}
		
		public function hideSoftKeyboard():void
		{
			if (mKeyboard != null)
			{
				TweenLite.fromTo(mKeyboard, 0.2, { y:1920-mKeyboard.getHeight() }, { y:1920, onComplete: function ():void
							   {
									mKeyboard.parent.removeChild(mKeyboard);
									mKeyboard = null;
							   }});
			}
		}
		
		public function backward():void
		{
			if (list.length > 1) startActivity(list[list.length-2]);
		}
	}

}