ShiftOuter        := True

EnvGet, HOME, USERPROFILE
HOME              := StrReplace(HOME, "\", "\\") 
;MsgBox SNAME: %SNAME% HOME: %HOME%
bashrc            := HOME . "\\df\\bashrc"
vimrc             := HOME . "\\df\\vimrc"
;chromePath        := "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"
chromePath        := "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"
connectifyPath    := "C:\\Program Files (x86)\\Connectify\\Connectify.exe"
ghosterPath       := HOME . "\\df\\Ghoster.ahk"
hostFilePath      := "c:\\windows\\system32\\drivers\\etc\\hosts"
hapPath           := HOME . "\\df\\bin\\hap\\hap.exe /hint"
dimmerPath        := HOME . "\\df\\bin\\dimmer.exe /hint"
blacknotepad      := HOME . "\\df\\bin\\blacknotepad.exe"
kittyPath         := HOME . "\\df\\bin\\kitty_portable.exe"
mouseModeAhk      := HOME . "\\df\\MouseMode.ahk"
screenDimAhk      := HOME . "\\df\\ScreenDim.ahk"
mouseModeExe      := HOME . "\\df\\MouseMode.exe"
mstscPath         := "C:\\Windows\\System32\\mstsc.exe"
nvimPath          := HOME . "\\df\\bin\\Neovim\\bin\\nvim.exe"
nvimqtPath        := HOME . "\\df\\bin\\Neovim\\bin\\nvim-qt.exe"
outlookPath       := "C:\Program Files\Microsoft Office\root\Office16\\Outlook.exe"
pushNvimCfg       := HOME . "\\df\\PushNvim.ahk"
powershellPath    := "powershell.exe"
tapPathAhk        := HOME . "\\df\\tap.ahk"
tapPathExe        := HOME . "\\df\\tap.exe"
timePath          := "C:\\Program Files\\WindowsApps\\Microsoft.WindowsAlarms_10.2009.5.0_x64__8wekyb3d8bbwe\\time.exe"
vifmPath          := HOME . "\\df\\bin\\vifm.exe"
windowsTerminal   := HOME . "\\AppData\\Local\\Microsoft\\WindowsApps\\wt.exe"
vsCodePath        := "C:\\Program Files\\Microsoft VS Code\\Code.exe"
YTdownloadAHKPath    := HOME . "\\df\youtube-dl.ahk"
minttyPath        := "C:\\Program Files\\Git\\usr\\bin\\mintty.exe"
;minttyPath        := "C:\\Program Files\\Git\\git-bash.exe"

for n, param in A_Args  ; For each parameter:
{
    ;MsgBox Parameter number %n% is %param%.
    if param = 3
        ;msgbox shiftRight1   := True
        shiftRight1   := False  ; right hand shift 1 key to the right.
        shiftRightHand2   := False  ; right hand shift 2 key to the right.
    ;
    if param = shitRightHand1
        ;msgbox shiftRight1   := True
        shiftRight1   := True   ; right hand shift 1 key to the right.
        shiftRightHand2   := False  ; right hand shift 2 key to the right.
    ;
    if param = shiftRightHand2
        msgbox shiftRightHand2   := True
        shiftRight1   := False  ; right hand shift 1 key to the right.
        shiftRightHand2   := True   ; right hand shift 2 key to the right.
}

reStartInAdmin()
{
    ; MsgBox, "%A_ScriptFullPath%" will restart in Admin mode.
    ;<<< Start as Admin >>>
    ; If the script is not elevated, relaunch as administrator and kill current instance:
    full_command_line := DllCall("GetCommandLine", "str")
    ; msgbox fullcmd: %full_command_line% A_IsAdmin: %A_IsAdmin%
    if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
    {
        ; MsgBox, Starting script in admin mode.
        try ; leads to having the script re-launching itself as administrator
        {
            if A_IsCompiled 
            {
                ; MsgBox Run *RunAs "%A_ScriptFullPath%" /restart
                Run *RunAs "%A_ScriptFullPath%" /restart
            }
            else
            {    
                ; MsgBox Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
                Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
            }
        }
        ExitApp
    }
}

;<<< Start as Admin >>>
if( "CAR-LT-C50626B" <> A_ComputerName) {
    ; MsgBox Computer is not CAR-LT-C50626, restarting in Admin mode.
    reStartInAdmin()
}

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include %A_ScriptDir%\DimScreen.ahk   ; ~/df/DimScreen.ahk  nvim path to open
#Include %A_ScriptDir%\passwords.ahk
#Include %A_ScriptDir%\FindClick.ahk
#Include %A_ScriptDir%\RunOrActivate.ahk
#Include %A_ScriptDir%\TrayIcon.ahk
#Include %A_ScriptDir%\CloseScript.ahk
; #Include %A_ScriptDir%\PreviousWindow.ahk
; #Include %A_ScriptDir%\KeepRemindingOutlook.ahk

#NoEnv
#SingleInstance force
;#InstallMouseHook
#installkeybdhook
#EscapeChar \
#HotkeyModifierTimeout 100

; DetectHiddenWindows, On  ; BUG: Causes windows not to be in focuse if turned on
SetNumLockState,Off
SetScrollLockState,Off
SetScrollLockState,AlwaysOff
SetCapsLockState,Off
SetCapsLockState,AlwaysOff
SendMode Input

;;;; TAP.AHK ;;;;
if (enableTap == True) {
    if  (A_IsCompiled) {
        Run %tapPathExe%
    } else {
        Run %A_AhkPath% %tapPathAhk%
    }
}

;;;;; KeepRemindingOutlook.ahk ;;;;
if (A_ComputerName = "CAR-LT-C50626B" ) {
; restart KeepRemindingOutlook.ahk
    TapPath = %A_ScriptDir%\\KeepRemindingOutlook.ahk
    WinClose, %TapPath% ahk_class AutoHotkey
    if(A_IsCompiled) {
        Run %A_AhkPath% %TapPath%
    } else {
        Run %A_AhkPath% %TapPath%
    }
}

:*:]d::  ; This hotstring replaces "]d" with the current date and time via the commands below.
    FormatTime, CurrentDateTime,, M/d/yyyy h:mm tt  ; It will look like 9/1/2005 3:53 PM
    SendInput %CurrentDateTime%
    return

