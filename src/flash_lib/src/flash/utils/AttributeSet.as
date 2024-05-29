package flash.utils 
{
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	
	import flash.utils.Dictionary;

	public dynamic class AttributeSet extends Dictionary
	{
		public function AttributeSet(attrs:Object = null)
		{
			for (var name:String in attrs)
			{
				this[name] = attrs[name];
			}
		}
		
		public function merge(attrs:Object):void
		{
			for (var name:String in attrs)
			{
				this[name] = attrs[name];
			}
		}
	}
}