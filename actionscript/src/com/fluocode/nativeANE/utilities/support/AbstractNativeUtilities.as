/**
 * Base types for the NativeUtilities AIR Native Extension (ANE).
 *
 * @see com.fluocode.nativeANE.utilities.NativeUtilities
 */
package com.fluocode.nativeANE.utilities.support
{
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import com.fluocode.nativeANE.nativeDialogNamespace;
	
	use namespace nativeDialogNamespace;
	/**
	 * Abstract base class for native utility wrappers. Do not instantiate directly; use
	 * <code>com.fluocode.nativeANE.utilities.NativeUtilities</code>.
	 *
	 * <p>Provides shared lifecycle, title handling, native <code>ExtensionContext</code> access,
	 * and error reporting for utility-style ANE APIs.</p>
	 *
	 * @playerversion AIR 3
	 */
	public class AbstractNativeUtilities extends EventDispatcher implements iNativeUtilites
	{
		private static const SUPER_CACHE:Dictionary = new Dictionary();

		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		/**@private*/
		protected var _context:ExtensionContext;
		/**@private*/
		protected var _title:String="";
		/**@private*/
		protected var _message:String = "";
		/**@private*/
		protected var _isShowing:Boolean=false;
		/**@private*/
		protected var _wasDisposed:Boolean = false;
		/**@private*/
		protected static var abstractKey:Number = Math.random();
		
		/**
		 * @private
		 */
		public function AbstractNativeUtilities(k:Number)
		{
			if(k!=abstractKey){
				throw new Error("[AbstractNativeUtilities] is an abstract class. It must not be directly instantiated.");
			}
			SUPER_CACHE[this] = true;
			
		}
		
		/**@private*/
		nativeDialogNamespace function get context():ExtensionContext
		{
			return _context;
		}
		
		/**@private*/
		protected function init():void
		{
			
		}
		
		/**
		 * Plays a native shake animation when supported by the underlying implementation.
		 *
		 * @throws Error if the call fails and no <code>ErrorEvent.ERROR</code> listener is registered
		 */
		public function shake():void
		{
			try
			{
				if(isIOS() || isAndroid())
					_context.call("shake");
			} 
			catch(error:Error) 
			{
				showError("'shake' "+error.message,error.errorID);
			}
		}
		
		/**
		 * Returns whether the native UI for this utility is currently visible.
		 *
		 * @return <code>true</code> if showing, <code>false</code> otherwise
		 *
		 * @throws Error if the call fails and no <code>ErrorEvent.ERROR</code> listener is registered
		 */
		public function isShowing():Boolean{
			if(_context){
				try{
					if(isIOS() || isAndroid()){
						const b2:Boolean = _context.call("isShowing");
						_isShowing = b2;
						return b2;
					}
				}catch(error:Error){
					showError("'isShowing' "+error);
				}
			}
			return false;
			
		}
		
		
		
		
		
		
		
		
		
		/**
		 * Sets the title. Updates the native title immediately when the UI is visible (platform permitting).
		 *
		 * @param value New title string
		 *
		 * @return <code>true</code> if the title was stored or applied successfully
		 */
		public function setTitle(value:String):Boolean
		{
			if(value==_title){
				return false;
			}
			
			try{
				if(_isShowing && (isAndroid() || isIOS())){
					_context.call("updateTitle",value);
					_title = value;
					return true;
				}else{
					_title = value;
					return true;
				}
				return false;
			}catch(e:Error){
				showError("'setTitle' "+e.message,e.errorID);
			}
			return false;
		}
		
		
		/**
		 * Staged title used when the UI is not showing (same semantics as dialog base types).
		 *
		 * @param value Title text
		 */
		public function set title(value:String):void
		{
			if(value==_title || _isShowing==true){
				return;
			}
			_title = value;
		}
		/**
		 * Current title string.
		 */
		public function get title():String
		{
			return _title;
		}
		
		
		
		
		
		
		
		/**
		 * Whether <code>dispose()</code> has completed and the extension context is no longer usable.
		 */
		public function get disposed():Boolean
		{
			return _wasDisposed;
		}
		
		
		/**
		 * Dismisses the native UI if it is showing.
		 *
		 * @param buttonIndex Index interpreted by native code when dismissing (e.g. which action was chosen)
		 *
		 * @return <code>true</code> if a dismiss request was issued to native code
		 *
		 * @throws Error if the call fails and no <code>ErrorEvent.ERROR</code> listener is registered
		 */
		public function hide(buttonIndex:int = 0):Boolean
		{
			try{
				if(_context){
					if(isNaN(buttonIndex) || buttonIndex<0){
						buttonIndex = 0;
					}
					if(isIOS() || isAndroid()){
						
						_context.call("dismiss", buttonIndex);
						return true;
					}
				}
				return false;
			}catch(e:Error){
				showError("'hide' "+e.message,e.errorID);
			}
			return false;
		}
		
		
		
		
		/**
		 * Disposes of this ExtensionContext instance.<br><br>
		 * The runtime notifies the native implementation, which can release any associated native resources. After calling <code>dispose()</code>,
		 * the code cannot call the <code>call()</code> method and cannot get or set the <code>actionScriptData</code> property.
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public function dispose():void
		{
			_isShowing = false;
			try{
				delete SUPER_CACHE[this];
				if(_context){
					trace("Disposing on dispose()");
					_context.dispose();
					_wasDisposed = true;
					_context = null;
				}else{
					trace(className+" was already disposed.");
				}
			}catch(e:Error){
				showError("'dispose' "+e.message,e.errorID);
			}
		}

		/**
		 * Returns whether the runtime reports an iOS device (AIR <code>Capabilities.os</code> check).
		 *
		 * @return <code>true</code> on iOS
		 */
		public static function isIOS():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("ip")>-1;
		}
		/**
		 * Returns whether the runtime reports an Android device (Linux-based AIR OS string).
		 *
		 * @return <code>true</code> on Android
		 */
		public static function isAndroid():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("linux")>-1;
		}
		/**
		 * Returns whether the runtime reports a Windows desktop host.
		 *
		 * @return <code>true</code> on Windows
		 */
		public static function isWindows():Boolean
		{
			return Capabilities.os.toLowerCase().indexOf("win")>-1;
		}

		/**
		 * Fully qualified class name of this instance (dots instead of package <code>::</code> separator).
		 */
		public final function get className():String
		{
			return getQualifiedClassName(this).split("::").join(".");
		}
		
		
		
		/**
		 * @private
		 */
		protected function showError(message:*,id:int=0):void
		{
			var m:String = "["+className+"] "+String(message);
			if(hasEventListener(ErrorEvent.ERROR))
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,m,id));
			else{
				throw new Error(m,id);
				//trace(m);
			}
		}
	}
}