Left & d::Send {RWin Down}d{Rwin Up}
Left::BS.SetBrightness(-15)
Right::BS.SetBrightness(15)
Up::Send {Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}
Down::Send {Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}
; Ctrl & Up::Send {Volume_Up}
; Ctrl & Down::Send {Volume_Down}

; IDLE
msgbox check_idle
SetTimer, check_idle, 10000
check_idle:
msgbox check_idle
If A_TimeIdlePhysical > 10000
   MouseMove, 500, 500, 0, R
return

` & 2::
    MsgBox FindClick("ExecutorCl1.png")
    FindClick("ExecutorCl1.png")
    Return
` & 1::
    MsgBox FindClick("executor.png")
    FindClick("executor.png")
    Return
` & ,::
    FindClick()
    Return
` & ]::  ; p
    runargs := "-pw aA -ssh ply@localhost"
    runcmd = %kittyPath% %runargs%
    RunOrActivate(runcmd)
    ;sleep 2000
    ;sendraw bash -x <(curl -sL https://raw.githubusercontent.com/pl643/tmpenv/master/tmpenv.sh)
    ;send {Enter}
    return

#IF OldStuff
LWIN::Return
LWIN & \;::Send ^l
; LWIN & f::Run, %hapPath%
LWIN & k::Send ^h
LWIN & '::Send ^l
LWIN & o::Send ^i
; LWIN & p::Send ^o
LWIN & BackSpace::Send #{Up}
LWIN & =::Send #{Down}
LWIN & ]::Send #{Left}
LWIN & \::Send #{Right}
;F3::RunOrActivate(mstscPath, "con103")
;,^!3::RunOrActivate(mstscPath, "con103")
;^!6::RunOrActivate(mstscPath, "connvm06")
;+3::RunOrActivate(mstscPath, "con103")
;+6::RunOrActivate(mstscPath, "connvm06")

CTRL & Left::Send {Left}
CTRL & Right::Send {Right}
CTRL & Up::Send {Up}
CTRL & Down::Send {Down}

