/**
 * Value object describing display cutout (notch) safe insets and bounds from native JSON.
 *
 * @see com.fluocode.nativeANE.utilities.NativeUtilities#getDisplayCutout()
 */
package com.fluocode.nativeANE.display
{
	import flash.geom.Rectangle;
	
	/**
	 * DisplayCutout provides information about display cutouts (notches) on the device.
	 * This object contains safe inset values indicating the number of pixels from the edge
	 * of the screen that system bars or cutouts may affect.
	 * 
	 * @author Based on distriqt Application Extension
	 */
	public class DisplayCutout
	{
		/**
		 * Safe inset from the top edge in pixels.
		 */
		public var safeInsetTop:int = 0;
		
		/**
		 * Safe inset from the left edge in pixels.
		 */
		public var safeInsetLeft:int = 0;
		
		/**
		 * Safe inset from the right edge in pixels.
		 */
		public var safeInsetRight:int = 0;
		
		/**
		 * Safe inset from the bottom edge in pixels.
		 */
		public var safeInsetBottom:int = 0;
		
		/**
		 * Bounding rectangles for any cutouts that may affect rendering.
		 */
		public var boundingRects:Vector.<Rectangle>;
		
		/**
		 * Constructor.
		 */
		public function DisplayCutout()
		{
			super();
			boundingRects = new Vector.<Rectangle>(0);
		}
		
		/**
		 * Creates a DisplayCutout instance from a JSON object.
		 * @param obj JSON object with top, left, right, bottom properties and optional boundingRects array
		 * @return DisplayCutout instance or null
		 */
		public static function fromObject(obj:Object):DisplayCutout
		{
			var rect:Rectangle = null;
			if (obj == null)
			{
				return null;
			}
			
			var cutout:DisplayCutout = new DisplayCutout();
			
			if (obj.hasOwnProperty("top"))
			{
				cutout.safeInsetTop = obj.top;
			}
			if (obj.hasOwnProperty("left"))
			{
				cutout.safeInsetLeft = obj.left;
			}
			if (obj.hasOwnProperty("right"))
			{
				cutout.safeInsetRight = obj.right;
			}
			if (obj.hasOwnProperty("bottom"))
			{
				cutout.safeInsetBottom = obj.bottom;
			}
			if (obj.hasOwnProperty("boundingRects"))
			{
				for each (var rectObj:Object in obj.boundingRects)
				{
					rect = new Rectangle();
					rect.x = rectObj.x;
					rect.y = rectObj.y;
					rect.width = rectObj.width;
					rect.height = rectObj.height;
					cutout.boundingRects.push(rect);
				}
			}
			
			return cutout;
		}
		
		/**
		 * Returns a string representation of the DisplayCutout.
		 */
		public function toString():String
		{
			return "[DisplayCutout top:" + safeInsetTop + ", left:" + safeInsetLeft + 
				", right:" + safeInsetRight + ", bottom:" + safeInsetBottom + "]";
		}
	}
}
