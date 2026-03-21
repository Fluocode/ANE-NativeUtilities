package com.fluocode.nativeANE.display
{
	/**
	 * LayoutMode constants for controlling how content is laid out relative to display cutouts.
	 * 
	 * @author Based on distriqt Application Extension
	 */
	public class LayoutMode
	{
		/**
		 * Default cutout handling.
		 */
		public static const CUTOUT_DEFAULT:String = "cutout_default";
		
		/**
		 * Allow layout into short edge cutouts.
		 */
		public static const CUTOUT_SHORT_EDGES:String = "cutout_short_edges";
		
		/**
		 * Never allow layout into cutouts.
		 */
		public static const CUTOUT_NEVER:String = "cutout_never";
		
		/**
		 * Always allow layout into cutouts (API 30+).
		 */
		public static const CUTOUT_ALWAYS:String = "cutout_always";
		
		/**
		 * Constructor - should not be instantiated.
		 */
		public function LayoutMode()
		{
			super();
		}
	}

}
