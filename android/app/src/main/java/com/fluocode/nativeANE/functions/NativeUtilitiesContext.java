package com.fluocode.nativeANE.functions;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;


import com.adobe.fre.FREArray;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.fluocode.nativeANE.FREUtilities;
import com.fluocode.nativeANE.NativeDialogsExtension;
import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Color;
import android.graphics.Rect;
import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.provider.Settings;
import android.util.Log;
import android.view.DisplayCutout;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import androidx.core.view.WindowCompat;
import org.json.JSONArray;
import org.json.JSONObject;


import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

/**
 * Native utilities implementation.
 */
@SuppressWarnings({
		"deprecation",
		// Suppress static-analysis warnings for Adobe FRE patterns (inner FREFunction classes, legacy APIs).
		"InnerClassMayBeStatic",
		"CommentedOutCode",
		"ConstantConditions",
		"IfCanBeSwitch",
		"UnusedReturnValue",
		"unused"
})
public class NativeUtilitiesContext  extends FREContext {


	public static final String KEY = "NativeUtilitiesContext";



	@Override
	public void dispose()
	{
		Log.d(KEY, "Disposing Extension Context");
	}

	/**
	 * Registers AS function name to Java Function Class
	 */
	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Log.d(KEY, "Registering Extension Functions");
		Map<String, FREFunction> functionMap = new HashMap<>();
		functionMap.put(getStatusBarHeight.KEY, new getStatusBarHeight());
		functionMap.put(isDarkMode.KEY, new isDarkMode());
		functionMap.put(statusBarStyleLight.KEY, new statusBarStyleLight());
		functionMap.put(statusBarColor.KEY, new statusBarColor());
		functionMap.put(navigationBarColor.KEY, new navigationBarColor());
		functionMap.put(navigationBarStyleLight.KEY, new navigationBarStyleLight());
		functionMap.put(statusBarTransparent.KEY, new statusBarTransparent());
		functionMap.put(navigationBarTransparent.KEY, new navigationBarTransparent());
		functionMap.put(hideNavigation.KEY, new hideNavigation());
		functionMap.put( GetSupportedUIFlags.KEY, new GetSupportedUIFlags() );
		functionMap.put( SetUIVisibility.KEY, new SetUIVisibility() );
		functionMap.put( UIVisibilityListener.KEY, new UIVisibilityListener() );
		functionMap.put( SetCutoutMode.KEY, new SetCutoutMode() );
		functionMap.put( GetDisplayCutoutRects.KEY, new GetDisplayCutoutRects() );
		functionMap.put(SetBrightness.KEY, new SetBrightness() );
		functionMap.put(SetTranslucentNavigation.KEY, new SetTranslucentNavigation() );
		functionMap.put(IsImmersiveSupported.KEY, new IsImmersiveSupported() );
		functionMap.put(HideWindowStatusBar.KEY, new HideWindowStatusBar() );
		functionMap.put(fullscreenMode.KEY, new fullscreenMode() );
		functionMap.put(blockScreenshot.KEY, new blockScreenshot() );
		functionMap.put(GetDisplayCutout.KEY, new GetDisplayCutout() );
		functionMap.put(SetDisplayMode.KEY, new SetDisplayMode() );
		functionMap.put(GetDeviceUniqueId.KEY, new GetDeviceUniqueId() );
		functionMap.put(SetDecorFitsSystemWindows.KEY, new SetDecorFitsSystemWindows() );
		functionMap.put(Vibrate.KEY, new Vibrate() );
		functionMap.put(VibratePattern.KEY, new VibratePattern() );
		return functionMap;
	}


	public  class getStatusBarHeight implements FREFunction{
		public static final String KEY = "getStatusBarHeight";

		@SuppressLint({ "NewApi", "InternalInsetResource", "DiscouragedApi" })
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args)
		{


			try {
				// status bar height
				int statusBarHeight = 0;
				int resourceId = frecontext.getActivity().getResources().getIdentifier("status_bar_height", "dimen", "android");
				if (resourceId > 0) {
					statusBarHeight = frecontext.getActivity().getResources().getDimensionPixelSize(resourceId);
				}

				//// action bar height
				//int actionBarHeight = 0;
				//final TypedArray styledAttributes = getActivity().getTheme().obtainStyledAttributes(
				//		new int[] { android.R.attr.actionBarSize }
				//);
				//actionBarHeight = (int) styledAttributes.getDimension(0, 0);
				//styledAttributes.recycle();

				//// navigation bar height
				//int navigationBarHeight = 0;
				//int resourceId = getResources().getIdentifier("navigation_bar_height", "dimen", "android");
				//if (resourceId > 0) {
				//	navigationBarHeight = resources.getDimensionPixelSize(resourceId);
				//}

				return FREObject.newObject(statusBarHeight);

			} catch( Exception e ) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			}

			return null;
		}
	}

	public class isDarkMode implements FREFunction{
		public static final String KEY = "isDarkMode";

		@Override
		public FREObject call(FREContext frecontext, FREObject[] args)
		{

			try{

				int nightModeFlags =
						frecontext.getActivity().getResources().getConfiguration().uiMode &
								Configuration.UI_MODE_NIGHT_MASK;
				Log.i(KEY, "::: NIGHTMODE STATUS : " + nightModeFlags );
				if( nightModeFlags == Configuration.UI_MODE_NIGHT_YES)// || nightModeFlags == 32)
					return FREObject.newObject(true);
				else
					return FREObject.newObject(false);
			}catch (Exception e){
				frecontext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
				e.printStackTrace();
			}
			return null;
		}
	}
	public class statusBarStyleLight implements FREFunction{
		public static final String KEY = "statusBarStyleLight";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args)
		{
			if (Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB) {
				Log.i( KEY,  "Changing bar style is not supported "+Build.VERSION.SDK_INT+' '+ Build.VERSION_CODES.HONEYCOMB);
				return null;
			}

			try{
				boolean v = args[0].getAsBool();
				Log.i( KEY,  "statusBarStyleLight " + v);
				if(v) {
					View decorView = frecontext.getActivity().getWindow().getDecorView();
					decorView.setSystemUiVisibility(decorView.getSystemUiVisibility() & ~View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
				}else{
					frecontext.getActivity().getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
				}
			}catch (Exception e){
				frecontext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
				e.printStackTrace();
			}
			return null;
		}
	}


	public class navigationBarStyleLight implements FREFunction {
		public static final String KEY = "navigationBarStyleLight";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args)
		{
			if (Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB) {
				Log.i( KEY,  "Changing bar style is not supported" );
				return null;
			}

			try{
				boolean v = args[0].getAsBool();
				Log.i( KEY,  "navigationBarStyleLight " + v);
				if(v) {
					View decorView = frecontext.getActivity().getWindow().getDecorView();
					decorView.setSystemUiVisibility(decorView.getSystemUiVisibility() & ~View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR);
				}else{
					frecontext.getActivity().getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR);
				}
			}catch (Exception e){
				frecontext.dispatchStatusEventAsync(NativeDialogsExtension.ERROR_EVENT,String.valueOf(e));
				e.printStackTrace();
			}
			return null;
		}
	}



	public class fullscreenMode implements FREFunction {

		public static final String KEY = "fullscreenMode";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args) {

			try {
				boolean mode = args[0].getAsBool();
				Window window = frecontext.getActivity().getWindow();

				if (Build.VERSION.SDK_INT < 16) {
					if(mode) {
						window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
								WindowManager.LayoutParams.FLAG_FULLSCREEN);
					}else {
						window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
					}
				} else {
					View decorView = window.getDecorView();
					int uiOptions;

					if (mode) {
						// Hide the status bar.
						uiOptions = View.SYSTEM_UI_FLAG_FULLSCREEN;
						decorView.setSystemUiVisibility(uiOptions);
						ActionBar actionBar = frecontext.getActivity().getActionBar();
						if (actionBar != null) {
							actionBar.hide();
						}
					} else {
						uiOptions = View.SYSTEM_UI_FLAG_VISIBLE;
						decorView.setSystemUiVisibility(
								View.SYSTEM_UI_FLAG_LAYOUT_STABLE
										| View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
										| View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
						decorView.setSystemUiVisibility(uiOptions);
						ActionBar actionBar = frecontext.getActivity().getActionBar();
						if (actionBar != null) {
							actionBar.show();
						}
					}

				}

			} catch (Exception e) {
				Log.i(KEY, "Error parsing fullscreen mode: " + e.getMessage());
			}


			return null;
		}
	}

	public class statusBarColor implements FREFunction {

		public static final String KEY = "statusBarColor";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args) {

			if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
				Log.i(KEY, "Changing status bar color is not supported");
				return null;
			}

			try {
				int color = Color.parseColor(args[0].getAsString());
				Window window = frecontext.getActivity().getWindow();
				window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
				window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
				window.setStatusBarColor(color);
			} catch (Exception e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage());
			}

			return null;
		}
	}

	public class navigationBarColor implements FREFunction {

		public static final String KEY = "navigationBarColor";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args) {

			if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
				Log.i(KEY, "Changing status bar color is not supported");
				return null;
			}

			try {
				int color = Color.parseColor(args[0].getAsString());
				Window window = frecontext.getActivity().getWindow();
				window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
				window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
				window.setNavigationBarColor(color);
			} catch (Exception e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage());
			}

			return null;
		}
	}

