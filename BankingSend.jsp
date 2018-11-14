<%@ page import="org.json.simple.*" contentType="text/html;charset=UTF-8" %>
<jsp:useBean id="dbManager" class="hellozin.DBManager"/>
<%
    request.setCharacterEncoding("UTF-8");
    String amount       = request.getParameter("amount");
    String nfcId        = request.getParameter("nfcId");
    String dstAccount   = request.getParameter("dstAccount");
    int result = dbManager.send(amount, nfcId, dstAccount);
    JSONObject jsonObject = new JSONObject();
    switch(result) {
        case 0: jsonObject.put("result", "success"); break;
        case 1: jsonObject.put("result", "NOT_ENOUGH_MONEY"); break;
        case 2: jsonObject.put("result", "NOT_FOUND_ACCOUNT"); break;
    }
    out.print(jsonObject);
%>