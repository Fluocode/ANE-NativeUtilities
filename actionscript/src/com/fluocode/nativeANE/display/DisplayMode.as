/**
 * String constants for <code>NativeUtilities.setDisplayMode()</code> (normal, fullscreen, immersive).
 *
 * @see com.fluocode.nativeANE.utilities.NativeUtilities#setDisplayMode()
 */
package com.fluocode.nativeANE.display
{
	/**
	 * DisplayMode constants for setting the display mode of the application.
	 * 
	 * @author Based on distriqt Application Extension
	 */
	public class DisplayMode
	{
		/**
		 * Normal display mode.
		 */
		public static const NORMAL:String = "normal";
		
		/**
		 * Fullscreen display mode.
		 */
		public static const FULLSCREEN:String = "fullscreen";
		
		/**
		 * Immersive display mode.
		 */
		public static const IMMERSIVE:String = "immersive";
		
		/**
		 * Constructor - should not be instantiated.
		 */
		public function DisplayMode()
		{
			super();
		}
	}
}
