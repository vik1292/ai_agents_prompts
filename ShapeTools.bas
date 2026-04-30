Attribute VB_Name = "ShapeTools"
' ═══════════════════════════════════════════════════════════════════
'  SHAPE TOOLS — PowerPoint VBA Add-in
'  Features:
'    1. Copy Size    — capture W/H from one shape, apply to another
'    2. Copy Position — capture X/Y from one shape, apply to another
'    3. Swap Positions — exchange the position of two shapes
'
'  HOW TO INSTALL:
'    1. Open PowerPoint
'    2. Press Alt+F11 to open the VBA Editor
'    3. In the left panel, right-click your presentation name
'       → Insert → Module
'    4. Paste this entire file into the module
'    5. Close the VBA Editor (Alt+F4 or just X it)
'    6. Use Alt+F8 to run any macro, OR add buttons to your ribbon
'       (see instructions at bottom of this file)
' ═══════════════════════════════════════════════════════════════════

Option Explicit

' ── Stored values (persist for the session) ──────────────────────
Private g_CapturedWidth    As Single
Private g_CapturedHeight   As Single
Private g_CapturedLeft     As Single
Private g_CapturedTop      As Single
Private g_SizeCaptured     As Boolean
Private g_PosCaptured      As Boolean

' Swap storage — holds shape references by slide index + shape name
Private g_SwapASlide       As Integer
Private g_SwapAName        As String
Private g_SwapALeft        As Single
Private g_SwapATop         As Single
Private g_SwapACaptured    As Boolean

Private g_SwapBSlide       As Integer
Private g_SwapBName        As String
Private g_SwapBLeft        As Single
Private g_SwapBTop         As Single
Private g_SwapBCaptured    As Boolean


' ═══════════════════════════════════════════════════════════════════
'  HELPERS
' ═══════════════════════════════════════════════════════════════════

' Returns the single selected shape, or Nothing if 0 or 2+ are selected
Private Function GetSelectedShape() As Shape
    Dim oSlide As Slide
    Dim oSel   As Selection

    Set oSel = ActiveWindow.Selection

    If oSel.Type <> ppSelectionShapes Then
        MsgBox "Please click on exactly one shape first.", _
               vbExclamation, "Shape Tools"
        Set GetSelectedShape = Nothing
        Exit Function
    End If

    If oSel.ShapeRange.Count <> 1 Then
        MsgBox "Please select exactly one shape (you have " & _
               oSel.ShapeRange.Count & " selected).", _
               vbExclamation, "Shape Tools"
        Set GetSelectedShape = Nothing
        Exit Function
    End If

    Set GetSelectedShape = oSel.ShapeRange(1)
End Function

' Returns the active slide index
Private Function ActiveSlideIndex() As Integer
    ActiveSlideIndex = ActiveWindow.View.Slide.SlideIndex
End Function

' Formats a point value nicely (1 decimal place)
Private Function Fmt(v As Single) As String
    Fmt = Format(v, "0.0") & " pt"
End Function


' ═══════════════════════════════════════════════════════════════════
'  FEATURE 1 — SIZE
' ═══════════════════════════════════════════════════════════════════