RWIN & \;::Send ^L
RWIN & `::Send ^`
RWIN & 1::Send ^1
RWIN & 2::Send ^2
RWIN & 3::Send ^3
RWIN & 4::Send ^4
RWIN & 5::Send ^5
RWIN & 6::Send ^6
RWIN & 7::Send ^7
RWIN & 8::Send ^8
RWIN & 9::Send ^9
RWIN & c::Send ^c
RWIN & d::Send ^d
RWIN & o::Send ^i
; RWIN & p::Send ^o
RWIN & r::Send ^r
RWIN & s::Send ^s
RWIN & t::Send ^t
RWIN & u::Send ^u
RWIN & v::Send ^v
RWIN & w::Send ^w
; LWIN & z::run Shutdown /s /t 0
; LWIN & q::run Shutdown /r /t 0

RWIN::RCTRL
AppsKey & \;::Send ^l
AppsKey & a::Send ^a
AppsKey & c::Send ^c
AppsKey & f::Run, %hapPath%
AppsKey & r::Send ^r
AppsKey & s::Send ^s
AppsKey & w::Send ^w
AppsKey & 4::Send !{F4}
;AppsKey & Space::Send ^{Backspace}
;RCTRL   & Space::
;    msgbox sending ^space
;    Send ^{Space}
;    return
AppsKey::Send {Enter}
; RCTRL::Msgbox RALT-Space
$PrintScreen::Send {Enter} ; for Lenovo bluetooth keyboard
$^PrintScreen::Send {PrintScreen} ; ctrl to send printscreen

