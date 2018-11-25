<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");

String button = request.getParameter("button");
String result = "button is "+button+ " clicked.";
out.println(result);
%>
