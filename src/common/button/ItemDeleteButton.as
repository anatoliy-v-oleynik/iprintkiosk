package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.ItemDeleteButton")]
	public class ItemDeleteButton extends Button
	{
		public function ItemDeleteButton() 
		{
			super();
		}
	}

}