<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    Class.forName("com.mysql.jdbc.Driver");
    String myUrl = "jdbc:mysql://localhost/jspdb";
    Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");
    
    String newToken = request.getParameter("newToken");

    String query = "insert into token values(?)";
    PreparedStatement preparedStmt = conn.prepareStatement(sql);
    preparedStmt.setString(1,newToken);
    preparedStmt.execute();
%>