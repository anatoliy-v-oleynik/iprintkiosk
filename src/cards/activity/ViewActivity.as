package cards.activity 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import common.activity.CardEditActivity;
	import common.activity.CartActivity;
	import common.activity.ErrorActivity;
	import common.activity.PhotoEditActivity;
	import common.button.BackwardButton;
	import common.button.HomeButton;
	import common.button.LoginButton;
	import common.button.LogoutButton;
	import common.button.MediaSampleButton;
	import common.button.PayButton;
	import common.button.SearchButton;
	import common.button.TagSampleButton;
	import common.button.UserSampleButton;
	import common.view.Grid;
	import flash.app.Activity;
	import flash.app.Application;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.AttributeSet;
	import flash.view.ImageView;
	import flash.view.events.ItemEvent;
	import flash.widget.Button;
	import flash.widget.ImageButton;
	import instagram.activity.SearchActivity;
	import instagram.dialogs.PrivateAccountDialog;
	
	[Embed(source="../../../lib/assets.swf", symbol="cards.activity.ViewActivity")]
	public class ViewActivity extends Activity
	{
		public var _backward_btn:BackwardButton;
		public var _home_btn:HomeButton;
		public var _search_btn:SearchButton;
		public var _pay_btn:PayButton;
		public var _total_price_txt:TextField;
		public var _count_photo_txt:TextField;
		public var _title_txt:TextField;
		public var _info_txt:TextField;
		public var _gridview:Grid;
		public var _waiter:MovieClip;
		
		public function ViewActivity(attrs:AttributeSet = null) 
		{
			super(attrs)
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
			
			_backward_btn.addEventListener("onClick", onClick);
			_home_btn.addEventListener("onClick", onClick);
			_search_btn.addEventListener("onClick", onClick);
			_pay_btn.addEventListener("onClick", onClick);
			_waiter.visible = false;
			
				
			_gridview.setNumColumns(4);
			_gridview.setRowHeight(330);
			_gridview.setColWidth(248);
			_gridview.setHorizontalSpacing(5);
			_gridview.setVerticalSpacing(5);
			
			attributes["adapter"] = new CardsAdapter();
			
			attributes["adapter"].addEventListener("onLoadComplete",
								function (e:Event):void
								{
									var wait:Boolean = false;
									if (!_gridview.canScrollVertically(1)) wait = attributes["adapter"].loadNext(40);
									_waiter.visible = wait;
								});
								
			attributes["adapter"].addEventListener("onError",
								function (e:flash.events.ErrorEvent):void
								{
									Container.current.log.error(e.toString(), "ViewActivity(cards) - onError()");

									attributes["destroyOnStop"] = true;
									startActivity(new ErrorActivity( new AttributeSet({ repeat:function ():void { attributes["adapter"].loadNext() } })), true);
								});									
								
			_gridview.addEventListener("onScrollDownEnd",
								function (e:Event):void
								{
									var wait:Boolean = false;
									if (!_gridview.canScrollVertically(1)) wait = attributes["adapter"].loadNext(40);
									_waiter.visible = wait;
								});
								
			_gridview.addEventListener("onItemClick",
								function (e:ItemEvent):void
								{
									trace(e.item.view.name);
									startActivity(new CardEditActivity(), true,  { view_type : "CARD",  item : e.item, photo : e.item.view.getTag().rawContent, price : 25 });
								});
								
			_gridview.setAdapter(attributes["adapter"]);
			attributes["adapter"].load();
		}		
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);
			
			Container.current.log.info("Переход на страницу просмотра. " + _title_txt.text, "cards.activity.ViewActivity");
			
			_pay_btn.visible = Order.current.items.length > 0
			_total_price_txt.text = Order.current.totalPrice.toString();
			_count_photo_txt.text = Order.current.totalCount.toString();
		}
		
		protected function onClick(e:Event):void
		{
			switch (e.target.name)
			{
				case "_backward_btn":
					Activity.current.backward();
					break;
				case "_home_btn":
					startActivity(Activity.list[0]);
					break;
				case "_search_btn":
					startActivity(new SearchActivity(), true);
					break;
				case "_pay_btn":
					startActivity(new CartActivity(), true);
					break;					
			}
		}			
		
	}
}


import common.button.MediaSampleButton;
import common.button.SearchButton;
import common.button.PayButton;
import common.button.UserSampleButton;
import common.button.ImageSampleButton;
import common.view.CardItemView;
import flash.app.Activity;
import flash.events.ProgressEvent;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.Base64;
import flash.view.ListAdapter;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import fl.display.ProLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLLoaderDataFormat;
import flash.utils.ByteArray;
import flash.utils.getTimer;
import flash.view.View;
import flash.text.TextField;
import flash.widget.ImageButton;
import flash.view.LoaderListAdapter;
import com.greensock.loading.SWFLoader;
import com.greensock.loading.LoaderMax;
import com.greensock.loading.XMLLoader;
import com.greensock.events.LoaderEvent;
import com.greensock.loading.DataLoader;
import com.greensock.loading.ImageLoader;
import com.greensock.loading.core.LoaderCore;
import flash.display.Bitmap;

class CardsAdapter extends LoaderListAdapter
{
	private var mUser:Object;
	private var mLoader:URLLoader;
	private var mTotalCount:int;
	private var mNextMaxId:String;
	private var mImageLoader:ProLoader;
	private var mImageLoadIndex:int = 0;
	private var mQueue:LoaderMax;
	private var mPageInfo:Object;
	private var mMaxId:String;
	private var mMoreAvailable:Boolean;
	

	function CardsAdapter()
	{
		super();
	}

	public override function getTotalCount():int
	{
		return mTotalCount;
	}

	public override function load(count:int = 20, clearList:Boolean = false, ... rest):void
	{
		if (mLoader == null)
		{
			LoaderMax.activate([ImageLoader, SWFLoader, DataLoader]); 
			mQueue = new LoaderMax();
			mQueue.autoLoad = true;
			
				var loader:XMLLoader = new XMLLoader("./cards/~list.xml", { name:"xmlDoc", maxConnections:1, estimatedBytes:5000, onChildComplete:
					function (e:LoaderEvent):void
					{
						var view:ImageSampleButton = new ImageSampleButton();
						view.name = e.target.name;
						view.setPadding(0, 0, 0, 0);
						view.setSize(248, 330);
						view.setScaleType("centerCrop");
						view.setImageBitmap(e.target.rawContent);
						view.setTag(e.target);
						addItem(view);
					}, onComplete: function ():void {  }  });
					
			mQueue.append(loader);	
		}
	}

	public override function loadNext(count:int = 20):Boolean
	{
		return false;
	}

	protected function onIOError(e:IOErrorEvent):void
	{
		e.target.removeEventListener(e.type, arguments.callee);
		e.target.close();
		mLoader = null;
		
		dispatchEvent(new flash.events.ErrorEvent("onError", false, false, e.text, e.errorID ));
	}
	
	protected function onLoadComplete(e:Event):void
	{
		e.target.removeEventListener(e.type, arguments.callee);
		e.target.close();

		try
		{

		}
		catch (ex:Error)
		{
			dispatchEvent(new flash.events.ErrorEvent("onError", false, false, ex.message, ex.errorID ));
		}
	}
}
