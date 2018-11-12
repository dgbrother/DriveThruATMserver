<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*"%>

<% request.setCharacterEncoding("utf-8"); %>

<% response.setContentType("text/html; charset=utf-8"); %>

<html>

<head>

<title>JSP Example</title>

</head>

<body>

<p>

<% 

 String number = request.getParameter("number");

 String id = request.getParameter("id");

 String comment = request.getParameter("comment");

 

 HashMap<String,String> map = new HashMap<String,String>();

	map.put("number",number);

	map.put("id",id);

	map.put("comment",comment);

%>

  글번호:<%=map.get("number")%><br>

  아이디:<%=map.get("id")%><br>

  코멘트:<%=map.get("comment")%><br>

<%



%>

</p>

</body>

</html>