<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:useBean id="message" class="hellozin.FCMSender"/>
<%
    request.setCharacterEncoding("UTF-8");
    message.Send("bean message test");
%>