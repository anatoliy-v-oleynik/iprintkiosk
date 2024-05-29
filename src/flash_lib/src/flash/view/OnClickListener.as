package flash.view
{
	import flash.errors.IllegalOperationError;

	public dynamic class OnClickListener implements IOnClickListener
	{
		// Called when a view has been clicked.
		public function onClick(view:View):void
		{
			throw new IllegalOperationError('this method should be overriden in a subclass');
		}
	}
}