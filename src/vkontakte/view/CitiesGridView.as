package vkontakte.view 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.text.TextField;
	import flash.view.GridView;
	import flash.view.TextEdit;
	import flash.view.View;
	import flash.view.events.ItemEvent;
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.view.CitiesGridView")]
	public class CitiesGridView extends GridView
	{
		public static function get defaultAdapterClass():Class
		{
			return CitiesAdapter;
		}
		
		public function CitiesGridView() 
		{
			super();
			setPadding(15, 25, 15, 15);
			setNumColumns(1);
			setColWidth(500);
			setRowHeight(65);
			setHorizontalSpacing(5);
			setVerticalSpacing(5);
		}
	}
}

import flash.app.Activity;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLLoaderDataFormat;
import flash.text.TextField;
import flash.utils.getTimer;
import flash.view.ListAdapter;
import flash.view.ListItem;
import flash.view.LoaderListAdapter;
import vkontakte.button.CityViewItem;


class CitiesAdapter extends LoaderListAdapter
{
	private var mLoader:URLLoader;
	private var mTotalCount:int;
	
	function CitiesAdapter()
	{
		super();
	}

	public override function getTotalCount():int
	{
		return mTotalCount;
	}

	public override function load(count:int = 4, clearList:Boolean = false, ... rest):void
	{
		if (!mLoader)
		{
			try
			{
				if (clearList) clear();
				
				mLoader = new URLLoader();
				mLoader.dataFormat = URLLoaderDataFormat.TEXT;
				mLoader.addEventListener(Event.COMPLETE, onLoadComplete);
				mLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				mLoader.addEventListener(ProgressEvent.PROGRESS, function (e:ProgressEvent):void { Activity.current.attributes["lastActive"] = new Date(); } );
				var request:URLRequest = new URLRequest("http://iprintkiosk.ru/vkontakte/cities_get.php?n=" + (Math.random() * getTimer()).toString() + "&count="  + count.toString() +  "&offset=" + getCount().toString() + "&" + rest.join("&"));
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
		if (mTotalCount > getCount())
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
		mLoader.removeEventListener(Event.COMPLETE, onLoadComplete);
		mLoader.close();
		mLoader = null;

		try
		{
			var data:Object = JSON.parse((e.target as URLLoader).data.toString());

			if (data.response)
			{
				mTotalCount = data.response.count + 1;
				
				var item:CityViewItem;
				for (var i:int = 0; i < data.response.items.length; i++)
				{
					item = new CityViewItem();
					item.name = data.response.items[i].id;
					item.setTextVerticalAlign(data.response.items[i].region ? "none" : "center");
					item.setText(data.response.items[i].title);
					item.setTag(data.response.items[i]);
					item._region_txt.text = data.response.items[i].region ? data.response.items[i].region : "";
					addItem(item);
				}
				
				item = new CityViewItem();
				item.name = "0";
				item.setTextVerticalAlign("center");
				item.setText("Любой город");
				item.setTag( {id:0, title:"Любой город" } );
				item._region_txt.text = "";
				addItem(item);
				
				dispatchEvent(new Event("onLoadComplete"));
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