#IF ShiftOuter ;{{{ #IF ShiftOuter

    ;Escape::MsgBox Escape is left Alt (left of Spacebar)
    ;123456
    `::1
    $1::2
    $2::3
    3::4
    4::5
    5::6
    l & `::SendRaw !
    l & 1::SendRaw @
    l & 2::SendRaw #
    l & 3::SendRaw $
    l & 4::SendRaw \%
    l & 5::SendRaw ^

    ;;;; qwert
    t::RunOrActivate(timePath)
    Tab::q
    q::w
    w::e
    e::r
    r::t
    l & tab::SendRaw Q
    l & q::SendRaw W
    l & w::SendRaw E
    l & e::SendRaw R
    l & r::SendRaw T

    ;;;; asdfg
    CapsLock::a
    a::s
    s::d
    d::f
    f::g
    l & capslock::SendRaw A
    l & a::SendRaw S
    l & s::SendRaw D
    l & d::SendRaw F
    l & f::SendRaw G

    ;;;; zxcvb
    Lshift::z
    z::x
    x::c
    c::v
    v::b
    l & lshift::SendRaw Z
    l & z::SendRaw X
    l & x::SendRaw C
    l & c::SendRaw V
    l & v::SendRaw B

    ;;;;; 790-=
    9::7
    0::8
    -::9
    =::0
    Backspace::-
    d & 9::SendRaw &
    d & 0::SendRaw *
    d & -::SendRaw (
    d & =::SendRaw )
    d & backspace::SendRaw _

    ;;;;; yuiop[]
    i::y
    o::u
    p::i
    [::o
    ]::p
    ;\::Tab
    ;\::Send ^]
    \::MsgBox Backslash
    Lctrl::Tab
    d & \::send |

    d & i::sendraw Y
    d & o::sendraw U
    d & p::sendraw I
    d & [::sendraw O
    d & ]::sendraw P
    d & Tab::send +Tab 
    ;d & \::sendraw {
    ;d & Delete::sendraw }

    ;;;;; hjklmn"
    k::h
    l::j
    \;::k
    '::l
    enter::\;
    d & k::sendraw H
    d & l::sendraw J
    d & \;::sendraw K
    d & '::sendraw L
    d & Enter::sendraw :

    ;;;;;  nm,./?  ;;;;;
    ,::n
    .::m
    /::,
    rshift::.
    d & ,::sendraw N
    d & .::sendraw M
    d & /::sendraw < 
    d & rshift::sendraw > 

    ; - & w::Send ^{WheelUp}
    ;- & q::Send ^{WheelDown}
    - & c::RunOrActivate("vlc.exe")

    - & d::LButton
    - & s::MButton
    - & a::RButton
    - & 2::WinActivate con103         ;con103   ; 3
    - & 5::WinActivate connvm06  ; connvm06 ; 6
    - & `::sendraw ~
    - & r::RunOrActivate("Teams.exe")
    - & e::
    ralt & e::
        msgbox ralt-e
        sendinput {Escape}:w{Enter}
        RunOrActivate(chromePath)
        SendInput ^r
        return 
    - & CapsLock::Run %A_AhkPath% %ScreenDimAhk%
;    = & r::Run chrome.exe "https://mail.google.com/" " --new-window "
    - & x::
        Run chrome.exe "http://avkaba01.microsemi.net:8080/WebTimeClock/main/index.jsp"
        sleep 2000
        Send {Down}
        sleep 100
        Send {Down}
        sleep 100
        send {Enter}
        sleep 100
        send {Enter}
        return
    - & q::Run chrome.exe "https://wd5.myworkday.com/wday/authgwy/microchiphr/login.htmld?returnTo=\%2fmicrochiphr\%2fd\%2ftask\%2f2997\%244767.htmld"
        sleep 1500
        send {Tab}
        sleep 500
        send {Tab}
        send f
        sleep 500
        send s
        return
    = & s::
        Process,Close,Dimmer.exe
        Run %dimmerPath% 
        return
    ralt & lshift::send !{z}

    = & r::RunOrActivate("Time.exe")

    ; left middle
    1 & p::Send {LWin Down}{Ctrl Down}c{Ctrl Up}{LWin Up}  ; toggle Wintools invert Win+Ctrl+c
    1 & l::Send ^{WheelDown} 
    1 & \;::Send ^{WheelUp} 
    1 & -::Send ^#{Left}
    1 & =::Send ^#{Right}
    ; 1 & '::Send !{Space}f
    ;2 & =::sendraw +
    ;2 & -::sendraw _
    ;2 & p::sendraw [
    ;2& [::sendraw ]
    ;2 & \;::sendraw {
    ;2 & '::sendraw }
    2 & '::send +#{right} ; send window to right screen
    2 & k::send +#{left}  ; send window to right screen
    2 & l::send #{down}   ; win+down 
    2 & \;::send #{up}   ; win+up 
    2 & ]::RunOrActivate("Popcorn-Time.exe")
    2 & [::
        SetTitleMatchMode, 2		; 2: A window's title can contain WinTitle anywhere inside it to be a match. 
        WinActivate, Outlook
        ; WinActivate, Teams
        Return
    ;2 & p::WinActivate Inbox
    2 & ,::RunOrActivate("OneNote.exe")

    ; virtual screen mappings
    1 & k::Send ^#{Left}    ; previous virtual screen
    1 & '::Send ^#{Right}   ; next virtual screen
    1 & ,::Send ^#{d}       ; new virtual screen (2 & n)
    1 & RALT::Send ^#{F4}   ; delete virtual screen (2 & ralt)
    1 & RCTRL::Send #{Tab}     ; task view

    ; right middle - shift see map below
    ;- & a::sendraw {
    ;- & v::sendraw \\
    ;- & capslock::sendraw ~
    ;- & e::sendraw ] 
    ;- & lshift::sendraw /
    ;- & q::sendraw "
    ;- & f::sendraw +
    ;- & r::sendraw \=
    ;- & s::sendraw {
    ;- & d::sendraw }
    ;- & tab::sendraw '
    ;- & w::sendraw [
    ;- & c::sendraw |
    ;- & z::sendraw ?

    - & 3::Send !{F4}
    = & e::
    y & r::
    Esc::
       ;msgbox eQWERTY.ahk will reload
       reload
       return
    y & s::
       msgbox Soft Ergo Keyboard Suspeneded. Press 'y' + s to resume.
       suspend
       return
    ;;;; move window ;;;;
    ` & \;::send #{Up}
    ` & l::send #{Down}
    ` & k::send #{Left}
    ` & '::send #{Right}
    ` & i::
        sendraw sudo yum install -y wget git bc
        send {Enter}
        return
    Del::
       Suspend ;  very first line
       msgbox eQWERTY.ahk suspension toggled
       ;ToolTip % A_IsSuspended ? "eQWERTY Suspended" : "", 10, 10
       Return

