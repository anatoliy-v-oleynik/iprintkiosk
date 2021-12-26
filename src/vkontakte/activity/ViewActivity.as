package vkontakte.activity 
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
	import common.button.MediaSampleButton;
	import common.button.PayButton;
	import common.button.SearchButton;
	import common.button.LogoutButton;
	import common.button.TagSampleButton;
	import common.button.UserSampleButton;
	import common.dialogs.WaitDialog;
	import common.view.Grid;
	import flash.app.Activity;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.AttributeSet;
	import flash.view.events.ItemEvent;
	import flash.widget.Button;
	import flash.widget.ImageButton;
	import vkontakte.User;
	import vkontakte.view.CountersBar;
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.activity.ViewActivity")]
	public class ViewActivity extends Activity
	{
		public var _counters:CountersBar;
		public var _backward_btn:BackwardButton;
		public var _home_btn:HomeButton;
		public var _search_btn:SearchButton;
		public var _login_btn:LoginButton;
		public var _logout_btn:LogoutButton;
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
			
			
			trace("ViewActivity")
			
			_backward_btn.addEventListener("onClick", onClick);
			_home_btn.addEventListener("onClick", onClick);
			_search_btn.addEventListener("onClick", onClick);
			_login_btn.addEventListener("onClick", onClick);
			_logout_btn.addEventListener("onClick", onClick);
			_pay_btn.addEventListener("onClick", onClick);
			_waiter.visible = false;
			
			switch (attributes["view_type"])
			{
				case "@ID" :
					attributes["adapter"] = new UserMediaAdapter(attributes["view_text"]);
					_title_txt.text = attributes["title"];
					_gridview.setNumColumns(4);
					_gridview.setRowHeight(256);
					_gridview.setColWidth(256);
					_gridview.setHorizontalSpacing(5);
					_gridview.setVerticalSpacing(5);
					break;
				case "@SEARCH" :
					attributes["adapter"] = new UsersSearchAdapter(attributes["view_text"], attributes["view_country_id"], attributes["view_city_id"]);
					_title_txt.text = attributes["title"];
					_gridview.setNumColumns(4);
					_gridview.setRowHeight(320);
					_gridview.setColWidth(247);
					_gridview.setHorizontalSpacing(16);
					_gridview.setVerticalSpacing(10);
					break;					
			}
			
			attributes["adapter"].addEventListener("onLoadStart",
								function (e:Event):void
								{
									showDialog(new WaitDialog());
								});				
			
			attributes["adapter"].addEventListener("onLoadComplete",
								function (e:Event):void
								{
									switch (attributes["view_type"])
									{
										case "@ID" :
											_title_txt.text = attributes["title"] + " Найдено " + e.target.getTotalCount().toString() + " фотографий.";
											break;
										case "@SEARCH" :
											_title_txt.text = attributes["title"] + " Найдено " + e.target.getTotalCount().toString() + " пользователей.";
											break;
									}
									
									var wait:Boolean = false;
									if (!_gridview.canScrollVertically(1)) wait = attributes["adapter"].loadNext(40);
									if (wait != true)
									{
										closeDialog();
									}									
									_waiter.visible = wait;
								});
								
			attributes["adapter"].addEventListener("onError",
								function (e:ErrorEvent):void
								{
									Container.current.log.error(e.toString(), "ViewActivity(vkontakte) - onError()");
									
									attributes["DestroyOnStop"] = false;
									startActivity(new ErrorActivity( new AttributeSet({ repeat:function ():void { attributes["adapter"].loadNext(); closeDialog(); } })), true);
								});								
								
			_gridview.addEventListener("onScrollDownEnd",
								function (e:Event):void
								{
									var wait:Boolean = false;
									if (!_gridview.canScrollVertically(1)) wait = attributes["adapter"].loadNext(40);
									if (wait != true)
									{
										closeDialog();
									}									
									_waiter.visible = wait;
								});
								
			_gridview.addEventListener("onItemClick",
								function (e:ItemEvent):void
								{
									switch (attributes["view_type"] as String)
									{
										case "@SEARCH":
											startActivity(new ViewActivity( new AttributeSet ( { view_type:"@ID", view_text:e.item.view.getTag().id, title : "Фотографии пользователя ( " + (e.item.view as UserSampleButton)._full_name_txt.text + " )." } )), false)
											break;
										case "@ID":
										default:
											var item:Object = e.item.view.getTag();
											var photo:Object = 
											{
												url : item.sizes.sortOn(['width', 'height'], [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC | Array.DESCENDING])[0].url,
												caption : item.text ? item.text : null,
												user: { name: "",  picture: "" },
												location : null,
												date : item.date
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
			
			Container.current.NotifyUserActivity("Страница результата поиска vkontakte - " + _title_txt.text);
			
			Container.current.log.info("Переход на страницу просмотра. " + _title_txt.text, "vkontakte.activity.ViewActivity");
			
			if (User.current.signed)
			{
				_counters.visible = !User.current.isAppUser();
				_counters._photos_btn.setText(User.current.data.user.counters.photos);
				_counters._friends_btn.setText(User.current.data.user.counters.friends);
				_login_btn.visible = User.current.isAppUser();
				_logout_btn.visible = !User.current.isAppUser();
			}
			else
			{
				_counters.visible = false;
				_login_btn.visible = true;
				_logout_btn.visible = false;
					
				User.current.signin();
			}
			
			_pay_btn.visible = Order.current.items.length > 0

			_total_price_txt.text = Order.current.totalPrice.toString();
			_count_photo_txt.text =  (Order.current.totalCount % 2 != 0) ? Order.current.totalCount.toString() + " + 1" : Order.current.totalCount.toString();
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
				case "_pay_btn":
					startActivity(new CartActivity(), true);
					break;
				case "_login_btn":
					startActivity(new vkontakte.activity.LoginActivity(), true);
					break;
				case "_search_btn":
					startActivity(new SearchActivity(), true);
					break;					
				case "_logout_btn":
					break;						
			}
		}
		
		protected override function onStop(e:Event):void
		{
			super.onStop(e);
			
			trace("onStop");
		}
		
		protected override function onDestroy(e:Event):void
		{
			super.onDestroy(e);
			
			attributes["adapter"].clear();
			
			trace("onDestroy");
		}			
		
	}
}

import common.button.MediaSampleButton;
import common.button.SearchButton;
import common.button.PayButton;
import common.button.UserSampleButton;
import flash.app.Activity;
import flash.events.ErrorEvent;
import flash.events.ProgressEvent;
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

class UsersSearchAdapter extends LoaderListAdapter
{
	private var mQ:String;
	private var mCountryId:int;
	private var mCityId:int;
	private var mLoader:URLLoader;
	private var mRequest:URLRequest;
	private var mTotalCount:int;
	private var mCanLoadNext:Boolean;

	function UsersSearchAdapter(q:String = "iprintkiosk", country_id:int = 1, city_id:int = 87)
	{
		super();
		mQ = q;
		mCountryId = country_id;
		mCityId = city_id;
		mTotalCount = 0;
		mCanLoadNext = false;
	}

	public override function getTotalCount():int
	{
		return mTotalCount;
	}

	public override function load(count:int = 16, clearList:Boolean = false, ... rest):void
	{
		if (!mLoader)
		{
			dispatchEvent(new Event("onLoadStart"));
			
			try
			{
				mLoader = new URLLoader();
				mLoader.dataFormat = URLLoaderDataFormat.TEXT;
				mLoader.addEventListener(Event.COMPLETE, onLoadComplete);
				mLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				mLoader.addEventListener(ProgressEvent.PROGRESS, function (e:ProgressEvent):void { Activity.current.attributes["lastActive"] = new Date(); } );
				
				var request:URLRequest = new URLRequest("http://iprintkiosk.ru/vkontakte/users_search.php?n=" + (Math.random() * getTimer()).toString() + "&count="  + count.toString() +  (getCount() > 0 ? "&offset=" + getCount().toString() : "") + (rest.length > 0 ? "&" + rest.join("&") : "") + ("&q=" + encodeURI(mQ)) + (mCountryId > 0 ? "&country=" + mCountryId.toString() : "") + (mCityId > 0 ? "&city=" + mCityId.toString() : "") + "&fields=photo_max,screen_name,city,country" );
				
				trace(request.url);
				
				request.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));
				mLoader.addEventListener(Event.COMPLETE, onLoadComplete);
				mLoader.load(request);
			}
			catch (ex:Error)
			{
				dispatchEvent(new ErrorEvent("onError", false, false, ex.message, ex.errorID ));
			}
		}
	}

	public override function loadNext(count:int = 20):Boolean
	{
		if (mCanLoadNext)
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
		mLoader.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
		mLoader.close();
		mLoader = null;		
		
		Container.current.log.error(e.text, "ViewActivity[vkontakte] - onIOError()");
		dispatchEvent(new ErrorEvent("onError", false, false, e.text, e.errorID ));
	}
	
	protected function onLoadComplete(e:Event):void
	{
		mLoader.removeEventListener(Event.COMPLETE, onLoadComplete);
		mLoader.close();
		mLoader = null;
		
		
		
		try
		{
			trace((e.target as URLLoader).data.toString());
			
			var data:Object = JSON.parse((e.target as URLLoader).data.toString());
		
			if (data.response)
			{
				if (data.response.items.length > 0)
				{
					mTotalCount = data.response.count;
					for (var i:int = 0; i < data.response.items.length; i++)
					{
						var view:UserSampleButton = new UserSampleButton();
						view.name = data.response.items[i].id;
						view.setScaleType("centerCrop");
						view.setTag(data.response.items[i]);
						view.setImageURI(data.response.items[i].photo_max);
						view._full_name_txt.text = data.response.items[i].first_name + " " + data.response.items[i].last_name;
						view._user_name_txt.text = data.response.items[i].city ? data.response.items[i].city.title : "";					
						addItem(view);
					}
					
					mCanLoadNext = getCount() < mTotalCount;
				}
				else
				{
					mCanLoadNext = false;
				}
				dispatchEvent(new Event("onLoadComplete"));
				
			}
			else if (data.error)
			{
				throw new Error(data.error.error_msg, data.error.error_code);
			}
			else
			{
				throw new Error((e.target as URLLoader).data.toString());
			}
		}
		catch (ex:Error)
		{
			dispatchEvent(new ErrorEvent("onError", false, false, ex.message, ex.errorID ));
		}
	}
}

