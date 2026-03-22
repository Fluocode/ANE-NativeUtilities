# 🧩 NativeUtilities ANE for Adobe AIR

**NativeUtilities** is a native extension that brings **native UI and system APIs** to your mobile app: alerts, lists, date/time pickers, text input dialogs, progress overlays, wheel pickers, toasts, and utilities such as status/navigation bar styling, display cutouts, screenshot protection, vibration, brightness, and device identifiers—on **Android** and **iOS**.

---

## ✨ What you get

| Area | Highlights |
|------|------------|
| 💬 **Dialogs** | `NativeAlertDialog`, `NativeListDialog`, `NativeDatePickerDialog`, `NativeTextInputDialog`, `NativeProgressDialog`, `NativePickerDialog` |
| 🛠️ **System** | `NativeUtilities` — bars, cutouts, UI visibility, fullscreen helpers, haptics, IDs, **`setDecorFitsSystemWindows`** (Android edge-to-edge fix) |
| 🍞 **Toasts** | `Toast` — short messages with optional gravity (Android) |

All public ActionScript APIs live under `com.fluocode.nativeANE.*`.

---

## 1. Register the extension in your app descriptor

Add the extension ID to your **AIR application descriptor** (`*-app.xml`). This tells the runtime to load the ANE when your app starts.

```xml
<extensions>
  <extensionID>com.fluocode.nativeANE.NativeUtilities</extensionID>
</extensions>
```

**Extension ID (constant used in code):** `com.fluocode.nativeANE.NativeUtilities`  
(same value as `NativeAlertDialog.EXTENSION_ID` / `NativeUtilities.EXTENSION_ID` in ActionScript.)

---

## 2. Events you can listen for

Most dialogs dispatch `NativeDialogEvent`:

| Event | When |
|--------|------|
| `NativeDialogEvent.OPENED` | Dialog became visible |
| `NativeDialogEvent.CLOSED` | Dialog closed; check `event.index` for the button index (as `String`) |
| `NativeDialogEvent.CANCELED` | Canceled (e.g. back / outside tap); often `index` is `"-1"` |

List dialogs also dispatch:

| Event | When |
|--------|------|
| `NativeDialogListEvent.LIST_CHANGE` | Selection changed while `NativeListDialog` is open |

---

## 3. Shared behavior on all dialogs

Dialogs implement the common dialog contract (`hide`, `dispose`, `shake`, etc.):

```actionscript
import com.fluocode.nativeANE.events.NativeDialogEvent;

if (dialog.isShowing()) {
  dialog.shake();
}
dialog.hide(0);
dialog.dispose();
```

---

## 💬 NativeAlertDialog — snippets

```actionscript
import com.fluocode.nativeANE.dialogs.NativeAlertDialog;
import com.fluocode.nativeANE.events.NativeDialogEvent;

var alert:NativeAlertDialog = new NativeAlertDialog(); // optional theme int

alert.title = "Title";
alert.message = "Message";
alert.buttons = Vector.<String>(["OK", "Cancel"]);

alert.closeHandler = function (e:NativeDialogEvent):void {
  trace(e.index); // button index as String
};

alert.show(true); // cancelable on Android (back / outside)

// One-shot helper
NativeAlertDialog.showAlert(
  "Message",
  "Title",
  Vector.<String>(["OK", "Cancel"]),
  function (e:NativeDialogEvent):void { /* ... */ },
  true,  // cancelable (Android)
  -1     // optional theme; -1 = default
);

if (NativeAlertDialog.isSupported) { /* ... */ }
```

---

## 📋 NativeListDialog — snippets

```actionscript
import com.fluocode.nativeANE.dialogs.NativeListDialog;
import com.fluocode.nativeANE.events.NativeDialogEvent;
import com.fluocode.nativeANE.events.NativeDialogListEvent;

var list:NativeListDialog = new NativeListDialog();

list.title = "Choose";
list.dataProvider = Vector.<Object>(["A", "B", "C"]);
list.displayMode = NativeListDialog.DISPLAY_MODE_SINGLE; // or DISPLAY_MODE_MULTIPLE
list.buttons = Vector.<String>(["OK", "Cancel"]);

list.addEventListener(NativeDialogEvent.CLOSED, function (e:NativeDialogEvent):void { });
list.addEventListener(NativeDialogListEvent.LIST_CHANGE, function (e:NativeDialogListEvent):void { });

list.show();
```

---

## 📅 NativeDatePickerDialog — snippets

