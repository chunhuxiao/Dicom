Imports System
Imports EnvDTE
Imports EnvDTE80
Imports System.Diagnostics
Imports Microsoft.CSharp
Imports System.CodeDom
Imports System.CodeDom.Compiler
Imports System.Reflection
Imports System.Text
Imports System.IO
Imports System.Collections
Imports System.Windows.Forms
Imports System.Text.RegularExpressions
Imports EK.Capture.Dicom.DicomToolKit


' copy the assembly to the ... \Common7\IDE\PublicAssemblies folder

Public Module DicomTool

    Dim NotInDictionary As String = "Not in dictionary!"

    Sub ReplaceTag()

        Dim selection As TextSelection = DTE.ActiveDocument.Selection
        Dim text = selection.Text
        text = text.Replace("""", "")

        If Not text.Contains("(") Then
            text = """" + Find(text) + """"
        Else
            Dim temp As t = New t
            Dim fields As FieldInfo() = temp.GetType().GetFields()
            For Each field As FieldInfo In fields
                If field.GetValue(temp) = text Then
                    text = "t." + field.Name
                    Exit For
                End If
            Next
        End If

        selection.Text = text
    End Sub

    Sub ShowTag()
        Dim text As String = DTE.ActiveDocument.Selection.Text
        text = text.Replace("""", "")

        If Not text.Contains("(") Then
            text = Find(text)
        End If

        If text Is Nothing Then
            Throw New System.Exception("Not in dictionary.")
        End If
        Dim tag As StandardTag = Dictionary.Instance(text)
        MsgBox(tag.ToString(), MsgBoxStyle.OkOnly, "DicomTool")

    End Sub

    Function Find(ByVal text As String) As String
        text = DTE.ActiveDocument.Selection.Text
        text = text.Replace("t.", "")

        Find = Nothing
        Dim temp As t = New t

        Dim field As FieldInfo = temp.GetType().GetField(text)
        If Not field Is Nothing Then
            Find = field.GetValue(temp)
        End If

    End Function

End Module

