/**
 * Events dispatched by native dialog wrappers when dialogs open, close, or are canceled.
 *
 * @see com.fluocode.nativeANE.dialogs.support.AbstractNativeDialog
 */
package com.fluocode.nativeANE.events
{
	import flash.events.Event;
	
	/**
	 * Event type used by NativeUtilities native dialogs. The <code>index</code> property carries
	 * the button index or native payload as a string.
	 *
	 * @playerversion AIR 3
	 */
	public class NativeDialogEvent extends Event
	{
		/**
		 * Event type: the dialog was canceled (back button, outside tap, or equivalent).
		 */
		public static const CANCELED:String = "nativeDialog_canceled";
		/**
		 * Event type: the dialog was closed (button index in <code>index</code>).
		 */
		public static const CLOSED:String = "nativeDialog_closed";
		/**
		 * Event type: the dialog was opened and is visible.
		 */
		public static const OPENED:String = "nativeDialog_opened";
		
		/**
		 * Defines the value of the type property of a NativeDialogEvent object. When a user presses outside the dialog.
		 */
		//public static const PRESSED_OUTSIDE:String = "nativeDialog_pressedOutside";
		
		/**
		 * Defines the value of the type property of a NativeDialogEvent object. When a user presses the button of the dialog.
		 */
		//public static const PRESSED_BUTTON:String = "nativeDialog_pressedButton";
		/**
		 * @private
		 */
		private var _index:String;
		
		/**
		 * Creates a new <code>NativeDialogEvent</code>.
		 *
		 * @param type      Event type (use <code>CANCELED</code>, <code>CLOSED</code>, or <code>OPENED</code>)
		 * @param index     Payload from native code (often the button index as a string)
		 * @param bubbles   Whether the event bubbles
		 * @param cancelable Whether the event can be canceled (<code>preventDefault</code>)
		 */
		public function NativeDialogEvent(type:String,index:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_index = index;
			super(type, bubbles, cancelable);
		}
		
		
		/**
		 * Native payload string (commonly the zero-based index of the pressed button).
		 */
		public function get index() : String
		{
			return _index;
		}
		
		
		/**
		 * @copy flash.events.Event#toString()
		 */
		override public function toString():String
		{
			return "[NativeDialogEvent type='"+type+"'  index='"+String(_index)
				+"' bubbles='"+String(bubbles)+"' cancelable='"+String(cancelable)
				+"' ]";
		}
		/**
		 * @copy flash.events.Event#clone()
		 */
		override public function clone() : Event
		{
			return new NativeDialogEvent(type,_index,bubbles,cancelable);
		}
	}
}