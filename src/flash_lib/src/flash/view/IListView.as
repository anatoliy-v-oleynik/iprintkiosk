package flash.view
{
	public interface IListView
	{
		function getAdapter():ListAdapter;
		function setAdapter(adapter:ListAdapter):void;
	}
}