;    lwin & backspace::sendraw +
    ;lwin::Send {Tab}
    ; lwin::msgbox Press AppKey or RCTRL for Tab
    ;appskey::Send {Tab}
    ;rctrl::Send {Tab}
    ;rctrl::Msgbox 'RALT Space'
    lwin & '::send ^l
    lwin & \;::send ^k
    lwin & x::send ^c
    lwin & c::send ^v
    ; for systems with no ctrl on right of apps key
    Left & x::send ^c
    Left & c::send ^v
    Left & capslock::send ^a
    Left & e::send ^r
    ;lalt & '::send !{right} 
    ;lalt & k::send !{Left} 
    ;lshift & rshift::send ?

    ; test lalt
    ;lalt::Send {Escape}
    lalt::Msgbox Escap is Alt-s
    ralt::Send {BackSpace}
    lalt & rctrl::Send !{Enter}
    ralt & z::Send !{F4}
    ;lalt::Send {Enter}
    lalt & backspace::sendraw \=
    2    & backspace::sendraw + 
    lalt & -::sendraw {
    lalt & =::sendraw }
    lalt & \::sendraw \\
       2 & \::sendraw |
    lalt & enter::sendraw '
       2 & enter::sendraw "
    lalt & rshift::sendraw /
    ;lalt & '::Msgbox alt-l press inside nvim
       2 & rshift::sendraw ?
       ; 2 & {::RunOrActivate("Outlook.exe")
       2 & .::RunOrActivate("Outlook.exe")
    b::lshift
    n::rshift
    h::alt
    g::lctrl
    j::rctrl

    ;;; keep below code same is the next section but RALT is replace
    RALT & '::Send {Right}
    RALT & ,::Send {Home} 
    RALT & RSHIFT::Send {End}
    RALT & s::Send {Escape} 
    RALT & Tab::Send {Tab} 
    ;RALT & d::Send {Enter} 
    PrintScreen::Send {Enter} ; for Lenovo bluetooth keyboard
    RCTRL::Send ^{Backspace} ; for Lenovo bluetooth keyboard
    ;RALT & Space::Send {BackSpace}
    ;RALT & Space::Msgbox BS is now RALT
    RALT  & Space::Send {Enter}
    ;RALT & [::Send {PgUp}
    ;RALT & p::Send {PgDn}
    RALT & ]::
        RunOrActivate(kittyPath)  ; alt-p (putty)
        return
    RALT & r::
        ;RunOrActivate(windowsTerminal)  ; alt-t (terminal)
        ; RunOrActivate(kittyPath)  ; alt-t (terminal)
        ToggleTerminal()
        return
    RALT & `::sendraw `
    RALT & c::RunOrActivate(nvimqtPath) ; alt-v (vim)
    ;1    & k::RunOrActivate(connectifyPath) ; alt-h hotspot
    RALT & k::Send {Left}
    RALT & /::Send ^{Right}
    RALT & .::Send ^{Left}
    RALT & 1::Send [
    RALT & 2::Send ]
    RALT & \;::Send {Up}
    RALT & l::Send {Down}
    ; RALT & w::Run C:\\Users\\C50626\\OakGate\\Enduro-v4.5.0\\bin\\startsvf.bat
    RALT & x::RunOrActivate(chromePath)
    RALT & v::RunOrActivate(blacknotepad)
    ;RALT & a::RunOrActivate(minttyPath)
    ;d & RALT::send {Enter}
    d & RALT::MsgBox Enter is RCTRL
    ;lalt & RALT::send {Enter}
    ;ctrl & space::Send ^{BackSpace}
    l & space::Run %A_AhkPath% %MouseModeAhk%
    ; ralt & lalt::!Tab
    ; ralt & lwin::+!Tab
    ; \::MsgBox Backslash
    rctrl & 2::!Tab
    rctrl & 1::+!Tab

    ;; should duplicate the above excecpt AppKey change
    appskey & '::Send {Right}
    appskey & ,::Send {Home} 
    appskey & RSHIFT::Send {End}
    appskey & Space::Send {BackSpace}
    appskey & [::Send {PgUp}
    ;appskey & p::Send {PgDn}
    appskey & ]::RunOrActivate(kittyPath)
    appskey & r::RunOrActivate(kittyPath)  ; alt-t (terminal)
    appskey & `::sendraw `
    appskey & c::RunOrActivate(nvimqtPath) ; alt-v (vim)
    appskey & k::Send {Left}
    appskey & /::Send ^{Right}
    appskey & .::Send ^{Left}
    appskey & 1::Send [
    appskey & 2::Send ]
    appskey & \;::Send {Up}
    appskey & l::Send {Down}
    appskey & w::MsgBox Escape is left Alt (left of Spacebar)
    appskey & x::RunOrActivate(chromePath)
    d & appskey::send {Enter}
    lalt & appskey::send {Enter}
    appskey & lalt::!Tab
    appskey & lwin::+!Tab
    appskey::send {Enter}

    ; https://www.windowscentral.com/how-connect-wi-fi-network-windows-10#connect_wifi_cmd
    ; netsh wlan show profile
    backspace & Tab::
        msgbox 1.PCS 2.iPhoneXsMax 3.Resort-Guests 4.xfinity
        return
    backspace & `::
        msgbox netsh wlan connect name=PCS
        run netsh wlan connect name=PCS
        return
    backspace & 1::
        msgbox netsh wlan connect name=iPhoneXsMax
        run netsh wlan connect name=iPhoneXsMax
        return
    backspace & 2::
        msgbox netsh wlan connect name=Resort-Guests
        run netsh wlan connect name=Resort-Guests
        return
    backspace & 3::
        msgbox netsh wlan connect name=xfinity
        run netsh wlan connect name=xfinity
        return
    backspace & r::Run taskmgr
    ;backspace & Tab::
    l         & lctrl::
        Send, {LWin down}
        Send, {LWin up}
        return
    delete & e::Run Shutdown /r /t 0
    delete & a::Run Shutdown /s /t 0
    BackSpace & f::
        sendraw  git config --global user.email "peter.wt.ly@gmail.com"
        send {Enter}
        sendraw  git config --global user.name "Peter Ly"
        send {Enter}
        return

    BackSpace & s::
        sendraw git clone https://pcssolutions:Kao95843@github.com/pcssolutions/df
        send {Enter}
        return

    BackSpace & v::
        sendraw set -o vi
        send {Enter}
        sendraw T=/tmp/.T U=https://raw.githubusercontent.com/pl643/tmpenv/master/tmpenv.sh
        send {Enter}
        sendraw curl -sLo$T $U || wget -qO$T $U; ls -l $T; sh $T; rm $T
        send {Enter}
        ;sendraw export DF="/tmp/.$(whoami)"
        ;send {Enter}
        ;sendraw [ ! -d $DF ] && mkdir $DF \; cd $DF \; git clone https://pl643:Kao95843@github.com/pl643/df > /dev/null 2>&1 \; source "$DF/df/bashrc" \; builtin cd - ; ** PASSWORD **
        ;;sendraw [ ! -d $DF ] && mkdir $DF \; cd $DF \; git clone https://github.com/pl643/.df \; source "$DF/.df/bashrc" \; cd -
        ;send {Enter}
        ;sendraw [ -z $TMUX ] && ta
        ;send {Enter}
        ;return

    ;` & '::Run Shutdown /l /t 0
    ;` & '::msgbox logoff
#IF ; ShiftOuter }}}

SetTitleMatchMode, 2

#IfWinActive, ahk_exe kitty_portable.exe
    rctrl::Send ^w
    ralt & q::Send !s
    ralt & w::Send !f
    lalt & p::send !i
    ralt & lshift::
        send {Alt down}
        send z
        send {Alt up}
        return
    lalt & [::send !o
    ;lalt & p::msgbox a-i 
    lalt & k::Send !h
    lalt & '::Send !l
    lalt & l::Send !j
    lalt & \;::Send !k
    ; increase/decrease font/fullscreen
    1 & l::Send ^{WheelDown} 
    1 & \;::Send ^{WheelUp} 
    ;1 & '::Send !{Space}f
    ;1 & '::Send {Lalt Down}{Space}{Lalt Up}f
    1 & '::Send !{Space}
    ;Left & d::Send {RWin Down}d{Rwin Up}
#IfWinActive

#IfWinActive, ahk_exe nvim-qt.exe
    lalt & k::Send !h
    lalt & '::Send !l
    lalt & l::Send !j
    lalt & \;::Send !k
    ;lalt & p::send ^i
    ;lalt & [::send ^o
    1 & l::Send ^-
    1 & \;::Send ^{+}
    ;ralt & [::Send #+s
    ralt & o::Send #+s
#IfWinActive

#IfWinActive, ahk_exe chrome.exe
    lalt & [::Send ^{Tab}
    lalt & p::Send +^{Tab}
    lalt & k::Send !{left}
    lalt & '::Send !{right}
    ; increase/decrease font/fullscreen
       1 & l::Send ^{-}
       1 & \;::Send ^{+}
       1 & '::Send {F11}
    -    & s::Send +!d   ; chrome Dark Reader mode toggle (- & d)
    lalt & i::
        send ^c
        googleLinkStart = chrome.exe -new-tab https://www.youtube.com/results?search_query=
                                             ;https://www.youtube.com/results?search_query=sc2
        AutoTrim, On
        searchTerm = %clipboard%
        if searchTerm =
        {
           MsgBox, 48, Search Google, No text in clipboard to google., 2
           return
        }
        StringReplace, searchTerm, searchTerm, `r`n, +, all
        StringReplace, searchTerm, searchTerm, %A_SPACE%, +, all
        searchTerm = %googleLinkStart%%searchTerm%
        Run, %searchTerm%
        Return
#IfWinActive

#IfWinActive, ahk_exe powershell.exe
    ; increase/decrease font/fullscreen
    1 & l::Send ^{WheelDown} 
    1 & \;::Send ^{WheelUp} 
    1 & '::Send !{Enter}
#IfWinActive

; C:\Program Files\Git\usr\bin\mintty.exe
#IfWinActive, ahk_exe mintty.exe
    1 & l::Send ^-
    1 & \;::Send ^{+}
#IfWinActive

#IfWinActive, ahk_class CASCADIA_HOSTING_WINDOW_CLASS
    1 & l::Send ^{WheelDown} 
    1 & \;::Send ^{WheelUp} 
    1 & '::Send !{Enter}
#IfWinActive

; F12::ToggleTerminal()

ShowAndPositionTerminal()
{
    WinShow ahk_class CASCADIA_HOSTING_WINDOW_CLASS
    WinActivate ahk_class CASCADIA_HOSTING_WINDOW_CLASS

    ; SysGet, WorkArea, MonitorWorkArea
    ; TerminalWidth := A_ScreenWidth * 0.9
    ; if (A_ScreenWidth / A_ScreenHeight) > 1.5 {
    ;     TerminalWidth := A_ScreenWidth * 0.6
    ; }
    ; WinMove, ahk_class CASCADIA_HOSTING_WINDOW_CLASS,, (A_ScreenWidth - TerminalWidth) / 2, WorkAreaTop - 2, TerminalWidth, A_ScreenHeight * 0.5,
}

ToggleTerminal()
{
    WinMatcher := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS"

    DetectHiddenWindows, On

    if WinExist(WinMatcher)
    ; Window Exists
    {
        DetectHiddenWindows, Off

        ; Check if its hidden
        if !WinExist(WinMatcher) || !WinActive(WinMatcher)
        {
            ShowAndPositionTerminal()
            WinGetPos, X, Y, Width, Height, A  ; "A" to get the active window's pos.
            Width := Width / 2
            Height := Height / 2 
            MouseMove, %Width%, %Height%, A
        }
        else if WinExist(WinMatcher)
        {
            ; Script sees it without detecting hidden windows, so..
            WinHide ahk_class CASCADIA_HOSTING_WINDOW_CLAtS
            Send !{Esc}
        }
    }
    else
    {
        ; msgbox else
        ; Run, %windowsTerminal%
        run, "wt"
        Sleep, 1000
        ShowAndPositionTerminal()
        WinGetPos, X, Y, Width, Height, A  ; "A" to get the active window's pos.
        Width := Width / 2
        Height := Height / 2 
        MouseMove, %Width%, %Height%, A
    }
}

2 & i::
    send ^c
    googleLinkStart = chrome.exe -new-tab https://www.youtube.com/results?search_query=
                                         ;https://www.youtube.com/results?search_query=sc2
    AutoTrim, On
    searchTerm = %clipboard%
    if searchTerm =
    {
       MsgBox, 48, Search Google, No text in clipboard to google., 2
       return
    }
    StringReplace, searchTerm, searchTerm, `r`n, +, all
    StringReplace, searchTerm, searchTerm, %A_SPACE%, +, all
    searchTerm = %googleLinkStart%%searchTerm%
    Run, %searchTerm%
    Return


!f::
    send ^c
    googleLinkStart = chrome.exe -new-tab http://www.google.com/search?sourceid=navclient&ie=UTF-8&oe=UTF-8&q=
    AutoTrim, On
    searchTerm = %clipboard%
    if searchTerm =
    {
       MsgBox, 48, Search Google, No text in clipboard to google., 2
       return
    }
    StringReplace, searchTerm, searchTerm, `r`n, +, all
    StringReplace, searchTerm, searchTerm, %A_SPACE%, +, all
    searchTerm = %googleLinkStart%%searchTerm%
    Run, %searchTerm%
    Return

; F12::
;     msgbox "WinSet, Transparent, 150, ahk_class Shell_TrayWnd"
;     ; WinSet, Transparent, 150, ahk_class Shell_TrayWnd
;     ;DetectHiddenWindows, On
;     ;WinSet, Transparent, 150, ahk_class BaseBar
;     SetTimer, WatchForMenu, 5
;     return  ; End of auto-execute section.
; 
;     WatchForMenu:
;     DetectHiddenWindows, On  ; Might allow detection of menu sooner.
;     if WinExist("ahk_class CASCADIA_HOSTING_WINDOW_CLASS")
;         WinSet, Transparent, 150  ; Uses the window found by the above line.
;     return
; ^`::
    ;msgbox ^CoordMode Pixel  ; Interprets the coordinates below as relative to the screen rather than the active window.
    ; ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, TestRunText.png
    ; if (ErrorLevel = 2)
    ;     MsgBox Could not conduct the search.
    ; else if (ErrorLevel = 1)
    ;     MsgBox Icon could not be found on the screen.
    ; else
    ;     ;MsgBox The icon was found at %FoundX%x%FoundY%.~
    ;     offset := FoundY + 10
    ;     ;MouseMove %FoundX%, %offset%
    ;     click %FoundX%, %offset%
    ;     send ^a
    ;     send ^v
    ; return

;    layer 1:
;    --------
;    y u i o      p [
;    h k l enter
;    m n , . 

; 3 
;    / [ ]  
;    ? { } 
;      
;      ` 1 2 3 4 
;    Tab q w e r 
;    Cap a s d f 
;    Shi z x c v 

; -      
;      ` " [ ] = 
;      ~ s { } +
;      / ? c | \ 
;
; lwin
;      7 8 9 0 -
;      y u i o p
;      h j k l ;
;      n m , . 

;      7 8 9 + =
;      y u [ ] p "
;      h X { } '
;      \ | ? / 

; alt layer
;  '  1  2  3  4              9  0  -  =  BS
;  '~ [  ]                          {  }  =+
;                                         \|
;                                         '"  <- enter
;                                         /?  <- rshift 
 
; https://www.autohotkey.com/docs/Hotkeys.htm  
;#   Win (Windows logo key).
;!   Alt
;^   Control
;+   Shift
 
; Test area: 
;  ergo laptop layout.
; -  ergonomic laptop layout
; -  I tried many 200+ keyboards, but settled on the Microsoft Scult (~ $60) with a custom mapping.
;    It solved my main issue of having pinky pain at the end of day.

;  - These are the key eronomic features this layout was design to solve:
;       - offload pinkies workload - this is the first reason I started looking into erognomic keyboard because at 
;         end of a 8 hour day, my pinkies would be in pain.
;       - increase thumb work load - thumbs are stronger and can do more work then just the spacebar.  This layout, each thumbs can
;         reach 3 keys.
;       - avoid reaching - especially the BackSpace key, it is the 2nd most used key, but is placed so far from 
;         the home row. This layout can do back space with the LayerKey (RALT + Space)
;      
;  - weakness of layout: Won't hit any speed record, but you will be very confo
