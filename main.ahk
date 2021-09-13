
DetectHiddenWindows On
SetTitleMatchMode 2

Gosub init

^!+e::
    Gosub, clearall
    reload("enclosed_alphanumeric")
    return

^!+b::
    Gosub, clearall
    reload("blocks")
    return

^!+t::
    Gosub, clearall
    reload("blocktext")
    return

^!+a::
    Gosub, clearall
    return

^!+r::Reload

^!+x::
    Gosub exitall
    ExitApp, -1


init:
    Loop, Files, *.ahk
    {
        SplitPath, A_LoopFileName,,,, fn
        if(fn != "main")
        {
            initfile(fn)
        }
    }
    return

initfile(filename)
{
    exitf(filename)
    Run % filename . ".ahk"
    clear(filename)
}

exitf(filename)
{
    WinClose % filename . ".ahk - AutoHotkey"
}

clear(filename)
{
    script := WinExist(filename . ".ahk ahk_class AutoHotkey")
    static ID_FILE_SUSPEND := 65404

    mainMenu := DllCall("GetMenu", "ptr", script)
    fileMenu := DllCall("GetSubMenu", "ptr", mainMenu, "int", 0)
    state := DllCall("GetMenuState", "ptr", fileMenu, "uint", ID_FILE_SUSPEND, "uint", 0)
    isSuspended := state >> 3 & 1
    DllCall("CloseHandle", "ptr", fileMenu)
    DllCall("CloseHandle", "ptr", mainMenu)
    if(!isSuspended)
    {
        PostMessage, 0x0111, ID_FILE_SUSPEND,,, % filename . ".ahk - AutoHotkey"
    }
}

reload(filename)
{
    PostMessage, 0x0111, 65303,,, % filename . ".ahk - AutoHotkey"
}

runall:
    Loop, Files, *.ahk
    {
        SplitPath, A_LoopFileName,,,, fn
        if(fn != "main")
        {
            Run % fn . ".ahk"
        }
    }
    return

clearall:
    Loop, Files, *.ahk
        {
            SplitPath, A_LoopFileName,,,, fn
            if(fn != "main")
            {
                clear(fn)
            }
        }
    return

exitall:
    Loop, Files, *.ahk
    {
        SplitPath, A_LoopFileName,,,, fn
        if(fn != "main")
        {
            exitf(fn)
        }
    }
    return