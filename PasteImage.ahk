#Requires AutoHotkey v2.0
#SingleInstance Force

; Hook callbacks do only cheap checks. Folder lookup (COM) runs in a timer.
#HotIf CanPasteImage()
$^v:: SetTimer(DoPaste, -1)
#HotIf

DoPaste() {
    folder := GetFolder()
    if (folder = "" || !DirExist(folder)) {
        Send("^v")          ; virtual folder (This PC etc.): normal paste
        return
    }
    file := folder "\Screenshot_" FormatTime(, "yyyyMMdd_HHmmss") ".png"
    esc := StrReplace(file, "'", "''")
    ps := "Add-Type -AssemblyName System.Windows.Forms,System.Drawing;"
        . "$i=[Windows.Forms.Clipboard]::GetImage();"
        . "if($i){$i.Save('" esc "',[Drawing.Imaging.ImageFormat]::Png)}"
    RunWait('powershell -NoProfile -STA -Command "' ps '"',, "Hide")
}

CanPasteImage() {
    cls := WinGetClass("A")
    if !(cls = "CabinetWClass" || cls = "Progman" || cls = "WorkerW")
        return false
    try focus := ControlGetClassNN(ControlGetFocus("A"))
    catch
        focus := ""
    if (focus != "" && !InStr(focus, "DirectUIHWND") && !InStr(focus, "SysListView32"))
        return false
    if DllCall("IsClipboardFormatAvailable", "uint", 15)      ; copied files
        return false
    return DllCall("IsClipboardFormatAvailable", "uint", 8)   ; image
}

GetFolder() {
    cls := WinGetClass("A")
    if (cls = "Progman" || cls = "WorkerW")
        return A_Desktop
    hwnd := WinExist("A")
    for w in ComObject("Shell.Application").Windows {
        try if (w.HWND = hwnd)
            return w.Document.Folder.Self.Path
    }
    return ""
}