```actionscript
import com.fluocode.nativeANE.dialogs.NativeDatePickerDialog;

var picker:NativeDatePickerDialog = new NativeDatePickerDialog();
picker.displayMode = NativeDatePickerDialog.DISPLAY_MODE_DATE; // or TIME, DATE_AND_TIME
picker.date = new Date();
picker.minDate = new Date(2020, 0, 1);
picker.maxDate = new Date(2030, 11, 31);
picker.show(true);
```

---

## ✏️ NativeTextInputDialog — snippets

```actionscript
import com.fluocode.nativeANE.dialogs.NativeTextInputDialog;
import com.fluocode.nativeANE.dialogs.support.NativeTextField;

var dlg:NativeTextInputDialog = new NativeTextInputDialog();
var fields:Vector.<NativeTextField> = new Vector.<NativeTextField>();

var line:NativeTextField = new NativeTextField("server");
line.prompText = "Host";
dlg.textInputs = fields;
dlg.title = "Connect";
dlg.buttons = Vector.<String>(["OK", "Cancel"]);
dlg.show(true);
```

---

## ⏳ NativeProgressDialog — snippets

```actionscript
import com.fluocode.nativeANE.dialogs.NativeProgressDialog;

var prog:NativeProgressDialog = new NativeProgressDialog();
prog.title = "Please wait";
prog.showSpinner(true);   // or showProgressbar(true), or show(cancelable, indeterminate)
prog.max = 100;
prog.setProgress(50);
```

---

## 🎡 NativePickerDialog & PickerList — snippets

```actionscript
import com.fluocode.nativeANE.dialogs.NativePickerDialog;
import com.fluocode.nativeANE.dialogs.support.PickerList;

var col:PickerList = new PickerList(Vector.<String>(["One", "Two", "Three"]), 0);
var dlg:NativePickerDialog = new NativePickerDialog();
dlg.dataProvider = new <PickerList>[col];
dlg.title = "Pick";
dlg.buttons = Vector.<String>(["OK"]);
dlg.show(true);
```

---

## 🛠️ NativeUtilities — reference

Use the extension only on supported runtimes. **Before any native call**, check support (and optionally bail early):

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) {
  return;
}
```

Each snippet below includes the **import** lines you need for that call.

---

### Support, version, and extension context

#### `NativeUtilities.isSupported` (getter)

**What it does:** Returns `true` on iOS and Android builds where this ANE is usable; `false` elsewhere (e.g. desktop simulators without the native lib).

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) {
  return;
}
```

#### `NativeUtilities.EXTENSION_ID` / `NativeUtilities.VERSION`

**What it does:** `EXTENSION_ID` is the string to declare in your app descriptor (`com.fluocode.nativeANE.NativeUtilities`). `VERSION` matches the ANE package version.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

trace(NativeUtilities.EXTENSION_ID, NativeUtilities.VERSION);
```

#### `NativeUtilities.context`

**What it does:** Lazily creates and returns the shared `ExtensionContext` used for native calls. Listeners (e.g. `StatusEvent.STATUS` for UI visibility) attach here.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;
import flash.external.ExtensionContext;

if (!NativeUtilities.isSupported) return;
var ctx:ExtensionContext = NativeUtilities.context;
```

#### `NativeUtilities.showError(message, id)`

**What it does:** Throws an `Error` prefixed with the extension ID—used internally when a static call fails.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

// Throws — typically internal; catch if you bridge your own errors.
NativeUtilities.showError("Something failed", 0);
```

---

### Status bar, navigation bar, fullscreen, and colors

Bar **background color** and most **navigation bar** APIs are **Android-only** (they no-op or return early on iOS). **Status bar icon/text style** and **dark mode** apply on both platforms where the OS allows it.

#### `NativeUtilities.getStatusBarHeight()`

**What it does:** Returns the status bar height as a **Number** (pixels on Android; on iOS the native value is adjusted in AS—use for layout padding). Returns **-1** if unavailable.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
var h:Number = NativeUtilities.getStatusBarHeight();
```

#### `NativeUtilities.isDarkMode()`

**What it does:** Returns whether the system UI is using a **dark theme** (dark mode).

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
var dark:Boolean = NativeUtilities.isDarkMode();
```

#### `NativeUtilities.statusBarStyleLight(light)`

**What it does:** Sets status bar **content** (icons/text) to a **light** style (`true`, e.g. on dark backgrounds) or **dark** style (`false`).

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.statusBarStyleLight(true);
```

#### `NativeUtilities.statusBarColor(color)`

**What it does:** Sets the status bar **background** color (`uint` RGB, e.g. `0xFF000000`). **Android only** (no-op on iOS).

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.statusBarColor(0xFF000000);
```

#### `NativeUtilities.statusBarTransparent()`

**What it does:** Makes the status bar **transparent** so content can show through (typical with edge-to-edge layouts). **Android only.**

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.statusBarTransparent();
```