Public Sub CaptureSize()
    Dim oShape As Shape
    Set oShape = GetSelectedShape()
    If oShape Is Nothing Then Exit Sub

    g_CapturedWidth  = oShape.Width
    g_CapturedHeight = oShape.Height
    g_SizeCaptured   = True

    MsgBox "Size captured from: """ & oShape.Name & """" & vbNewLine & _
           "  Width:  " & Fmt(g_CapturedWidth) & vbNewLine & _
           "  Height: " & Fmt(g_CapturedHeight) & vbNewLine & vbNewLine & _
           "Now select your target shape and run Apply Size.", _
           vbInformation, "Shape Tools — Capture Size"
End Sub


Public Sub ApplySize()
    If Not g_SizeCaptured Then
        MsgBox "No size captured yet. Run Capture Size first.", _
               vbExclamation, "Shape Tools"
        Exit Sub
    End If

    Dim oShape As Shape
    Set oShape = GetSelectedShape()
    If oShape Is Nothing Then Exit Sub

    Dim oldW As Single, oldH As Single
    oldW = oShape.Width
    oldH = oShape.Height

    oShape.Width  = g_CapturedWidth
    oShape.Height = g_CapturedHeight

    MsgBox "Size applied to: """ & oShape.Name & """" & vbNewLine & _
           "  Before: " & Fmt(oldW) & " × " & Fmt(oldH) & vbNewLine & _
           "  After:  " & Fmt(g_CapturedWidth) & " × " & Fmt(g_CapturedHeight), _
           vbInformation, "Shape Tools — Apply Size"
End Sub


Public Sub ClearSize()
    g_SizeCaptured   = False
    g_CapturedWidth  = 0
    g_CapturedHeight = 0
    MsgBox "Captured size cleared.", vbInformation, "Shape Tools"
End Sub


' ═══════════════════════════════════════════════════════════════════
'  FEATURE 2 — POSITION
' ═══════════════════════════════════════════════════════════════════

Public Sub CapturePosition()
    Dim oShape As Shape
    Set oShape = GetSelectedShape()
    If oShape Is Nothing Then Exit Sub

    g_CapturedLeft = oShape.Left
    g_CapturedTop  = oShape.Top
    g_PosCaptured  = True

    MsgBox "Position captured from: """ & oShape.Name & """" & vbNewLine & _
           "  X (Left): " & Fmt(g_CapturedLeft) & vbNewLine & _
           "  Y (Top):  " & Fmt(g_CapturedTop) & vbNewLine & vbNewLine & _
           "Now select your target shape and run Apply Position.", _
           vbInformation, "Shape Tools — Capture Position"
End Sub


Public Sub ApplyPosition()
    If Not g_PosCaptured Then
        MsgBox "No position captured yet. Run Capture Position first.", _
               vbExclamation, "Shape Tools"
        Exit Sub
    End If

    Dim oShape As Shape
    Set oShape = GetSelectedShape()
    If oShape Is Nothing Then Exit Sub

    Dim oldL As Single, oldT As Single
    oldL = oShape.Left
    oldT = oShape.Top

    oShape.Left = g_CapturedLeft
    oShape.Top  = g_CapturedTop

    MsgBox "Position applied to: """ & oShape.Name & """" & vbNewLine & _
           "  Before: X=" & Fmt(oldL) & "  Y=" & Fmt(oldT) & vbNewLine & _
           "  After:  X=" & Fmt(g_CapturedLeft) & "  Y=" & Fmt(g_CapturedTop), _
           vbInformation, "Shape Tools — Apply Position"
End Sub


Public Sub ClearPosition()
    g_PosCaptured  = False
    g_CapturedLeft = 0
    g_CapturedTop  = 0
    MsgBox "Captured position cleared.", vbInformation, "Shape Tools"
End Sub


' ═══════════════════════════════════════════════════════════════════
'  FEATURE 3 — SWAP POSITIONS
' ═══════════════════════════════════════════════════════════════════

Public Sub CaptureSwapA()
    Dim oShape As Shape
    Set oShape = GetSelectedShape()
    If oShape Is Nothing Then Exit Sub

    g_SwapASlide    = ActiveSlideIndex()
    g_SwapAName     = oShape.Name
    g_SwapALeft     = oShape.Left
    g_SwapATop      = oShape.Top
    g_SwapACaptured = True

    Dim status As String
    status = ""
    If g_SwapBCaptured Then
        status = vbNewLine & "Shape B is already captured. Run Swap Positions when ready."
    Else
        status = vbNewLine & "Now select Shape B and run Capture Swap B."
    End If

    MsgBox "Shape A captured: """ & oShape.Name & """" & vbNewLine & _
           "  X=" & Fmt(g_SwapALeft) & "  Y=" & Fmt(g_SwapATop) & _
           status, vbInformation, "Shape Tools — Swap (Step 1)"
End Sub


Public Sub CaptureSwapB()
    Dim oShape As Shape
    Set oShape = GetSelectedShape()
    If oShape Is Nothing Then Exit Sub

    ' Guard: don't let A and B be the same shape on the same slide
    If g_SwapACaptured Then
        If oShape.Name = g_SwapAName And ActiveSlideIndex() = g_SwapASlide Then
            MsgBox "Shape B must be different from Shape A. Please select a different shape.", _
                   vbExclamation, "Shape Tools"
            Exit Sub
        End If
    End If

    g_SwapBSlide    = ActiveSlideIndex()
    g_SwapBName     = oShape.Name
    g_SwapBLeft     = oShape.Left
    g_SwapBTop      = oShape.Top
    g_SwapBCaptured = True

    Dim status As String
    If g_SwapACaptured Then
        status = vbNewLine & "Both shapes captured! Run Swap Positions."
    Else
        status = vbNewLine & "Now capture Shape A."
    End If

    MsgBox "Shape B captured: """ & oShape.Name & """" & vbNewLine & _
           "  X=" & Fmt(g_SwapBLeft) & "  Y=" & Fmt(g_SwapBTop) & _
           status, vbInformation, "Shape Tools — Swap (Step 2)"
End Sub


Public Sub SwapPositions()
    ' Validate both captured
    If Not g_SwapACaptured Or Not g_SwapBCaptured Then
        MsgBox "You must capture both Shape A and Shape B before swapping." & vbNewLine & _
               "  Shape A: " & IIf(g_SwapACaptured, "Ready ✓", "Not captured") & vbNewLine & _
               "  Shape B: " & IIf(g_SwapBCaptured, "Ready ✓", "Not captured"), _
               vbExclamation, "Shape Tools"
        Exit Sub
    End If

    ' Retrieve Shape A from its slide
    Dim oSlideA As Slide
    Dim oSlideB As Slide
    Dim oShapeA As Shape
    Dim oShapeB As Shape

    On Error GoTo ErrHandler

    Set oSlideA = ActivePresentation.Slides(g_SwapASlide)
    Set oSlideB = ActivePresentation.Slides(g_SwapBSlide)

    ' Find shapes by name
    Set oShapeA = oSlideA.Shapes(g_SwapAName)
    Set oShapeB = oSlideB.Shapes(g_SwapBName)

    ' Read current positions (in case shapes moved since capture)
    Dim aLeft As Single, aTop As Single
    Dim bLeft As Single, bTop As Single
    aLeft = oShapeA.Left : aTop = oShapeA.Top
    bLeft = oShapeB.Left : bTop = oShapeB.Top

    ' Write — swap
    oShapeA.Left = bLeft : oShapeA.Top = bTop
    oShapeB.Left = aLeft : oShapeB.Top = aTop

    MsgBox "Positions swapped!" & vbNewLine & vbNewLine & _
           "  """ & g_SwapAName & """  →  X=" & Fmt(bLeft) & "  Y=" & Fmt(bTop) & vbNewLine & _
           "  """ & g_SwapBName & """  →  X=" & Fmt(aLeft) & "  Y=" & Fmt(aTop), _
           vbInformation, "Shape Tools — Swap Complete"

    ' Reset swap state after a successful swap
    g_SwapACaptured = False
    g_SwapBCaptured = False
    Exit Sub

ErrHandler:
    MsgBox "Error during swap: " & Err.Description & vbNewLine & vbNewLine & _
           "The shape may have been deleted or renamed since it was captured." & vbNewLine & _
           "Re-capture both shapes and try again.", _
           vbCritical, "Shape Tools — Error"
End Sub


Public Sub ClearSwap()
    g_SwapACaptured = False
    g_SwapBCaptured = False
    g_SwapAName = ""
    g_SwapBName = ""
    MsgBox "Swap captures cleared.", vbInformation, "Shape Tools"
End Sub


' ═══════════════════════════════════════════════════════════════════
'  SHOW STATUS — run this to see what's currently stored
' ═══════════════════════════════════════════════════════════════════

Public Sub ShowStatus()
    Dim msg As String
    msg = "═══ Shape Tools Status ═══" & vbNewLine & vbNewLine

    ' Size
    msg = msg & "SIZE" & vbNewLine
    If g_SizeCaptured Then
        msg = msg & "  Captured: " & Fmt(g_CapturedWidth) & " × " & Fmt(g_CapturedHeight) & vbNewLine
    Else
        msg = msg & "  Nothing captured" & vbNewLine
    End If

    msg = msg & vbNewLine & "POSITION" & vbNewLine
    If g_PosCaptured Then
        msg = msg & "  Captured: X=" & Fmt(g_CapturedLeft) & "  Y=" & Fmt(g_CapturedTop) & vbNewLine
    Else
        msg = msg & "  Nothing captured" & vbNewLine
    End If

    msg = msg & vbNewLine & "SWAP" & vbNewLine
    If g_SwapACaptured Then
        msg = msg & "  Shape A: """ & g_SwapAName & """ on slide " & g_SwapASlide & vbNewLine
        msg = msg & "    X=" & Fmt(g_SwapALeft) & "  Y=" & Fmt(g_SwapATop) & vbNewLine
    Else
        msg = msg & "  Shape A: not captured" & vbNewLine
    End If
    If g_SwapBCaptured Then
        msg = msg & "  Shape B: """ & g_SwapBName & """ on slide " & g_SwapBSlide & vbNewLine
        msg = msg & "    X=" & Fmt(g_SwapBLeft) & "  Y=" & Fmt(g_SwapBTop) & vbNewLine
    Else
        msg = msg & "  Shape B: not captured" & vbNewLine
    End If

    MsgBox msg, vbInformation, "Shape Tools — Status"
End Sub


' ═══════════════════════════════════════════════════════════════════
'  QUICK COMBO MACROS
'  These let you bind a single button to a full workflow
'  when you already know what you want to do.
' ═══════════════════════════════════════════════════════════════════

' Run this once to set up all-in-one size copy in two clicks
' (First call = capture, second call = apply — no menus needed)
Public Sub ToggleSize()
    If Not g_SizeCaptured Then
        CaptureSize
    Else
        ApplySize
    End If
End Sub

Public Sub TogglePosition()
    If Not g_PosCaptured Then
        CapturePosition
    Else
        ApplyPosition
    End If
End Sub

' ═══════════════════════════════════════════════════════════════════
'  HOW TO ADD RIBBON BUTTONS
' ═══════════════════════════════════════════════════════════════════
'
'  OPTION A — Quick Access Toolbar (easiest, 2 minutes):
'    1. Right-click the Quick Access Toolbar (top-left of PowerPoint)
'    2. Click "Customize Quick Access Toolbar..."
'    3. In "Choose commands from" dropdown → select "Macros"
'    4. Find and add any of these macros:
'         ShapeTools.CaptureSize
'         ShapeTools.ApplySize
'         ShapeTools.CapturePosition
'         ShapeTools.ApplyPosition
'         ShapeTools.CaptureSwapA
'         ShapeTools.CaptureSwapB
'         ShapeTools.SwapPositions
'    5. Click OK — buttons appear in the toolbar
'
'  OPTION B — Custom Ribbon Tab:
'    1. File → Options → Customize Ribbon
'    2. Click "New Tab" → name it "Shape Tools"
'    3. Add a New Group → name it "Tools"
'    4. In "Choose commands from" → Macros
'    5. Add the macros listed above to your group
'    6. Click OK
'
'  OPTION C — Keyboard shortcuts (fastest):
'    Alt+F8 → type macro name → Run
'    Or assign shortcuts via the Macros dialog Options button
'
' ═══════════════════════════════════════════════════════════════════
'  SAVING AS .PPTM (MACRO-ENABLED)
' ═══════════════════════════════════════════════════════════════════
'
'  For this VBA to persist in your file:
'    File → Save As → change file type to:
'    "PowerPoint Macro-Enabled Presentation (*.pptm)"
'
'  To make it available in EVERY presentation (global add-in):
'    File → Save As → change file type to:
'    "PowerPoint Add-in (*.ppam)"
'    Save to: C:\Users\<you>\AppData\Roaming\Microsoft\AddIns\
'    Then: File → Options → Add-Ins → Manage: PowerPoint Add-ins → Go
'    → Add → browse to your .ppam file → OK
'    Macros will now be available in all presentations.
'
' ═══════════════════════════════════════════════════════════════════
