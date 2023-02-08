Attribute VB_Name = "dynamic_screens"
Global SapGuiAuto As Object
Global Connection As Object
Global session As Object

Sub ME21N_Create_PO()

    Set SapGuiAuto = GetObject("SAPGUI")  'Get the SAP GUI Scripting object
    Set SAPApp = SapGuiAuto.GetScriptingEngine 'Get the currently running SAP GUI
    Set SAPCon = SAPApp.Children(0) 'Get the first system that is currently connected
    Set session = SAPCon.Children(0) 'Get the first session (window) on that connection
    
    
    Dim i, LastRow, j As Long  'i to loop rows / LastRow to get last used row on the file
    Dim Vendor, PurchOrder, PoRequester, Material, MatText, GLacc, ProfitCntr, CostCntr, OrderNmbr, WBSelmnt, PoValue, Plant, StorLoc As String
    Dim Screen_no As String
    Dim ScrollDown As Double
    
    ScrollDown = 2
    
    Screen_no = "0020"  ' when header, item, item detail unfolded, 0200, when header folded, item and detail unfolded, 0019, header foled, item unfoled, detail folded, screen 0016
    
    LastRow = Shdata.Range("A" & Rows.Count).End(xlUp).Row
    
    session.findById("wnd[0]").maximize
    
    For i = 3 To 14
        
        Vendor = Shdata.Range("A" & i).Value
        PurchOrder = Shdata.Range("C" & i).Value
        LastPurchOrder = Shdata.Range("C" & i - 1).Value
        NextPurchOrder = Shdata.Range("C" & i + 1).Value
        PoRequester = Shdata.Range("F" & i).Value
        Material = Shdata.Range("G" & i).Value
        MatText = Shdata.Range("H" & i).Value
        GLacc = Shdata.Range("I" & i).Value
        ProfitCntr = Shdata.Range("J" & i).Value
        CostCntr = Shdata.Range("K" & i).Value
        OrderNmbr = Shdata.Range("L" & i).Value
        WBSelmnt = Shdata.Range("M" & i).Value
        PoValue = Shdata.Range("Q" & i).Value
        Plant = Shdata.Range("W" & i).Value
        StorLoc = Shdata.Range("X" & i).Value
        GetPoNum = Shdata.Range("Z" & i).Value
        
        If LastPurchOrder <> PurchOrder Then
            session.findById("wnd[0]/tbar[0]/okcd").Text = "/nme21n"
            session.findById("wnd[0]").sendVKey 0
        Else
            GoTo ItemLvl
        End If
        
        On Error Resume Next   'if header section is initially folded, press the expand button to set the correct layout
            session.findById ("wnd[0]/usr/subSUB0:SAPLMEGUI:0016/subSUB1:SAPLMEVIEWS:1100/subSUB1:SAPLMEVIEWS:4000/btnDYN_4000-BUTTON")
        If Err.Number = 0 Then
            session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:0016/subSUB1:SAPLMEVIEWS:1100/subSUB1:SAPLMEVIEWS:4000/btnDYN_4000-BUTTON").press
        End If
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB0:SAPLMEGUI:0030/subSUB1:SAPLMEGUI:1105/cmbMEPO_TOPLINE-BSART").Key = "FO"   'order type
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB0:SAPLMEGUI:0030/subSUB1:SAPLMEGUI:1105/ctxtMEPO_TOPLINE-SUPERFIELD").Text = Vendor   'vendor number
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT9/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1221/ctxtMEPO1222-EKORG").Text = "1004"    'purchase organisation
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT9/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1221/ctxtMEPO1222-EKGRP").Text = "WRS"     'purchasing group
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT9/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1221/ctxtMEPO1222-BUKRS").Text = "9000"    'company code
        
        session.findById("wnd[0]").sendVKey 0   'enter
        session.findById("wnd[0]").sendVKey 0   'enter
        
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT7/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1229/ctxtMEPO1229-KDATB").Text = "01.01.2023"  'validity start date
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT7/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1229/ctxtMEPO1229-KDATE").Text = "31.12.2023"  'validity end date
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT11").Select    'go to custom fields
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT11/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1227/ssubCUSTOMER_DATA_HEADER:SAPLXM06:0101/ctxtEKKO_CI-ZZSIGNER1").Text = PoRequester
        
        session.findById("wnd[0]").sendVKey 0   'enter
        
