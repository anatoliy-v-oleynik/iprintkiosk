package vkontakte.button 
{
	import flash.text.TextField;
	import flash.widget.Button;
	
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	[Embed(source="../../../lib/assets.swf", symbol="vkontakte.button.CounterButton")]
	public class CounterButton extends Button
	{
		public var _label:TextField;
		
		public function CounterButton() 
		{
			super();
		}
		
	}

}