#### `NativeUtilities.navigationBarColor(color)`

**What it does:** Sets the navigation bar **background** color (`uint` RGB). **Android only.**

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.navigationBarColor(0xFF000000);
```

#### `NativeUtilities.navigationBarTransparent()`

**What it does:** Makes the navigation bar **transparent**. **Android only.**

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.navigationBarTransparent();
```

#### `NativeUtilities.navigationBarStyleLight(light)`

**What it does:** Sets navigation bar **icons** to light (`true`) or dark (`false`) style. **Android only.**

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.navigationBarStyleLight(true);
```

#### `NativeUtilities.hideNavigation(light)`

**What it does:** Controls whether content extends into the navigation bar area per native behavior (`true` / `false`). The ActionScript parameter is named `light` in the API; it maps to the native `hideNavigation` call. **Android only.**

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.hideNavigation(true);
```

#### `NativeUtilities.fullscreen(mode)`

**What it does:** Enables (`true`) or disables (`false`) **fullscreen** window mode (Android window decor). **Android only.**

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.fullscreen(true);
```

#### `NativeUtilities.setTranslucentNavigation()`

**What it does:** Makes the navigation bar **translucent** (API 19+ behavior on Android). **Android only.**

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.setTranslucentNavigation();
```

#### `NativeUtilities.hideWindowStatusBar()`

**What it does:** Hides the status bar at the **window** level so it stays hidden when other native surfaces (e.g. dialogs) appear—unlike toggling flags on a single view only. **Android only.**

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.hideWindowStatusBar();
```

---

### Display cutout, brightness, display mode, and window insets

#### `NativeUtilities.getDisplayCutout()`

**What it does:** Returns a **`DisplayCutout`** with safe insets and cutout geometry parsed from native JSON, or `null` if unavailable.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;
import com.fluocode.nativeANE.display.DisplayCutout;

if (!NativeUtilities.isSupported) return;
var cutout:DisplayCutout = NativeUtilities.getDisplayCutout();
```

#### `NativeUtilities.displayCutoutRects` (getter)

**What it does:** On **Android**, returns a **`Vector.<Rectangle>`** of cutout bounds in **window** coordinates; on **iOS** and elsewhere returns **`null`**.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;
import flash.geom.Rectangle;

if (!NativeUtilities.isSupported) return;
var rects:Vector.<Rectangle> = NativeUtilities.displayCutoutRects;
```

#### `NativeUtilities.setCutoutMode(mode)`

**What it does:** Sets how the window lays out relative to display cutouts. Use constants: **`CUTOUTMODE_DEFAULT`**, **`CUTOUTMODE_SHORT_EDGES`**, **`CUTOUTMODE_NEVER`**. **Android only.**

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.setCutoutMode(NativeUtilities.CUTOUTMODE_SHORT_EDGES);
```

#### `NativeUtilities.setBrightness(value)`

**What it does:** Sets window brightness: **0..1**, or **-1** to restore the user’s system preference.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.setBrightness(0.5);
```

#### `NativeUtilities.setDisplayMode(displayMode, layoutMode)`

**What it does:** Sets **display mode** (`DisplayMode.NORMAL`, `FULLSCREEN`, `IMMERSIVE`) and **cutout layout** (`LayoutMode.*`). Returns `true` if the native call succeeded. On iOS, fullscreen is often used together with `Stage.displayState`; cutout layout mainly affects Android.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;
import com.fluocode.nativeANE.display.DisplayMode;
import com.fluocode.nativeANE.display.LayoutMode;

if (!NativeUtilities.isSupported) return;
NativeUtilities.setDisplayMode(DisplayMode.IMMERSIVE, LayoutMode.CUTOUT_NEVER);
```

#### `NativeUtilities.setDecorFitsSystemWindows(fit)`

**What it does:** Maps to AndroidX **`WindowCompat.setDecorFitsSystemWindows`**: `true` lays content **below** system bars; `false` is edge-to-edge (pad with **`getStatusBarHeight()`** / **`getDisplayCutout()`**). **Android only** (no-op on iOS). See **Edge-to-edge on Android** below for when to call it.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.setDecorFitsSystemWindows(true);
```

---

### System UI visibility (Android)

#### `NativeUtilities.setUIVisibility(flags)`

**What it does:** Applies a bitmask of Android **`View.SYSTEM_UI_FLAG_*`** values for status/navigation visibility and immersive behavior.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.setUIVisibility(0); // replace with View.SYSTEM_UI_FLAG_* bitmask
```