ItemLvl:
        If LastPurchOrder <> PurchOrder Then    'ME21N table iteration
            j = 0
        Else
            j = 1
        End If
        
        Screen_no = detect_screen_no(Screen_no, "wnd[0]/usr/subSUB0:SAPLMEGUI:", "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-KNTTP[2," & j & "]")   'get new table number
        
        If CostCntr <> "#" Then 'account assigment for cost center
            If CostCntr <> "" Then
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-KNTTP[2," & j & "]").Text = "V"
            End If
        End If
        If OrderNmbr <> "#" Then 'account assignment for order number
            If OrderNmbr <> "" Then
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-KNTTP[2," & j & "]").Text = "Y"
            End If
        End If
        If WBSelmnt <> "#" Then 'account assignment for WBS element
            If WBSelmnt <> "" Then
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-KNTTP[2," & j & "]").Text = "Z"
            End If
        End If
        
        If Material <> "#" Then 'if material field is empty in excel leave empty in ME21N table and fill in manually material group
            If Material <> "" Then
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-EMATN[4," & j & "]").Text = Material
            Else
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-EMATN[4," & j & "]").Text = ""
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-WGBEZ[14,0]").Text = "0N01"
            End If
        Else
            session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-EMATN[4," & j & "]").Text = ""
            session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-WGBEZ[14,0]").Text = "0N01"
        End If
        
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/txtMEPO1211-TXZ01[5," & j & "]").Text = MatText   'input material text
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/txtMEPO1211-MENGE[6," & j & "]").Text = "1"   'input PO quantity always 1
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-MEINS[7," & j & "]").Text = "pc" 'input order unit always pc
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-EEIND[9," & j & "]").Text = "31.12.2023" 'input delivery date always 31.12.2023
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/txtMEPO1211-NETPR[10," & j & "]").Text = PoValue 'net price
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-NAME1[15," & j & "]").Text = Plant    'input plant
        
        If StorLoc <> "" Then 'input storage location if field not empty in excel
            session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-LGOBE[16," & j & "]").Text = StorLoc 'input storage location
        End If
        
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/txtMEPO1211-AFNAM[19," & j & "]").Text = PoRequester  'input PO requesitioner
        
        session.findById("wnd[0]").sendVKey 0 'press enter
        
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/txtMEPO1211-NETPR[10," & j & "]").Text = PoValue 'correction of price after automatic change
        
        session.findById("wnd[0]").sendVKey 0 'press enter
        
        Screen_no = detect_screen_no(Screen_no, "wnd[0]/usr/subSUB0:SAPLMEGUI:", "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-KNTTP[2," & j & "]")   'get new table number
        
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT13").Select  'select account assigment tab
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT13/ssubTABSTRIPCONTROL1SUB:SAPLMEVIEWS:1101/subSUB2:SAPLMEACCTVI:0100/subSUB1:SAPLMEACCTVI:1100/ctxtMEACCT1100-SAKTO").Text = GLacc 'input g/l account
        
        Screen_no = detect_screen_no(Screen_no, "wnd[0]/usr/subSUB0:SAPLMEGUI:", "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-KNTTP[2," & j & "]")   'get new table number
        
        If j <> 0 Then  'if PO item >1 then we scroll down (scroll down button has increment of +1) - this is to prevent we dont run out of space in ME21N table
            session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211").verticalScrollbar.Position = ScrollDown
            ScrollDown = ScrollDown + 1
        End If
        
        If CostCntr <> "#" Then 'input cost center if available
            If CostCntr <> "" Then
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT13/ssubTABSTRIPCONTROL1SUB:SAPLMEVIEWS:1101/subSUB2:SAPLMEACCTVI:0100/subSUB1:SAPLMEACCTVI:1100/subKONTBLOCK:SAPLKACB:1101/ctxtCOBL-KOSTL").Text = CostCntr
            End If
        End If
        
        If OrderNmbr <> "#" Then 'input order number if available
            If OrderNmbr <> "" Then
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT13/ssubTABSTRIPCONTROL1SUB:SAPLMEVIEWS:1101/subSUB2:SAPLMEACCTVI:0100/subSUB1:SAPLMEACCTVI:1100/subKONTBLOCK:SAPLKACB:1101/ctxtCOBL-AUFNR").Text = OrderNmbr
            End If
        End If
        
        If WBSelmnt <> "#" Then 'input WBS element if available
            If WBSelmnt <> "" Then
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT13/ssubTABSTRIPCONTROL1SUB:SAPLMEVIEWS:1101/subSUB2:SAPLMEACCTVI:0100/subSUB1:SAPLMEACCTVI:1100/subKONTBLOCK:SAPLKACB:1101/ctxtCOBL-PS_POSID").Text = WBSelmnt
            End If
        End If
        
        session.findById("wnd[0]").sendVKey 0   'press enter
        
        Screen_no = detect_screen_no(Screen_no, "wnd[0]/usr/subSUB0:SAPLMEGUI:", "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-KNTTP[2," & j & "]")   'get new table number
        
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT7").Select   'select invoice tab
        
        If GLacc <> "3140021" Then  'input specific tax code according to g/l account
            If GLacc <> "4300020" Then
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT7/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1317/ctxtMEPO1317-MWSKZ").Text = "K1"
            Else
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT7/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1317/ctxtMEPO1317-MWSKZ").Text = "K8"
            End If
        Else
            session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT7/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1317/ctxtMEPO1317-MWSKZ").Text = "K8"
        End If
        
        If InStr(MatText, "K0") > 0 Then    'input tax code K0 if explicit in material description
            session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT7/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1317/ctxtMEPO1317-MWSKZ").Text = "K0"
        End If
        
        session.findById("wnd[0]").sendVKey 0   'press enter
        
        Screen_no = detect_screen_no(Screen_no, "wnd[0]/usr/subSUB0:SAPLMEGUI:", "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-KNTTP[2," & j & "]")   'get new table number
        
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT20").Select  'select tab condition control
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT20/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1325/chkMEPO1325-PRSDR").Selected = False    'to untick print price
        'sometimes when i untick price print tax code changes, need to change tax code again
        Screen_no = detect_screen_no(Screen_no, "wnd[0]/usr/subSUB0:SAPLMEGUI:", "/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-KNTTP[2," & j & "]")   'get new table number
        session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT7").Select
        
        If GLacc <> "3140021" Then  'input specific tax code according to g/l account
            If GLacc <> "4300020" Then
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT7/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1317/ctxtMEPO1317-MWSKZ").Text = "K1"
            Else
                session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT7/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1317/ctxtMEPO1317-MWSKZ").Text = "K8"
            End If
        Else
            session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT7/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1317/ctxtMEPO1317-MWSKZ").Text = "K8"
        End If
        
        If InStr(MatText, "K0") > 0 Then    'input tax code K0 if explicit in material description
            session.findById("wnd[0]/usr/subSUB0:SAPLMEGUI:" & Screen_no & "/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT7/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1317/ctxtMEPO1317-MWSKZ").Text = "K0"
        End If
        
        session.findById("wnd[0]").sendVKey 0   'press enter
        
        If PurchOrder <> NextPurchOrder Then    'if next iteration is a new PO then we release output message
            session.findById("wnd[0]/tbar[1]/btn[21]").press    'press button messages
            session.findById("wnd[0]/usr/tblSAPDV70ATC_NAST3").getAbsoluteRow(0).Selected = True    'select first line
            session.findById("wnd[0]/tbar[1]/btn[5]").press 'press first line
            session.findById("wnd[0]/usr/cmbNAST-VSZTP").Key = "4"  'choose 4 send immediately
            session.findById("wnd[0]/tbar[0]/btn[3]").press 'go back
            session.findById("wnd[0]/tbar[0]/btn[3]").press 'go back
            'session.findById("wnd[0]/tbar[0]/btn[11]").press ' save PO - Uncomment this once in production
            'GetPoNum = session.findById("wnd[0]/sbar").Text    'write PO number back to excel - Uncomment this once in production
        End If
        
    Next i

End Sub

Function detect_screen_no(Screen_no As String, str1 As String, str2 As String) As String
    On Error Resume Next
        session.findById (str1 & Screen_no & str2)
    If Err.Number = 0 Then
        detect_screen_no = Screen_no
    End If
    For i = 20 To 10 Step -1
        On Error Resume Next
           session.findById (str1 & "00" & CStr(i) & str2)
        If Err.Number = 0 Then
            detect_screen_no = "00" & CStr(i)
            Exit For
        End If
    Next i
    'detect_screen_no = ""
End Function
