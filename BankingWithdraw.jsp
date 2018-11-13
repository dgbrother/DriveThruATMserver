<%@ page import="org.json.simple.*" contentType="text/html;charset=UTF-8" %>
<jsp:useBean id="dbManager" class="hellozin.DBManager"/>
<%
    request.setCharacterEncoding("UTF-8");
    String amount = request.getParameter("amount");
    String nfcId  = request.getParameter("nfcId");
    int result = dbManager.withdraw(amount, nfcId);
    JSONObject jsonObject = new JSONObject();
    if(result == 0)
        jsonObject.put("result", "success");
    else
        jsonObject.put("result", "fail");
    out.print(jsonObject);
%>