<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");

// action : select(User 정보 조회), update(User 정보 업데이트)
String function = request.getParameter("function");

switch(function) {
    case "user_info":
        String url = "http://35.200.117.1:8080/user_info.jsp";
        pageContext.forword(url);
        break;
}

conn.close();
%>
