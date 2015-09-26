; --------------------------------------------------------------------
; 發票對獎
; --------------------------------------------------------------------
_Main:
    Bingo := False

    ; 檢查 INI 檔案
    IniFile := "Invoice.ini"
    IfNotExist, %A_ScriptDir%\%IniFile%
    {
        MsgBox, 0x10, 發票對獎, %IniFile% 不存在
        ExitApp
    }

    ; 讀入中獎號碼
    IniRead, Especial, %IniFile%, Especial
    IniRead, Special, %IniFile%, Special
    IniRead, First, %IniFile%, First
    IniRead, Sixth, %IniFile%, Sixth
    StringSplit, Especial, Especial, `n
    StringSplit, Special, Special, `n
    StringSplit, First, First, `n
    StringSplit, Sixth, Sixth, `n

    ; 建立 GUI
    Gui, Invoice: Default

    ; 特別獎號碼
    Gui, Font, s12 norm cBlack, 新細明體
    Gui, Add, Text, xm, 特別獎
    Loop, %Especial0%
    {
        String := Especial%A_Index%
        Gui, Font, s24 bold cBlack, Arial
        Gui, Add, Text, xm, %String%
        Gui, Font, s12 norm cBlue, 新細明體
        Gui, Add, Text, x+10 yp+10 w200 vEspecial%A_Index%
    }

    ; 特獎號碼
    Gui, Font, s12 norm cBlack, 新細明體
    Gui, Add, Text, xm, 特獎
    Loop, %Special0%
    {
        String := Special%A_Index%
        Gui, Font, s24 bold cBlack, Arial
        Gui, Add, Text, xm, %String%
        Gui, Font, s12 norm cBlue, 新細明體
        Gui, Add, Text, x+10 yp+10 w200 vSpecial%A_Index%
    }

    ; 頭獎號碼
    Gui, Font, s12 norm cBlack, 新細明體
    Gui, Add, Text, xm, 頭獎
    Loop, %First0%
    {
        String := First%A_Index%
        Gui, Font, s24 bold cBlack, Arial
        Gui, Add, Text, xm, % SubStr(String, 1, 5)
        Gui, Font, s24 bold cRed, Arial
        Gui, Add, Text, x+, % SubStr(String, -2)
        Gui, Font, s12 norm cBlue, 新細明體
        Gui, Add, Text, x+10 yp+10 w200 vFirst%A_Index%
    }

    ; 增開陸獎號碼
    Gui, Font, s12 norm cBlack, 新細明體
    Gui, Add, Text, xm, 增開陸獎
    Loop, %Sixth0%
    {
        String := Sixth%A_Index%
        Gui, Font, s24 bold cRed, Arial
        Gui, Add, Text, xm, %String%
        Gui, Font, s12 norm cBlue, 新細明體
        Gui, Add, Text, x+10 yp+10 w200 vSixth%A_Index%
    }

    ; 使用者輸入欄
    Gui, Font, s12 norm cBlack, 新細明體
    Gui, Add, Text, xm, 輸入發票號碼末三碼
    Gui, Add, Edit, x+10 yp-3 w50 Limit3 Number vEdit1 gVerify

    ; 已輸入的號碼
    Gui, Font, s24 bold cBlue, Arial
    Gui, Add, Text, xm vInput, XXX

    ; 顯示 GUI
    Gui, Show,, 發票對獎

    Return

Verify:
    GuiControlGet, Edit1

    ; 重設對獎結果
    If (Bingo)
    {
        Loop, %Especial0%
        {
            GuiControl, Text, Especial%A_Index%
        }
        Loop, %Special0%
        {
            GuiControl, Text, Special%A_Index%
        }
        Loop, %First0%
        {
            GuiControl, Text, First%A_Index%
        }
        Loop, %Sixth0%
        {
            GuiControl, Text, Sixth%A_Index%
        }
        Bingo := False
    }

    ; 檢查是否中獎
    If (StrLen(Edit1) = 3)
    {
        ; 核對特別獎
        Loop, %Especial0%
        {
            If (Edit1 = SubStr(Especial%A_Index%, -2))
            {
                Bingo := True
                GuiControl, Text, Especial%A_Index%, ★ 請核對前 5 碼
            }
        }

        ; 核對特獎
        Loop, %Special0%
        {
            If (Edit1 = SubStr(Special%A_Index%, -2))
            {
                Bingo := True
                GuiControl, Text, Special%A_Index%, ★ 請核對前 5 碼
            }
        }

        ; 核對頭獎
        Loop, %First0%
        {
            If (Edit1 = SubStr(First%A_Index%, -2))
            {
                Bingo := True
                GuiControl, Text, First%A_Index%, ★ 恭喜中獎，並核對前 5 碼
            }
        }

        ; 核對增開陸獎
        Loop, %Sixth0%
        {
            If (Edit1 = Sixth%A_Index%)
            {
                Bingo := True
                GuiControl, Text, Sixth%A_Index%, ★ 恭喜中獎
            }
        }

        ; 清除輸入欄
        GuiControl, Text, Edit1

        ; 顯示已輸入的號碼
        GuiControl, Text, Input, %Edit1%

        ; 播放提示音效
        If (Bingo)
        {
            SoundPlay, %A_ScriptDir%\Win.wav
        }
        Else
        {
            SoundPlay, %A_ScriptDir%\Lose.wav
        }
    }

    Return

InvoiceGuiClose:
    ExitApp
