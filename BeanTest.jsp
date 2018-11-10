<%@ page 
    import="java.sql.*" 
    import="org.json.simple.*" 
    import="java.util.*" 
    import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<jsp:useBean id="dbo" class="hellotest.DBManager"/>
<%
    request.setCharacterEncoding("UTF-8");
    out.println("result : "+dbo.getData());
%>