<%
Class EasyAsp_Tpl	
	Private s_html, s_unknown, s_dict, s_path, s_m, s_ms, s_me
	Private o_tag, o_blockdata, o_block, o_blocktag, o_blocks
	Private b_asp

	Private Sub class_Initialize
		s_path = ""
		s_unknown = "keep"
		s_dict = "Scripting.Dictionary"
		Set o_tag = createobject(s_dict)
		Set o_blockdata = createobject(s_dict)
		Set o_block = createobject(s_dict)
		Set o_blocktag = createobject(s_dict)
		Set o_blocks = createobject(s_dict)
		s_m = "{*}"
		getMaskSE s_m
		b_asp = False
		s_html = ""
	End Sub
	Private Sub Class_Terminate
		Set o_tag = Nothing
		Set o_blockdata = Nothing
		Set o_block = Nothing
		Set o_blockTag = Nothing
		Set o_blocks = Nothing
	End Sub

	'ģ��·��
	Public Property Get FilePath
		FilePath = s_path
	End Property
	Public Property Let FilePath(ByVal f)
		s_path = f
	End Property
	'����ģ�巽��һ
	Public Property Let [File](ByVal f)
		Load(f)
	End Property
	'��ǩ�ı�ʶ��
	Public Property Get TagMask
		TagMask = s_m
	End Property
	Public Property Let TagMask(ByVal m)
		s_m = m
		getMaskSE s_m
	End Property
	'ģ�����Ƿ����ִ��ASP����
	Public Property Get AspEnable
		AspEnable = b_asp
	End Property
	Public Property Let AspEnable(ByVal b)
		b_asp = b
	End Property
	'��δ���δ����ı�ǩ
	Public Property Get TagUnknown
		TagUnknown = s_unknown
	End Property
	Public Property Let TagUnknown(ByVal s)
		Select Case LCase(s)
			Case "1", "remove"
				s_unknown = "remove"
			Case "2", "comment"
				s_unknown = "comment"
			Case Else
				s_unknown = "keep"
		End Select
	End Property

	'����ģ�巽����
	Public Sub Load(ByVal f)
		s_html = LoadInc(s_path & f,"")
		SetBlocks()
	End Sub
	'���ظ���ģ��
	Public Sub TagFile(ByVal tag, ByVal f)
		Dim s
		s = LoadInc(s_path & f,"")
		s_html = Easp.regReplace(s_html, s_ms & tag & s_me, s)
		SetBlocks()
	End Sub
	'�滻��ǩ(Ĭ�Ϸ���)
	Public Default Sub Tag(ByVal s, ByVal v)
		If o_tag.Exists(s) Then o_tag.Remove s
		o_tag.Add s, v
	End Sub
	'�����滻��ǩ������������
	Public Sub Append(s, v)
		Dim tmp
		If o_tag.Exists(s) Then
			tmp = o_tag.Item(s) & v
			o_tag.Remove s
			o_tag.Add s, tmp
		Else
			o_tag.Add s, v
		End If
	End Sub
	'��ȡ����html
	Public Function GetHtml
		Dim Matches, Match, n
		Set Matches = Easp.RegMatch(s_html, s_ms & "(.+?)" & s_me)
		For Each Match In Matches
			n = Match.SubMatches(0)
			If o_tag.Exists(n) Then
				s_html = Easp.regReplace(s_html, Match.Value, o_tag.Item(n))
			End If
		Next
		Set Matches = Easp.regMatch(s_html, Chr(0) & "\w+" & Chr(0))
		For Each Match In Matches
			s_html = Easp.regReplace(s_html, Match.Value, "")
		Next
		Set Matches = Easp.RegMatch(s_html, s_ms & "(.+?)" & s_me)
		select case s_unknown
			case "keep"
			case "remove"
				For Each Match In Matches
					s_html = Easp.regReplace(s_html, Match.Value, "")
				Next
			case "comment"
				For Each Match In Matches
					s_html = Easp.regReplace(s_html, Match.Value, "<!-- Unknown Tag '" & Match.Submatches(0) & "' -->")
				Next
		End select
		GetHtml = s_html
	End Function
	'���ģ������
	Public Sub Show
		Easp.W GetHtml
	End Sub
	'����ѭ��������
	Public Sub [Update](b)
		Dim Matches, Match, tmp, s, rule, data
		s = BlockData(b)
		rule = Chr(0) & "(\w+)" & Chr(0)
		Set Matches = Easp.regMatch(s, rule)
		Set Match = Matches
		For Each Match In Matches
			data = Match.SubMatches(0)
			If o_blocktag.Exists(data) Then
				s = Easp.regReplace(s, rule, o_blocktag.Item(data))
				o_blocktag.Remove(data)
			End If
		Next
		If o_blocktag.Exists(b) Then
			tmp = o_blocktag.Item(b) & s
			o_blocktag.Remove b
			o_blocktag.Add b, tmp
		Else
			o_blocktag.Add b, s
		End If
		Set Matches = Easp.regMatch(s_html, Chr(0) & b & Chr(0))
		Set Match = Matches
		For Each Match In Matches
			s = BlockTag(b)
			s_html = Easp.regReplace(s_html, Chr(0) & b & Chr(0), s & Chr(0) & b & Chr(0))
		Next
	End Sub
	'����html��ǩ
	Public Function MakeTag(ByVal t, ByVal f)
		Dim s,e,a,i
		Select Case Lcase(t)
			Case "css"
				s = "<link href="""
				e = """ rel=""stylesheet"" type=""text/css"" />"
			Case "js"
				s = "<scr"&"ipt type=""text/javascript"" src="""
				e = """></scr"&"ipt>"
			Case "author", "keywords", "description", "copyright", "generator", "revised", "others"
				MakeTag = MakeTagMeta("name",t,f)
				Exit Function
			Case "content-type", "expires", "refresh", "set-cookie"
				MakeTag = MakeTagMeta("http-equiv",t,f)
				Exit Function
		End Select
		a = Split(f,"|")
		For i = 0 To Ubound(a)
			a(i) = s & Trim(a(i)) & e
		Next
		MakeTag = Join(a,vbCrLf)
	End Function

	'����Meta��ǩ
	Private Function MakeTagMeta(ByVal m, ByVal t, ByVal s)
		MakeTagMeta = "<meta " & m & "=""" & t & """ content=""" & s & """ />"
	End Function
	'��ȡTag��ʶ
	Private Sub getMaskSE(ByVal m)
		s_ms = FixRegStr(Easp.CLeft(m,"*"))
		s_me = FixRegStr(Easp.CRight(m,"*"))
	End Sub
	'�������ʽ�����ַ�ת��
	Private Function FixRegStr(ByVal s)
		Dim re,i
		re = Split("$,(,),*,+,.,[,?,\,^,{,|",",")
		For i = 0 To Ubound(re)
			s = Replace(s,re(i),"\"&re(i))
		Next
		FixRegStr = s
	End Function
	'����ģ���ļ��������޼�includeģ������
	Private Function LoadInc(ByVal f, ByVal p)
		Dim h,pa,rule,inc,Match,incFile,incStr
		pa = Easp.IIF(Left(f,1)="/","",p)
		If b_asp Then
			h = Easp.GetInclude( pa & f )
		Else
			h = Easp.Read( pa & f )
		End If
		rule = "(<!--[\s]*)?" & s_ms & "#include:(.+?)" & s_me & "([\s]*-->)?"
		If Easp.Test(h,rule) Then
			If Easp.isN(p) Then
				If Instr(f,"/")>0 Then p = Left(f,InstrRev(f,"/"))
			Else
				If Instr(f,"/")>0 Then p = pa & Left(f,InstrRev(f,"/"))
			End If
			Set inc = Easp.regMatch(h,rule)
			For Each Match In inc
				incFile = Match.SubMatches(1)
				incStr = LoadInc(incFile, p)
				h = Replace(h,Match,incStr)
			Next
			Set inc = Nothing
		End If
		LoadInc = h
	End Function
	Private Sub SetBlocks()
		Dim Matches, Match, rule, n, i, j
		i = 0
		rule = "(<!--[\s]*)?" & s_ms & "#:(.+?)" & s_me
		If Not Easp.Test(s_html, rule) Then Exit Sub
		Set Matches = Easp.regMatch(s_html,rule)
		For Each Match In Matches
			n = Match.SubMatches(1)
			If o_blocks.Exists(i) Then o_blocks.Remove i
			o_blocks.Add i, n
			i = i + 1
		Next
		For j = i-1 To 0 Step -1
			Begin o_blocks.item(j)
		Next
	End Sub
	'��ʼ��ѭ����
	Private Sub Begin(ByVal b)
		Dim Matches, Match, rule, data
		rule = "(<!--[\s]*)?(" & s_ms & ")#:(" & b & ")(" & s_me & ")([\s]*-->)?([\s\S]+?)(<!--[\s]*)?\2/#:\3\4([\s]*-->)?"
		Set Matches = Easp.regMatch(s_html, rule)
		Set Match = Matches
		For Each Match In Matches
			data = Match.SubMatches(5)
			If o_blockdata.Exists(b) Then
				o_blockdata.Remove(b)
				o_block.Remove(b)
			End If
			o_blockdata.Add b, data
			o_block.Add b, b
			s_html = Easp.regReplace(s_html, rule, Chr(0) & b & Chr(0))
		Next
	End Sub
	'ȡѭ����ԭʼģ������
	Private Function BlockData(b)
		Dim tmp, s
		If o_blockdata.Exists(b) Then
			tmp = o_blockdata.Item(b)
			s = UpdateBlockTag(tmp)
			BlockData = s
		Else
			BlockData = "<!--" & b & "-->"
		End If
	End Function
	'ȡѭ������ʱ����
	Private Function BlockTag(b)
		Dim tmp, s
		If o_blockdata.Exists(b) Then
			tmp = o_blocktag.Item(b)
			s = UpdateBlockTag(tmp)
			BlockTag = s
			o_blocktag.Remove(b)
		Else
			BlockTag = "<!--" & b & "-->"
		End If
	End Function
	'����ѭ�����ǩ
	Private Function UpdateBlockTag(s)
		Dim Matches, Match, data, rule
		Set Matches = Easp.RegMatch(s, s_ms & "(.+?)" & s_me)
		For Each Match In Matches
			data = Match.SubMatches(0)
			If o_tag.Exists(data) Then
				rule = Match.Value
				If Easp.isN(o_tag.Item(data)) Then
					s = Easp.regReplace(s, rule, "")
				Else
					s = Easp.regReplace(s, rule, o_tag.Item(data))
				End If
			End If
		Next
		UpdateBlockTag = s
	End Function
End Class
%>