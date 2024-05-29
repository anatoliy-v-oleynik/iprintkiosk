package flash.view 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	import adobe.utils.CustomActions;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.ui.MultitouchInputMode;
	
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.AttributeSet;
	import flash.content.*;
	import flash.view.*;
	import flash.app.*;
	import flash.events.*;
	
	import flashpress.touch.*;
	
	
	public class View extends MovieClip implements IViewParent
	{
		private static var lastMouseDown:int;
		
		private var $attributes:AttributeSet;
		private var $content:*;
		
		public var self:View;
		
		public function View(attrs:Object = null)
		{
			stop();
			self = this;
			
			$content = handler.getChildByName("_content") != null ? handler.getChildByName("_content") : null;
			
			attributes["focusable"] = false;
			attributes["gravity"] = "top|left";
			attributes["left"] = this.x;
			attributes["top"] = this.y;			
			attributes["width"] = this.width;
			attributes["height"] = this.height;

			var handlerBounds:Rectangle = handler.getBounds(null);
			var contentBounds:Rectangle = content.getBounds(this);
			
			if (!handlerBounds.isEmpty() && !contentBounds.isEmpty())
			{
				attributes["padding-left"] = contentBounds.left - handlerBounds.left;
				attributes["padding-top"] = contentBounds.top - handlerBounds.top;
				attributes["padding-right"] = Math.abs(-handlerBounds.right + contentBounds.right);
				attributes["padding-bottom"] = Math.abs( -handlerBounds.bottom + contentBounds.bottom);
				attributes["hitRect"] = handlerBounds;
			}
			else
			{
				attributes["padding-left"] = 0;
				attributes["padding-top"] = 0;
				attributes["padding-right"] = 0;
				attributes["padding-bottom"] = 0;
			}
				
			attributes.merge(attrs);
			
			if (loaderInfo != null) handler.loaderInfo.addEventListener(Event.COMPLETE,
																		function (e:Event):void
																		{
																			e.currentTarget.removeEventListener(e.type, arguments.callee);
																			requestLayout();
																			invalidate();
																		}); else handler.addEventListener(Event.ADDED_TO_STAGE,
																										 function (e:Event):void
																										 {
																											e.currentTarget.removeEventListener(e.type, arguments.callee);
																											requestLayout();
																											invalidate();
																										  });
		}
		
		public final function get attributes():AttributeSet
		{
			if ($attributes == null)
			{
				$attributes = new AttributeSet();
			}
			
			return $attributes;
		}
		
		public final function get handler():MovieClip
		{
			return this;
		}
		
		public final function get content():*
		{
			if ($content != null)
			{
				return $content;
			}
			
			return this;
		}		
		
		public final function isFinishing():Boolean
		{
			return attributes["finishing"];
		}		
		
		public function finish():void
		{
			attributes["finishing"] = false;
		}
		
		public final function findViewById(index:int):View
		{
			return content.getChildAt(index) as View;
		}
		
		public final function findViewByName(name:String):View
		{
			return content.getChildByName(name) as View;
		}		
		
		public final function findRootView():View
		{
			return null;
		}		
		
		public function setContentView(contentView:*, layout:Object = null):void
		{
			if ($content === contentView) return;
			if ($content != null && $content != this && $content.parent === this) removeChild($content);
			
			//$content = (contentView != this && contentView.parent != this) ? addChild(contentView.parent != null ? contentView.parent.removeChild(contentView) : contentView) : contentView;
			$content = (contentView != this && contentView.parent != this) ? addChild(contentView) : contentView;
			
			if (layout != null)
			{
				$content.x = layout.x;
				$content.y = layout.y;
				$content.width = layout.width;
				$content.height = layout.height;
			}
			
			onContentChanged();
		}
		
		// Gets the parent of this view.
		public function getParent():View
		{
			for (var o:DisplayObject = handler.parent; o != null; o = o.parent ) 
			{
				if (o is IViewManager)
				{
					return o as View;
				}
			}
			return null;
		}
		
		public function getRootView():View
		{
			return null;
		}
		
		public function performLayout():void
		{
			
		}
		
		// Enables or disables click events for this view.
		public function setClickable(clickable:Boolean):void
		{
			if (attributes["clickable"] == clickable)
			{
				return;
			}
			
			attributes["clickable"] = clickable;
			
			if (clickable)
			{
				handler.addEventListener(MouseEvent.MOUSE_DOWN, onCaptureMouseDown);
				//handler.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN, function (e:flash.events.TouchEvent):void { trace(e) });
			}
			else
			{
				handler.removeEventListener(MouseEvent.MOUSE_DOWN, onCaptureMouseDown);	
				Context.base.removeEventListener(MouseEvent.MOUSE_UP, onCaptureMouseUp);
				Context.base.removeEventListener(MouseEvent.MOUSE_UP, onCaptureMouseUp, true);	
			}
		}

		
		// Sets whether this node is long clickable.
		public function setLongClickable(longClickable:Boolean):void
		{
			
		}
		
		// Set whether this view can receive the focus.
		public function setFocusable(focusable:Boolean):void
		{
			attributes["focusable"] = focusable;
		}		
		
		// Returns whether this View is able to take focus.
		public function isFocusable():Boolean
		{
			if (attributes["focusable"])
			{
				return attributes["focusable"];
			}
			
			return false;
		}
		
		// Returns true if this view has focus
		public function isFocused():Boolean
		{
			return Activity.focused == this;
		}		
		
		// Called when this view wants to give up focus.
		public function clearFocus():void
		{
			setFocused(false);
		}
		
		// Call this to try to give focus to a specific view or to one of its descendants.
		public function requestFocus():void
		{
			setFocused(true);
		}
		
		
		public function setFocused(focused:Boolean, relatedFocus:View = null):void
		{
			if (focused)
			{
				if (Activity.focused != this)
				{
					if (Activity.focused != null)
					{
						Activity.focused.setFocused(false, this);
					}
					else
					{
						Activity.focused = this;
						onFocusChanged(true, relatedFocus);
					}
				}
			}
			else
			{
				if (Activity.focused == this)
				{
					Context.base.focus = null;
					Activity.focused = null;
					Activity.previouslyFocused = this;
					onFocusChanged(false, relatedFocus);
					
					if (relatedFocus != null) relatedFocus.setFocused(true, this);
				}
			}
		}		
		
		public function layout(l:Number, t:Number, r:Number, b:Number):void
		{
			
		}
		
		public function setLocation(left:Number, top:Number):void
		{
			if (attributes["left"] != left || attributes["top"] != top)
			{
				var oldLeft:Number = attributes["left"];
				var oldTop:Number = attributes["top"];
				
				attributes["left"] = left;
				attributes["top"] = top;
				
				onLocationChanged(left, top, oldLeft, oldTop);
			}
		}
		
		public function setSize(w:Number, h:Number):void
		{
			if (attributes["width"] != w || attributes["height"] != h)
			{
				var oldWidth:Number = attributes["width"];
				var oldHeight:Number = attributes["height"];
				
				attributes["width"] = w;
				attributes["height"] = h;
				
				onSizeChanged(w, h, oldWidth, oldHeight);
			}
		}
		
		public function setPadding(left:Number, top:Number, right:Number, bottom:Number):void
		{
			if (attributes["padding-left"] != left || attributes["padding-top"] != top || attributes["padding-right"] != right || attributes["padding-bottom"] != bottom)
			{
				attributes["padding-left"] = left;
				attributes["padding-top"] = top;
				attributes["padding-right"] = right;
				attributes["padding-bottom"] = bottom;
			}
		}
		
		public function getPaddingLeft():Number
		{
			return attributes["padding-left"];
		}
		
		public function getPaddingTop():Number
		{
			return attributes["padding-top"];
		}
		
		public function getPaddingRight():Number
		{
			return attributes["padding-right"];
		}
		
		public function getPaddingBottom():Number
		{
			return attributes["padding-bottom"];
		}		
		
		public function getTag():Object
		{
			return attributes["tag"];
		}
		
		public function setTag(tag:Object):void
		{
			attributes["tag"] = tag;
		}
		
		// The visual x position of this view, in pixels. This is equivalent to the translationX property plus the current left property.
		public function getX():Number
		{
			return attributes["left"];
		}
		
		// The visual y position of this view, in pixels. This is equivalent to the translationY property plus the current top property.
		public function getY():Number
		{
			return attributes["top"];
		}		
		
		// Return the width of the your view.
		public function getWidth():Number
		{
			return attributes["width"];
		}
		
		// Return the height of your view.
		public function getHeight():Number
		{
			return attributes["height"];
		}		
		
		public function setGravity(gravity:String):void
		{
			attributes["gravity"] = gravity;
		}
		
		// Sets a rectangular area on this view to which the view will be clipped when it is drawn.
		public function setClipBounds(clipBounds:Rectangle):void
		{
			handler.scrollRect = clipBounds;
		}
		
		public function getClipBounds():Rectangle
		{
			return handler.scrollRect;
		}
		
		// Hit rectangle in parent's coordinates
		public function getHitRect():Rectangle
		{
			return attributes["hitRect"];
		}
		
		public function getLocalVisibleRect():Rectangle
		{
			var rect:Rectangle = handler.getBounds(null);
			return new Rectangle(0, 0, attributes["width"], attributes["height"]);
		}
		
		public function setOnClickListener(listener:Function):void
		{
			addEventListener("onClick", listener);
		}
		
		public function callOnClick():void
		{

		}
		
		// Call this when something has changed which has invalidated the layout of this view.
		public function requestLayout():void
		{
			onLayout();
		}
		
		public function isScrollContainer():Boolean
		{
			return content != this;
		}
		
		public function setScrollContainer(isScrollContainer:Boolean):void
		{
			
		}
		
		public function setEnabled(enable:Boolean):void
		{
			if (attributes["enable"] != enable)
			{
				this.mouseEnabled = enable;
				this.mouseChildren = enable;
				this.alpha = enable ? 1.0 : 0.7;
				attributes["enable"] = enable;
			}
		}
		
		// Invalidate the whole view. If the view is visible, onDraw(android.graphics.Canvas) will be called at some point in the future.
		public function invalidate():void
		{
			onDraw(this.graphics);
		}		
		
		protected function onClick(e:MouseEvent):void
		{
			dispatchEvent(e);
		}
		
		protected function onLongClick(e:MouseEvent):void
		{
			
		}
		
		protected function onLocationChanged(left:Number, top:Number, oldLeft:Number, oldTop:Number):void
		{
			onLayout();
			invalidate();
		}		
		
		protected function onSizeChanged(w:Number, h:Number, oldWidth:Number, oldHeight:Number):void
		{
			onLayout();
			invalidate();
		}
		
		protected function onFocusChanged(gainFocus:Boolean, relatedFocus:View):void
		{
			if (gainFocus)
			{
				handler.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );
				if (handler.currentLabels.some(function (item:*, index:int, array:Array):Boolean { return (item.name == "focused"); }, this))
				{
					handler.gotoAndStop("focused");
				}
			}
			else
			{
				handler.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );
				handler.gotoAndStop(1);
			}
		}
		
		// Called from layout when this view should assign a size and position to each of its children.
		protected function onLayout():void
		{
			this.x = attributes["left"];
			this.y = attributes["top"];
		}
		
		// Manually render this view (and all of its children) to the given Canvas.
		protected function onDraw(canvas:Graphics):void
		{
//			var rect:Rectangle = getLocalVisibleRect();
//			canvas.beginFill(0x222125, 1);        
//			canvas.drawRect(rect.x, rect.y, rect.width, rect.height);
//			canvas.endFill();
		}
		
		private function onCaptureMouseDown(e:MouseEvent):void
		{
			View.lastMouseDown = getTimer();
			Context.base.addEventListener(MouseEvent.MOUSE_UP, onCaptureMouseUp);
			Context.base.addEventListener(MouseEvent.MOUSE_UP, onCaptureMouseUp, true);
			onPress(new MouseEvent("onPress", e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta));
		}		
		
	
		
		private function onCaptureMouseUp(e:MouseEvent):void
		{
			if (e.eventPhase == EventPhase.BUBBLING_PHASE)
			{
				return;
			}
			
			if (e.target == self)
			{
				onRelease(new MouseEvent("onRelease", e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta));
				if (!TouchManager.isScroll)
				{
					//stage.focus = this;
					Context.base.removeEventListener(MouseEvent.MOUSE_UP, onCaptureMouseUp);
					Context.base.removeEventListener(MouseEvent.MOUSE_UP, onCaptureMouseUp, true);
					onClick(new MouseEvent("onClick", true, false, e.localX, e.localY, null, false, false, false, false, getTimer() - View.lastMouseDown));
					return;
				}
			}
			else
			{
				// отпущена вне компонента
				Context.base.removeEventListener(MouseEvent.MOUSE_UP, onCaptureMouseUp);
				Context.base.removeEventListener(MouseEvent.MOUSE_UP, onCaptureMouseUp, true);
				onReleaseOutside(new MouseEvent("onReleaseOutside", e.bubbles, e.cancelable, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta));
			}
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			dispatchEvent(new KeyboardEvent("onKeyDown", true, false, e.charCode, e.keyCode, e.keyLocation, e.ctrlKey, e.altKey, e.shiftKey));
		}

		protected function onPress(e:MouseEvent):void
		{
			dispatchEvent(e);
		}
		
		protected function onRelease(e:MouseEvent):void
		{
			dispatchEvent(e);
		}
		
		protected function onReleaseOutside(e:MouseEvent):void
		{
			dispatchEvent(e);
		}		
		
		protected function onContentChanged():void
		{
			dispatchEvent(new Event("onContentChanged"));
		}		
		
	}

}