package instagram.activity 
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
	import common.dialogs.WaitDialog;
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
	import instagram.activity.SearchActivity;
	import instagram.dialogs.PrivateAccountDialog;
	import flash.system.Security;
	
	[Embed(source="../../../lib/assets.swf", symbol="instagram.activity.ViewActivity")]
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
				case "#" :	
					attributes["adapter"] = new UsersAdapter(attributes["view_text"], attributes["view_type"]);
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
			
			attributes["adapter"].addEventListener("onLoadStart",
								function (e:Event):void
								{
									showDialog(new WaitDialog());
								});			
			
			attributes["adapter"].addEventListener("onLoadComplete",
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
								
			attributes["adapter"].addEventListener("onError",
								function (e:flash.events.ErrorEvent):void
								{
									Container.current.log.error(e.toString(), "ViewActivity(instagram) - onError()");

									attributes["destroyOnStop"] = true;
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
											startActivity(new PhotoEditActivity(), true,  { view_type : "PHOTO",  item : null, photo : e.item.view.getTag(), price : 50 });
											break;
									}
								});
								
			_gridview.setAdapter(attributes["adapter"]);
			attributes["adapter"].load();			
		}		
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);
			
			Container.current.NotifyUserActivity("Страница результата поиска instagramm - " + _title_txt.text);	
			
			Container.current.log.info("Переход на страницу просмотра. " + _title_txt.text, "instagram.activity.ViewActivity");
			
			_pay_btn.visible = Order.current.items.length > 0
			_total_price_txt.text = Order.current.totalPrice.toString();
			_count_photo_txt.text = Order.current.totalCount.toString();
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
		
		protected function onClick(e:Event):void
		{
			switch (e.target.name)
			{
				case "_backward_btn":
					Activity.current.attributes["DestroyOnStop"] = true;
					Activity.current.backward();
					break;
				case "_home_btn":
					startActivity(Activity.list[0]);
					trace("Activity.list.length", Activity.list.length);
					
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
import common.dialogs.WaitDialog;
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
	private var mNextMaxId:String;
	private var mImageLoader:ProLoader;
	private var mImageLoadIndex:int = 0;
	private var mQueue:LoaderMax;
	private var mPageInfo:Object;
	private var mMaxId:String;
	private var mMoreAvailable:Boolean;

	function UserMediaAdapter(user:Object)
	{
		super();
		mUser = user;
		mMaxId = "";
		mMoreAvailable = false;
	}

	public override function getTotalCount():int
	{
		return mTotalCount;
	}

	public override function load(count:int = 20, clearList:Boolean = false, ... rest):void
	{
		if (mLoader == null)
		{
			dispatchEvent(new Event("onLoadStart"));
			
			mLoader = new URLLoader();
			mLoader.dataFormat = URLLoaderDataFormat.TEXT;
			mLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			mLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			mLoader.addEventListener(ProgressEvent.PROGRESS, function (e:ProgressEvent):void { Activity.current.attributes["lastActive"] = new Date(); } );
			
			//var url:String = "https://instagram.com/" + mUser.username + "/?__a=1" + ((mMaxId != "") ? "&max_id=" + mMaxId : "");
			//var	url:String = "https://instagram.com/graphql/query/?query_id=17888483320059182&id=" + mUser.pk + "&first=50" + ((mMaxId != "") ? "&after=" + mMaxId : "");
			
			//var	url:String = "https://stapico.ru/" + mUser.username + "/photos/ajax" + ((mMaxId != "") ? "/" + mMaxId : "");
			
			
			
			//trace(JSON.stringify(mUser));
			
			
			//var url:String = "https://stapico.ru/instagram/photos/ajax/";
			
			var	url:String = "https://www.instagram.com/graphql/query/?query_id=17880160963012870&id=" + mUser.pk + "&first=50" + ((mMaxId != "") ? "&after=" + mMaxId : "");

			
			trace(url);
			
			Container.current.log.info("ЗАГРУЗКА: " + url, "vkontakte.activity.ViewActivity");
			
			
			var request:URLRequest = new URLRequest(url);
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
		if (mMoreAvailable)
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
		
		trace("-----------------------");
		trace(data);
		trace("-----------------------");
		
		Container.current.log.info("ДАННЫЕ: " + data,  "vkontakte.activity.ViewActivity");
		
		
		try
		{
		
			var view:MediaSampleButton;
			
			var response:Object = JSON.parse(data);
			
			trace("RESPONSE_STATUS:" + response.status);
			
			if (response.status.toUpperCase() == "OK")
			{
				for each(var item:Object in response.data.user.edge_owner_to_timeline_media.edges)
				{
					trace("media_thumbnail_src:" + item.node.display_url);
					
					view = new common.button.MediaSampleButton();
					view.name = item.node.id;
					view.setPadding(0, 0, 0, 0);
					view.setScaleType("centerCrop");
					view.setImageURI(item.node.thumbnail_src);
					view.setTag( { id:item.node.id, url:item.node.display_url, date:item.node.taken_at_timestamp,  caption: (item.node.edge_media_to_caption.edges.length > 0) ? item.node.edge_media_to_caption.edges[0].node.text : "", location:"" } );
					addItem(view);	
					
/*					
 * 					switch (item.media_type)
					{
						case 8:
							if (item.carousel_media != null)
							{
								for each(var media:Object in item.carousel_media)
								{
									switch (media.media_type)
									{
										case 1:
											view = new common.button.MediaSampleButton();
											view.name = item.id;
											view.setPadding(0, 0, 0, 0);
											view.setScaleType("centerCrop");
											
											if (media.image_versions2 != null)
											{
												view.setImageURI(media.image_versions2.candidates[media.image_versions2.candidates.length - 1].url);
												view.setTag( { id:media.id, fullname:media.user != null ? media.user.full_name : "", username:media.user != null ? media.user.username : "", url:media.image_versions2.candidates[0].url, date:media.created_time, caption:media.caption != null ? media.caption.text_alt : "", location:media.location != null ? media.location.name : "" } );
												
											}
											else if ((media.images != null) && (media.images.low_resolution != null))
											{
												view.setImageURI(media.images.low_resolution.url);
												view.setTag( { id:media.id, fullname:media.user != null ? media.user.full_name : "", username:media.user != null ? media.user.username : "", url:media.images.low_resolution.url, date:media.created_time, caption:media.caption != null ? media.caption.text_alt : "", location:media.location != null ? media.location.name : "" } );
											}
											else
											{
												trace("Неудалось найти фотографии для медиа(1).");
											}											
											addItem(view);											
											break;
										default:
											trace("Тип медиа №" + media.media_type.toString() + " для карусели(8) не обробатывается.");
											break;
									}
								}
							}
							break;
						case 1:
							view = new common.button.MediaSampleButton();
							view.name = item.id;
							view.setPadding(0, 0, 0, 0);
							view.setScaleType("centerCrop");							
							if (item.image_versions2 != null)
							{
								view.setImageURI(item.image_versions2.candidates[item.image_versions2.candidates.length - 1].url.replace("//", "/").replace(":/", "://"));
								view.setTag( { id:item.id, fullname:item.user != null ? item.user.full_name : "", username:item.user != null ? item.user.username : "", url:item.image_versions2.candidates[0].url.replace("//", "/").replace(":/", "://"), date:item.created_time, caption:item.caption != null ? item.caption.text_alt : "", location:item.location != null ? item.location.name : "" } );
							}
							else if ((item.images != null) && (item.images.low_resolution != null))
							{
								view.setImageURI(item.images.low_resolution.url.replace("//", "/").replace(":/", "://"));
								view.setTag( { id:item.id, fullname:item.user != null ? item.user.full_name : "", username:item.user != null ? item.user.username : "", url:item.images.low_resolution.url.replace("//", "/").replace(":/", "://"), date:item.created_time, caption:item.caption != null ? item.caption.text_alt : "", location:item.location != null ? item.location.name : "" } );
							}
							else
							{
								trace("Неудалось найти фотографии для медиа(1).");
							}
							
							addItem(view);	
							break;
						default:
							trace("Тип медиа №" + item.media_type.toString() + " не обробатывается.");
							break;
					}
				*/	
					
				}

				mMoreAvailable = response.data.user.edge_owner_to_timeline_media.page_info.has_next_page; 
				mMaxId = ((mMoreAvailable == true) ? response.data.user.edge_owner_to_timeline_media.page_info.end_cursor : ""); // response.data.user.edge_owner_to_timeline_media.page_info.end_cursor;
				
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

class UsersAdapter extends LoaderListAdapter
{
	private var mText:String;
	private var mType:String;
	private var mLoader:URLLoader;
	private var mTotalCount:int;
	private var mOffset:int;
	private var mQueue:LoaderMax;

	function UsersAdapter(text:String = "iprintkiosk", type:String = "@")
	{
		super();
		mText = text;
		mType = type;
	}

	public override function getTotalCount():int
	{
		return mTotalCount;
	}

	public override function load(count:int = 20, clearList:Boolean = false, ... rest):void
	{
		if (mLoader == null)
		{
			dispatchEvent(new Event("onLoadStart"));
			
			mLoader = new URLLoader();
			mLoader.dataFormat = URLLoaderDataFormat.BINARY;
			mLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			mLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			mLoader.addEventListener(ProgressEvent.PROGRESS, function (e:ProgressEvent):void { Activity.current.attributes["lastActive"] = new Date(); } );			
			//var request:URLRequest = new URLRequest("https://stapico.com/search/ajax/" + (mType == "@" ? "@" + mText : mText));
			
			var request:URLRequest = new URLRequest("https://www.instagram.com/web/search/topsearch/?query=" + mText);
			
			request.method = URLRequestMethod.GET;
			
			
			request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json; charset=utf-8"));
			request.requestHeaders.push(new URLRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"));
			request.requestHeaders.push(new URLRequestHeader("Accept-Language", "ru,en-US;q=0.9,en;q=0.8"));
			request.requestHeaders.push(new URLRequestHeader("Cache-Control", "none"));
			request.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));
			mLoader.load(request);
		}
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
		
		trace("DATA:");
		trace(data);
		
		try
		{
			var response:Object = JSON.parse(data);


			//mQueue = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
			
			//var request:URLRequest = new URLRequest("https://instagram.fhel5-1.fna.fbcdn.net/vp/11df9c9f62c5f0ed0900aeabafd196fb/5D19121F/t51.2885-19/10691661_369853923167554_951922450_a.jpg?_nc_ht=instagram.fhel5-1.fna.fbcdn.net");
			//request.method = URLRequestMethod.GET;
			
			
			//request.requestHeaders.push(new URLRequestHeader("Content-Type", "image/jpeg"));
			//request.requestHeaders.push(new URLRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"));
			//request.requestHeaders.push(new URLRequestHeader("Accept-Language", "ru,en-US;q=0.9,en;q=0.8"));
			//request.requestHeaders.push(new URLRequestHeader("Cache-Control", "none"));
			//request.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));			
			
			
			//mQueue.append( new ImageLoader(request, {name:"photo1", estimatedBytes:2400, container:this, alpha:0, width:250, height:150, scaleMode:"proportionalInside"}) );
			//mQueue.load();

			
			if (response.users != null)
			{
				for each (var o:Object in response.users)
				{

					//trace(o.user.profile_pic_url);
					
					var view:UserSampleButton = new common.button.UserSampleButton();
					view.name = o.user.username;
					//trace(view.name);
					
					view.setPadding(10, 10, 10, 90);
					view.setScaleType("centerCrop");
					if (!o.user.has_anonymous_profile_picture)
					{
						view.setImageURI(o.user.profile_pic_url);
					}
					view.setTag(o.user);
					view._full_name_txt.text = o.user.full_name;
					view._user_name_txt.text = o.user.username;
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
	
	protected function progressHandler(event:LoaderEvent):void
	{
		trace("progress: " + event.target.progress);
	}

	protected function completeHandler(event:LoaderEvent):void
	{
		trace(event.target + " is complete!");
	}
	 
	protected function errorHandler(event:LoaderEvent):void
	{
		trace("ERROR", event.text);
	}	
}

class TagsAdapter extends LoaderListAdapter
{
	private var mText:String;
	private var mType:String;
	private var mLoader:URLLoader;
	private var mTotalCount:int;
	private var mOffset:int;
	private var mQueue:LoaderMax;

	function TagsAdapter(text:String = "iprintkiosk", type:String = "#")
	{
		super();
		mText = text;
		mType = type;
	}

	public override function getTotalCount():int
	{
		return mTotalCount;
	}

	public override function load(count:int = 20, clearList:Boolean = false, ... rest):void
	{
		if (mLoader == null)
		{
			dispatchEvent(new Event("onLoadStart"));
			
			mLoader = new URLLoader();
			mLoader.dataFormat = URLLoaderDataFormat.BINARY;
			mLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			mLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			mLoader.addEventListener(ProgressEvent.PROGRESS, function (e:ProgressEvent):void { Activity.current.attributes["lastActive"] = new Date(); } );			
			//var request:URLRequest = new URLRequest("https://stapico.com/search/ajax/" + (mType == "@" ? "@" + mText : mText));
			var request:URLRequest = new URLRequest("https://www.instagram.com/web/search/topsearch/?query=" + mText);
			
			request.method = URLRequestMethod.GET;
			
			
			request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json; charset=utf-8"));
			request.requestHeaders.push(new URLRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"));
			request.requestHeaders.push(new URLRequestHeader("Accept-Language", "ru,en-US;q=0.9,en;q=0.8"));
			request.requestHeaders.push(new URLRequestHeader("Cache-Control", "none"));
			request.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));
			mLoader.load(request);
		}
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

			if (response.users != null)
			{
				for each (var o:Object in response.users)
				{
					trace(o.username);
					
					var view:UserSampleButton = new common.button.UserSampleButton();
					view.name = o.username;
					trace(view.name);
					
					view.setPadding(10, 10, 10, 90);
					view.setScaleType("centerCrop");
					if (!o.has_anonymous_profile_picture)
					{
						view.setImageURI(o.profile_pic_url);
					}
					view.setTag(o);
					view._full_name_txt.text = o.full_name;
					view._user_name_txt.text = o.username;
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
