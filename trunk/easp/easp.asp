<%
Option Explicit
'######################################################################
'## easp.asp
'## -------------------------------------------------------------------
'## Feature     :   EasyAsp Class
'## Version     :   v2.2 alpha
'## Author      :   Coldstone(coldstone[at]qq.com)
'## Update Date :   2009/12/15 15:51
'## Description :   EasyAsp Class
'##
'## Update Info	:
'    1. �޸�Easp.CutStringΪEasp.CutStr��Easp.GetCookieΪEasp.Cookie��
'    2. ����Easp.Str��Easp.WStr����ַ�����
'    3. ����Easp.JsCode�������������ɵ�javascript�����ַ�����
'    4. ����Easp.Rewrite��Easp.RewriteRule����������αRewrite��ʵ�֣�
'    5. ����Easp.Get��Easp.Post��������ȫ��ȡ��Easp.Rϵ�к��������Ӱ�ȫ��
'    6. ����Easp.Use��������������Easp�Ĺٷ���⣬��Easp.Aes��Easp.Fso��
'       Easp.Upload�ȣ��˷���Ϊ��̬���أ��ɶ�ε��õ�ֻ����һ���ļ���
'    7. ����Easp.MD5��Easp.MD5_16����������Md5���ܣ��˷���Ϊ��̬�����ļ���
'    8. ����Easp.CLeft��Easp.CRight����������ȡ�����ַ������������ַ�����
'    9. �޸�Easp.IfThen����������ֻ��������������������Ϊ��ĸ�ֵ��
'   10. ����Easp.Ext���������ڶ�̬�����ʹ��Easp�Ĳ����
'   11. �Ż�Easp.isN�������������ж�Recordset��Dictionary�Ƿ�Ϊ�գ�
'   12. ����Easp.Has�����������ж϶����Ƿ�Ϊ�գ���Easp.isN�պ��෴��
'   13. ����Easp.Aes�࣬���ڶ���Ӣ���ַ�����AES�㷨���ܣ���ʹ����������(Կ)��
'   14. �Ż�Easp.Cookie/SetCookie���ɶ�cookie��AES�㷨���ܣ���α�죻
'       ͬʱ�������������仯��ԭ���ķָ���:����Ϊ>����֧��Easp.Get�Ĳ�����ʽ��
'   15. ����Easp.Fso�࣬����FSO�ļ����������ܷǳ�ȫ�������ʹ�ã�
'   16. �Ż�Easp.GetUrlWith���������Խ�������������ҳ�棻
'   17. �Ż�Easp.CheckForm������rule���������:��ͷ������||�������������
'       ֤�����ʾ"��"��ϵ�Ĺ����������������һ����������֤ͨ����
'   18. �Ż�Easp.JsEncode���������˫�ֽ��ַ����б��룬�����Ͻ������������⣻
'   19. ����Easp.ReplacePart�����������滻����ĳ��������ַ����е�ĳһ���飻
'   20. ����Easp.ReplaceUrl�����������滻url�����е�ĳһ����ֵ�������ַ�����
'   21. ����Easp.Error�࣬�����쳣(Exception)�Ĵ����ʹ�����Ϣ���׳���
'   22. �޸�Easp.db.dbConn����ΪEasp.db.Conn��
'   23. ����Easp.tpl�࣬����ģ�崦��������ǿ��֧�����޼�ģ��Ƕ�׺�Ƕ��ѭ����
'   24. ����Easp.upload�࣬�����ϴ��ļ���֧�ֶ��ļ��ϴ�����ʱ��֧�ֽ�������
'######################################################################
Dim Easp_Timer : Easp_Timer = Timer()
Dim Easp : Set Easp = New EasyASP : Easp.Init()
Dim EasyAsp_s_html
%>
<!--#include file="easp.config.asp"-->
<%
Class EasyAsp
	Public db,fso,upload,tpl,aes,[error]
	Private s_path, s_plugin, s_fsoName, s_dicName, s_charset, s_rq
	Private s_url, s_rwtS, s_rwtU
	Private o_md5, o_rwt, o_ext, o_regex, o_fso, o_strm
	Private b_cooen, i_rule, b_debug
	Private Sub Class_Initialize()
		s_path		= "/easp/"
		s_plugin	= "/easp/plugin/"
		s_fsoName	= "Scripting.FileSystemObject"
		s_dicName	= "Scripting.Dictionary"
		s_charset	= "GBK"
		s_rq		= Request.QueryString()
		i_rule		= 1
		b_cooen		= True
		b_debug		= False
		Set o_rwt 	= Server.CreateObject(s_dicName)
		Set o_ext 	= Server.CreateObject(s_dicName)
		Set o_fso	= Server.CreateObject(s_fsoName)
		Set o_strm	= Server.CreateObject("ADODB.Stream")
		Set o_regex = New Regexp
		o_regex.Global = True
		o_regex.IgnoreCase = True
		Set [error]	= New EasyAsp_obj
		Set db		= New EasyAsp_obj
		Set o_md5	= New EasyAsp_obj
		Set fso		= New EasyAsp_obj
		Set upload	= New EasyAsp_obj
		Set tpl		= New EasyAsp_obj
		Set aes		= New EasyAsp_obj
	End Sub
	Private Sub Class_Terminate()
		Set aes		= Nothing
		Set tpl		= Nothing
		Set upload	= Nothing
		Set fso		= Nothing
		Set o_md5	= Nothing
		Set db 		= Nothing
		Set [error]	= Nothing
		ClearExt() : Set o_ext	= Nothing
		Set o_rwt	= Nothing
		Set o_regex = Nothing
		Set o_fso	= Nothing
		Set o_strm	= Nothing
	End Sub
	Public Property Let basePath(ByVal p)
		p = IIF(Left(p,1)= "/", p, "/" & p)
		p = IIF(Right(p,1)="/", p, p & "/")
		s_path = p
	End Property
	Public Property Get basePath()
		basePath = s_path
	End Property
	Public Property Let pluginPath(ByVal p)
		s_plugin = p
	End Property
	Public Property Get pluginPath()
		pluginPath = s_plugin
	End Property
	Public Property Let fsoName(ByVal s)
		s_fsoName = s
	End Property
	Public Property Get fsoName()
		fsoName = s_fsoName
	End Property
	Public Property Let [CharSet](ByVal s)
		s_charset = Ucase(s)
	End Property
	Public Property Get [CharSet]()
		[CharSet] = s_charset
	End Property
	Public Property Let CookieEncode(ByVal b)
		b_cooen = b
	End Property
	Public Property Get CookieEncode()
		CookieEncode = b_cooen
	End Property
	Public Property Get [Debug]
		[Debug] = b_debug
	End Property
	Public Property Let [Debug](ByVal b)
		b_debug = b
		[error].debug = b
	End Property

	Public Sub Init()
		Set [error] = New EasyAsp_Error
		[error](1) = "�����ļ��ڲ����д�����������ļ����룡"
		Set db = New EasyAsp_db
		Set tpl = New EasyAsp_tpl
	End Sub

	Private Function rqsv(ByVal s)
		rqsv = Request.ServerVariables(s)
	End Function
	
	'����ַ���(���׶ϵ����)
	Sub W(ByVal s)
		Response.Write(s)
	End Sub
	Sub WC(ByVal s)
		W(s & VbCrLf)
	End Sub
	Sub WN(ByVal s)
		W(s & "<br />" & VbCrLf)
	End Sub
	Sub WE(ByVal s)
		W(s)
		Response.End()
	End Sub
	'���ɶ�̬�ַ���
	Function Str(ByVal s, ByVal v)
		Dim i
		s = Replace(s,"\\",Chr(0))
		s = Replace(s,"\{",Chr(1))
		If isArray(v) Then
			For i = 0 To Ubound(v)
				s = Replace(s,"{"&(i+1)&"}",v(i))
			Next
		Else
			s = Replace(s,"{1}",v)
		End If
		s = Replace(s,Chr(1),"{")
		Str = Replace(s,Chr(0),"\")
	End Function
	'�����̬�ַ���
	Sub WStr(ByVal s, ByVal v)
		W Str(s,v)
	End Sub
	'����������ת
	Sub RR(ByVal u)
		Response.Redirect(u)
	End Sub
	'�ж��Ƿ�Ϊ��ֵ
	Function isN(ByVal s)
		isN = False
		Select Case VarType(s)
			Case vbEmpty, vbNull
				isN = True : Exit Function
			Case vbString
				If s="" Then isN = True : Exit Function
			Case vbObject
				Select Case TypeName(s)
					Case "Nothing","Empty"
						isN = True : Exit Function
					Case "Recordset"
						If s.State = 0 Then isN = True : Exit Function
						If s.Bof And s.Eof Then isN = True : Exit Function
					Case "Dictionary"
						If s.Count = 0 Then isN = True : Exit Function
				End Select
			Case vbArray,8194,8204,8209
				If Ubound(s)=-1 Then isN = True : Exit Function
		End Select
	End Function
	Function Has(ByVal s)
		Has = Not isN(s)
	End Function
	'�ж���Ԫ����ʽ
	Function IIF(ByVal Cn, ByVal T, ByVal F)
		If Cn Then
			IIF = T
		Else
			IIF = F
		End If
	End Function
	Function IfThen(ByVal Cn, ByVal T)
		IfThen = IIF(Cn,T,"")
	End Function
	'�����������javascript
	Sub Js(ByVal s)
		W JsCode(s)
	End Sub
	Function JsCode(ByVal s)
		JsCode = Str("<{1} type=""text/java{1}"">{2}{3}{4}{2}</{1}>{2}", Array("sc"&"ript",vbCrLf,vbTab,s))
	End Function
	'�����������javascript������Ϣ�򲢷���ǰҳ
	Sub Alert(ByVal s)
		WE JsCode(Str("alert('{1}');history.go(-1);",JsEncode(s)))
	End Sub
	'�����������javascript������Ϣ��ת��URL
	Sub AlertUrl(ByVal s, ByVal u)
		WE JsCode(Str("alert('{1}');location.href='{2}';",Array(JsEncode(s),u)))
	End Sub
	'�����������javascriptȷ����Ϣ�򲢸���ѡ��ת��URL
	Sub ConfirmUrl(ByVal s, ByVal t, ByVal f)
		WE JsCode(Str("location.href=confirm('{1}')?'{2}':'{3}';",Array(JsEncode(s),t,f)))
	End Sub
	'�����ַ����е�Javascript�����ַ�
	Function JsEncode(ByVal s)
		Dim i, j, aL1, aL2, c, p, t
		aL1 = Array(&h22, &h5C, &h2F, &h08, &h0C, &h0A, &h0D, &h09)
		aL2 = Array(&h22, &h5C, &h2F, &h62, &h66, &h6E, &h72, &h74)
		For i = 1 To Len(s)
			p = True
			c = Mid(s, i, 1)
			For j = 0 To 7
				If c = Chr(aL1(j)) Then
					t = t & "\" & Chr(aL2(j))
					p = False
					Exit For
				End If
			Next
			If p Then 
				Dim a
				a = AscW(c)
				If a > 31 And a < 127 Then
					t = t & c
				ElseIf a > -1 Or a < 65535 Then
					t = t & "\u" & String(4 - Len(Hex(a)), "0") & Hex(a)
				End If 
			End If
		Next
		JsEncode = t
	End Function
	'�����ַ�����
	Function Escape(ByVal ss)
		Dim i,c,a,s : s = ""
		If isN(ss) Then Escape = "" : Exit Function
		For i = 1 To Len(ss)
			c = Mid(ss,i,1)
			a = ASCW(c)
			If (a>=48 and a<=57) or (a>=65 and a<=90) or (a>=97 and a<=122) Then
				s = s & c
			ElseIf InStr("@*_+-./",c)>0 Then
				s = s & c
			ElseIf a>0 and a<16 Then
				s = s & "%0" & Hex(a)
			ElseIf a>=16 and a<256 Then
				s = s & "%" & Hex(a)
			Else
				s = s & "%u" & Hex(a)
			End If
		Next
		Escape = s
	End Function
	'�����ַ�����
	Function UnEscape(ByVal ss)
		Dim x, s
		x = InStr(ss,"%")
		s = ""
		Do While x>0
			s = s & Mid(ss,1,x-1)
			If LCase(Mid(ss,x+1,1))="u" Then
				s = s & ChrW(CLng("&H"&Mid(ss,x+2,4)))
				ss = Mid(ss,x+6)
			Else
				s = s & Chr(CLng("&H"&Mid(ss,x+1,2)))
				ss = Mid(ss,x+3)
			End If
			x=InStr(ss,"%")
		Loop
		UnEscape = s & ss
	End Function
	'��ʽ������ʱ��
	Function DateTime(ByVal iTime, ByVal iFormat)
		If Not IsDate(iTime) Then DateTime = "Date Error" : Exit Function
		If Instr(",0,1,2,3,4,",","&iFormat&",")>0 Then DateTime = FormatDateTime(iTime,iFormat) : Exit Function
		Dim diffs,diffd,diffw,diffm,diffy,dire,before,pastTime
		Dim iYear, iMonth, iDay, iHour, iMinute, iSecond,iWeek,tWeek
		Dim iiYear, iiMonth, iiDay, iiHour, iiMinute, iiSecond,iiWeek
		Dim iiiWeek, iiiMonth, iiiiMonth
		Dim SpecialText, SpecialTextRe,i,t
		iYear = right(Year(iTime),2) : iMonth = Month(iTime) : iDay = Day(iTime)
		iHour = Hour(iTime) : iMinute = Minute(iTime) : iSecond = Second(iTime)
		iiYear = Year(iTime) : iiMonth = right("0"&Month(iTime),2)
		iiDay = right("0"&Day(iTime),2) : iiHour = right("0"&Hour(iTime),2)
		iiMinute = right("0"&Minute(iTime),2) : iiSecond = right("0"&Second(iTime),2)
		tWeek = Weekday(iTime)-1 : iWeek = Array("��","һ","��","��","��","��","��")
		If isDate(iFormat) or isN(iFormat) Then
			If isN(iFormat) Then : iFormat = Now() : pastTime = true : End If
			dire = "��" : If DateDiff("s",iFormat,iTime)<0 Then : dire = "ǰ" : before = True : End If
			diffs = Abs(DateDiff("s",iFormat,iTime))
			diffd = Abs(DateDiff("d",iFormat,iTime))
			diffw = Abs(DateDiff("ww",iFormat,iTime))
			diffm = Abs(DateDiff("m",iFormat,iTime))
			diffy = Abs(DateDiff("yyyy",iFormat,iTime))
			If diffs < 60 Then DateTime = "�ո�" : Exit Function
			If diffs < 1800 Then DateTime = Int(diffs\60) & "����" & dire : Exit Function
			If diffs < 2400 Then DateTime = "��Сʱ"  & dire : Exit Function
			If diffs < 3600 Then DateTime = Int(diffs\60) & "����" & dire : Exit Function
			If diffs < 259200 Then
				If diffd = 3 Then DateTime = "3��" & dire & " " & iiHour & ":" & iiMinute : Exit Function
				If diffd = 2 Then DateTime = IIF(before,"ǰ�� ","���� ") & iiHour & ":" & iiMinute : Exit Function
				If diffd = 1 Then DateTime = IIF(before,"���� ","���� ") & iiHour & ":" & iiMinute : Exit Function
				DateTime = Int(diffs\3600) & "Сʱ" & dire : Exit Function
			End If
			If diffd < 7 Then DateTime = diffd & "��" & dire & " " & iiHour & ":" & iiMinute : Exit Function
			If diffd < 14 Then
				If diffw = 1 Then DateTime = IIF(before,"������","������") & iWeek(tWeek) & " " & iiHour & ":" & iiMinute : Exit Function
				If Not pastTime Then DateTime = diffd & "��" & dire : Exit Function
			End If
			If Not pastTime Then
				If diffd < 31 Then
					If diffm = 2 Then DateTime = "2����" & dire : Exit Function
					If diffm = 1 Then DateTime = IIF(before,"�ϸ���","�¸���") & iDay & "��" : Exit Function
					DateTime = diffw & "����" & dire : Exit Function
				End If
				If diffm < 36 Then
					If diffy = 3 Then DateTime = "3��" & dire : Exit Function
					If diffy = 2 Then DateTime = IIF(before,"ǰ��","����") & iMonth & "��" : Exit Function
					If diffy = 1 Then DateTime = IIF(before,"ȥ��","����") & iMonth & "��" : Exit Function
					DateTime = diffm & "����" & dire : Exit Function
				End If
				DateTime = diffy & "��" & dire : Exit Function
			Else
				iFormat = "yyyy-mm-dd hh:ii"
			End If
		End If
		iiWeek = Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
		iiiWeek = Array("Sun","Mon","Tue","Wed","Thu","Fri","Sat")
		iiiMonth = Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
		iiiiMonth = Array("January","February","March","April","May","June","July","August","September","October","November","December")
		SpecialText = Array("y","m","d","h","i","s","w")
		SpecialTextRe = Array(Chr(0),Chr(1),Chr(2),Chr(3),Chr(4),Chr(5),Chr(6))
		For i = 0 To 6 : iFormat = Replace(iFormat,"\"&SpecialText(i), SpecialTextRe(i)) : Next
		t = Replace(iFormat,"yyyy", iiYear) : t = Replace(t, "yyy", iiYear)
		t = Replace(t, "yy", iYear) : t = Replace(t, "y", iiYear)
		t = Replace(t, "mmmm", iiiiMonth(iMonth-1)) : t = Replace(t, "mmm", iiiMonth(iMonth-1))
		t = Replace(t, "mm", iiMonth) : t = Replace(t, "m", iMonth)
		t = Replace(t, "dd", iiDay) : t = Replace(t, "d", iDay)
		t = Replace(t, "hh", iiHour) : t = Replace(t, "h", iHour)
		t = Replace(t, "ii", iiMinute) : t = Replace(t, "i", iMinute)
		t = Replace(t, "ss", iiSecond) : t = Replace(t, "s", iSecond)
		t = Replace(t, "www", iiiWeek(tWeek)) : t = Replace(t, "ww", iiWeek(tWeek))
		t = Replace(t, "w", iWeek(tWeek))
		For i = 0 To 6 : t = Replace(t, SpecialTextRe(i),SpecialText(i)) : Next
		DateTime = t
	End Function
	'αRewrite�������ã���ͳ������
	Sub RewriteRule(ByVal s, ByVal u)
		If (Left(s,3)<>"^\/" And Left(s,2)<>"\/" And Left(s,2)<>"^/" And Left(s,1)<>"/") Or Left(u,1)<>"/" Then Exit Sub
		o_rwt.Add ("rule" & i_rule), Array(s,u)
		i_rule = i_rule + 1
	End Sub
	'αRewrite�������ã��Ƽ�������
	Sub Rewrite(ByVal p, ByVal s, Byval u)
		Dim rp,arr,i,rs,ru
		If Left(s,1) = "^" Then s = Mid(s,2)
		If Right(s,1) = "$" Then s = Left(s,Len(s)-1)
		arr = Split(p,"|")
		For i = 0 To Ubound(arr)
			If Left(arr(i),1) <> "/" Then Exit For
			rp = Replace(arr(i),".","\.")
			rs = "^" & rp & "\?" & s & "$"
			ru = arr(i) & "?" & u
			o_rwt.Add ("rule" & i_rule), Array(rs,ru)
			i_rule = i_rule + 1
			rp = ""
		Next
	End Sub
	'��Ȿҳ�Ƿ���Rewrite
	Function isRewrite()
		Dim rule,i
		isRewrite = False
		If Has(o_rwt) Then
			s_url = GetUrl(1)
			For Each i In o_rwt
				rule = o_rwt(i)(0)
				If Easp_Test(s_url,rule) Then
					isRewrite = True
					s_rwtS = rule
					s_rwtU = CRight(o_rwt(i)(1),"?")
					Exit For
				End If
			Next
		End If
	End Function
	'�滻Url����
	Function ReplaceUrl(ByVal p, ByVal s)
		Dim arrQs,tmp
		If isRewrite Then
			arrQs = Split(s_rwtU,"&")
			For i = 0 To Ubound(arrQs)
				If p = CLeft(arrQs(i),"=") Then
					tmp = CRight(arrQs(i),"=")
					Exit For
				End If
			Next
			If Left(tmp,1) = "$" Then
				ReplaceUrl = ReplacePart(s_url, s_rwtS, tmp, s)
			End If
		Else
			ReplaceUrl = GetUrlWith("-" & p, p & "=" & s)
		End If
	End Function
	'��ȡQueryStringֵ��֧��ȡRewriteֵ
	Function [Get](Byval s)
		Dim tmp, i, arrQs, t
		If Instr(s,":")>0 Then
		'��������Ͳ�������ȡ��Ϊt
			t = CRight(s,":") : s = CLeft(s,":")
		End If
		If isRewrite Then
		'�����Rewrite��ҳ���ַ
			arrQs = Split(s_rwtU,"&")
			For i = 0 To Ubound(arrQs)
				If s = CLeft(arrQs(i),"=") Then
					tmp = RegReplace(s_url,s_rwtS,CRight(arrQs(i),"="))
					Exit For
				End If
			Next
		Else
		'����ֱ��ȡQueryString
			tmp = Request.QueryString(s)
		End If
		[Get] = Safe(tmp,t)
	End Function
	'ȡFormֵ
	Function Post(ByVal s)
		Dim t,tmp
		If Instr(s,":")>0 Then
			t = CRight(s,":") : s = CLeft(s,":")
		End If
		tmp = Request.Form(s)
		Post = Safe(tmp,t)
	End Function
	'��ȫ��ȡֵ�°�
	Function Safe(ByVal s, ByVal t)
		Dim spl,d,l,li,i,tmp,arr() : l = False
		'�����������Ĭ��ֵ
		If Instr(t,":")>0 Then
			d = CRight(t,":") : t = CLeft(t,":")
		End If
		If Instr(",sa,da,na,", "," & Left(LCase(t),2) & ",")>0 Then
			'����зָ�����Ҫ����
			If Len(t)>2 Then
				spl = Mid(t,3) : t = LCase(Left(t,2)) : l = True
			End If
		ElseIf Instr("sdn", Left(LCase(t),1))>0 Then
			'����зָ����Ҳ�����
			If Len(t)>1 Then
				spl = Mid(t,2) : t = LCase(Left(t,1)) : l = True
			End If
		ElseIf Has(t) Then
			'���зָ���������
			spl = t : t = "" : l = True
		End If
		li = Split(s,spl)
		If l Then Redim arr(Ubound(li))
		For i = 0 To Ubound(li)
			If i<>0 Then tmp = tmp & spl
			Select Case t
				Case "s","sa"
				'�ַ�������
					If isN(li(i)) Then li(i) = d
					tmp = tmp & Replace(li(i),"'","''")
					If l Then arr(i) = Replace(li(i),"'","''")
				Case "d","da"
				'��������
					If t = "da" Then
						If Not isDate(li(i)) And Has(li(i)) Then Alert("����ȷ������ֵ��")
					End If
					tmp = IIF(isDate(li(i)), tmp & li(i), tmp & d)
					If l Then arr(i) = IIF(isDate(li(i)), li(i), d)
				Case "n","na"
				'��������
					If t = "na" Then
						If Not isNumeric(li(i)) And Has(li(i)) Then Alert("����ȷ����ֵ��")
					End If
					tmp = IIF(isNumeric(li(i)), tmp & li(i), tmp & d)
					If l Then arr(i) = IIF(isNumeric(li(i)), li(i), d)
				Case Else
				'δָ�������򲻴���
					tmp = IIF(isN(li(i)), tmp & d, tmp & li(i))
					If l Then arr(i) = IIF(isN(li(i)), d, li(i))
			End Select
		Next
		Safe = IIF(l,arr,tmp)
	End Function
	'����ύ������Դ
	Function CheckDataFrom()
		Dim v1, v2
		CheckDataFrom = False
		v1 = Cstr(rqsv("HTTP_REFERER"))
		v2 = Cstr(rqsv("SERVER_NAME"))
		If Mid(v1,8,Len(v2)) = v2 Then
			CheckDataFrom = True
		End If
	end Function
	Sub CheckDataFromA()
		If Not CheckDataFrom Then alert "��ֹ��վ���ⲿ�ύ���ݣ�"
	end Sub
	'��ȡ���ַ�����߲��ֲ���������Ŵ���
	Function CutStr(ByVal s, ByVal strlen)
		Dim l,t,i,j,d,f,n
		s = Replace(s,vbCrLf,"")
		l = len(s) : t = 0 : d = "��" : f = Easp_Param(strlen)
		If Has(f(1)) Then
			strlen = Int(f(0)) : d = f(1) : f = ""
		End If
		For j = 1 To Len(d)
			n = IIF(Abs(Ascw(Mid(d,j,1)))>255, n+2, n+1)
		Next
		strlen = strlen - n
		For i = 1 to l
			t = IIF(Abs(Ascw(Mid(s,i,1)))>255, t+2, t+1)
			If t >= strlen Then
				f = Left(s,i) & d
				Exit For
			Else
				f = s
			End If
		Next
		CutStr = f
	End Function
	'ȡ�ַ����������
	Function CLeft(ByVal s, ByVal m)
		CLeft = Easp_LR(s,m,0)
	End Function
	'ȡ�ַ��������Ҷ�
	Function CRight(ByVal s, ByVal m)
		CRight = Easp_LR(s,m,1)
	End Function
	'��ȡ��ǰ�ļ��ĵ�ַ
	Function GetUrl(param)
		Dim script_name,url,dir
		Dim out,qitem,qtemp,i,hasQS,qstring
		script_name = rqsv("SCRIPT_NAME")
		url = script_name
		dir  = Left(script_name,InstrRev(script_name,"/"))
		If isN(param) or param = "-1" Then
			Dim ustart,uport
			If rqsv("HTTPS")="on" Then
				ustart = "https://"
				uport = IIF(Int(rqsv("SERVER_PORT"))=443,"",":"&rqsv("SERVER_PORT"))
			Else
				ustart = "http://"
				uport = IIF(Int(rqsv("SERVER_PORT"))=80,"",":"&rqsv("SERVER_PORT"))
			End If
			url = ustart & rqsv("SERVER_NAME") & uport
			If isN(param) Then
				url = url & script_name
			Else
				GetUrl = url : Exit Function
			End If
			If Has(s_rq) Then url = url & "?" & s_rq
			GetUrl = url : Exit Function
		End If
		If param = "0" Then : GetUrl = url : Exit Function
		If param = "2" Then : GetUrl = dir : Exit Function
		If InStr(param,":")>0 Then
			url = dir
			out = Mid(param,2)
			hasQS = IIF(isN(out),0,1)
		Else
			out = param : hasQS = 1
		End If
		If Has(s_rq) Then
			If param="1" Or hasQS = 0 Then
				url = url & "?" & s_rq
			Else
				qtemp = "" : i = 0 : out = ","&out&","
				qstring = IIF(InStr(out,"-")>0,"Not InStr(out,"",-""&qitem&"","")>0","InStr(out,"",""&qitem&"","")>0")
				For Each qitem In Request.QueryString()
					If Eval(qstring) Then
						If i<>0 Then qtemp = qtemp & "&"
						qtemp = qtemp & qitem & "=" & Request.QueryString(qitem)
						i = i + 1
					End If
				Next
				If Has(qtemp) Then url = url & "?" & qtemp
			End If
		End If
		GetUrl = url
	End Function
	'��ȡ��ҳURL�����������µ�URL����
	Function GetUrlWith(ByVal p, ByVal v)
		Dim u,s,n
		s = IIF(p=-1,GetUrl(-1)&"/","")
		s = IIF(IsN(p),GetUrl(""),GetUrl(0))
		If Instr(p,":")>0 Then
			If Has(CLeft(p,":")) Then
				n = Cleft(p,":") : p = CRight(p,":")
			End If
		End If
		u = GetUrl(p)
		If Left(p,1)=":" Then s = Left(u,InstrRev(u,"/"))
		u = u & IfThen(Has(v),IIF(isN(Mid(u,len(s)+1)),"?","&") & v)
		If Has(n) Then
			If Instr(u,"?")>0 Then
				u = n & Mid(u,Instr(u,"?"))
			Else
				u = n
			End If
		End If
		GetUrlWith = u
	End Function
	'��ȡ�û�IP��ַ
	Function GetIP()
		Dim addr, x, y
		x = rqsv("HTTP_X_FORWARDED_FOR")
		y = rqsv("REMOTE_ADDR")
		addr = IIF(isN(x) or lCase(x)="unknown",y,x)
		If InStr(addr,".")=0 Then addr = "0.0.0.0"
		GetIP = addr
	End Function
	'����ʽ��HTML�ı����ɴ�HTML��ǩ��
	Function HtmlFormat(ByVal s)
		If Has(s) Then
			Dim m,Match : Set m = RegMatch(s, "<([^>]+)>")
			For Each Match In m
				 s = Replace(s, Match.SubMatches(0), regReplace(Match.SubMatches(0), "\s+", Chr(0)))
			Next
			Set m = Nothing
			s = Replace(s, Chr(32), "&nbsp;")
			s = Replace(s, Chr(9), "&nbsp;&nbsp; &nbsp;")
			s = Replace(s, Chr(0), " ")
			s = regReplace(s, "(<[^>]+>)\s+", "$1")
			s = Replace(s, vbCrLf, "<br />")
		End If
		HtmlFormat = s
	End Function
	'HTML���뺯��
	Function HtmlEncode(ByVal s)
		If Has(s) Then
			s = Replace(s, Chr(38), "&#38;")
			s = Replace(s, "<", "&lt;")
			s = Replace(s, ">", "&gt;")
			s = Replace(s, Chr(39), "&#39;")
			s = Replace(s, Chr(32), "&nbsp;")
			s = Replace(s, Chr(34), "&quot;")
			s = Replace(s, Chr(9), "&nbsp;&nbsp; &nbsp;")
			s = Replace(s, vbCrLf, "<br />")
		End If
		HtmlEncode = s
	End Function
	'HTML���뺯��
	Function HtmlDecode(ByVal s)
		If Has(s) Then
			s = regReplace(s, "<br\s*/?\s*>", vbCrLf)
			s = Replace(s, "&nbsp;&nbsp; &nbsp;", Chr(9))
			s = Replace(s, "&quot;", Chr(34))
			s = Replace(s, "&nbsp;", Chr(32))
			s = Replace(s, "&#39;", Chr(39))
			s = Replace(s, "&apos;", Chr(39))
			s = Replace(s, "&gt;", ">")
			s = Replace(s, "&lt;", "<")
			s = Replace(s, "&amp;", Chr(38))
			s = Replace(s, "&#38;", Chr(38))
			HtmlDecode = s
		End If
	End Function
	'����HTML��ǩ
	Function HtmlFilter(ByVal s)
		s = regReplace(s,"<[^>]+>","")
		s = Replace(s, ">", "&gt;")
		HtmlFilter = Replace(s, "<", "&lt;")
	End Function
	'��ȷ������Ľű�ִ��ʱ��
	Function GetScriptTime(t)
		If t = "" Or t = "0" Then t = Easp_Timer
		GetScriptTime = FormatNumber((Timer()-t)*1000, 2, -1)
	End Function
	'ȡָ�����ȵ�����ַ���
	Function RandStr(ByVal cfg)
		Dim a, p, l, t, reg, m, mi, ma
		cfg = Replace(Replace(Replace(cfg,"\<",Chr(0)),"\>",Chr(1)),"\:",Chr(2))
		a = ""
		If Easp_Test(cfg, "(<\d+>|<\d+-\d+>)") Then
			t = cfg
			p = Easp_Param(cfg)
			If Not isN(p(1)) Then
				a = p(1) : t = p(0) : p = ""
			End If
			Set reg = RegMatch(cfg, "(<\d+>|<\d+-\d+>)")
			For Each m In reg
				p = m.SubMatches(0)
				l = Mid(p,2,Len(p)-2)
				If Easp_Test(l,"^\d+$") Then
					t = Replace(t,p,Easp_RandString(l,a),1,1)
				Else
					mi = CLeft(l,"-")
					ma = CRight(l,"-")
					t =  Replace(t,p,Rand(mi, ma),1,1)
				End If
			Next
			Set reg = Nothing
		ElseIf Easp_Test(cfg,"^\d+-\d+$") Then
			mi = CLeft(cfg,"-")
			ma = CRight(cfg,"-")
			t = Rand(mi, ma)
		ElseIf Easp_Test(cfg, "^(\d+)|(\d+:.)$") Then
			l = cfg : p = Easp_Param(cfg)
			If Not isN(p(1)) Then
				a = p(1) : l = p(0) : p = ""
			End If
			t = Easp_RandString(l, a)
		Else
			t = cfg
		End If
		RandStr = Replace(Replace(Replace(t,Chr(0),"<"),Chr(1),">"),Chr(2),":")
	End Function
	Private Function Easp_RandString(ByVal length, ByVal allowStr)
		Dim i
		If IsN(allowStr) Then allowStr = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		For i = 1 To length
			Randomize() : Easp_RandString = Easp_RandString & Mid(allowStr, Int(Len(allowStr) * Rnd + 1), 1)
		Next
	End Function
	'ȡһ�������
	Function Rand(ByVal min, ByVal max)
		Randomize() : Rand = Int((max - min + 1) * Rnd + min)
	End Function
	'��ʽ������
	Function toNumber(ByVal n, ByVal d)
		toNumber = FormatNumber(n,d,-1)
	End Function
	'������ת��Ϊ���Ҹ�ʽ
	Function toPrice(ByVal n)
		toPrice = FormatCurrency(n,2,-1,0,-1)
	End Function
	'������ת��Ϊ�ٷֱȸ�ʽ
	Function toPercent(ByVal n)
		toPercent = FormatPercent(n,2,-1)
	End Function
	'�رն����ͷ���Դ
	Sub C(ByRef o)
		On Error Resume Next
		o.Close() : Set o = Nothing
		Err.Clear()
	End Sub
	'������ҳ����Ϣ
	Sub noCache()
		Response.Buffer = True
		Response.Expires = 0
		Response.ExpiresAbsolute = Now() - 1
		Response.CacheControl = "no-cache"
		Response.AddHeader "Expires",Date()
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Cache-Control","private, no-cache, must-revalidate"
	End Sub
	'����һ��Cookiesֵ
	Sub SetCookie(ByVal cooName, ByVal cooValue, ByVal cooCfg)
		Dim n,i,cExp,cDomain,cPath,cSecure
		If isArray(cooCfg) Then
			For i = 0 To Ubound(cooCfg)
				If isDate(cooCfg(i)) Then
					cExp = cDate(cooCfg(i))
				ElseIf Test(cooCfg(i),"int") Then
					If cooCfg(i)<>0 Then cExp = Now()+Int(cooCfg(i))/60/24
				ElseIf Test(cooCfg(i),"domain") or Test(cooCfg(i),"ip") Then
					cDomain = cooCfg(i)
				ElseIf Instr(cooCfg(i),"/")>0 Then
					cPath = cooCfg(i)
				ElseIf cooCfg(i)="True" or cooCfg(i)="False" Then
					cSecure = cooCfg(i)
				End If
			Next
		Else
			If isDate(cooCfg) Then
				cExp = cDate(cooCfg)
			ElseIf Test(cooCfg,"int") Then
				If cooCfg<>0 Then cExp = Now()+Int(cooCfg)/60/24
			ElseIf Test(cooCfg,"domain") or Test(cooCfg,"ip") Then
				cDomain = cooCfg
			ElseIf Instr(cooCfg,"/")>0 Then
				cPath = cooCfg
			ElseIf cooCfg = "True" or cooCfg = "False" Then
				cSecure = cooCfg
			End If
		End If
		If Has(cooValue) Then
			If b_cooen Then
				Use("Aes") : cooValue = Aes.Encode(cooValue)
			End If
		End If
		If Instr(cooName,">")>0 Then
			n = CRight(cooName,">")
			cooName = CLeft(cooName,">")
			Response.Cookies(cooName)(n) = cooValue
		Else
			Response.Cookies(cooName) = cooValue
		End If
		If Has(cExp) Then Response.Cookies(cooName).Expires = cExp
		If Has(cDomain) Then Response.Cookies(cooName).Domain = cDomain
		If Has(cPath) Then Response.Cookies(cooName).Path = cPath
		If Has(cSecure) Then Response.Cookies(cooName).Secure = cSecure
	End Sub
	'��ȡһ��Cookiesֵ
	Function Cookie(ByVal s)
		Dim p,t,coo
		If Instr(s,">") > 0 Then
			p = CLeft(s,">")
			s = CRight(s,">")
		End If
		If Instr(s,":")>0 Then
			t = CRight(s,":")
			s = CLeft(s,":")
		End If
		If Has(p) And Has(s) Then
			If Response.Cookies(p).HasKeys Then
				coo = Request.Cookies(p)(s)
			End If
		ElseIf Has(s) Then
			coo = Request.Cookies(s)
		Else
			Cookie = "" : Exit Function
		End If
		If IsN(coo) Then Cookie = "": Exit Function
		If  b_cooen Then
			Use("Aes") : coo = Aes.Decode(coo)
		End If
		Cookie = Safe(coo,t)
	End Function
	'ɾ��һ��Cookiesֵ
	Sub RemoveCookie(ByVal s)
		Dim p,t
		If Instr(s,">") > 0 Then
			p = CLeft(s,">")
			s = CRight(s,">")
		End If
		If Has(p) And Has(s) Then
			If Response.Cookies(p).HasKeys Then
				Response.Cookies(p)(s) = Empty
			End If
		ElseIf Has(s) Then
			Response.Cookies(s) = Empty
			Response.Cookies(s).Expires = Now()
		End If
	End Sub
	'���û����¼
	Sub SetApp(AppName,AppData)
		Application.Lock
		Application.Contents.Item(AppName) = AppData
		Application.UnLock
	End Sub
	'��ȡһ�������¼
	Function GetApp(AppName)
		If IsN(AppName) Then GetApp = "" : Exit Function
		GetApp = Application.Contents.Item(AppName)
	End Function
	'ɾ��һ�������¼
	Sub RemoveApp(AppName)
		Application.Lock
		Application.Contents.Remove(AppName)
		Application.UnLock
	End Sub
	'��֤����֤����
	Private Function isIDCard(ByVal s)
		Dim Ai, BirthDay, arrVerifyCode, Wi, i, AiPlusWi, modValue, strVerifyCode
		isIDCard = False
		If Len(s) <> 15 And Len(s) <> 18 Then Exit Function
		Ai = IIF(Len(s) = 18,Mid(s, 1, 17),Left(s, 6) & "19" & Mid(s, 7, 9))
		If Not IsNumeric(Ai) Then Exit Function
		If Not Test(Left(Ai,6),"^(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|8[12]|91)\d{2}[01238]\d{1}$") Then Exit Function
		BirthDay = Mid(Ai, 7, 4) & "-" & Mid(Ai, 11, 2) & "-" & Mid(Ai, 13, 2)
		If IsDate(BirthDay) Then
			If cDate(BirthDay) > Date() Or cDate(BirthDay) < cDate("1870-1-1") Then  Exit Function
		Else
			Exit Function
		End If
		arrVerifyCode = Split("1,0,x,9,8,7,6,5,4,3,2", ",")
		Wi = Split("7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2", ",")
		For i = 0 To 16
			AiPlusWi = AiPlusWi + CInt(Mid(Ai, i + 1, 1)) * Wi(i)
		Next
		modValue = AiPlusWi Mod 11
		strVerifyCode = arrVerifyCode(modValue)
		Ai = Ai & strVerifyCode
		If Len(s) = 18 And LCase(s) <> Ai Then Exit Function
		isIDCard = True
	End Function
	'���׵ķ���˼�����
	Function CheckForm(ByVal s, ByVal Rule, ByVal Require, ByVal ErrMsg)
		Dim tmpMsg, Msg, i
		tmpMsg = Replace(ErrMsg,"\:",chr(0))
		Msg = IIF(Instr(tmpMsg,":")>0,Split(tmpMsg,":"),Array("����Ŀ����Ϊ��",tmpMsg))
		If Require = 1 And IsN(s) Then
			If Instr(tmpMsg,":")>0 Then
				Alert Replace(Msg(0),chr(0),":") : Exit Function
			Else
				Alert Replace(tmpMsg,chr(0),":") : Exit Function
			End If
		End If
		If Not (Require = 0 And isN(s)) Then
			If Left(Rule,1)=":" Then
				pass = False
				arrRule = Split(Mid(Rule,2),"||")
				For i = 0 To Ubound(arrRule)
					If Test(s,arrRule(i)) Then pass = True : Exit For
				Next
				If Not pass Then Alert(Replace(Msg(1),chr(0),":")) : Exit Function
			Else
				If Not Test(s,Rule) Then Alert(Replace(Msg(1),chr(0),":")) : Exit Function
			End If
		End If
		CheckForm = s
	End Function
	'����������֤���
	Function [Test](ByVal s, ByVal p)
		Dim Pa
		Select Case Lcase(p)
			Case "date"		[Test] = IIF(isDate(s),True,False) : Exit Function
			Case "idcard"	[Test] = IIF(isIDCard(s),True,False) : Exit Function
			Case "english"	Pa = "^[A-Za-z]+$"
			Case "chinese"	Pa = "^[\u0391-\uFFE5]+$"
			Case "username"	Pa = "^[a-zA-Z]\w{2,19}$"
			Case "email"	Pa = "^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
			Case "int"		Pa = "^[-\+]?\d+$"
			Case "number"	Pa = "^\d+$"
			Case "double"	Pa = "^[-\+]?\d+(\.\d+)?$"
			Case "price"	Pa = "^\d+(\.\d+)?$"
			Case "zip"		Pa = "^[1-9]\d{5}$"
			Case "qq"		Pa = "^[1-9]\d{4,9}$"
			Case "phone"	Pa = "^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$"
			Case "mobile"	Pa = "^((\(\d{2,3}\))|(\d{3}\-))?(1[35][0-9]|189)\d{8}$"
			Case "url"		Pa = "^(http|https|ftp):\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\""])*$"
			Case "domain"	Pa = "^[A-Za-z0-9\-\.]+\.([A-Za-z]{2,4}|[A-Za-z]{2,4}\.[A-Za-z]{2})$"
			Case "ip"		Pa = "^(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5])$"
			Case Else Pa = p
		End Select
		[Test] = Easp_Test(CStr(s),Pa)
	End Function
	'�����滻
	Function regReplace(ByVal s, ByVal rule, Byval Result)
		regReplace = Easp_Replace(s,rule,Result,0)
	End Function
	'�����滻����ģʽ
	Function regReplaceM(ByVal s, ByVal rule, Byval Result)
		regReplaceM = Easp_Replace(s,rule,Result,1)
	End Function
	'����ƥ�䲶��
	Function regMatch(ByVal s, ByVal rule)
		o_regex.Pattern = rule
		Set regMatch = o_regex.Execute(s)
		o_regex.Pattern = ""
	End Function
	'�滻�������
	Function replacePart(ByVal txt, ByVal rule, ByVal part, ByVal replacement)
		If Not Easp_Test(txt, rule) Then
			replacePart = "[not match]"
			Exit Function
		End If
		Dim Match,i,j,ma,pos,uleft,ul
		i = Int(Mid(part,2))-1
		Set Match = RegMatch(txt,rule)(0)
		For j = 0 To Match.SubMatches.Count-1
			ma = Match.SubMatches(j)
			pos = Instr(txt,ma)
			If pos > 0 Then
				ul = Left(txt,pos-1)
				txt = Mid(txt,Len(ul)+1)
				If i = j Then
					replacePart = uleft & ul & Replace(txt,ma,replacement,pos-len(ul),1,0)
					Exit For
				End If
				uleft = uleft & ul & ma
				txt = Mid(txt, Len(ma)+1)
			End If
		Next
		Set Match = Nothing
	End Function
	'�������Ƿ�װ
	Function isInstall(Byval s)
		On Error Resume Next : Err.Clear()
		isInstall = False
		Dim obj : Set obj = Server.CreateObject(s)
		If Err.Number = 0 Then isInstall = True
		Set obj = Nothing : Err.Clear()
	End Function
	'��̬�����ļ�
	Sub Include(ByVal filePath)
		On Error Resume Next
		ExecuteGlobal GetIncCode(IncRead(filePath),0)
		If Err.Number<>0 Then
			[error].Msg = " ( " & filePath & " )"
			[error].Raise 1
		End If
		Err.Clear()
	End Sub
	Function getInclude(ByVal filePath)
		On Error Resume Next
		ExecuteGlobal GetIncCode(IncRead(filePath),1)
		getInclude = EasyAsp_s_html
		If Err.Number<>0 Then
			[error].Msg = " ( " & filePath & " )"
			[error].Raise 1
		End If
		Err.Clear()
	End Function
	'��ȡ�ļ�����
	Function Read(ByVal filePath)
		Dim Fso, p, f, tmpStr,o_strm
		p = filePath
		If Not (Mid(filePath,2,1)=":") Then p = Server.MapPath(filePath)
		Set Fso = Server.CreateObject(s_fsoName)
		If Fso.FileExists(p) Then
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
			tmpStr = "�ļ�δ�ҵ�:" & filePath
		End If
		Set Fso = Nothing
		Read = tmpStr
	End Function
	'��ȡ�����ļ����ݣ����޼���
	Private Function IncRead(ByVal filePath)
		Dim content, rule, inc, incFile, incStr
		content = Read(filePath)
		If isN(content) Then Exit Function
		content = regReplace(content,"<% *?@.*?%"&">","")
		content = regReplace(content,"(<%[^>]+?)(option +?explicit)([^>]*?%"&">)","$1'$2$3")
		rule = "<!-- *?#include +?(file|virtual) *?= *?""??([^"":?*\f\n\r\t\v]+?)""?? *?-->"
		If Easp_Test(content,rule) Then
			Set inc = regMatch(content,rule)
			For Each Match In inc
				If LCase(Match.SubMatches(0))="virtual" Then
					incFile = Match.SubMatches(1)
				Else
					incFile = Mid(filePath,1,InstrRev(filePath,IIF(Instr(filePath,":")>0,"\","/"))) & Match.SubMatches(1)
				End If
				incStr = IncRead(incFile)
				content = Replace(content,Match,incStr)
			Next
			Set inc = Nothing
		End If
		IncRead = content
	End Function
	'���ı�����ת��ΪASP����
	Function GetIncCode(ByVal content, ByVal getHtml)
		Dim tmpStr,code,tmpCode,s_code,st,en
		code = "" : st = 1 : en = Instr(content,"<%") + 2
		s_code = IIF(getHtml=1,"EasyAsp_s_html = EasyAsp_s_html & ","Response.Write ")
		While en > st + 1
			tmpStr = Mid(content,st,en-st-2)
			st = Instr(en,content,"%"&">") + 2
			If Has(tmpStr) Then
				tmpStr = Replace(tmpStr,"""","""""")
				tmpStr = Replace(tmpStr,vbCrLf,"""&vbCrLf&""")
				code = code & s_code & """" & tmpStr & """" & vbCrLf
			End If
			tmpStr = Mid(content,en,st-en-2)
			tmpCode = regReplace(tmpStr,"^\s*=\s*",s_code) & vbCrLf
			If getHtml = 1 Then
				tmpCode = regReplaceM(tmpCode,"response\.write([\( ])", s_code & "$1") & vbCrLf
				tmpCode = regReplaceM(tmpCode,"Easp\.(WC|WN|W)([\( ])", s_code & "$2") & vbCrLf
			End If
			code = code & tmpCode
			en = Instr(st,content,"<%") + 2
		Wend
		tmpStr = Mid(content,st)
		If Has(tmpStr) Then
			tmpStr = Replace(tmpStr,"""","""""")
			tmpStr = Replace(tmpStr,vbcrlf,"""&vbCrLf&""")
			code = code & s_code & """" & tmpStr & """" & vbCrLf
		End If
		If getHtml = 1 Then code = "EasyAsp_s_html = """" " & vbCrLf & code
		GetIncCode = regReplace(code,"(\n\s*\r)+",vbCrLf)
	End Function
	'��������EasyAsp����
	Sub Use(ByVal f)
		Dim p, o, t : o = f
		p = "easp." & Lcase(o) & ".asp"
		If LCase(o) = "md5" Then o = "o_md5"
		t = Eval("LCase(TypeName("&o&"))")
		If t = "easyasp_obj" Then
			Include s_path & "core/" & p
			Execute("Set "&o&" = New EasyAsp_"&f)
		End If
	End Sub
	'���ز��
	Function Ext(ByVal f)
		Dim loaded
		f = Lcase(f) : loaded = True
		If Not o_ext.Exists(f) Then
			loaded = False
		Else
			If LCase(TypeName(o_ext(f))) <> "easyasp_" & f Then loaded = False
		End If
		If Not loaded Then
			Include(s_plugin & "easp." & f & ".asp")
			Execute("Set o_ext(""" & f & """) = New EasyAsp_" & f)
		End If
		Set Ext = o_ext(f)
	End Function
	'������ز��
	Private Sub ClearExt()
		Dim i
		If Has(o_ext) Then
			For Each i In o_ext
				Set o_ext(i) = Nothing
			Next
			o_ext.RemoveAll
		End If
	End Sub
	'Md5�����ַ���
	Function MD5(ByVal s)
		Use("Md5") : MD5 = o_md5(s)
	End Function
	Function MD5_16(ByVal s)
		Use("Md5") : MD5_16 = o_md5.To16(s)
	End Function
	'���Ժ���
	Sub Trace(ByVal o)
		Dim s,i,j
		Select Case VarType(o)
			Case vbEmpty, vbNull
				s = "[Empty]"
			Case vbString
				s = IIF(o="","[Empty String]",htmlEncode(o))
			Case vbObject
				Select Case TypeName(o)
					Case "Nothing","Empty"
						s = "[Empty Object]"
					Case "Recordset"
						If o.State = 0 Then
							s = "[Closed Recordset]"
						Else
							If o.Bof And o.Eof Then
								s = "[Empty Recordset]"
							Else
								Set o = o.Clone
								s = "<h3>[RecordSet]</h3>"
								o.MoveFirst
								While i<10 And Not o.Eof
									For j = 0 To o.Fields.Count-1
										s = s & "<b>" &  o.Fields(j).Name & "</b>" & ": " & htmlEncode(o.Fields(j).Value) & "<br />"
									Next
									s = s & "<br />--------------------<br /><br />"
									i = i + 1
									o.MoveNext
								Wend
							End If
						End If
					Case "Dictionary"
						If o.Count = 0 Then
							s = "[Empty Dictionary]"
						Else
							s = "<h3>[Dictionary]</h3>"
							For Each i In o
								s = s & "<b>" & i & "</b>" & ": " & htmlEncode(o(i)) & "<br />"
							Next
						End If
				End Select
			Case vbArray,8194,8204,8209
				If Ubound(o) = -1 Then
					s = "[Empty Array]"
				Else
					s = "<h3>[Array]</h3>"
					s = htmlEncode(Join(o,", "))
				End If
		End Select
		W s
	End Sub
	Private Function Easp_Test(ByVal s, ByVal p)
		If IsN(s) Then Easp_Test = False : Exit Function
		o_regex.Pattern = p
		Easp_Test = o_regex.Test(CStr(s))
		o_regex.Pattern = ""
	End Function
	Private Function Easp_Replace(ByVal s, ByVal rule, Byval Result, ByVal isM)
		Dim tmpStr,Reg : tmpStr = s
		If Has(s) Then
			If isM = 1 Then o_regex.Multiline = True
			o_regex.Pattern = rule
			tmpStr = o_regex.Replace(tmpStr,Result)
			If isM = 1 Then o_regex.Multiline = False
			o_regex.Pattern = ""
		End If
		Easp_Replace = tmpStr
	End Function
	'ȡ�ַ�������ͷ
	Private Function Easp_LR(ByVal s, ByVal m, ByVal t)
		Dim n : n = Instr(s,m)
		If n>0 Then
			If t = 0 Then
				Easp_LR = Left(s,n-1)
			ElseIf t = 1 Then
				Easp_LR = Mid(s,n+1)
			End If
		Else
			Easp_LR = s
		End If
	End Function
End Class
Class EasyAsp_obj : End Class

Private Function Easp_Param(ByVal s)
	Dim arr(1),t : t = Instr(s,":")
	If t > 0 Then
		arr(0) = Left(s,t-1) : arr(1) = Mid(s,t+1)
	Else
		arr(0) = s : arr(1) = ""
	End If
	Easp_Param = arr
End Function
%>
<!--#include file="core/easp.error.asp"-->
<!--#include file="core/easp.db.asp"-->
<!--#include file="core/easp.tpl.asp"-->