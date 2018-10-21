<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");

String device = request.getParameter("device");
switch(device) {

case "mobile": /*************************************/

    String action = request.getParameter("action");
    switch(action) {

    case "userInfo":
        pageContext.forward("UserInfo.jsp"); break;
    
    case "businesses":
        pageContext.forward("Businesses.jsp"); break;

    }

    break;

case "atm": /****************************************/
    
    String action = request.getParameter("action");
    switch(action) {

    case "businesses":
        pageContext.forword("Businesses.jsp"); break;

    }

    break;

case "rasp": /***************************************/

    String action = request.getParameter("action");
    switch(action) {

    case "arrived":
        pageContext.forword("empt"); break;

    }

default: /*******************************************/

}

%>
