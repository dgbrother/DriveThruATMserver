<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    Class.forName("com.mysql.jdbc.Driver");
    String myUrl = "jdbc:mysql://localhost/jspdb";
    Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

    String query = "delete from reservation";
    PreparedStatement preparedStmt = conn.prepareStatement(query);
    preparedStmt.executeUpdate();

    preparedStmt.close();
    conn.close();

    response.sendRedirect("Viewer.jsp");
%>