class UserMediaAdapter extends LoaderListAdapter
{
	private var mUserId:String;
	private var mLoader:URLLoader;
	private var mRequest:URLRequest;
	private var mTotalCount:int;
	private var mQueue:LoaderMax;
	private var mCanLoadNext:Boolean;

	function UserMediaAdapter(userid:String = "1589410363")
	{
		super();
		mUserId = userid;
		mCanLoadNext = false;
	}

	public override function getTotalCount():int
	{
		return mTotalCount;
	}

	public override function load(count:int = 20, clearList:Boolean = false, ... rest):void
	{
		if (!mLoader)
		{
			dispatchEvent(new Event("onLoadStart"));
			
			try
			{
				mLoader = new URLLoader();
				mLoader.dataFormat = URLLoaderDataFormat.TEXT;
				mLoader.addEventListener(Event.COMPLETE, onLoadComplete);
				mLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				mLoader.addEventListener(ProgressEvent.PROGRESS, function (e:ProgressEvent):void { Activity.current.attributes["lastActive"] = new Date(); } );
				var request:URLRequest = new URLRequest("http://iprintkiosk.ru/vkontakte/photos_get.php?n=" + (Math.random() * getTimer()).toString() + "&access_token=" + vkontakte.User.current.data.access_token + "&count="  + count.toString() +  "&offset=" + getCount().toString() + (rest.length > 0 ? "&" + rest.join("&") : "") + "&owner_id=" + encodeURI(mUserId) + "&photo_sizes=1");
				
				trace(vkontakte.User.current.data.access_token);
				
				trace(request.url);
				
				request.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));
				mLoader.addEventListener(Event.COMPLETE, onLoadComplete);
				mLoader.load(request);
			}
			catch (ex:Error)
			{
				trace("ONERROR");
				
				dispatchEvent(new ErrorEvent("onError", false, false, ex.message, ex.errorID ));
			}
		}
	}

	public override function loadNext(count:int = 20):Boolean
	{
		if (mCanLoadNext)
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
		mLoader.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
		mLoader.close();
		mLoader = null;		
		
		dispatchEvent(new ErrorEvent("onError", false, false, e.text, e.errorID ));
	}	
	
	protected function onLoadComplete(e:Event):void
	{
		trace("ONLOADCOMPLETE");
		
		mLoader.removeEventListener(Event.COMPLETE, onLoadComplete);
		mLoader.close();
		mLoader = null;
		
		try
		{
			var data:Object = JSON.parse((e.target as URLLoader).data.toString());

			if (data.response)
			{
				if (data.response.items.length > 0)
				{	
					mTotalCount = data.response.count;
					
					for (var i:int = 0; i < data.response.items.length; i++)
					{
						var item:MediaSampleButton = new MediaSampleButton();
						item.name = data.response.items[i].id;
							
						var photo_sizes:Array = data.response.items[i].sizes;
						photo_sizes = photo_sizes.sortOn(['width', 'height'], [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC | Array.DESCENDING]);
						
						var prop:String = "";
						var curr_photo:Object = null;
						for each (var photo:Object in photo_sizes)
						{
							if (curr_photo == null)
							{
								prop = photo.width > photo.height ? "width" : "height";
								curr_photo = photo;
							}
							else if ((photo[prop] >= 256) && ((photo[prop] < curr_photo[prop]) || (curr_photo[prop] < 256)))
							{
								curr_photo = photo;
							}
							else if ((photo[prop] > curr_photo[prop]) && (curr_photo[prop] < 256))
							{
								curr_photo = photo;
							}
						}
						
						item.setScaleType("centerCrop");
						item.setTag(data.response.items[i]);
						item.setImageURI(curr_photo.url);
						this.addItem(item);
					}
					mCanLoadNext = getCount() < mTotalCount;
				}
				else
				{
					mCanLoadNext = false;
				}
				dispatchEvent(new Event("onLoadComplete"));
			}
			else if (data.error)
			{
				throw new Error(data.error.error_msg, data.error.error_code);
			}			
			else
			{
				throw new Error((e.target as URLLoader).data.toString());
			}
		}
		catch (ex:Error)
		{
			dispatchEvent(new ErrorEvent("onError", false, false, ex.message, ex.errorID ));
		}
	}
}