public class statusBarTransparent implements FREFunction {

		public static final String KEY = "statusBarTransparent";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args) {

			if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
				Log.i(KEY, "Changing status bar color is not supported");
				return null;
			}

			try {
				Window window = frecontext.getActivity().getWindow();
				window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
				window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
				window.setStatusBarColor(Color.TRANSPARENT);
			} catch (Exception e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage());
			}

			return null;
		}
	}

public class navigationBarTransparent implements FREFunction {

		public static final String KEY = "navigationBarTransparent";
		private static final String TAG = "navBarTransparent";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args) {

			if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
				Log.i(TAG, "Changing status bar color is not supported");
				return null;
			}

			try {
				Window window = frecontext.getActivity().getWindow();
				window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
				window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
				window.setNavigationBarColor(Color.TRANSPARENT);
			} catch (Exception e) {
				Log.i(TAG, "Error parsing status bar color: " + e.getMessage());
			}

			return null;
		}
	}



	public class blockScreenshot implements FREFunction {

		public static final String KEY = "blockScreenshot";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args) {

			try {
				boolean mode = args[0].getAsBool();

				if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
					Log.i(KEY, "blockScreenshot is not supported");
					return null;
				}

				Window window = frecontext.getActivity().getWindow();
				if(mode) {
					window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);
				}else {
					window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
				}
			} catch (Exception e) {
				Log.i(KEY, "Error parsing block Screenshot: " + e.getMessage());
			}

			return null;
		}
	}




	public class hideNavigation implements FREFunction {

		public static final String KEY = "hideNavigation";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args) {

			try {
				boolean mode = args[0].getAsBool();

				if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
					Log.i(KEY, "Hide navigation bars is not supported");
					return null;
				}

				Window window = frecontext.getActivity().getWindow();
				if(mode) {
					window.addFlags(View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION);
				}else{
					window.clearFlags(View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION);
				}
			} catch (Exception e) {
				Log.i(KEY, "Error parsing hide navigation bars: " + e.getMessage());
			}

			return null;
		}
	}


	public class GetSupportedUIFlags implements FREFunction {

		public static final String KEY = "getSupportedUIFlags";

		public FREObject call(FREContext frecontext, FREObject[] args) {

			Set<Integer> supportedFlags = new HashSet<>();

			int systemVersion = Build.VERSION.SDK_INT;
			if (systemVersion >= Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
				supportedFlags.add(View.SYSTEM_UI_FLAG_VISIBLE);
				supportedFlags.add(View.SYSTEM_UI_FLAG_LOW_PROFILE);
				supportedFlags.add(View.SYSTEM_UI_FLAG_HIDE_NAVIGATION);
			}
			if (systemVersion >= Build.VERSION_CODES.JELLY_BEAN) {
				supportedFlags.add(View.SYSTEM_UI_FLAG_FULLSCREEN);
			}
			if (systemVersion >= Build.VERSION_CODES.KITKAT) {
				supportedFlags.add(View.SYSTEM_UI_FLAG_IMMERSIVE);
				supportedFlags.add(View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
			}

			return FREUtilities.getVectorFromSet(supportedFlags.size(), true, supportedFlags);
		}
	}


	/**
	 * Sets {@link android.view.View#setSystemUiVisibility(int)} on the window decor view.
	 * Flag values are Android <code>View.SYSTEM_UI_FLAG_*</code> constants (API 11+).
	 */
	public class SetUIVisibility implements FREFunction {
		public static final String KEY = "setUIVisibility";
		public FREObject call(FREContext frecontext, FREObject[] args){
			int flags = 0;
			try {
				flags = args[0].getAsInt();
			} catch (FRETypeMismatchException e) {
				e.printStackTrace();
			} catch (FREInvalidObjectException e) {
				e.printStackTrace();
			} catch (FREWrongThreadException e) {
				e.printStackTrace();
			}
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
				frecontext.getActivity().getWindow().getDecorView().setSystemUiVisibility( flags );
			}

			return null;
		}
	}

	@SuppressLint("NewApi")
	public class UIVisibilityListener implements FREFunction, View.OnSystemUiVisibilityChangeListener  {
		public static final String KEY = "UIVisibilityListener";
		public FREObject call(FREContext frecontext, FREObject[] args){
			boolean enable = false;
			try {
				enable = args[0].getAsBool();
			} catch (FRETypeMismatchException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			} catch (FREInvalidObjectException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			} catch (FREWrongThreadException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			}
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
				frecontext.getActivity().getWindow().getDecorView().setOnSystemUiVisibilityChangeListener( enable ? this : null );
			}
			return null;
		}

		@Override
		public void onSystemUiVisibilityChange(int visibility) {
			NativeUtilitiesContext.this.dispatchStatusEventAsync(NativeDialogsExtension.UI_VISIBILITY_CHANGE, String.valueOf(visibility));
		}
	}

	/**
	 * Triggers device vibration for the given duration (Android only; requires VIBRATE permission).
	 */
	public class Vibrate implements FREFunction {
		public static final String KEY = "vibrate";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args) {
			try {
				long durationMs = 200;
				if (args != null && args.length > 0) {
					double d = args[0].getAsDouble();
					durationMs = Math.max(1, Math.min((long) d, 5000));
				}
				Vibrator vibrator = (Vibrator) frecontext.getActivity().getSystemService(Context.VIBRATOR_SERVICE);
				if (vibrator != null && vibrator.hasVibrator()) {
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
						vibrator.vibrate(VibrationEffect.createOneShot(durationMs, VibrationEffect.DEFAULT_AMPLITUDE));
					} else {
						vibrator.vibrate(durationMs);
					}
				}
			} catch (Exception e) {
				Log.i(KEY, "vibrate: " + e.getMessage());
			}
			return null;
		}
	}

	/**
	 * Triggers device vibration with a pattern (Android only).
	 * Pattern format: [delay0, vibrate0, delay1, vibrate1, ...] in milliseconds. Even length, at least 2 elements.
	 */
	public class VibratePattern implements FREFunction {
		public static final String KEY = "vibratePattern";

		@SuppressLint("NewApi")
		@Override
		public FREObject call(FREContext frecontext, FREObject[] args) {
			try {
				if (args == null || args.length == 0 || !(args[0] instanceof FREArray)) return null;
				FREArray freArray = (FREArray) args[0];
				long length = freArray.getLength();
				if (length < 2 || (length & 1) != 0) return null;
				double[] doubles = FREUtilities.convertFREArrayToDoubleArray(freArray);
				long[] pattern = new long[doubles.length];
				for (int i = 0; i < doubles.length; i++) {
					pattern[i] = Math.max(0, Math.min((long) doubles[i], 10000));
				}
				Vibrator vibrator = (Vibrator) frecontext.getActivity().getSystemService(Context.VIBRATOR_SERVICE);
				if (vibrator != null && vibrator.hasVibrator()) {
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
						vibrator.vibrate(VibrationEffect.createWaveform(pattern, null, -1));
					} else {
						vibrator.vibrate(pattern, -1);
					}
				}
			} catch (Exception e) {
				Log.i(KEY, "vibratePattern: " + e.getMessage());
			}
			return null;
		}
	}

	/**
	 * Controls whether the window content is laid out below system bars (status/navigation).
	 * When true: content does not draw under the bars and the system reserves that area (fixes touch issues with Edge-to-Edge on API 24–25 and 35+).
	 * When false: edge-to-edge; content can draw behind the bars and the app should use getStatusBarHeight/getDisplayCutout to apply padding.
	 */
	public class SetDecorFitsSystemWindows implements FREFunction {
		public static final String KEY = "setDecorFitsSystemWindows";
		private static final String TAG = "setDecorFitsSysWin";

		@Override
		public FREObject call(FREContext frecontext, FREObject[] args) {
			try {
				if (args != null && args.length > 0) {
					boolean fit = args[0].getAsBool();
					Window window = frecontext.getActivity().getWindow();
					WindowCompat.setDecorFitsSystemWindows(window, fit);
				}
			} catch (Exception e) {
				Log.i(TAG, "setDecorFitsSystemWindows: " + e.getMessage());
			}
			return null;
		}
	}

	public class SetCutoutMode implements FREFunction {

		public static final String KEY = "setCutoutMode";

		public FREObject call(FREContext frecontext, FREObject[] args){

			if (Build.VERSION.SDK_INT >= 28) {
				int value = 0;
				try {
					value = args[0].getAsInt();
				} catch (FRETypeMismatchException e) {
					Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
				} catch (FREInvalidObjectException e) {
					Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
				} catch (FREWrongThreadException e) {
					Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
				}

				Window window = frecontext.getActivity().getWindow();
				WindowManager.LayoutParams params = window.getAttributes();
				params.layoutInDisplayCutoutMode = value;
				window.setAttributes(params);
			}

			return null;
		}
	}

	public class GetDisplayCutoutRects implements FREFunction
	{
		public static final String KEY = "getDisplayCutoutRects";

		public FREObject call(FREContext frecontext, FREObject[] args){

			if (Build.VERSION.SDK_INT >= 28) {
				try {
					View view = frecontext.getActivity().getWindow().getDecorView();
					if (view.getRootWindowInsets() == null) {
						return null;
					}
					DisplayCutout cutout = view.getRootWindowInsets().getDisplayCutout();
					if (cutout == null) {
						return null;
					}

					List<Rect> rects = cutout.getBoundingRects();

					FREArray freArray = FREArray.newArray("flash.geom.Rectangle", rects.size(), true);
					long i = 0;

					for(Rect rect : rects) {
						FREObject x = FREObject.newObject(rect.left);
						FREObject y = FREObject.newObject(rect.top);
						FREObject w = FREObject.newObject(rect.width());
						FREObject h = FREObject.newObject(rect.height());
						FREObject[] params = new FREObject[] { x, y, w, h };
						FREObject freRect = FREObject.newObject("flash.geom.Rectangle", params);
						freArray.setObjectAt(i, freRect);
						i++;
					}

					return freArray;
				} catch(Exception e) {
					Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
				}
			}
			return null;
		}
	}

	public class GetDeviceUniqueId implements FREFunction {
		public static final String KEY = "getDeviceUniqueId";

		@SuppressLint({ "HardwareIds", "ApplySharedPref" })
		public FREObject call(FREContext frecontext, FREObject[] args) {
			try {
				// Use Android ID - more stable than IMEI and doesn't require permissions
				String androidId = Settings.Secure.getString(
					frecontext.getActivity().getContentResolver(),
					Settings.Secure.ANDROID_ID
				);

				if (androidId != null && androidId.length() > 0) {
					return FREObject.newObject(androidId);
				} else {
					// Fallback: generate a unique ID and store it in SharedPreferences
					SharedPreferences prefs = frecontext.getActivity()
						.getSharedPreferences("device_id", Context.MODE_PRIVATE);
					String storedId = prefs.getString("unique_id", null);

					if (storedId == null) {
						// Generate UUID
						storedId = UUID.randomUUID().toString();
						// commit() for API < 9 support (minSdkVersion is 8)
						prefs.edit().putString("unique_id", storedId).commit();
					}

					return FREObject.newObject(storedId);
				}
			} catch (Exception e) {
				Log.e(KEY, "Error getting device unique ID: " + e.getMessage());
				e.printStackTrace();
				try {
					return FREObject.newObject("");
				} catch (Exception ex) {
					return null;
				}
			}
		}
	}

	public class GetDisplayCutout implements FREFunction {
		public static final String KEY = "getDisplayCutout";

		@SuppressLint("NewApi")
		public FREObject call(FREContext frecontext, FREObject[] args) {
			try {
				if (Build.VERSION.SDK_INT < 28) {
					return FREObject.newObject("{}");
				}

			View view = frecontext.getActivity().getWindow().getDecorView();
			DisplayCutout displayCutout = null;

			if (view.getRootWindowInsets() != null) {
				displayCutout = view.getRootWindowInsets().getDisplayCutout();
			}

			JSONObject displayCutoutObj = new JSONObject();

			if (displayCutout != null && Build.VERSION.SDK_INT >= 28) {
				displayCutoutObj.put("top", displayCutout.getSafeInsetTop());
				displayCutoutObj.put("left", displayCutout.getSafeInsetLeft());
				displayCutoutObj.put("right", displayCutout.getSafeInsetRight());
				displayCutoutObj.put("bottom", displayCutout.getSafeInsetBottom());

				JSONArray boundingRectsArr = new JSONArray();
				for (Rect notch : displayCutout.getBoundingRects()) {
					JSONObject rectObj = new JSONObject();
					rectObj.put("x", notch.left);
					rectObj.put("y", notch.top);
					rectObj.put("width", notch.width());
					rectObj.put("height", notch.height());
					boundingRectsArr.put(rectObj);
				}
				displayCutoutObj.put("boundingRects", boundingRectsArr);
			}

			return FREObject.newObject(displayCutoutObj.toString());
			} catch (Exception e) {
				Log.e(KEY, "Error getting display cutout: " + e.getMessage());
				e.printStackTrace();
				try {
					return FREObject.newObject("{}");
				} catch (Exception ex) {
					return null;
				}
			}
		}
	}

	public class SetDisplayMode implements FREFunction {
		public static final String KEY = "setDisplayMode";

		@SuppressLint("NewApi")
		public FREObject call(FREContext frecontext, FREObject[] args) {
			try {
				if (args.length < 2) {
					return FREObject.newObject(false);
				}

				String displayMode = args[0].getAsString();
				String layoutMode = args[1].getAsString();

				Window window = frecontext.getActivity().getWindow();
				WindowManager.LayoutParams params = window.getAttributes();
				View decorView = window.getDecorView();

				// Handle layout mode (cutout handling)
				if (Build.VERSION.SDK_INT >= 28) {
					int cutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_DEFAULT;
					
					if (layoutMode.equals("cutout_never")) {
						cutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_NEVER;
					} else if (layoutMode.equals("cutout_short_edges")) {
						cutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
					} else if (layoutMode.equals("cutout_default")) {
						cutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_DEFAULT;
					} else if (layoutMode.equals("cutout_always") && Build.VERSION.SDK_INT >= 30) {
						cutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_ALWAYS;
					}

					params.layoutInDisplayCutoutMode = cutoutMode;
					window.setAttributes(params);
				}

				// Handle display mode
				if (displayMode.equals("fullscreen")) {
					int flags = View.SYSTEM_UI_FLAG_FULLSCREEN
							| View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN;
					decorView.setSystemUiVisibility(flags);
				} else if (displayMode.equals("immersive")) {
					int flags = View.SYSTEM_UI_FLAG_FULLSCREEN
							| View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
							| View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
							| View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION;
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
						flags |= View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY;
					}
					decorView.setSystemUiVisibility(flags);
				} else if (displayMode.equals("normal")) {
					decorView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE);
				}

				return FREObject.newObject(true);
			} catch (Exception e) {
				Log.e(KEY, "Error setting display mode: " + e.getMessage());
				e.printStackTrace();
				try {
					return FREObject.newObject(false);
				} catch (Exception ex) {
					return null;
				}
			}
		}
	}

	public class SetBrightness implements FREFunction {
		public static final String KEY = "setBrightness";

		public FREObject call(FREContext frecontext, FREObject[] args){

			Window window = frecontext.getActivity().getWindow();
			WindowManager.LayoutParams lp = window.getAttributes();
			try {
				lp.screenBrightness = (float) args[0].getAsDouble();
			} catch (FRETypeMismatchException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			} catch (FREInvalidObjectException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			} catch (FREWrongThreadException e) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			}
			window.setAttributes( lp );

			return null;
		}
	}



	public class SetTranslucentNavigation implements FREFunction {

		public static final String KEY = "setTranslucentNavigation";

		public FREObject call(FREContext frecontext, FREObject[] args){

			/* Enable translucent navigation on Kitkat and above */
			if( Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT ) {
				Window window = frecontext.getActivity().getWindow();
				window.addFlags( WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION );
			}

			return null;
		}

	}


	public class IsImmersiveSupported implements FREFunction {

		public static final String KEY = "isImmersiveSupported";

		public FREObject call(FREContext frecontext, FREObject[] args){

			try {
				return FREObject.newObject( Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT );
			} catch( FREWrongThreadException e ) {
				Log.i(KEY, "Error parsing status bar color: " + e.getMessage() );
			}

			return null;
		}

	}


	public class HideWindowStatusBar implements FREFunction {

		public static final String KEY = "hideWindowStatusBar";
		public FREObject call(FREContext frecontext, FREObject[] args){

			Window window = frecontext.getActivity().getWindow();
			window.clearFlags( WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN );
			/* Enabled translucent status bar on Kitkat and above */
			if( Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT ) {
				window.addFlags( WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS );
			}
			window.addFlags( WindowManager.LayoutParams.FLAG_FULLSCREEN );

			return null;
		}

	}







}



