<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%><!--#include virtual="/easp/easp.asp" --><%
Easp.Use "Http"
Dim http, tmp
'=========================
'最简单的应用：
'Set http = Easp.Http.New()
'直接获取页面源码
'tmp = http.Get("http://easp.lengshi.com/docs/easp.db._conn.html")
'Easp.WE tmp
'=========================

'通过属性配置
'Set http = Easp.Http.New()
'http.Url = "http://bbs.lengshi.com/index.aspx?login"	'目标URL地址
'http.Method = "POST"  'GET 或者 POST, 默认GET
'http.Async = False	'异步，默认False
'http.Charset = "gb2312"	'目标URL的编码
'http.Data = "username=myname&password=mypass"	'同时要提交的数据，如果是GET则会附在URL后以参数形式提交
'http.Data = Array("username:coldstone", "password:123321")	'可以用Array参数的方式提交数据
'http.User = ""	'如果访问目标URL需要用户名
'http.Password = ""	'如果访问目标URL需要密码

'Set http = Easp.Http.New()
'http.CharSet = "GB2312"
'tmp = http.Get("http://www.cnbeta.com/articles/110634.htm")
'tmp = Easp.GetImg(tmp)
'Easp.Trace tmp
'Set http = Nothing

Dim s,re,ma,i
Easp.Http.Get "http://code.google.com/p/easyasp/updates/list"
's = Easp.Http.Search("<span class=""date below-more"" title=""(.+?)""[\s\S]+?>(.+?)</span>[\s\S]+?<span class=""title""><a class=""ot-revision-link"" href=""/p/easyasp/source/detail\?r=(?:\d+?)"">(r\d+?)</a>\n \(([\s\S]+?)\).+>(\w+?)</a></span>")
'For i = 0 To Ubound(s)
'	Easp.WN Easp.HtmlEncode(s(i))
'	Easp.wn "======================================="
'Next
's = Easp.Http.Find("<span class=""date below-more"" title=""(.+?)""[\s\S]+?>(.+?)</span>[\s\S]+?<span class=""title""><a class=""ot-revision-link"" href=""/p/easyasp/source/detail\?r=(?:\d+?)"">(r\d+?)</a>\n \(([\s\S]+?)\).+>(\w+?)</a></span>")
's = Easp.Http.SubStr("<span class=""date below-more"" title=""Fri Aug 13 02:47:39 2010""","r199</a>",0)
Easp.WN Easp.HtmlEncode(s)

's = Easp.Http.Get("http://code.google.com/p/easyasp/updates/list")
'Set re = Easp.RegMatch(s,"<span class=""date below-more"" title=""(.+?)""[\s\S]+?>(.+?)</span>[\s\S]+?<span class=""title""><a class=""ot-revision-link"" href=""/p/easyasp/source/detail\?r=(?:\d+?)"">(r\d+?)</a>\n \(([\s\S]+?)\).+>(\w+?)</a></span>")
'Easp.WN "Easp's Update Log:"
'For Each ma In re
'	If ma.SubMatches(3)<>"[No log message]" Then Easp.WN Easp.Format("<li>{3}, {4} ({5} @ {2})</li>",ma)
'Next
'Set re = Nothing

Easp.WN ""
Easp.wn "------------------------------------"
Easp.w "页面执行时间： " & Easp.ScriptTime & " 秒"
Set Easp = Nothing
%>