<%@ page import="org.json.simple.*" contentType="text/html;charset=UTF-8" %>
<jsp:useBean id="dbManager" class="hellozin.DBManager"/>
<%
    request.setCharacterEncoding("UTF-8");
    String amount = request.getParameter("amount");
    String nfcId  = request.getParameter("nfcId");
    dbManager.deposit2(amount, nfcId);
%>