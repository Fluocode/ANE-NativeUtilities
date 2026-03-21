# 🧩 NativeUtilities ANE for Adobe AIR

**NativeUtilities** is an Native Extension that brings **native UI and system APIs** to your mobile app: alerts, lists, date/time pickers, text input dialogs, progress overlays, wheel pickers, toasts, and utilities such as status/navigation bar styling, display cutouts, screenshot protection, vibration, brightness, and device identifiers—on **Android** and **iOS**.

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

## 🛠️ NativeUtilities — snippets

Always guard with **`NativeUtilities.isSupported`** before calling.

### Bars, fullscreen, and color (mostly Android for color / nav)

```actionscript
import com.fluocode.nativeANE.utilities.NativeUtilities;

NativeUtilities.getStatusBarHeight();
NativeUtilities.isDarkMode();
NativeUtilities.statusBarStyleLight(true);
NativeUtilities.statusBarColor(0xFF000000);
NativeUtilities.statusBarTransparent();
NativeUtilities.navigationBarColor(0xFF000000);
NativeUtilities.navigationBarTransparent();
NativeUtilities.navigationBarStyleLight(true);
NativeUtilities.hideNavigation(true);
NativeUtilities.fullscreen(true);
NativeUtilities.setTranslucentNavigation();
NativeUtilities.hideWindowStatusBar();
```

### Display cutout, layout, and brightness

```actionscript
import com.fluocode.nativeANE.display.DisplayCutout;
import com.fluocode.nativeANE.display.DisplayMode;
import com.fluocode.nativeANE.display.LayoutMode;
import flash.geom.Rectangle;

var cutout:DisplayCutout = NativeUtilities.getDisplayCutout();
var rects:Vector.<Rectangle> = NativeUtilities.displayCutoutRects;
NativeUtilities.setCutoutMode(NativeUtilities.CUTOUTMODE_SHORT_EDGES);
NativeUtilities.setBrightness(0.5); // 0..1, or -1 for system default
NativeUtilities.setDisplayMode(DisplayMode.IMMERSIVE, LayoutMode.CUTOUT_NEVER);
NativeUtilities.setDecorFitsSystemWindows(true); // Android: content below system bars
```

### System UI visibility (Android)

```actionscript
import flash.events.StatusEvent;

var flags:Vector.<int> = NativeUtilities.supportedUIFlags;
NativeUtilities.setUIVisibility(/* View.SYSTEM_UI_FLAG_* */ 0);
NativeUtilities.enableUIVisibilityListener(true);
NativeUtilities.context.addEventListener(StatusEvent.STATUS, function (e:StatusEvent):void {
  if (e.code == NativeUtilities.UI_VISIBILITY_CHANGE_EVENT) {
    var visibilityFlags:int = int(e.level);
  }
});
```

### Security, identity, and haptics

```actionscript
NativeUtilities.blockScreenshot(true);
var id:String = NativeUtilities.getDeviceUniqueId();
NativeUtilities.vibrate(200);
NativeUtilities.vibratePattern([0, 100, 50, 100]);
```

### Errors from static helpers

```actionscript
NativeUtilities.showError("Something failed", 0); // throws Error with ANE prefix
```

---

## 📐 Edge-to-edge on Android — fix and how to implement it

Modern Android (including **API 35 / Android 15** and related **edge-to-edge** window behavior) often draws your app **behind** the status and navigation bars. AIR’s root view may then overlap system UI: touches can miss controls, or content sits under the status bar.

This ANE exposes a single, compatibility-oriented hook that maps to AndroidX **`WindowCompat.setDecorFitsSystemWindows`**:

| Call | Effect on Android |
|------|-------------------|
| **`NativeUtilities.setDecorFitsSystemWindows(true)`** | Window content is **laid out below** the status and navigation bars (system reserves that inset). Use this when you want **classic “safe” layout** or when you hit **touch / overlap issues** on edge-to-edge devices (including API 24–25 edge cases and **API 35+**). |
| **`NativeUtilities.setDecorFitsSystemWindows(false)`** | **Edge-to-edge**: content **can draw behind** the bars. You must add your own padding or reposition UI using **`NativeUtilities.getStatusBarHeight()`**, **`NativeUtilities.getDisplayCutout()`**, and (on Android) **`NativeUtilities.displayCutoutRects`** so tappable areas are not under the bars. |

**Platform note:** This API is **Android-only**; on iOS the ActionScript method returns without applying window insets in the same way (use iOS safe-area patterns in your UI as needed).

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

The ANE is built with **`VIBRATE`** so **`NativeUtilities.vibrate()` / `vibratePattern()`** can run on devices that expose the vibrator. When you package your app, AIR **merges** the extension’s manifest with yours—if you use custom manifest merging, ensure **`android.permission.VIBRATE`** remains present for vibration.

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