#### `NativeUtilities.supportedUIFlags` (getter)

**What it does:** Returns a **`Vector.<int>`** of UI flag values supported on this device/build; empty vector when not on Android.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
var flags:Vector.<int> = NativeUtilities.supportedUIFlags;
```

#### `NativeUtilities.enableUIVisibilityListener(enable)`

**What it does:** When `true`, registers a native listener so the extension dispatches **`StatusEvent.STATUS`** when the user shows/hides system bars (e.g. swipe in immersive mode). Use **`NativeUtilities.UI_VISIBILITY_CHANGE_EVENT`** as `event.code`; **`int(event.level)`** holds the visibility flags.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;
import flash.events.StatusEvent;

if (!NativeUtilities.isSupported) return;
NativeUtilities.enableUIVisibilityListener(true);
NativeUtilities.context.addEventListener(StatusEvent.STATUS, function (e:StatusEvent):void {
  if (e.code == NativeUtilities.UI_VISIBILITY_CHANGE_EVENT) {
    var visibilityFlags:int = int(e.level);
  }
});
```

---

### Security, identity, and haptics

**Security** → `blockScreenshot`. **Identity** → `getDeviceUniqueId`. **Haptics** → `vibrate` / `vibratePattern`.

#### `NativeUtilities.blockScreenshot(block)` — security

**What it does:** When `true`, blocks screenshots and screen recording where supported (Android `FLAG_SECURE`; iOS uses an overlay-style approach when backgrounding).

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.blockScreenshot(true);  // true = block capture, false = allow
```

#### `NativeUtilities.getDeviceUniqueId()` — identity

**What it does:** Returns a **string** ID: Android uses **`ANDROID_ID`** (hex) with fallback; iOS uses **`identifierForVendor`**. May be empty if unavailable. Treat as **device-scoped**; it can change after factory reset, or on iOS if all apps from the same vendor are uninstalled.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
var id:String = NativeUtilities.getDeviceUniqueId();
```

#### `NativeUtilities.vibrate(durationMs)` — haptics

**What it does:** **Android:** vibrates for **1–5000 ms** (values clamped). **iOS:** short system vibration; `durationMs` is ignored. For vibration on Android, ensure **`android.permission.VIBRATE`** is in the merged manifest (see **Android manifest** below).

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.vibrate(200);  // ms on Android; default 200 if omitted
```

#### `NativeUtilities.vibratePattern(pattern)` — haptics

**What it does:** **Android:** native waveform from an **Array** or Vector: **`[delay, vibrate, delay, vibrate, …]`** (even length, length ≥ 2). **iOS:** emulated with timed short vibrates. On Android, **`VIBRATE`** permission must be present.

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

if (!NativeUtilities.isSupported) return;
NativeUtilities.vibratePattern([0, 100, 50, 100]);  // wait 0, vibrate 100ms, wait 50, vibrate 100ms
```

---

## 📐 Edge-to-edge on Android — fix and how to implement it

Modern Android (including **API 35 / Android 15** and related **edge-to-edge** window behavior) often draws your app **behind** the status and navigation bars. AIR’s root view may then overlap system UI: touches can miss controls, or content sits under the status bar.

This ANE exposes a single, compatibility-oriented hook that maps to AndroidX **`WindowCompat.setDecorFitsSystemWindows`**:

| Call | Effect on Android |
|------|-------------------|
| **`NativeUtilities.setDecorFitsSystemWindows(true)`** | Window content is **laid out below** the status and navigation bars (system reserves that inset). Use this when you want **classic “safe” layout** or when you hit **touch / overlap issues** on edge-to-edge devices (including API 24–25 edge cases and **API 35+**). |
| **`NativeUtilities.setDecorFitsSystemWindows(false)`** | **Edge-to-edge**: content **can draw behind** the bars. You must add your own padding or reposition UI using **`NativeUtilities.getStatusBarHeight()`**, **`NativeUtilities.getDisplayCutout()`**, and (on Android) **`NativeUtilities.displayCutoutRects`** so tappable areas are not under the bars. |

The mapping above is **Android**. On **iOS**, `setDecorFitsSystemWindows` does not change window insets the same way—use iOS safe-area patterns in your UI as needed.

### When to call it

Call **`setDecorFitsSystemWindows`** once your app has a **visible Activity / Stage** (for example after **`Event.ADDED_TO_STAGE`** on your root sprite, or from an **`activate`** / first-frame handler). You can switch between `true` and `false` if your app has modes that need different layout (e.g. fullscreen video vs. forms).

