<%@ page contentType="text/html;charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String param = request.getParameter("param");
    out.print("parameter is "+param);
%>
