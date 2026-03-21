/**
 * List-related events for native list-style dialogs (selection changes while the dialog is open).
 *
 * @see com.fluocode.nativeANE.dialogs.NativeListDialog
 */
package com.fluocode.nativeANE.events
{
	import flash.events.Event;
	
	/**
	 * Dispatched when the selection in a native list dialog changes.
	 *
	 * @playerversion AIR 3
	 */
	public class NativeDialogListEvent extends Event
	{
		/**
		 * Event type: selection in the native list changed.
		 */
		public static const LIST_CHANGE:String = "nativeListDialog_change";
		/**
		 * @private
		 */
		private var _index:int = -1;
		/**
		 * @private
		 */
		private var _selected:Boolean = false;
		
		
		/**
		 * Creates a new <code>NativeDialogListEvent</code>.
		 *
		 * @param type       Event type (typically <code>LIST_CHANGE</code>)
		 * @param index      Index of the row whose selection changed
		 * @param selected   New selected state for that row
		 * @param bubbles    Whether the event bubbles
		 * @param cancelable Whether the event can be canceled
		 */
		public function NativeDialogListEvent(type:String, index:int , selected:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_index = index;
			_selected  = selected;
			super(type, bubbles, cancelable);
		}
		
		
		/**
		 * Zero-based index of the item whose selection changed.
		 */
		public function get index() : int
		{
			return _index;
		}
		/**
		 * Whether the item at <code>index</code> is selected after this change.
		 */
		public function get selected() : Boolean
		{
			return _selected;
		}

		/**
		 * @copy flash.events.Event#toString()
		 */
		override public function toString():String
		{
			return "[NativeDialogListEvent type='"+type+"'  index='"+String(_index)
				+"' selected='"+String(_selected)+"'  bubbles='"+String(bubbles)
				+"' cancelable='"+String(cancelable)+"' ]";
		}
		/**
		 * @copy flash.events.Event#clone()
		 */
		override public function clone() : Event
		{
			return new NativeDialogListEvent(type,_index,_selected,bubbles,cancelable);
		}
	}
}