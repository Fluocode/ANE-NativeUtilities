/**
 * Native system UI and device utilities for the NativeUtilities AIR Native Extension (ANE).
 *
 * @see http://fluocode.com/
 * @since 2011
 */
package com.fluocode.nativeANE.utilities
{
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import flash.system.Capabilities;
	
	import com.fluocode.nativeANE.utilities.support.AbstractNativeUtilities;
	import com.fluocode.nativeANE.events.NativeDialogEvent;
	import com.fluocode.nativeANE.display.DisplayCutout;
	import com.fluocode.nativeANE.display.DisplayMode;
	import com.fluocode.nativeANE.display.LayoutMode;
	
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	/**
	 * Static and instance API for status bar, navigation bar, display cutout, screenshot blocking,
	 * device identification, vibration, brightness, and related native utilities on iOS and Android.
	 *
	 * <p>Declare the extension ID <code>EXTENSION_ID</code> in your application descriptor and use
	 * <code>isSupported</code> before calling native methods.</p>
	 *
	 * @see http://fluocode.com/
	 * @since 2011
	 * @playerversion AIR 3
	 */
	public class NativeUtilities extends AbstractNativeUtilities
	{
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
		/**
		 * The id of the extension that has to be added in the descriptor file.
		 */
		public static const EXTENSION_ID : String = "com.fluocode.nativeANE.NativeUtilities";
		
		/**
		 * The current Version of the Extension (matches extension.xml versionNumber).
		 */
		public static const VERSION:String = "1.3.1";
		
		/**
		 * Default display cutout layout mode (maps to Android cutout default behavior).
		 *
		 * @see #setCutoutMode()
		 */
		public static const CUTOUTMODE_DEFAULT:int = 0;
		/**
		 * Allow drawing into short-edge display cutouts (notches).
		 *
		 * @see #setCutoutMode()
		 */
		public static const CUTOUTMODE_SHORT_EDGES:int = 1;
		/**
		 * Never lay out content in the cutout region.
		 *
		 * @see #setCutoutMode()
		 */
		public static const CUTOUTMODE_NEVER:int = 2;

		/** StatusEvent.code when system UI visibility changes (Android). Event.level is the visibility flags int as string. */
		public static const UI_VISIBILITY_CHANGE_EVENT:String = "UIVisibilityChange";
				
		//---------------------------------------------------------------------
		//
		// Private Static Properties.
		//
		//---------------------------------------------------------------------
		/**
		 * @private
		 */
		//private static var _defaultTheme:uint = DEFAULT_THEME;
		//---------------------------------------------------------------------
		//
		// private properties.
		//
		//---------------------------------------------------------------------
		/**@private*/
		private var _closeLabel:String = null;
		/**@private*/
		private var _buttons:Vector.<String> = null;
		/**@private*/
		private var _theme:int = -1;
		/**@private*/
		private var _closeHandler:Function=null;
		/**@private*/
		private var _disposeAfterClose:Boolean = false;

		
		//---------------------------------------------------------------------
		//
		// Public Methods.
		//
		//---------------------------------------------------------------------
		/**
		 * Creates a <code>NativeUtilities</code> instance (rarely needed; most APIs are static).
		 *
		 * @param theme Reserved for future use; pass <code>-1</code> for default behavior
		 *
		 * @since 2011
		 * @see http://fluocode.com/
		 */
		public function NativeUtilities(theme:int=-1)
		{
			super(abstractKey);

			init();
		}
		
		
		
		/**@private*/
		override protected function init():void{
			try{
				_context = ExtensionContext.createExtensionContext(EXTENSION_ID, "NativeUtilitiesContext");
				//_context.addEventListener(StatusEvent.STATUS, onStatus);
			}catch(e:Error){
				showError("Error initiating contex of the NativeUtilities extension: "+e.message,e.errorID);
			}
		}
		
		/**
		 * Shared extension context reference used internally; prefer the <code>context</code> getter for lazy creation.
		 *
		 * @see #context
		 */
		public static var ctx:ExtensionContext;
		
		/**
		 * Lazily creates and returns the <code>ExtensionContext</code> for this ANE (<code>NativeUtilitiesContext</code>).
		 *
		 * @return The extension context used for native calls
		 *
		 * @throws Error if the context cannot be created
		 */
		public static function get context():ExtensionContext{
			try{
				if(!ctx)
					ctx = ExtensionContext.createExtensionContext(EXTENSION_ID, "NativeUtilitiesContext");
				
			}catch(e:Error){
				showError("Error initiating contex of the NativeUtilities extension: "+e.message,e.errorID);
			}
			return ctx;
		}
		
		
		/**
		 * Throws a prefixed <code>Error</code> for static API failures (no instance to dispatch <code>ErrorEvent</code>).
		 *
		 * @param message Error message or object stringified
		 * @param id      Optional error id
		 *
		 * @throws Error always (unless caught by the caller)
		 */
		public static function showError(message:*, id:int = 0):void {
			throw new Error("[" + EXTENSION_ID + "] " + String(message), id);
		}
		
		
		
		/**
		 * Returns the status bar height in pixels (Android) or points (iOS; may be scaled for resolution).
		 *
		 * @return Height in pixels or points, or <code>-1</code> if unavailable
		 *
		 * @throws Error if the native call fails (see <code>showError</code>)
		 */
		//public static function getStatusBarHeight(stage:Stage=null):Number
		public static function getStatusBarHeight():Number
		{
			var barHeight:Number =-1;
			try
			{
				if(isIOS() || isAndroid()){
					barHeight = context.call("getStatusBarHeight") as Number;
					/*
					if(stage){
						var relY:Number = stage.stageHeight/Capabilities.screenResolutionY;
						barHeight = barHeight *relY;
						if(isIOS())
							barHeight = barHeight/2;
					}
					*/
					if(isIOS())
					barHeight = barHeight*2;
				}
			} 
			catch(error:Error) 
			{
				showError("'getStatusBarHeight' "+error.message,error.errorID);
			}
			return barHeight;
		}
		
		
		/**
		 * Indicates whether the device is using a dark theme (dark mode).
		 *
		 * @return <code>true</code> if dark mode is active
		 *
		 * @throws Error if the native call fails
		 */
		public static function isDarkMode():Boolean
		{
			var dark:Boolean;
			try
			{
				if(isIOS() || isAndroid())
					dark = context.call("isDarkMode") as Boolean;
			} 
			catch(error:Error) 
			{
				showError("'isDarkMode' "+error.message,error.errorID);
			}
			return dark;
		}
		
		
		
		
		/**
		 * Prevents or allows screenshots and screen recording where supported.
		 *
		 * <p>Android uses <code>FLAG_SECURE</code>. iOS uses an overlay-based approach when the app
		 * transitions to background (approximate equivalent to secure window flags).</p>
		 *
		 * @param block <code>true</code> to block capture, <code>false</code> to allow
		 *
		 * @throws Error if the native call fails
		 */
		public static function blockScreenshot(block:Boolean):void
		{
			if( !isAndroid() && !isIOS() ) return;
			try
			{
				context.call("blockScreenshot", block);
			} 
			catch(error:Error) 
			{
				showError("'blockScreenshot' "+error.message,error.errorID);
			}
		}
		
		/**
		 * Gets the unique identifier of the device.
		 * 
		 * @return Device unique ID string, or empty string if not available
		 * 
		 * <p>Platform-specific behavior:</p>
		 * <ul>
		 * <li><strong>Android:</strong> Returns Android ID (Settings.Secure.ANDROID_ID). 
		 * This is a 64-bit number (as a hex string) unique to each combination of app-signing key, 
		 * user, and device. Falls back to a stored UUID if Android ID is not available.</li>
		 * <li><strong>iOS:</strong> Returns identifierForVendor (IDFV). This is unique per vendor 
		 * (app developer) and per device. It persists across app installs unless all apps from 
		 * the same vendor are uninstalled. For iOS &lt; 6.0, uses a stored UUID.</li>
		 * </ul>
		 * 
		 * <p><strong>Note:</strong> These IDs are device-specific but may change in certain scenarios:
		 * <ul>
		 * <li>Android ID may change after factory reset or on some devices</li>
		 * <li>iOS IDFV changes if all apps from the same vendor are uninstalled</li>
		 * </ul>
		 * </p>
		 * 
		 * @throws Error if the call was unsuccessful. Or will dispatch an Error Event.ERROR if there is a listener.
		 */
		public static function getDeviceUniqueId():String
		{
			if( !isAndroid() && !isIOS() ) return "";
			
			try
			{
				var uniqueId:String = context.call("getDeviceUniqueId") as String;
				return uniqueId != null ? uniqueId : "";
			} 
			catch(error:Error) 
			{
				showError("'getDeviceUniqueId' "+error.message,error.errorID);
			}
			return "";
		}
		
		
		
		/**
		 * Sets whether status bar content (icons and text) uses a light or dark style.
		 *
		 * @param light <code>true</code> for light-colored content (e.g. on a dark status bar), <code>false</code> for dark content
		 *
		 * @throws Error if the native call fails
		 */
		public static function statusBarStyleLight(light:Boolean):void
		{
			try
			{
				if(isIOS() || isAndroid())
					context.call("statusBarStyleLight", light);
			} 
			catch(error:Error) 
			{
				showError("'statusBarStyleLight' "+error.message,error.errorID);
			}
		}
		
		
		/**
		 * Sets the status bar background color (Android only; no-op on iOS).
		 *
		 * @param color RGB color as <code>uint</code> (e.g. <code>0xFF0000</code> for red)
		 *
		 * @throws Error if the native call fails
		 */
		public static function statusBarColor(color:uint):void
		{
			if( !isAndroid()  ) return;
			var strColor:String =  "#" + color.toString(16);
			try
			{
				if(isAndroid())
					context.call("statusBarColor", strColor);
			} 
			catch(error:Error) 
			{
				showError("'statusBarColor' "+error.message,error.errorID);
			}
		}
		
		/**
		 * Enables or disables fullscreen window mode (Android only).
		 *
		 * @param mode <code>true</code> for fullscreen, <code>false</code> for normal window decor
		 *
		 * @throws Error if the native call fails
		 */
		public static function fullscreen(mode:Boolean):void
		{
			if( !isAndroid()  ) return;
			try
			{
				if(isAndroid())
					context.call("fullscreenMode", mode);
			} 
			catch(error:Error) 
			{
				showError("'fullscreenMode' "+error.message,error.errorID);
			}
		}
		
		
		/**
		 * Sets the navigation bar background color (Android only).
		 *
		 * @param color RGB color as <code>uint</code>
		 *
		 * @throws Error if the native call fails
		 */
		public static function navigationBarColor(color:uint):void
		{
			if( !isAndroid()  ) return;
			var strColor:String =  "#" + color.toString(16);
			try
			{
				if(isAndroid())
					context.call("navigationBarColor", strColor);
			} 
			catch(error:Error) 
			{
				showError("'navigationBarColor' "+error.message,error.errorID);
			}
		}
		
		/**
		 * Makes the status bar transparent (Android only).
		 *
		 * @throws Error if the native call fails
		 */
		public static function statusBarTransparent():void
		{
			if( !isAndroid()  ) return;
			try
			{
				if(isAndroid())
					context.call("statusBarTransparent");
			} 
			catch(error:Error) 
			{
				showError("'statusBarTransparent' "+error.message,error.errorID);
			}
		}
		
		/**
		 * Makes the navigation bar transparent (Android only).
		 *
		 * @throws Error if the native call fails
		 */
		public static function navigationBarTransparent():void
		{
			if( !isAndroid()  ) return;
			try
			{
				if(isAndroid())
					context.call("navigationBarTransparent");
			} 
			catch(error:Error) 
			{
				showError("'navigationBarTransparent' "+error.message,error.errorID);
			}
		}
		
		
		/**
		 * Sets whether navigation bar content uses light or dark style (Android only).
		 *
		 * @param light <code>true</code> for light-colored icons on a dark bar, <code>false</code> otherwise
		 *
		 * @throws Error if the native call fails
		 */
		public static function navigationBarStyleLight(light:Boolean):void
		{
			if( !isAndroid()  ) return;
			try
			{
				if(isAndroid())
					context.call("navigationBarStyleLight", light);
			} 
			catch(error:Error) 
			{
				showError("'navigationBarStyleLight' "+error.message,error.errorID);
			}
		}
		
		/**
		 * Controls whether content extends into the navigation bar area (Android only).
		 *
		 * @param light <code>true</code> to extend or hide navigation area per native behavior, <code>false</code> for default layout
		 *
		 * @throws Error if the native call fails
		 */
		public static function hideNavigation(light:Boolean):void
		{
			if( !isAndroid()  ) return;
			try
			{
				if(isAndroid())
					context.call("hideNavigation", light);
			} 
			catch(error:Error) 
			{
				showError("'hideNavigation' "+error.message,error.errorID);
			}
		}
		
		
	
		
		//////////////////////////////////////////////////////////////////
		
		/**
		 * Sets Android system UI visibility flags (status bar, navigation bar, fullscreen, etc.).
		 *
		 * @param flags Bitmask of system UI visibility flags (see Android <code>View.SYSTEM_UI_FLAG_*</code> documentation)
		 *
		 * @see com.marpies.ane.androidutils.data.AndroidUIFlags
		 */
        public static function setUIVisibility( flags:int ):void {
            if( !isAndroid()  ) return;

            context.call( "setUIVisibility", flags );
        }
		
		
		/**
		 * Hides the status bar at the <strong>window</strong> level (Android). Unlike <code>setUIVisibility</code> on a single view,
		 * the status bar stays hidden when other native surfaces (e.g. dialogs) appear.
		 */
        public static function hideWindowStatusBar():void {
            if( !isAndroid()  ) return;

            context.call( "hideWindowStatusBar" );
        }

        /**
         * Makes the navigation bar translucent (Android API 19+).
         */
        public static function setTranslucentNavigation():void {
            if( !isAndroid()  ) return;

            context.call( "setTranslucentNavigation" );
        }
		
		
		
		
		/**
		 * Sets screen brightness for the application window.
		 *
		 * @param value Brightness from <code>0</code> to <code>1</code>, or <code>-1</code> to restore the user preference
		 */
        public static function setBrightness( value:Number ):void {
            if( !isAndroid() && !isIOS() ) return;

            context.call( "setBrightness", value );
        }
		
		
		
		/**
		 * Sets how the window lays out relative to display cutouts (notches) on Android.
		 *
		 * @param mode One of <code>CUTOUTMODE_DEFAULT</code>, <code>CUTOUTMODE_SHORT_EDGES</code>, or <code>CUTOUTMODE_NEVER</code>
		 *
		 * @see #CUTOUTMODE_DEFAULT
		 * @see #CUTOUTMODE_SHORT_EDGES
		 * @see #CUTOUTMODE_NEVER
		 */
		public static function setCutoutMode( mode:int ):void {
			if( !isAndroid()  ) return;

			context.call( "setCutoutMode", mode );
		}

        /**
         * Enables or disables the system UI visibility listener (Android only).
         * When enabled, the extension dispatches a StatusEvent when the user shows or hides the status/navigation bar
         * (e.g. by swiping in immersive mode).
         * <p>To receive the event, add a listener to the context:</p>
         * <listing>NativeUtilities.context.addEventListener(StatusEvent.STATUS, onStatus);
         * function onStatus(e:StatusEvent):void {
         *     if (e.code == NativeUtilities.UI_VISIBILITY_CHANGE_EVENT) {
         *         var visibilityFlags:int = int(e.level);
         *         // e.g. react to bar shown/hidden
         *     }
         * }</listing>
         * @param enable <code>true</code> to enable the listener, <code>false</code> to remove it.
         */
        public static function enableUIVisibilityListener( enable:Boolean ):void {
            if( !isAndroid()  ) return;

            context.call( "UIVisibilityListener", enable );
        }
		
		/**
		 * Returns the system UI visibility flag values supported on this Android device/build.
		 *
		 * @return Vector of supported flag integers, or empty on non-Android platforms
		 */
		public static function get supportedUIFlags():Vector.<int> {
            if( !isAndroid()  ) return new <int>[];

            return context.call( "getSupportedUIFlags") as Vector.<int>;
        }
		
		
		/**
		 * Returns bounding rectangles for display cutouts in window coordinates (Android).
		 *
		 * @return A vector of rectangles, or <code>null</code> on non-Android platforms
		 */
		  public static function get displayCutoutRects():Vector.<Rectangle> {
            if( !isAndroid()   ) return null;

            return context.call( "getDisplayCutoutRects") as Vector.<Rectangle>;
        }
		
		/**
		 * Gets the DisplayCutout information containing safe insets and bounding rectangles.
		 * @return DisplayCutout object with safe inset values and bounding rectangles, or null if not available
		 */
		public static function getDisplayCutout():DisplayCutout {
			if (!isAndroid() && !isIOS()) return null;
			
			try {
				var jsonString:String = context.call("getDisplayCutout") as String;
				if (jsonString == null || jsonString == "") {
					return null;
				}
				var obj:Object = JSON.parse(jsonString);
				return DisplayCutout.fromObject(obj);
			} catch (error:Error) {
				showError("'getDisplayCutout' " + error.message, error.errorID);
			}
			return null;
		}
		
		/**
		 * Sets the display mode and layout mode for the application window.
		 *
		 * @param displayMode One of <code>DisplayMode.NORMAL</code>, <code>DisplayMode.FULLSCREEN</code>, or <code>DisplayMode.IMMERSIVE</code>
		 * @param layoutMode  Cutout layout: <code>LayoutMode.CUTOUT_DEFAULT</code>, <code>CUTOUT_SHORT_EDGES</code>, <code>CUTOUT_NEVER</code>, or <code>CUTOUT_ALWAYS</code>
		 *
		 * @return <code>true</code> if the native call succeeded, <code>false</code> otherwise
		 *
		 * <p><b>Note:</b> On iOS, fullscreen is typically driven via <code>Stage.displayState</code>; cutout layout mainly applies on Android.</p>
		 *
		 * @see com.fluocode.nativeANE.display.DisplayMode
		 * @see com.fluocode.nativeANE.display.LayoutMode
		 */
		public static function setDisplayMode(displayMode:String, layoutMode:String = LayoutMode.CUTOUT_NEVER):Boolean {
			if (!isAndroid() && !isIOS()) return false;

			try {
				return context.call("setDisplayMode", displayMode, layoutMode) as Boolean;
			} catch (error:Error) {
				showError("'setDisplayMode' " + error.message, error.errorID);
			}
			return false;
		}

		/**
		 * Controls whether the window content is laid out below system bars (Android only).
		 * Use this to fix touch/interaction issues when the status bar overlaps your app (e.g. on API 24–25 or with Edge-to-Edge on Android 15+).
		 * <p><code>true</code>: content is laid out below the status and navigation bars; the system reserves that area (recommended if you have interaction issues).</p>
		 * <p><code>false</code>: edge-to-edge; content can draw behind the bars; use getStatusBarHeight() / getDisplayCutout() to apply padding so tappable content is not under the bars.</p>
		 * @param fit true to make content sit below system bars, false for edge-to-edge.
		 */
		public static function setDecorFitsSystemWindows(fit:Boolean):void {
			if (!isAndroid()) return;
			try {
				context.call("setDecorFitsSystemWindows", fit);
			} catch (error:Error) {
				showError("'setDecorFitsSystemWindows' " + error.message, error.errorID);
			}
		}

		/**
		 * Triggers device vibration.
		 * <p><strong>Android:</strong> Vibrates for the given duration (1–5000 ms). Requires VIBRATE permission (declared in the ANE).</p>
		 * <p><strong>iOS:</strong> Plays the system vibration (short pulse; duration parameter is ignored).</p>
		 * @param durationMs Duration in milliseconds (Android only). Default 200. Clamped to 1–5000 on Android.
		 */
		public static function vibrate(durationMs:Number = 200):void {
			if (!isAndroid() && !isIOS()) return;
			try {
				context.call("vibrate", durationMs);
			} catch (error:Error) {
				showError("'vibrate' " + error.message, error.errorID);
			}
		}

		/**
		 * Vibrates with a pattern: [delay0, vibrate0, delay1, vibrate1, ...] in milliseconds.
		 * <p><strong>Android:</strong> Uses the native pattern API (VibrationEffect.createWaveform).</p>
		 * <p><strong>iOS:</strong> No native pattern API; the pattern is emulated with timers: a short system vibration
		 * is triggered at each "vibrate" moment (delay0, then delay0+vibrate0+delay1, etc.).</p>
		 * @param pattern Array or Vector of numbers: pairs of (delay before next vibrate, vibrate duration) in ms. Length must be even and ≥ 2. Example: [0, 200, 100, 200] = vibrate 200ms, pause 100ms, vibrate 200ms.
		 */
		public static function vibratePattern(pattern:*):void {
			if (!isAndroid() && !isIOS()) return;
			if (pattern == null || pattern.length < 2 || (pattern.length & 1) !== 0) return;
			var len:int = pattern.length;
			if (isAndroid()) {
				try {
					var arr:Array = pattern is Array ? pattern as Array : [];
					if (!(pattern is Array) && "length" in pattern) {
						arr = [];
						for (var i:int = 0; i < len; i++) arr[i] = pattern[i];
					}
					if (arr.length >= 2) context.call("vibratePattern", arr);
				} catch (error:Error) {
					showError("'vibratePattern' " + error.message, error.errorID);
				}
				return;
			}
			// iOS: emulate pattern with setTimeout at each vibrate time
			var t:Number = 0;
			var times:Array = [];
			for (var j:int = 0; j < len; j += 2) {
				t += Number(pattern[j]);
				times.push(t);
				if (j + 1 < len) t += Number(pattern[j + 1]);
			}
			for (var k:int = 0; k < times.length; k++) {
				(function(delayMs:Number):void {
					setTimeout(function():void {
						try { NativeUtilities.vibrate(); } catch (e:Error) { }
					}, delayMs);
				})(times[k]);
			}
		}


		//////////////////////////////////////////////////////////////////
		

		
		/**
		 * Whether the extension is available on the device (<code>true</code>);<br>otherwise <code>false</code>.
		 */
		public static function get isSupported():Boolean{
			if(isIOS()|| isAndroid())
				return true;
			else 
				return false;
		}
		
		//---------------------------------------------------------------------
		//
		// Private Methods.
		//
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function onStatus( event : StatusEvent ) : void
		{
			event.stopImmediatePropagation();
			if(event.code==NativeDialogEvent.OPENED){
				_isShowing = true;
				if(hasEventListener(NativeDialogEvent.OPENED))
					dispatchEvent(new NativeDialogEvent(NativeDialogEvent.OPENED,event.level));
				
			}
			else if( event.code == NativeDialogEvent.CLOSED || event.code =="ALERT_CLOSED")
			{
				_isShowing = false;
				
				var level:int = int(event.level);
				if(isWindows())
					level--;
				var wasPrevented:Boolean = true;
				if(hasEventListener(NativeDialogEvent.CLOSED)){
					wasPrevented = dispatchEvent(new NativeDialogEvent(NativeDialogEvent.CLOSED,String(level)));
					if(wasPrevented && _closeHandler!=null){
						removeEventListener(NativeDialogEvent.CLOSED,_closeHandler);
						_closeHandler = null;
					}
				}
				
				if(_disposeAfterClose && wasPrevented){
					dispose();
				}
				
			}else{
				showError(event);
			}
		}
		
		
		
		
		
		
		
		
		
		
	}
}