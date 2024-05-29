package flashpress.touch
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class TouchManager
	{
		public static var isScroll:Boolean = false;
		private static var dictionary:Dictionary;
		private static var pool:Vector.<TouchManager>
		public static function register(target:DisplayObject, info:TouchInfo=null):void
		{
			if (!dictionary) {
				dictionary = new Dictionary();
				pool = new Vector.<TouchManager>();
			}
			//
			var touch:TouchManager;
			if (!pool.length) {
				touch = new TouchManager();
			} else {
				touch = pool.shift();
			}
			touch.init(target, info);
			dictionary[target] = touch;
		}
		public static function unregister(target:DisplayObject):void
		{
			if (!dictionary[target]) return;
			var touch:TouchManager = dictionary[target];
			touch.release();
		}
		//
		//
		//
		private var target:DisplayObject;
		private var info:TouchInfo;
		//
		private var stage:Stage;
		private var startLocal:Point;
		private var startGlobal:Point;
		private var previosPoint:Point;
		private var delta:Point;
		private var shift:Point;
		private var fixV:Boolean;
		private var fixH:Boolean;
		private var isSwipe:Boolean;
		private var beginTime:Number;
		//
		private var beginData:TouchData;
		private var updateData:TouchData;
		private var endData:TouchData;
		private var swipeData:TouchData;
		private var tapData:TouchData;
		public function TouchManager()
		{
			this.startLocal = new Point();
			this.startGlobal = new Point();
			this.previosPoint = new Point();
			this.delta = new Point();
			this.shift = new Point();
			//
			this.beginData = new TouchData(TouchPhases.BEGIN);
			this.updateData = new TouchData(TouchPhases.UPDATE);
			this.endData = new TouchData(TouchPhases.END);
			this.swipeData = new TouchData(TouchPhases.SWIPE);
			this.tapData = new TouchData(null);
		}
		internal function init(target:DisplayObject, info:TouchInfo):void
		{
			this.target = target;
			this.target.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			//
			this.info = info ? info : new TouchInfo();
			if (!this.info.length2Start) this.info.length2Start = 30;
			if (!this.info.length2Swipe) this.info.length2Swipe = 100;
		}
		//
		private function dropEvent(touchData:TouchData):void
		{
			this.target.dispatchEvent(new TouchEvent(touchData.event, touchData));
		}
		//
		private function downHandler(event:MouseEvent):void
		{
			this.stage = target.stage;
			//
			startLocal.x = target.mouseX;
			startLocal.y = target.mouseY;
			startGlobal.x = stage.mouseX;
			startGlobal.y = stage.mouseY;
			previosPoint.x = startGlobal.x;
			previosPoint.y = startGlobal.y;
			//
			fixV = false;
			fixH = false;
			isSwipe = false;
			//
			beginData.event = null;
			beginData.stopTouch = false;
			//
			updateData.event = null;
			updateData.stopTouch = false;
			//
			endData.event = null;
			endData.stopTouch = false;
			//
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageUpHandler);
		}
		
		private function stageMoveHandler(event:MouseEvent):void
		{
			delta.x = stage.mouseX-startGlobal.x;
			delta.y = stage.mouseY-startGlobal.y;
			var dxa:Number = Math.abs(delta.x);
			var dya:Number = Math.abs(delta.y);
			
			isScroll = dya > info.length2Start || dxa > info.length2Start;
			
			//
			shift.x = stage.mouseX-previosPoint.x;
			shift.y = stage.mouseY-previosPoint.y;
			previosPoint.x = stage.mouseX;
			previosPoint.y = stage.mouseY;
			//
			if (!fixV && !fixH) {
				if (dxa > dya) {
					fixH = dxa >= info.length2Start;
					if (fixH) {
						if (delta.x < 0) {
							beginData.event = TouchEvent.LEFT;
						} else {
							beginData.event = TouchEvent.RIGHT;
						}
						beginData.delta = 0;
						beginData.shift = 0;
						beginData.startGlobal = startGlobal.x;
						beginData.startLocal = startLocal.x;
					}
				} else {
					fixV = dya >= info.length2Start;
					if (fixV) {
						if (delta.y < 0) {
							beginData.event = TouchEvent.UP;
						} else {
							beginData.event = TouchEvent.DOWN;
						}
						beginData.delta = 0;
						beginData.shift = 0;
						beginData.startGlobal = startGlobal.y;
						beginData.startLocal = startLocal.y;
					}
				}
				if (beginData.event) {
					beginTime = getTimer();
					dropEvent(beginData);
					updateData.event = beginData.event;
					updateData.startGlobal = beginData.startGlobal;
					updateData.startLocal = beginData.startLocal;
				}
			}
			//
			if (updateData.event) {
				if (fixH) {
					updateData.delta = delta.x;
					updateData.shift = shift.x;
				} else if (fixV) {
					updateData.delta = delta.y;
					updateData.shift = shift.y;
				}
				dropEvent(updateData);
				if (updateData.stopTouch) {
					updateData.stopTouch = false;
					stageUpHandler();
				}
			}
			//
			if (!isSwipe) {
				if (dxa > info.length2Swipe) {
					isSwipe = true;
					swipeData.event = beginData.event;
				} else if (dya > info.length2Swipe) {
					isSwipe = true;
				}
				if (isSwipe) {
					swipeData.event = beginData.event;
					swipeData.delta = updateData.delta;
					swipeData.shift = updateData.shift;
					swipeData.startGlobal = beginData.startGlobal;
					swipeData.startLocal = beginData.startLocal;
					dropEvent(swipeData);
				}
			}
		}
		private function stageUpHandler(event:MouseEvent=null):void
		{
			isScroll = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageUpHandler);
			//
			if (beginData.event) {
				endData.event = beginData.event;
				endData.delta = updateData.delta;
				endData.shift = updateData.shift;
				endData.startGlobal = beginData.startGlobal;
				endData.startLocal = beginData.startLocal;
				dropEvent(endData);
			} else {
				if (Math.abs(delta.x) < info.length2Start &&
					Math.abs(delta.y) < info.length2Start
				) {
					this.target.dispatchEvent(new TouchEvent(TouchEvent.TAP));
				}
			}
		}
		
		internal function release():void
		{
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, stageUpHandler);
				stage = null;
			}
			if (target) {
				target.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
				target = null;
			}
			pool.push(this);
		}
	}
}