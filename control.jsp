<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");

String function = request.getParameter("function");
switch(function) {
    case "userInfo":
        pageContext.forward("test.jsp");
        break;
    case "atmReservedWorks":
	pageContext.forword("ATMReservedWorks");
	break;
}
%>
