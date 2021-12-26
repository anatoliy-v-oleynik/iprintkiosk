package common.activity
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import common.activity.PrintActivity;
	import common.button.GiftButton;
	import common.dialogs.GiftDialog;
	import flash.content.Context;
	import flash.events.ErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SampleDataEvent;
	import flash.events.TextEvent;
	import flash.external.devices.AcceptorEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;	
	import common.button.BackwardButton;
	import common.button.PrintButton;
	import common.view.OrderGridView;
	import flash.app.Activity;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.view.IListView;
	import flash.view.events.ItemEvent;
	import flash.ui.Keyboard;
	
	
	[Embed(source = "../../../lib/assets.swf", symbol = "common.activity.CartActivity")]
	public class CartActivity extends Activity
	{
		public var _backward_btn:BackwardButton;
		public var _print_btn:PrintButton;
		public var _gift_btn:GiftButton;
		public var _total_price_txt:TextField;
		public var _count_photo_txt:TextField;
		public var _title_txt:TextField;
		public var _info_txt:TextField;
		
		public var _amount_txt:TextField;
		public var _amount_label_txt:TextField;
		public var _deposit_txt:TextField;
		public var _deposit_label_txt:TextField;
		public var _balance_txt:TextField;
		public var _balance_label_txt:TextField;
		public var _gridview:OrderGridView;
		
		
		private var billLastDataReceive:Date;
		private var billInterval:uint;
		private var reinit:Boolean;
		
		
		public function CartActivity()
		{
			super();
			
			_print_btn.visible = false;
			
			reinit = false;
			billLastDataReceive = new Date();
			billInterval = setInterval(
			function(a:uint):void
			{
				var timePassed:uint = (new Date().getTime() - billLastDataReceive.getTime()) / 1000;
				if (timePassed > 20)
				{
					if (!reinit)
					{
						Container.current.Logging("Нет отклика от купюра приемника, делаем сброс.", "CartActivity");
						
						Container.current.log.error("НЕТ ОТКЛИКА ОТ КУПЮРНИКА делаем сброс купюраприемника.", "common.activity.CartActivity");
						
						Container.current.acceptor.Polling(0, 0);
						Container.current.acceptor.Reset();
						Container.current.acceptor.Disable();
					
						Container.current.acceptor.Enable();
						Container.current.acceptor.Polling(15000, 10000);
						reinit = true;
					}
					else
					{
						clearInterval(billInterval);
						reinit = false;
						Container.current.Shutdown("После сброса купюраприемника отклик не появился, делаем перезагрузку.");
					}
				}

			}, 1000 * 10, billInterval);
		}
		
		protected override function onCreate(e:Event):void
		{
			super.onCreate(e);
			
			attributes["idleTimeout"] = 60000 * 3;
			
			_backward_btn.addEventListener("onClick", onClick);
			_print_btn.addEventListener("onClick", onClick);
			_gift_btn.addEventListener("onClick", onClick);

			Order.current.addEventListener("onOrderChanged", function(e:Event):void
			{
				refresh();
			});
			
			attributes["adapter"] = new PhotoListAdapter();
			attributes["adapter"].addEventListener("onItemRemoved", function(e:ItemEvent):void
			{
				Order.current.removeItem(e.item.view.getTag());
				
			});
			
			_gridview.addEventListener("onItemClick", function(e:ItemEvent):void
			{
				switch (getQualifiedClassName(e.item.view))
				{
				case "common.view::OrderItemView": 
					switch (e.relatedObject.name)
					{
					case "_delete_btn": 
						(e.target as IListView).getAdapter().removeItem(e.item.view);
						break;
					}
					break;
				case "common.view::OrderItemAddView": 
					switch (e.relatedObject.name)
					{
					case "_add_btn": 
						Activity.current.backward();
						break;
					}
					break;
				}
			});
			_gridview.setNumColumns(3);
			_gridview.setRowHeight(520.2);
			_gridview.setColWidth(332.4);
			_gridview.setHorizontalSpacing(18);
			_gridview.setVerticalSpacing(6);
			_gridview.setAdapter(attributes["adapter"]);
			
			_title_txt.text = "Мой заказ: для оплаты заказа внесите купюры в купюраприемник и нажмите кнопку печать."
			_info_txt.text = "Принимает купюры номиналом 10, 50, 100, 500, 1000. Не выдает сдачу наличными.";
		}
		
		protected override function onStart(e:Event):void
		{
			super.onStart(e);

			if (Activity.current) Activity.current.attributes["lastActive"] = new Date();
			
			Container.current.NotifyUserActivity("Пользователь в карзине.");
			
			Container.current.log.info("Переход в карзину.", "common.activity.CartActivity");
			
			Context.base.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			Container.current.acceptor.addEventListener("onStacked", onBillStacked);
			Container.current.acceptor.addEventListener("onReturned", onBillReturned);
			Container.current.acceptor.addEventListener("onError", onBillError);
			Container.current.acceptor.addEventListener("onData", onBillData);
			Container.current.acceptor.Enable();
			Container.current.acceptor.Polling(15000, 10000);
			refresh();
		}
		
		protected override function onStop(e:Event):void
		{	
			Container.current.log.info("Покинули карзину.", "common.activity.CartActivity");
			
			Context.base.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			Container.current.acceptor.removeEventListener("onStacked", onBillStacked);
			Container.current.acceptor.removeEventListener("onReturned", onBillReturned);
			Container.current.acceptor.removeEventListener("onError", onBillError);
			Container.current.acceptor.removeEventListener("onData", onBillData);
			Container.current.acceptor.Polling(0, 0);
			Container.current.acceptor.Reset();
			Container.current.acceptor.Disable();
			
			clearInterval(billInterval);
			super.onStop(e);
		}
			
		protected function onClick(e:Event):void
		{
			switch (e.target.name)
			{
			case "_backward_btn": 
				Activity.current.backward();
				break;
			case "_print_btn": 
				startActivity(new PrintActivity(), true);
				break;
			case "_gift_btn": 
			showDialog(new GiftDialog( {
				ok:	function (response:Object):void
				{
					Container.current.log.info("Учтен подарочный сертификат (номинал:" + response.nominal + ").", "common.activity.CartActivity");
					
					Order.current.inputAmount(response.nominal);	
					
					refresh();
				} }));
				break;				
			}
		}
		
		protected function onKeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.INSERT)
			{
				onBillStacked(new AcceptorEvent("onStacked", "RUR", 50));
			}
		}
		
		protected function onBillStacked(e:AcceptorEvent):void
		{
			billLastDataReceive = new Date();
			
			if (Activity.current) Activity.current.attributes["lastActive"] = new Date();
			
			Container.current.log.info("Внесена купюра номиналом: " + e.nominal.toString() + " руб.", "common.activity.CartActivity");
			
			Container.current.NotifyUserActivity("Внесена купюра номиналом " + e.nominal.toString() + " руб.");
			
			Order.current.inputAmount(e.nominal);
			refresh();
		}
		
		protected function onBillReturned(e:AcceptorEvent):void
		{
			billLastDataReceive = new Date();
			
			if (Activity.current) Activity.current.attributes["lastActive"] = new Date();
			
			Container.current.NotifyUserActivity("Возвращена купюра номиналом " + e.nominal.toString() + " руб.");
			
			Container.current.log.warn("Возвращена купюра номиналом: " + e.nominal.toString() + " руб.", "common.activity.CartActivity");
		}
		
		protected function onBillError(e:ErrorEvent):void
		{
			billLastDataReceive = new Date();
			
			if (Activity.current) Activity.current.attributes["lastActive"] = new Date();			
			
			Container.current.Logging("Ошибка купюра приемника: " + e.text, "CartActivity");
			
			Container.current.log.error("Ошибка купюра приемника: " + e.text, "common.activity.CartActivity");
		}		
		
		protected function onBillData(e:TextEvent):void
		{
			billLastDataReceive = new Date();
		}		
		
		protected function refresh():void
		{
			_total_price_txt.text = Order.current.totalPrice.toString();
			_count_photo_txt.text =  (Order.current.totalCount % 2 != 0) ? Order.current.totalCount.toString() + " + 1" : Order.current.totalCount.toString();
				
			_amount_label_txt.text = "К оплате:";
			_amount_txt.text = Order.current.totalPrice.toString();
			
			_deposit_label_txt.text = "Внесено:";
			_deposit_txt.text = Order.current.deposit.toString();
			
			_balance_label_txt.text = Order.current.balance < 0 ? "Осталось внести:" : "Остаток средств:";
			_balance_txt.text = Math.abs(Order.current.balance).toString();
			
			_print_btn.visible = Order.current.deposit >= Order.current.totalPrice;
			
			if (Order.current.totalCount == 0)
			{
				_print_btn.visible = false;
			}
		}
	}
}

import common.view.OrderItemAddView;
import common.view.OrderItemView;
import flash.view.ListAdapter;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.events.Event;

class PhotoListAdapter extends ListAdapter
{
	function PhotoListAdapter()
	{
		super();
		
		var view:OrderItemView;
		
		for each (var item:Object in Order.current.items)
		{
			for (var i:int = 0; i < item.count; i++)
			{
				view = new OrderItemView();
				view._preview.setScaleType("centerCrop");
				view._preview.setImageBitmap(item.preview);
				view.setTag(item);
				addItem(view);
			}
		}
		
		addItem(new OrderItemAddView());
	}
}