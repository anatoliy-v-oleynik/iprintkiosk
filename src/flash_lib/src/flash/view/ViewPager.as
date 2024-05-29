package flash.view
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.TransitionManager;
	import fl.transitions.PixelDissolve;
	import fl.transitions.Transition;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.geom.Rectangle;
	import flashpress.touch.TouchEvent;
	import flashpress.touch.TouchManager;
	import flashpress.touch.TouchPhases;
	import fl.motion.MotionEvent;
	import flash.view.events.ItemEvent;
	import fl.motion.Animator;
	import com.greensock.*;
	

	public class ViewPager extends ViewGroup
	{
		private var mAdapter:PagerAdapter;
		private var mCurrentItem:View;
		private var mPrevItem:View;
		private var mNextItem:View;
		private var mDragItemIndex:int;
		private var mTouchEnding:Boolean;
		
		private var mOnPageChangeListener:IOnPageChangeListener;
		
		
		public function ViewPager(attrs:Object = null)
		{
			attributes.merge(attrs);
			
			TouchManager.register(this);
			handler.addEventListener(TouchEvent.LEFT, onTouchHorizontal);
			handler.addEventListener(TouchEvent.RIGHT, onTouchHorizontal);	
		}

		public function getAdapter():PagerAdapter
		{
			return mAdapter;
		}

		public function setAdapter(adapter:PagerAdapter):void
		{
			var oldAdapter:PagerAdapter = mAdapter;
			
			if (adapter)
			{
				adapter.addEventListener("onItemAdded", onItemAdded);
				adapter.addEventListener("onItemRemoved", onItemRemoved);
				adapter.addEventListener("onRefresh", function (e:Event):void { trace("onRefresh"); requestLayout(); });
				mAdapter = adapter;
				removeViews();
				requestLayout();
			}
			else
			{
				mAdapter = null;
				removeViews();
				requestLayout();
			}
			
			onAdapterChanged(oldAdapter, mAdapter);
		}

		public function setPageMargin(value:Number):void
		{
			if (attributes["pageMargin"] != value)
			{
				attributes["pageMargin"] = value;
			}
		}
		
		public function setOnPageChangeListener(listener:IOnPageChangeListener):void
		{
			mOnPageChangeListener = listener;
		}

		public function setCurrentItem(i:*):void
		{
			if (mTouchEnding)
			{
				return;
			}			
			
			var showTransition:*;
			var hideTransition:*;
			var index:int = (i is View) ? mAdapter.getItemPosition(i) : i as int;

			if (index >= 0 && index < mAdapter.getCount())
			{
				var showItem:View = (i is View) ? i as View : mAdapter.instantiateItem(this, index);
				var hideItem:View = mCurrentItem;
				var localVisibleRect:Rectangle = getLocalVisibleRect();

				if (getCurrentItemIndex() < 0)
				{
					mTouchEnding = true;
					TweenLite.to(showItem, 0.2, {alpha:1.0, onComplete:
								function ():void
								{
									mCurrentItem = showItem;
									showItem.dispatchEvent(new Event("onStart"));
									onPageSelected(index);
									mTouchEnding = false;
								}});
				}
				else if (getCurrentItemIndex() < index)
				{
					mTouchEnding = true;
					hideItem.setEnabled(false);
					showItem.setEnabled(false);
					
					TweenLite.fromTo(hideItem, 1, { x:hideItem.x }, { x: localVisibleRect.x - hideItem.getWidth() - (attributes["pageMargin"] ? attributes["pageMargin"] : 0), onComplete:
								function ():void
								{
									hideItem.setEnabled(true);
									mAdapter.destroyItem(self as ViewGroup, mAdapter.getItemByView(hideItem));
									hideItem.dispatchEvent(new Event("onStop"));
								}});
					
					TweenLite.fromTo(showItem, 1,  { x: (i is View) ? showItem.x : localVisibleRect.width + (attributes["pageMargin"] ? attributes["pageMargin"] : 0) }, { x:localVisibleRect.x, onComplete:
								function ():void
								{
									mCurrentItem = showItem;
									showItem.setEnabled(true);
									showItem.dispatchEvent(new Event("onStart"));
									onPageSelected(index);
									mTouchEnding = false;
								}});
				}
				else if (getCurrentItemIndex() > index)
				{
					mTouchEnding = true;
					hideItem.setEnabled(false);
					showItem.setEnabled(false);				
					
					TweenLite.fromTo(hideItem, 1, { x:hideItem.x }, { x:localVisibleRect.width + (attributes["pageMargin"] ? attributes["pageMargin"] : 0), onComplete:
								function ():void
								{
									mAdapter.destroyItem(self as ViewGroup, mAdapter.getItemByView(hideItem));
									hideItem.setEnabled(true);
									hideItem.dispatchEvent(new Event("onStop"));
								}});

					TweenLite.fromTo(showItem, 1,  { x: (i is View) ? showItem.x : -(showItem.getWidth()+(attributes["pageMargin"] ? attributes["pageMargin"] : 0)) }, { x:localVisibleRect.x, onComplete:
								function ():void
								{
									
									mCurrentItem = showItem;
									showItem.setEnabled(true);
									showItem.dispatchEvent(new Event("onStart"));
									onPageSelected(index);
									mTouchEnding = false;
								}});				
				}
			}
		}

		public function getCurrentItem():View
		{
			return mCurrentItem;
		}

		public function getCurrentItemIndex():int
		{
			return mAdapter.getItemPosition(mCurrentItem);
		}
		
		public function canPrevPage():Boolean
		{
			if (mAdapter && mAdapter.getItemPosition(mCurrentItem) > 0)
			{
				return true;
			}
			
			return false;
		}
		
		public function prevPage():void
		{
			if (canPrevPage())
			{
				setCurrentItem(mAdapter.getItemPosition(mCurrentItem) - 1);
			}
		}
		
		public function canNextPage():Boolean
		{
			if (mAdapter && mAdapter.getItemPosition(mCurrentItem)+1 < mAdapter.getCount())
			{
				return true;
			}
			
			return false;
		}		
		
		public function nextPage():void
		{
			if (canNextPage())
			{
				setCurrentItem(mAdapter.getItemPosition(mCurrentItem) + 1);
			}
		}
		
		protected function onPageSelected(position:int):void
		{
			dispatchEvent(new Event("onPageSelected"));
		}
		
		protected function onAdapterChanged(oldAdapter:PagerAdapter, newAdapter:PagerAdapter):void
		{
			
		}		
		
		protected function onItemAdded(e:ItemEvent):void
		{
			if (mCurrentItem == null)
			{
				setCurrentItem(0);
			}
		}
		
		protected function onItemRemoved(e:ItemEvent):void
		{

		}		
		
		internal function onTouchHorizontal(e:TouchEvent):void
		{
			if (mTouchEnding)
			{
				return;
			}		
			
			if (mCurrentItem == null)
			{
				return;
			}
			
			var localVisibleRect:Rectangle = getLocalVisibleRect();
			var newPos:int = mCurrentItem.x + e.touchData.shift;
			
			switch (e.touchData.phase)
			{
				case TouchPhases.BEGIN:
					mDragItemIndex = mAdapter.getItemPosition(mCurrentItem);

					if (canNextPage() || canPrevPage())
					{
						mCurrentItem.setEnabled(false);
					}
					break;
				case TouchPhases.UPDATE:
					if ((newPos > 0) && (mDragItemIndex > 0))
					{
						if (mNextItem != null)
						{
							 mAdapter.destroyItem(this, mAdapter.getItemByView(mNextItem));
							 mNextItem = null;
						}
						
						if (mPrevItem == null)
						{
							mPrevItem = mAdapter.instantiateItem(this, mDragItemIndex - 1);
							mPrevItem.setEnabled(false);
						}
						
						mCurrentItem.x = newPos;
						mPrevItem.x = mCurrentItem.x - mPrevItem.getWidth() - (attributes["pageMargin"] ? attributes["pageMargin"] : 0);
					}
					else if ((newPos + mCurrentItem.getWidth() < localVisibleRect.width) && (mDragItemIndex < mAdapter.getCount()-1) && mDragItemIndex >= 0)
					{
						if (mPrevItem != null)
						{
							 mAdapter.destroyItem(this, mAdapter.getItemByView(mPrevItem));
							 mPrevItem = null;
						}
						
						if (mNextItem == null)
						{
							mNextItem = mAdapter.instantiateItem(this, mDragItemIndex + 1);
							mNextItem.setEnabled(false);
						}
						
						mCurrentItem.x = newPos;
						mNextItem.x = mCurrentItem.x + mCurrentItem.getWidth() + (attributes["pageMargin"] ? attributes["pageMargin"] : 0);
					}
					else
					{
						if (mNextItem != null && mNextItem != mCurrentItem)
						{
							mAdapter.destroyItem(this, mAdapter.getItemByView(mNextItem));
							mNextItem = null;
						}						
						
						if (mPrevItem != null && mPrevItem != mCurrentItem)
						{
							mAdapter.destroyItem(this, mAdapter.getItemByView(mPrevItem));
							mPrevItem = null;
						}
					}
					break;
				case TouchPhases.END:
					mTouchEnding = true;
					
					if (mPrevItem == null && mNextItem == null)
					{
						TweenLite.to(mCurrentItem, 0.2, { x:0, onComplete: function(adapter:PagerAdapter, itemView:View):void { mTouchEnding = false;  itemView.setEnabled(true); }, onCompleteParams:[mAdapter, mCurrentItem] })
						mTouchEnding = false;
					}
					else if (mNextItem != null)
					{
						if ((mCurrentItem.x + mCurrentItem.getWidth()) < (localVisibleRect.width / 2))
						{
							mTouchEnding = false;
							setCurrentItem(mNextItem);
						}
						else
						{
							new TimelineLite({tweens: [ TweenLite.to(mNextItem, 1.0, { x:localVisibleRect.width + (attributes["pageMargin"] ? attributes["pageMargin"] : 0), onComplete: function(adapter:PagerAdapter, itemView:View):void { adapter.destroyItem(self as ViewGroup, adapter.getItemByView(itemView)); }, onCompleteParams:[mAdapter, mNextItem] }),  TweenLite.to(mCurrentItem, 1.0, { x:0, onComplete: function(adapter:PagerAdapter, itemView:View):void { mTouchEnding = false;  itemView.setEnabled(true); }, onCompleteParams:[mAdapter, mCurrentItem] }) ], align:TweenAlign.START } );
						}
					}
					else if (mPrevItem != null)
					{
						if (mCurrentItem.x > (localVisibleRect.width / 2))
						{
							mTouchEnding = false;
							setCurrentItem(mPrevItem);
						}
						else
						{
							new TimelineLite({tweens: [ TweenLite.to(mPrevItem, 1.0, { x:localVisibleRect.x - mPrevItem.getWidth() - (attributes["pageMargin"] ? attributes["pageMargin"] : 0), onComplete: function(adapter:PagerAdapter, itemView:View):void { adapter.destroyItem(self as ViewGroup, adapter.getItemByView(itemView)); }, onCompleteParams:[mAdapter, mPrevItem] }),  TweenLite.to(mCurrentItem, 1.0, { x:0, onComplete: function(adapter:PagerAdapter, itemView:View):void { mTouchEnding = false; itemView.setEnabled(true); }, onCompleteParams:[mAdapter, mCurrentItem] }) ], align:TweenAlign.START } );
						}
					}
					mNextItem = mPrevItem = null;
					mDragItemIndex = -1;
					break;
				case TouchPhases.SWIPE:
					break;
			}
		}
	}
}