package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.ItemEditButton")]
	public class ItemEditButton extends Button
	{
		public function ItemEditButton() 
		{
			super();
		}
	}

}