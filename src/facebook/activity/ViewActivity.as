package facebook.activity 
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
	import flash.view.events.ItemEvent;
	import flash.widget.Button;
	import flash.widget.ImageButton;
	import facebook.activity.SearchActivity;
	import instagram.dialogs.PrivateAccountDialog;
	
	[Embed(source="../../../lib/assets.swf", symbol="facebook.activity.ViewActivity")]
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
			
			switch (attributes["view_type"])
			{
				case "@" :
					attributes["adapter"] = new UsersAdapter(attributes["view_data"]);
					_title_txt.text = attributes["title"];
					_gridview.setNumColumns(4);
					_gridview.setRowHeight(320);
					_gridview.setColWidth(247);
					_gridview.setHorizontalSpacing(16);
					_gridview.setVerticalSpacing(10);
					break;
				case "@ID" :
					attributes["adapter"] = new UserMediaAdapter(attributes["view_data"]);
					_title_txt.text = attributes["title"];
					_gridview.setRowHeight(256);
					_gridview.setColWidth(256);
					_gridview.setHorizontalSpacing(5);
					_gridview.setVerticalSpacing(5);
					break;
			}
			
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
									Container.current.log.error(e.toString(), "ViewActivity(instagram) - onError()");

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
									switch (attributes["view_type"] as String)
									{
										case "@":
											if (e.item.view.getTag().is_private)
											{
												 showDialog(new PrivateAccountDialog(
												 {
													ok:function ():void
													{
														startActivity(new ViewActivity(), false, { view_type : attributes["view_type"] + "ID", view_data: e.item.view.getTag(), title: "Фотографии пользователя: " + (e.item.view.getTag().full_name ? e.item.view.getTag().full_name : e.item.view.getTag().username) } );
													},
													cancel:function ():void
													{
		
													}
												 }));
												
											}
											else
											{
												startActivity(new ViewActivity(), false, { view_type : attributes["view_type"] + "ID", view_data: e.item.view.getTag(), title: "Фотографии пользователя: " + (e.item.view.getTag().full_name ? e.item.view.getTag().full_name : e.item.view.getTag().username) } );
											}
											break;
										case "@ID":
										default:
											var photo:Object = 
											{
												url : e.item.view.getTag().display_src,
												caption : e.item.view.getTag().caption ? e.item.view.getTag().caption : null,
												user: { name: "",  picture: "" },
												location : e.item.view.getTag().location ? e.item.view.getTag().location.name : null,
												date : e.item.view.getTag().date
											}
											startActivity(new PhotoEditActivity(), true,  { view_type : "PHOTO",  item : e.item, photo : photo, price : 50 });
											break;
									}
								});
								
			_gridview.setAdapter(attributes["adapter"]);
			attributes["adapter"].load();			
		}		
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);
			
			Container.current.log.info("Переход на страницу просмотра. " + _title_txt.text, "instagram.activity.ViewActivity");
			
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


import com.adobe.protocols.dict.events.ErrorEvent;
import common.button.MediaSampleButton;
import common.button.SearchButton;
import common.button.PayButton;
import common.button.UserSampleButton;
import flash.app.Activity;
import flash.events.ProgressEvent;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
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
import com.greensock.loading.LoaderMax;
import com.greensock.loading.XMLLoader;
import com.greensock.events.LoaderEvent;
import com.greensock.loading.DataLoader;
import com.greensock.loading.ImageLoader;
import com.greensock.loading.core.LoaderCore;
import flash.display.Bitmap;

class UserMediaAdapter extends LoaderListAdapter
{
	private var mUser:Object;
	private var mLoader:URLLoader;
	private var mTotalCount:int;
	private var mNextPage:String;

	function UserMediaAdapter(user:Object)
	{
		super();
		mUser = user;
		mNextPage = "";
	}

	public override function getTotalCount():int
	{
		return mTotalCount;
	}

	public override function load(count:int = 20, clearList:Boolean = false, ... rest):void
	{
		if (mLoader == null)
		{
			mLoader = new URLLoader();
			mLoader.dataFormat = URLLoaderDataFormat.TEXT;
			mLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			mLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			mLoader.addEventListener(ProgressEvent.PROGRESS, function (e:ProgressEvent):void { Activity.current.attributes["lastActive"] = new Date(); } );
			
			var url:String = "https://graph.facebook.com/v2.6/" + mUser.id + "/photos?type=uploaded&access_token=EAAZAOZCJ8qHZBQBABA2vBhXSpWacCZBP69ky7X67xhKBvueWLQXzU4FcEhQUZAbgOngBAXUa0IGtRrzM2mhLo4kZBuBMdGczSzHHMouuvnYt30sZAbOt3VNapYpleZA8EJAJJsFpo5BOwpGLdkclmmlxU8wcnCmDZBr8fghri7t39AQZDZD&limit=" + count.toString() + "&offset=" + getCount().toString() + "&rank_token=" + (Math.random() * getTimer()).toString();
			
			trace(url);
			
			var request:URLRequest = new URLRequest(mNextPage.length > 0 ? mNextPage : url);
			request.method = URLRequestMethod.GET;
			request.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));
			request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8"));
			request.requestHeaders.push(new URLRequestHeader("Accept", "application/json, text/javascript, */*; q=0.01"));
			request.requestHeaders.push(new URLRequestHeader("X-Instagram-AJAX", "1"));
			request.requestHeaders.push(new URLRequestHeader("Accept-Language", "en-US,en;q=0.7,ru;q=0.3"));
			request.requestHeaders.push(new URLRequestHeader("Cache-Control", "none"));
			mLoader.load(request);
		}
	}

	public override function loadNext(count:int = 20):Boolean
	{
		if (mNextPage.length > 0)
		{
			load(count);
		}
		else
		{
			return false;
		}
		
		return true;
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
		mLoader = null;
		
		var data:String = URLLoader(e.target).data;
		
		trace(data);
		
		try
		{
			var response:Object = JSON.parse(data);

			//if (response.status == "ok")
			//{
				//mTotalCount = response.media.count;
				//mPageInfo = response.media.page_info;
//
				//for (var i:int = 0; i < response.media.nodes.length; i++)
				//{
					//var view:MediaSampleButton = new common.button.MediaSampleButton();
					//view.name = response.media.nodes[i].id;
					//view.setPadding(0, 0, 0, 0);
					//view.setScaleType("centerCrop");
					//view.setImageURI(response.media.nodes[i].thumbnail_src);
					//view.setTag(response.media.nodes[i]);
					//addItem(view);
				//}
				//
				//dispatchEvent(new Event("onLoadComplete"));
			//}
			//else
			//{
				//throw new Error(data, 0);
			//}
		}
		catch (ex:Error)
		{
			dispatchEvent(new flash.events.ErrorEvent("onError", false, false, ex.message, ex.errorID ));
		}
	}
}

