package common.button 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.widget.Button;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.button.SearchButton")]
	public class SearchButton extends Button
	{
		public function SearchButton() 
		{
			super();
		}
	}

}