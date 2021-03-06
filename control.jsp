<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");

String type = request.getParameter("type");
String action = request.getParameter("action");

switch(type) {

case "user":
    switch(action) {
        case "login":
            pageContext.forward("login.jsp");
            break;
        case "select":
            pageContext.forward("UserInfo.jsp");
            break;
        case "update":
            pageContext.forward("UserUpdate.jsp");
            break;
        default:
    }
    break;

case "reservation":
    switch(action) {
        case "insert":
            pageContext.forward("ReserveInsert.jsp");
            break;
        case "select":
            pageContext.forward("ReserveInfo.jsp");
            break;
        case "update":
            pageContext.forward("ReserveUpdate.jsp");
            break;
        case "execute":
            pageContext.forward("ReservationExecute.jsp");
            break;
        case "execute_deposit":
            pageContext.forward("DepositExecute.jsp");
            break;
    }
    break;

case "notification":
    switch(action) {
        case "carEntry":
            pageContext.forward("CarEnterence.jsp");
            break;
        case "nfcTag":
            pageContext.forward("NFCTag.jsp");
            break;
    }
    break;

case "banking":
    switch(action) {
        case "deposit":
            pageContext.forward("BankingDeposit.jsp");
            break;
        case "withdraw":
            pageContext.forward("BankingWithdraw.jsp");
            break;
        case "send":
            pageContext.forward("BankingSend.jsp");
            break;
    }
}
%>
