Function CONVDUR(ByVal t As String) As String
    Dim num As Integer
    num = Val(onlyDigits(t))
    If UCase(t) Like "HOUR" Then
        num = num * 3600
    End If
    If UCase(t) Like "MINUTE" Then
        num = num * 60
    End If
    CONVDUR = CStr(num)
End Function


Function onlyDigits(s As String) As String
    ' Variables needed (remember to use "option explicit").   '
    Dim retval As String    ' This is the return string.      '
    Dim i As Integer        ' Counter for character position. '
    Dim f As Boolean
    f = False

    ' Initialise return string to empty                       '
    retval = ""

    ' For every character in input string, copy digits to     '
    '   return string.                                        '
    For i = 1 To Len(s)
        If Mid(s, i, 1) Like "[0-9]" Then
            f = True
            retval = retval + Mid(s, i, 1)
        Else
            If f Then
                Exit For
            End If
        End If
    Next

    ' Then return the return string.                          '
    onlyDigits = retval
End Function