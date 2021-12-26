package common.view 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.view.GridView;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.view.OrderGridView")]
	public class OrderGridView extends GridView
	{
		public function OrderGridView() 
		{
			super();
		}
		
	}

}