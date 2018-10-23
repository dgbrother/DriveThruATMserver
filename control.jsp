<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");

String type = request.getParameter("type");
String action = request.getParameter("action");

switch(type) {
case "user":
    // 유저 정보 조회, 유저 정보 수정
    switch(action) {
        case "select":
            pageContext.forward("test_UserInfo.jsp");
            break;
        case "update":
            pageContext.forward("test_UserUpdate.jsp");
            break;
    }
    break;

case "reservation":
    // 예약 정보 조회, 예약 정보 추가, 예약 정보 수정
    switch(action) {
        case "select":
            pageContext.forward("test_ReserveInfo.jsp");
            break;
        case "update":
            pageContext.forward("test_ReserveUpdate.jsp");
            break;
    }
    break;

case "arrived":
    break;
}
%>
