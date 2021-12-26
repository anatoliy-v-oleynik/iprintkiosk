package common.dialogs 
{
	import flash.view.View;
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	[Embed(source="../../../lib/assets.swf", symbol="common.dialogs.WaitDialog")]
	public class WaitDialog extends View
	{
		public function WaitDialog(attrs:Object = null) 
		{
			super(attrs);
		}
	}

}