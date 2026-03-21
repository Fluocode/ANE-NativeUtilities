/**
 * Contract implemented by all native dialog wrappers in this ANE.
 *
 * @see com.fluocode.nativeANE.dialogs.support.AbstractNativeDialog
 */
package com.fluocode.nativeANE.dialogs.support
{
	import flash.events.IEventDispatcher;

	/**
	 * Common API for native alert, list, picker, progress, and text-input dialogs.
	 */
	public interface iNativeDialog extends IEventDispatcher
	{
		
		/**
		 * Indicates whether the native dialog is currently visible.
		 *
		 * @return <code>true</code> if showing, <code>false</code> otherwise
		 *
		 * @throws Error if the call was unsuccessful, or <code>ErrorEvent.ERROR</code> is dispatched if a listener is registered
		 */
		function isShowing():Boolean;
		
		/**
		 * Sets the dialog title. Updates the native title while visible when supported.
		 *
		 * @param value New title text
		 *
		 * @return <code>true</code> if the title was applied successfully
		 */
		function setTitle(value:String):Boolean;
		/**
		 * Sets the staged title when the dialog is not showing.
		 *
		 * @param value Title text
		 */
		function set title(value:String):void;
		/**
		 * Current dialog title.
		 */
		function get title():String;
		/**
		 * Whether <code>dispose()</code> has been called and the extension context was released.
		 */
		function get disposed():Boolean;
		/**
		 * Dismisses the dialog if it is visible.
		 *
		 * @param buttonIndex Button index forwarded to native code for the close action
		 *
		 * @return <code>true</code> if the dismiss request was sent successfully
		 *
		 * @throws Error if the call was unsuccessful, or <code>ErrorEvent.ERROR</code> is dispatched if a listener is registered
		 */
		function hide(buttonIndex:int = 0):Boolean;
		/**
		 * Disposes of this ExtensionContext instance.<br><br>
		 * The runtime notifies the native implementation, which can release any associated native resources. After calling <code>dispose()</code>,
		 * the code cannot call the <code>call()</code> method and cannot get or set the <code>actionScriptData</code> property.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		function dispose():void;
		
		/**
		 * Plays a native shake animation on the dialog when supported.
		 *
		 * @throws Error if the call was unsuccessful, or <code>ErrorEvent.ERROR</code> is dispatched if a listener is registered
		 */
		function shake():void;
	}
}