class UsersAdapter extends LoaderListAdapter
{
	private var mUsername:String;
	private var mLoader:URLLoader;
	private var mTotalCount:int;
	private var mNextPage:String;

	function UsersAdapter(username:String = "iprintkiosk")
	{
		super();
		mUsername = username;
		mNextPage = "";
	}

	public override function getTotalCount():int
	{
		return mTotalCount;
	}

	public override function load(count:int = 20, clearList:Boolean = false, ... rest):void
	{
		if (mLoader == null)
		{		
			mLoader = new URLLoader();
			mLoader.dataFormat = URLLoaderDataFormat.BINARY;
			mLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			mLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			mLoader.addEventListener(ProgressEvent.PROGRESS, function (e:ProgressEvent):void { Activity.current.attributes["lastActive"] = new Date(); } );			
			var url:String = "https://graph.facebook.com/v2.6/search?type=user&q=" + encodeURI(mUsername) +  "&format=json&fields=name&access_token=EAAZAOZCJ8qHZBQBABA2vBhXSpWacCZBP69ky7X67xhKBvueWLQXzU4FcEhQUZAbgOngBAXUa0IGtRrzM2mhLo4kZBuBMdGczSzHHMouuvnYt30sZAbOt3VNapYpleZA8EJAJJsFpo5BOwpGLdkclmmlxU8wcnCmDZBr8fghri7t39AQZDZD&limit=" + count.toString() + "&offset=" + getCount().toString() + "&rank_token=" + (Math.random() * getTimer()).toString();
			var request:URLRequest = new URLRequest(mNextPage.length > 0 ? mNextPage : url);
			request.method = URLRequestMethod.GET;
			request.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));
			request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8"));
			request.requestHeaders.push(new URLRequestHeader("Accept", "application/json, text/javascript, */*; q=0.01"));
			request.requestHeaders.push(new URLRequestHeader("X-Instagram-AJAX", "1"));
			request.requestHeaders.push(new URLRequestHeader("Accept-Language", "en-US,en;q=0.7,ru;q=0.3"));
			request.requestHeaders.push(new URLRequestHeader("Cache-Control", "none"));
			mLoader.load(request);
		}
	}

	public override function loadNext(count:int = 20):Boolean
	{
		if (mNextPage.length > 0)
		{
			load(count);
		}
		else
		{
			return false;
		}
		
		return true;
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
		mLoader = null;

		var data:String = URLLoader(e.target).data;
		
		trace(data);
		
		try
		{
			var response:Object = JSON.parse(data);
			
			if (response.data != null)
			{
				mNextPage = (response.paging && response.paging.next) ? response.paging.next : "";
				
				for (var i:int = 0; i < response.data.length; i++)
				{
					var view:UserSampleButton = new common.button.UserSampleButton();
					view.name = response.data[i].id;
					view.setPadding(10, 10, 10, 90);
					view.setScaleType("centerCrop");
					view.setImageURI("https://graph.facebook.com/v2.6/" + response.data[i].id +  "/picture?type=large&access_token=EAAZAOZCJ8qHZBQBABA2vBhXSpWacCZBP69ky7X67xhKBvueWLQXzU4FcEhQUZAbgOngBAXUa0IGtRrzM2mhLo4kZBuBMdGczSzHHMouuvnYt30sZAbOt3VNapYpleZA8EJAJJsFpo5BOwpGLdkclmmlxU8wcnCmDZBr8fghri7t39AQZDZD");
					view.setTag(response.data[i]);
					view._full_name_txt.text = response.data[i].name;
					view._user_name_txt.text = "";
					addItem(view);
				}
				dispatchEvent(new Event("onLoadComplete"));
			}
			else
			{
				throw new Error(data, 0);
			}
		}
		catch (ex:Error)
		{
			dispatchEvent(new flash.events.ErrorEvent("onError", false, false, ex.message, ex.errorID ));
		}
	}
}
