<%@ page contentType="text/html;charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	String test = "success!";
	String param = request.getParameter("param");
%>
요청 param is <%=request.getParameter("param") %>
