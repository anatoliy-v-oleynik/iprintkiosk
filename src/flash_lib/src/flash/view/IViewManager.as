package flash.view 
{
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	public interface IViewManager
	{
		function addView(view:View):View;
		
		function removeView(view:View):View;
		
		function removeViews():void;
		
	}
	
}