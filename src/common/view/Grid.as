package common.view 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.view.GridView;
	
	[Embed(source="../../../lib/assets.swf", symbol="common.view.Grid")]
	public class Grid extends GridView
	{
		public function Grid() 
		{
			super();
		}
		
	}

}