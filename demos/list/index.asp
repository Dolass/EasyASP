<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%><!--#include virtual="/easp/easp.asp" --><%
'先构造一个随机数组
Dim arrayA(19),i
For i = 0 To 19
	arrayA(i) = Easp.RandStr(Easp.Rand(0,6)&":abcdeABCDE1234567890")
Next
Dim list, list1, list2
'加载List核心
Easp.Use "List"
'创建一个List对象
Set list = Easp.List.New
'忽略大小写(去重复项、搜索、取索引值、排序时)
'list.IgnoreCase = False
'把数组存入List对象管理
'list.Data = arrayA
list.Data = "aa a ee ddd A AA aa Ab ab a bb b  bb c ccc  ddd b d"
Easp.WN "初始数组为：" & list.ToString
'去除重复元素
list.Uniq
Easp.WN "去除重复元素后为：" & list.ToString
Easp.WN "是否包含字符串 bb ：" & list.Has("bb") & "，在数组中第1次出现的下标是：" & list.IndexOf("bb")
'取值
Easp.WN "下标为3的元素为：" & list.At(3)
'赋值
list.At(3) = "three"
'list.At(n)可以简写为 list(n)
Easp.WN "下标为5的元素为：" & list(5)
list(5) = "five"
'可以向超过当前最大下标的元素赋值，相当于添加元素
list(22) = "this22"
Easp.WN "添加和更改元素后的数组为：" & list.ToString
Easp.WN "数组的长度（元素个数）是：" & list.Size
Easp.WN "数组的有效长度（非空值）是：" & list.Count
'去除空元素
list.Compact
Easp.WN "去除所有空元素的结果是：" & list.ToString
Easp.WN "数组的最大值是：" & list.Max
Easp.WN "数组的最小值是：" & list.Min
Easp.WN "数组的第一个元素是：" & list.First
Easp.WN "数组的最后一个元素是：" & list.Last
'排序
list.Sort
Easp.WN "将数组排序后的结果是：" & list.ToString
'反向
list.Reverse
Easp.WN "将数组反向排列结果是：" & list.ToString
'随机排序
list.Rand
Easp.WN "将数随机排序结果是：" & list.ToString
'删除指定下标项
list.Delete 12
Easp.WN "删除下标为12的元素后结果是：" & list.ToString
Set list1 = list.Clone
'因为Search方法会更改当前的List对象，所以这里复制为新list对象操作
list1.Search("a")
Easp.WN "数组中包含字符串 a 的元素：" & list1.ToString
Set list1 = list.Clone
list1.SearchNot("a")
Easp.WN "数组中不包含字符串 a 的元素：" & list1.ToString
Easp.C(list1)
Easp.WN "=========="
'取得数组的其中一部分（按下标），返回一个新的List对象
'可取多个元素，用逗号隔开，可以用 - 表示范围（如2-5表示第2到第5下标，\s表示开头，\e表示结尾）
Set arr = list.Get("1,3,7-\e")
Easp.WN "取得下标为1,3,7-\e的新数组为：" & arr.ToString
Easp.WN "新数组的长度是：" & arr.Length
Easp.WN "用 | 符号连接起是：" & arr.J("|")
'删除第一个元素
arr.Shift
'添加一个元素到开头
arr.UnShift "first"
'删除最后一个元素
arr.Pop
'添加一个元素到最后
arr.Push "last"
'插入一个元素到指定下标
arr.Insert 4, "four"
Easp.WN "删除和添加元素后是：" & arr.ToString
'删除多个元素，用逗号隔开，可以用 - 表示范围（如2-5表示第2到第5下标，\s表示开头，\e表示结尾）
arr.Delete "\s-2,5-\e"
Easp.WN "删除\s-2,5-\e后是：" & arr.ToString
Easp.C(arr)
Easp.WN "=========="

Easp.wn "---遍历现在的List---"
For i = 0 To list.End
	Easp.WN "list("&i&") 的值是：" & list(i)
Next
Easp.WN "=========="

Easp.wn "---取出为普通数组后再遍历---"
arr = list.Data
For i = 0 To Ubound(arr)
	Easp.WN "arr("&i&") 的值是：" & arr(i)
Next

Easp.wn "------------------------------------"
Easp.w "页面执行时间： " & Easp.ScriptTime & " 秒"
Set list = Nothing
Set Easp = Nothing
%>