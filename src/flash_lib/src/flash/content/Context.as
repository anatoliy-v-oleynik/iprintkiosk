package flash.content 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import fl.display.ProLoader;
	import fl.display.ProLoaderInfo;
	import com.greensock.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.ui.MultitouchInputMode;
	import flash.utils.AttributeSet;
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.getTimer;
	import flash.view.IViewParent;
	import flash.view.View;
	import flash.app.Application;
	import flash.app.Activity;
	import flash.system.ApplicationDomain;
	import flash.system.fscommand;
	import flash.view.ViewGroup;
	import flash.view.keyboard.SoftKeyboard;
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	
	public class Context extends MovieClip
	{
		public static var base:Stage;
		
		private var $attributes:AttributeSet;

		public function Context(attrs:AttributeSet = null)
		{
			super();
			
			attributes.merge(attrs);
			
			if (stage)
			{
				if (this == root)
				{
					Application.current = this as Application;

					fscommand("showmenu", "false");
					
				}
				
				Multitouch.mapTouchToMouse = false;
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				
				base = stage;
				base.stageFocusRect = false;
				base.needsSoftKeyboard = false;

				base.addEventListener(MouseEvent.MOUSE_DOWN,
									  function (e:MouseEvent):void
									  {
										  if (Activity.current) Activity.current.attributes["lastActive"] = new Date();
										  
										  //trace(11, Activity.focused, e.target, e.relatedObject, e.currentTarget);
										  
										  //if ((e.target is Activity) && (Activity.focused != null)) 
										  //{
											  //Activity.focused.setFocused(false);
										  //}
										  //else if ((e.target is View) && (e.target as View).isFocusable())
										  //{
											  //trace(1, Activity.focused, e.target, e.relatedObject, e.currentTarget);
											  //
												//if ((Activity.focused != null) && (Activity.focused != e.target))
												//{
													//Activity.focused.setFocused(false, e.target as View);
												//}
												//else
												//{
													//(e.target as View).setFocused(true);
												//}
										  //}
									  });


				base.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, function (e:FocusEvent):void
									  {
											if (e.relatedObject is View && (e.relatedObject as View).isFocusable())
											{
												if (Activity.focused != null && Activity.focused != e.relatedObject && Activity.focused != e.target)
												{
													Activity.focused.setFocused(false, e.relatedObject as View);
												}
												else
												{
													(e.relatedObject as View).setFocused(true);
												}
											}
											else if (e.relatedObject is View && Activity.focused)
											{
												var f:Function = function (c:Object, o:Object):Boolean { return (c.parent && c.parent != o) ? arguments.callee(c.parent, o) : c.parent == o  };
												
												if (
													(f(e.relatedObject, Activity.focused)) ||
													(e.relatedObject is SoftKeyboard) ||
													(e.relatedObject is IViewParent && (e.relatedObject as IViewParent).getParent() is SoftKeyboard) ||
													(e.relatedObject is IViewParent && (e.relatedObject as IViewParent).getParent() is IViewParent && ((e.relatedObject as IViewParent).getParent() as IViewParent).getParent() is SoftKeyboard) 
													)
												{
													//stage.focus = e.target as InteractiveObject;
												}
												else
												{
													Activity.focused.setFocused(false);
												}
											}
											else if (Activity.focused)
											{
												Activity.focused.setFocused(false);
											}
									  });
				
				onCreate(null);
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onCreate);
			}
			
			scrollRect = new Rectangle(0, 0, base.stageWidth, base.stageHeight);
		}
		
		public final function get attributes():AttributeSet
		{
			if ($attributes == null)
			{
				$attributes = new AttributeSet();
			}
			
			return $attributes;
		}		
		
		protected function onCreate(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onCreate);
			//addEventListener(Event.REMOVED_FROM_STAGE, onDestroy);
			addEventListener("onStart", onStart);
			addEventListener("onStop", onStop);
		}
		
		protected function onDestroy(e:Event):void
		{
			removeEventListener("onStart", onStart);
			removeEventListener("onStop", onStop);
		}
		
		protected function onStart(e:Event):void
		{
			if (Activity.current) Activity.current.attributes["lastActive"] = new Date();
		}
		
		protected function onStop(e:Event):void
		{

		}		
		
		public function loadActivity(url:String, destroyOnStop:Boolean = false, attrs:Object = null):void
		{
			var loader:ProLoader = new ProLoader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
													  function (e:Event):void
													  {
														 startActivity((e.currentTarget as ProLoaderInfo).content as Activity, destroyOnStop, attrs);
													  });
			loader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain));		
		}
		
		public function startActivity(activity:Activity, destroyOnStop:Boolean = false, attrs:Object = null):uint
		{
			activity.attributes.merge(attrs);
			activity.attributes["DestroyOnStop"] = destroyOnStop;				
			
			trace("current Activity Index", Activity.list.indexOf(Activity.current));
			trace("start Activity Index", Activity.list.indexOf(activity));
			
			if (Activity.current)
			{
				Activity.current.mouseEnabled = false;
				Activity.current.mouseChildren = false;
				activity.mouseChildren = false;
				activity.mouseEnabled = false;	
				
				if (Activity.list.indexOf(activity) != -1)
				{
					trace("Activity.list.length до splice", Activity.list.length);
				
					var removed:Array = Activity.list.splice(Activity.list.indexOf(activity));
					
					activity.x = -activity.width;
					new TimelineLite({tweens: [ TweenLite.to(Activity.current, 1.0, { x:scrollRect.width, onComplete:Activity.current.onStopActivity, onCompleteParams:[Activity.current] }),  TweenLite.to(Context.base.addChild(activity), 1.0, { x:0, onComplete:activity.onStartActivity, onCompleteParams:[activity, removed] }) ], align:TweenAlign.START } );
			
				}
				else
				{
					activity.x = scrollRect.width;
					new TimelineLite({tweens: [ TweenLite.to(Activity.current, 1.0, { x:-Activity.current.width, onComplete:Activity.current.onStopActivity, onCompleteParams:[Activity.current] }),  TweenLite.to(Context.base.addChild(activity), 1.0, { x:0, onComplete:activity.onStartActivity, onCompleteParams:[activity, null] }) ], align:TweenAlign.START } );
				}
			}
			else
			{
				TweenLite.to(Context.base.addChild(activity), 1, {alpha:1.0, onComplete:activity.onStartActivity, onCompleteParams:[activity, null]});
			}

			trace("Activity.list.length до push", Activity.list.length);
			
			return Activity.list.push(activity);
		}
		
		private function onStartActivity(activity:Activity, removed:Array):void
		{
			if (removed != null) 
			{
				for (var i:int = 1; i < removed.length; i++ )
				{
					removed[i].onDestroy(new Event("onDestroy"));
				}
			}
		
			removed = null;
			
			Context.base.focus = null;
			
			Activity.focused = null;
			Activity.previouslyFocused = null;
			Activity.current = activity;
			
			activity.mouseChildren = true;
			activity.mouseEnabled = true;
			activity.hideSoftKeyboard();
			activity.dispatchEvent(new Event("onStart"));
		}
		
		private function onStopActivity(activity:Activity):void
		{
			activity.parent.removeChild(activity);
			activity.dispatchEvent(new Event("onStop"));
			
			if (activity.attributes["DestroyOnStop"] == true) activity.onDestroy(new Event("onDestroy"));
		}
	}

}