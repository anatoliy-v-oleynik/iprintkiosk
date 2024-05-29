package flash.external.devices 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Анатолий Олейник
	 */
	public class AcceptorEvent extends Event
	{
		public var valuta:String;
		public var nominal:Number;

		public function AcceptorEvent(type:String, valuta:String, nominal:Number) 
		{
			super(type);
			this.valuta = valuta;
			this.nominal = nominal;
		}
	}

}