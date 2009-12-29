<%
'######################################################################
'## easp.fso.asp
'## -------------------------------------------------------------------
'## Feature     :   EasyAsp FileSystemObject Class
'## Version     :   v2.2
'## Author      :   Coldstone(coldstone[at]qq.com)
'## Update Date :   2009/12/15 15:47
'## Description :   EasyAsp�ļ�������
'##
'######################################################################
Class EasyAsp_Fso
	Public oFso
	Private Fso
	Private b_force,b_overwrite
	Private s_fsoName,s_sizeformat,s_charset

	Private Sub Class_Initialize
		s_fsoName 	= Easp.FsoName
		s_charset	= Easp.CharSet
		Set Fso 	= Server.CreateObject(s_fsoName)
		Set oFso 	= Fso
		b_force		= True
		b_overwrite	= True
		s_sizeformat= "K"
		Easp.Error(51) = "��ȡ�ļ������ļ�δ�ҵ���"
		Easp.Error(52) = "д���ļ�����"
		Easp.Error(53) = "�����ļ��д���"
		Easp.Error(54) = "��ȡ�ļ��б�ʧ�ܣ�"
		Easp.Error(55) = "��������ʧ�ܣ��ļ������ڣ�"
		Easp.Error(56) = "��������ʧ�ܣ�"
		Easp.Error(57) = "��ȡ����ʧ�ܣ��ļ������ڣ�"
		Easp.Error(58) = "����ʧ�ܣ�Դ�ļ������ڣ�"
		Easp.Error(59) = "�ƶ�ʧ�ܣ�Դ�ļ������ڣ�"
		Easp.Error(60) = "ɾ��ʧ�ܣ��ļ������ڣ�"
		Easp.Error(61) = "������ʧ�ܣ�Դ�ļ������ڣ�"
		Easp.Error(62) = "������ʧ�ܣ��Ѵ���ͬ���ļ���"
		Easp.Error(63) = "�ļ����ļ��в�������"
	End Sub

	Private Sub Class_Terminate
		Set Fso 	= Nothing
		Set oFso 	= Nothing
	End Sub
	'���ԣ�FSO�������
	Public Property Let fsoName(Byval str)
		s_fsoName = str
		Set Fso = Server.CreateObject(s_fsoName)
		Set oFso = Fso
	End Property
	'���ԣ��ļ�����
	Public Property Let CharSet(Byval str)
		s_charset = Ucase(str)
	End Property
	'���ԣ��Ƿ�ɾ��ֻ���ļ�
	Public Property Let Force(Byval bool)
		b_force = bool
	End Property
	'���ԣ��Ƿ񸲸�ԭ���ļ�
	Public Property Let OverWrite(Byval bool)
		b_overwrite = bool
	End Property
	'���ԣ��ļ���С��ʾ��ʽ(G,M,K,b,auto)
	Public Property Let SizeFormat(Byval str)
		s_sizeformat = str
	End Property
	'���ԣ���ʾ������Ϣ
	Public Property Get ShowErr()
		ShowErr = s_err
	End Property

	'�ļ����ļ����Ƿ����
	Public Function isExists(ByVal path)
		path = absPath(path) : isExists = False
		If Fso.FileExists(path) or Fso.FolderExists(path) Then isExists = True
	End Function
	'�ļ��Ƿ����
	Public Function isFile(ByVal filePath)
		filePath = absPath(filePath) : isFile = False
		If Fso.FileExists(filePath) Then isFile = True
	End Function
	'��ȡ�ļ�����
	Public Function Read(ByVal filePath)
		Dim p, f, o_strm, tmpStr : p = absPath(filePath)
		If isFile(p) Then
			Set o_strm = Server.CreateObject("ADODB.Stream")
			With o_strm
				.Type = 2
				.Mode = 3
				.Open
				.LoadFromFile p
				.Charset = s_charset
				.Position = 2
				tmpStr = .ReadText
				.Close
			End With
			Set o_strm = Nothing
		Else
			tmpStr = ""
			Easp.Error.Msg = "(" & filePath & ")"
			Easp.Error.Raise 51
		End If
		Read = tmpStr
	End Function
	'�����ļ���д������
	Public Function CreateFile(ByVal filePath, ByVal fileContent)
		On Error Resume Next
		Dim f,p,t : p = absPath(filePath)
		CreateFile = MD(Left(p,InstrRev(p,"\")-1))
		If CreateFile Then
			Set o_strm = Server.CreateObject("ADODB.Stream")
			With o_strm
				.Type = 2
				.Open
				.Charset = s_charset
				.Position = o_strm.Size
				.WriteText = fileContent
				.SaveToFile p,Easp.IIF(b_overwrite,2,1)
				.Close
			End With
			Set o_strm = Nothing
		End If
		If Err.Number<>0 Then
			CreateFile = False
			Easp.Error.Msg = "(" & filePath & ")"
			Easp.Error.Raise 52
		End If
		Err.Clear()
	End Function
	'���������ʽ�����ļ�����
	Public Function UpdateFile(ByVal filePath, ByVal rule, ByVal result)
		Dim tmpStr : filePath = absPath(filePath)
		tmpStr = Easp.regReplace(Read(filePath),rule,result)
		UpdateFile = CreateFile(filePath,tmpStr)
	End Function
	'׷���ļ�����
	Public Function AppendFile(ByVal filePath, ByVal fileContent)
		Dim tmpStr : filePath = absPath(filePath)
		tmpStr = Read(filePath) & fileContent
		AppendFile = CreateFile(filePath,tmpStr)
	End Function
	'�ļ����Ƿ����
	Public Function isFolder(ByVal folderPath)
		folderPath = absPath(folderPath) : isFolder = False
		If Fso.FolderExists(folderPath) Then isFolder = True
	End Function
	'�����ļ��� MD
	Public Function CreateFolder(ByVal folderPath)
		On Error Resume Next
		Dim p,arrP,i : CreateFolder = True
		p = absPath(folderPath)
		arrP = Split(p,"\") : p = ""
		For i = 0 To Ubound(arrP)
			p = p & arrP(i) & "\"
			If Not isFolder(p) Then Fso.CreateFolder(p)
		Next
		If Err.Number<>0 Then
			CreateFolder = False
			Easp.Error.Msg = "(" & folderPath & ")"
			Easp.Error.Raise 53
		End If
		Err.Clear()
	End Function
	Public Function MD(ByVal folderPath)
		MD = CreateFolder(folderPath)
	End Function
	'�г��ļ����µ������ļ��С��ļ�
	Public Function Dir(ByVal folderPath)
		Dir = List(folderPath,0)
	End Function
	'�г��ļ����µ������ļ��л��ļ�
	Public Function List(ByVal folderPath, ByVal fileType)
		On Error Resume Next
		Dim f,fs,k,arr(),i,l
		folderPath = absPath(folderPath) : i = 0
		Select Case LCase(fileType)
			Case "0","" l = 0
			Case "1","file" l = 1
			Case "2","folder" l = 2
			Case Else l = 0
		End Select
		Set f = Fso.GetFolder(folderPath)
		If l = 0 Or l = 2 Then
			Set fs = f.SubFolders
			ReDim Preserve arr(4,fs.Count-1)
			For Each k In fs
				arr(0,i) = k.Name & "/"
				arr(1,i) = formatSize(k.Size,s_sizeformat)
				arr(2,i) = k.DateLastModified
				arr(3,i) = Attr2Str(k.Attributes)
				arr(4,i) = k.Type
				i = i + 1
			Next
		End If
		If l = 0 Or l = 1 Then
			Set fs = f.Files
			ReDim Preserve arr(4,fs.Count+i-1)
			For Each k In fs
				arr(0,i) = k.Name
				arr(1,i) = formatSize(k.Size,s_sizeformat)
				arr(2,i) = k.DateLastModified
				arr(3,i) = Attr2Str(k.Attributes)
				arr(4,i) = k.Type
				i = i + 1
			Next
		End If
		Set fs = Nothing
		Set f = Nothing
		List = arr
		If Err.Number<>0 Then
			Easp.Error.Msg = "(" & folderPath & ")"
			Easp.Error.Raise 54
		End If
		Err.Clear()
	End Function
	'�����ļ����ļ�������
	Public Function Attr(ByVal path, ByVal attrType)
		On Error Resume Next
		Dim p,a,i,n,f,at : p = absPath(path) : n = 0 : Attr = True
		If not isExists(p) Then
			Attr = False
			Easp.Error.Msg = "(" & path & ")"
			Easp.Error.Raise 55
			Exit Function
		End If
		If isFile(p) Then
			Set f = Fso.GetFile(p)
		ElseIf isFolder(p) Then
			Set f = Fso.GetFolder(p)
		End If
		at = f.Attributes : a = UCase(attrType)
		If Instr(a,"+")>0 Or Instr(a,"-")>0 Then
			a = Easp.IIF(Instr(a," ")>0,Split(a," "),Split(a,","))
			For i = 0 To Ubound(a)
				Select Case a(i)
					Case "+R" at = Easp.IIF(at And 1,at,at+1)
					Case "-R" at = Easp.IIF(at And 1,at-1,at)
					Case "+H" at = Easp.IIF(at And 2,at,at+2)
					Case "-H" at = Easp.IIF(at And 2,at-2,at)
					Case "+S" at = Easp.IIF(at And 4,at,at+4)
					Case "-S" at = Easp.IIF(at And 4,at-4,at)
					Case "+A" at = Easp.IIF(at And 32,at,at+32)
					Case "-A" at = Easp.IIF(at And 32,at-32,at)
				End Select
			Next
			f.Attributes = at
		Else
			For i = 1 To Len(a)
				Select Case Mid(a,i,1)
					Case "R" n = n + 1
					Case "H" n = n + 2
					Case "S" n = n + 4
				End Select
			Next
			f.Attributes = Easp.IIF(at And 32,n+32,n)
		End If
		Set f = Nothing
		If Err.Number<>0 Then
			Attr = False
			Easp.Error.Msg = "(" & path & ")"
			Easp.Error.Raise 56
		End If
		Err.Clear()
	End Function
	'��ȡ�ļ����ļ�������
	Public Function getAttr(ByVal path, ByVal attrType)
		Dim f,s : p = absPath(path)
		If isFile(p) Then
			Set f = Fso.GetFile(p)
		ElseIf isFolder(p) Then
			Set f = Fso.GetFolder(p)
		Else
			getAttr = ""
			Easp.Error.Msg = "(" & path & ")"
			Easp.Error.Raise 57
			Exit Function
		End If
		Select Case LCase(attrType)
			Case "0","name" : s = f.Name
			Case "1","date", "datemodified" : s = f.DateLastModified
			Case "2","datecreated" : s = f.DateCreated
			Case "3","dateaccessed" : s = f.DateLastAccessed
			Case "4","size" : s = formatSize(f.Size,s_sizeformat)
			Case "5","attr" : s = Attr2Str(f.Attributes)
			Case "6","type" : s = f.Type
			Case Else s = ""
		End Select
		Set f = Nothing
		getAttr = s
	End Function
	'�����ļ�(֧��ͨ���*��?)
	Public Function CopyFile(ByVal fromPath, ByVal toPath)
		CopyFile = FOFO(fromPath,toPath,0,0)
	End Function
	'�����ļ���(֧��ͨ���*��?)
	Public Function CopyFolder(ByVal fromPath, ByVal toPath)
		CopyFolder = FOFO(fromPath,toPath,1,0)
	End Function
	'�����ļ����ļ���
	Public Function Copy(ByVal fromPath, ByVal toPath)
		Dim ff,tf : ff = absPath(fromPath) : tf = absPath(toPath)
		If isFile(ff) Then
			Copy = CopyFile(fromPath,toPath)
		ElseIf isFolder(ff) Then
			Copy = CopyFolder(fromPath,toPath)
		Else
			Copy = False
			Easp.Error.Msg = "(" & fromPath & ")"
			Easp.Error.Raise 58
		End If
	End Function
	'�ƶ��ļ�(֧��ͨ���*��?)
	Public Function MoveFile(ByVal fromPath, ByVal toPath)
		MoveFile = FOFO(fromPath,toPath,0,1)
	End Function
	'�ƶ��ļ���(֧��ͨ���*��?)
	Public Function MoveFolder(ByVal fromPath, ByVal toPath)
		MoveFolder = FOFO(fromPath,toPath,1,1)
	End Function
	'�ƶ��ļ����ļ���
	Public Function Move(ByVal fromPath, ByVal toPath)
		Dim ff,tf : ff = absPath(fromPath) : tf = absPath(toPath)
		If isFile(ff) Then
			Move = MoveFile(fromPath,toPath)
		ElseIf isFolder(ff) Then
			Move = MoveFolder(fromPath,toPath)
		Else
			Move = False
			Easp.Error.Msg = "(" & fromPath & ")"
			Easp.Error.Raise 59
		End If
	End Function
	'ɾ���ļ�(֧��ͨ���*��?)
	Public Function DelFile(ByVal path)
		DelFile = FOFO(path,"",0,2)
	End Function
	'ɾ���ļ���(֧��ͨ���*��?)
	Public Function DelFolder(ByVal path)
		DelFolder = FOFO(path,"",1,2)
	End Function
	Public Function RD(ByVal path)
		RD = DelFolder(path)
	End Function
	'ɾ���ļ����ļ���
	Public Function Del(ByVal path)
		Dim p : p = absPath(path)
		If isFile(p) Then
			Del = DelFile(path)
		ElseIf isFolder(p) Then
			Del = DelFolder(path)
		Else
			Del = False
			Easp.Error.Msg = "(" & path & ")"
			Easp.Error.Raise 60
		End If
		Err.Clear()
	End Function
	'�ļ����ļ��и���
	Public Function Rename(ByVal path, ByVal newname)
		Dim p,n : p = absPath(path) : Rename = True
		n = Left(p,InstrRev(p,"\")) & newname
		If Not isExists(p) Then
			Rename = False
			Easp.Error.Msg = "(" & path & ")"
			Easp.Error.Raise 61
			Exit Function
		End If
		If isExists(n) Then
			Rename = False
			Easp.Error.Msg = "(" & newname & ")"
			Easp.Error.Raise 62
			Exit Function
		End If
		Copy p,n : Del p
	End Function
	Public Function Ren(ByVal path, ByVal newname)
		Ren = Rename(path,newname)
	End Function
	'===˽�з���===
	'ȡ�ļ��о���·��
	Private Function absPath(ByVal p)
		If Instr(p,":")=0 Then
			If isWildcards(p) Then
				p = Server.MapPath(Easp.IIF(Left(p,1)="/", "/", Easp.GetUrl(2) & "/")) & Replace(p,"/","\")
			Else
				p = Server.MapPath(p)
			End If
		End If
		If Right(p,1) = "\" Then p = Left(p,Len(p)-1)
		absPath = p
	End Function
	'·���Ƿ����ͨ���
	Private Function isWildcards(ByVal path)
		isWildcards = False
		If Instr(path,"*")>0 Or Instr(path,"?")>0 Then isWildcards = True
	End Function
	'�ļ����ļ��в���ԭ��
	Private Function FOFO(ByVal fromPath, ByVal toPath, ByVal FOF, ByVal MOC)
		On Error Resume Next
		Dim ff,tf,oc,of,oi,ot,os
		ff = absPath(fromPath) : tf = absPath(toPath)
		If FOF = 0 Then
			oc = isFile(ff) : of = "File" : oi = "�ļ�"
		ElseIf FOF = 1 Then
			oc = isFolder(ff) : of = "Folder" : oi = "�ļ���"
		End If
		If MOC = 0 Then
			ot = "Copy" : os = "����"
		ElseIf MOC = 1 Then
			ot = "Move" : os = "�ƶ�"
		ElseIf MOC = 2 Then
			ot = "Delete" : os = "ɾ��"
		End If
		If oc Then
			If MOC<>2 Then
				If FOF = 0 Then
					If Right(toPath,1)="/" or Right(toPath,1)="\" Then
						FOFO = MD(tf) : tf = tf & "\"
					Else
						FOFO = MD(Left(tf,InstrRev(tf,"\")-1))
					End If
				ElseIf FOF = 1 Then
					FOFO = MD(tf)
				End If
				Execute("Fso."&ot&of&" ff,tf"&Easp.IIF(MOC=0,",b_overwrite",""))
			Else
				Execute("Fso."&ot&of&" ff,b_force")
			End If
			If Err.Number<>0 Then
				FOFO = False
				Easp.Error.Msg = "<br />" & os & oi & "ʧ�ܣ�" & "( "&frompath&" "&Easp.IIF(MOC=2,"",os&"�� "&toPath)&" )"
				Easp.Error.Raise 63
			End If
		ElseIf isWildcards(ff) Then
			If Not isFolder(Left(ff,InstrRev(ff,"\")-1)) Then
				FOFO = False
				Easp.Error.Msg = "<br />" & os & oi & "ʧ�ܣ�" & Easp.IIF(MOC=2,"","Դ") & oi & "������( "&frompath&" )"
				Easp.Error.Raise 63
			End If
			If MOC<>2 Then
				FOFO = MD(tf)
				Execute("Fso."&ot&of&" ff,tf"&Easp.IIF(MOC=0,",b_overwrite",""))
			Else
				Execute("Fso."&ot&of&" ff,b_force")
			End If
			If Err.Number<>0 Then
				FOFO = False
				Easp.Error.Msg = "<br />" & os & oi & "ʧ�ܣ�" & "( "&frompath&" "&Easp.IIF(MOC=2,"",os&"�� "&toPath)&" )"
				Easp.Error.Raise 63
			End If
		Else
			FOFO = False
			Easp.Error.Msg = "<br />" & os & oi & "ʧ�ܣ�" & Easp.IIF(MOC=2,"","Դ")&oi&"������( "&frompath&" )"
			Easp.Error.Raise 63
		End If
		Err.Clear()
	End Function
	'��ʽ���ļ���С
	Private Function formatSize(Byval fileSize, ByVal level)
		Dim s : s = Int(fileSize) : level = UCase(level)
		formatSize = Easp.IIF(s/(1073741824)>0.01,FormatNumber(s/(1073741824),2,-1,0,-1),"0.01") & " GB"
		If s = 0 Then formatSize = "0 GB"
		If level = "G" Or (level="AUTO" And s>1073741824) Then Exit Function
		formatSize = Easp.IIF(s/(1048576)>0.1,FormatNumber(s/(1048576),1,-1,0,-1),"0.1") & " MB"
		If s = 0 Then formatSize = "0 MB"
		If level = "M" Or (level="AUTO" And s>1048576) Then Exit Function
		formatSize = Easp.IIF((s/1024)>1,Int(s/1024),1) & " KB"
		If s = 0 Then formatSize = "0 KB"
		If Level = "K" Or (level="AUTO" And s>1024) Then Exit Function
		If level = "B" or level = "AUTO" Then
			formatSize = s & " bytes"
		Else
			formatSize = s
		End If
	End Function
	'��ʽ���ļ�����
	Private Function Attr2Str(ByVal attrib)
		Dim a,s : a = Int(attrib)
		If a>=2048 Then a = a - 2048
		If a>=1024 Then a = a - 1024
		If a>=32 Then : s = "A" : a = a- 32 : End If
		If a>=16 Then a = a- 16
		If a>=8 Then a = a - 8
		If a>=4 Then : s = "S" & s : a = a- 4 : End If
		If a>=2 Then : s = "H" & s : a = a- 2 : End If
		If a>=1 Then : s = "R" & s : a = a- 1 : End If
		Attr2Str = s
	End Function
End Class
%>