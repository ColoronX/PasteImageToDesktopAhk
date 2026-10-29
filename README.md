# PasteImage

Paste a screenshot straight into a Windows folder or onto the desktop with **Ctrl+V**.

Windows can't do this natively: if you copy an image (e.g. with `Win+Shift+S`), Explorer ignores Ctrl+V. PasteImage fixes that by saving the clipboard image as a PNG in the folder you're viewing.

## Features

- Ctrl+V in any Explorer folder or on the desktop saves the clipboard image as a PNG
- Files are named `Screenshot_YYYYMMDD_HHMMSS.png`
- Normal Ctrl+V keeps working for files, text, and everywhere outside Explorer
- Ignores rename and search boxes
- Single portable `.exe`, no AutoHotkey install required

## Usage

1. Download `PasteImage.exe` from [Releases](../../releases) and run it. It lives in the system tray.
2. Take a screenshot (`Win+Shift+S`).
3. Open a folder or the desktop and press **Ctrl+V**.

To stop it, right-click the tray icon and choose **Exit**.

**Autostart:** press `Win+R`, enter `shell:startup`, and put a shortcut to `PasteImage.exe` there.

## Run from source

1. Install [AutoHotkey v2](https://www.autohotkey.com/).
2. Double-click `PasteImage.ahk`.

## Build the .exe

1. Right-click `PasteImage.ahk` and choose **Compile Script**.
2. Or open **Ahk2Exe**, set Base File to `v2.0.x U64 AutoHotkey64.exe`, and click **Convert**.

## How it works

- A `#HotIf` condition activates the hotkey only when Explorer or the desktop is focused and the clipboard holds an image but no copied files.
- The folder path is resolved via `Shell.Application` COM, deferred with `SetTimer` because COM calls are not allowed inside a keyboard-hook callback.
- The image is saved by a hidden PowerShell call to `Clipboard.GetImage()`.

## Limitations

- Does nothing in virtual folders (This PC, Quick access, etc.); normal paste runs instead.
- Output is PNG only.
- Requires Windows 10 or later with built-in `powershell.exe`.
- Some antivirus tools flag AutoHotkey-compiled executables as false positives. Add an exclusion or run the `.ahk` directly.

## License

MIT