### Minimal “fix” snippet (recommended starting point)

If your goal is to **stop content from sitting under the system bars** and restore reliable hit-testing:

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

private function applyEdgeToEdgeFix():void {
  if (!NativeUtilities.isSupported) return;
  NativeUtilities.setDecorFitsSystemWindows(true);
}
```

Invoke `applyEdgeToEdgeFix()` when the main view is ready (e.g. from your root document class after the stage is available).

### Edge-to-edge look with manual insets

If you prefer **full bleed** behind the bars, use `false` and **pad your layout** using native metrics:

```actionscript
import com.fluocode.nativeANE.display.DisplayCutout;
import com.fluocode.nativeANE.utilities.NativeUtilities;

NativeUtilities.setDecorFitsSystemWindows(false);
var topInset:Number = NativeUtilities.getStatusBarHeight();
var cutout:DisplayCutout = NativeUtilities.getDisplayCutout();
if (cutout != null) {
  topInset = Math.max(topInset, cutout.safeInsetTop);
}
// Apply topInset (and bottom insets as needed) to your Stage / root container.
```

You can combine this with **`NativeUtilities.setDisplayMode(...)`** and **`LayoutMode`** if you also control immersive / cutout policy (see the **Display cutout** snippet under **NativeUtilities** above).

### Descriptor

No extra **extension ID** is required beyond the standard **`com.fluocode.nativeANE.NativeUtilities`** entry. **`setDecorFitsSystemWindows`** does not add new Android permissions; it only changes how the **window** insets are applied.

---

## 🍞 Toast — snippets

```actionscript
import com.fluocode.nativeANE.notifications.Toast;

Toast.show("Saved", Toast.LENGTH_SHORT);

// Android: position / offsets
Toast.showWithDifferentGravit("Hello", Toast.LENGTH_LONG, Toast.GRAVITY_BOTTOM, 0, 0);

Toast.dispose(); // release extension context when done
```

---

## 📱 Android manifest & iOS Info.plist

### Android

The ANE’s library manifest includes **`android.permission.VIBRATE`** so **`NativeUtilities.vibrate()`** and **`NativeUtilities.vibratePattern()`** can run on devices that expose the vibrator. When you package your app, AIR **merges** the extension manifest with yours. If you use **custom** `manifestAdditions` or a merge setup that **drops** inherited permissions, ensure **`VIBRATE`** stays in the final APK.

Keep vibration working in your AIR application descriptor (`<android>` in `*-app.xml`): add or preserve this permission inside `<manifest>` (merge the line if you already have a manifest block):

```xml
<android>
  <manifestAdditions><![CDATA[
    <manifest android:installLocation="auto">
      <uses-permission android:name="android.permission.VIBRATE"/>
      <!-- Your other permissions, activities, etc. -->
    </manifest>
  ]]></manifestAdditions>
</android>
```

If you already have a `<manifest>...</manifest>` block, **merge** this line with your existing permissions instead of duplicating the whole `<manifest>` element.

You do **not** need extra permissions for features such as:

- Status / navigation bar appearance (where supported)  
- Display cutout / safe area queries  
- Device identifier via **`ANDROID_ID`** (no `READ_PHONE_STATE` for that path in this ANE)

Add **only** permissions your own app logic requires (network, storage, etc.); they are independent of this ANE unless you call APIs that need them.

### iOS

For typical use (**alerts, pickers, progress, toasts, utilities**), you usually **do not** need extra **`Info.plist`** keys beyond what your app already declares. Features such as **`identifierForVendor`**, system vibration, and UI overlays do not require separate API keys.

If Apple’s privacy manifests or **App Store** forms ask about data collection, describe your app’s behavior; **`getDeviceUniqueId()`** uses vendor/device identifiers as documented in Apple’s guidelines—**no third-party SDK key** is involved.

---

## 🔑 API keys, secrets, and developer credentials

**This ANE does not require you to create or configure any API key, client secret, or cloud console project** for its core features. Identifiers and system UI calls use **on-device OS APIs** (e.g. Android `Settings.Secure`, iOS `identifierForVendor`).

If you integrate **other** SDKs in the same app, manage those keys according to those vendors—**not** part of NativeUtilities.

---

## 📌 Quick reference — extension ID

| Constant | Value |
|----------|--------|
| Extension ID | `com.fluocode.nativeANE.NativeUtilities` |

---

<p align="center">Made for apps that need native look & feel on mobile 🚀</p>

---

If you like what I make, you can donate:

[![Donate with PayPal](https://www.paypalobjects.com/en_GB/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4QBWVDKEVRL46)
