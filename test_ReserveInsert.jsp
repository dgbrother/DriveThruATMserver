<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    Class.forName("com.mysql.jdbc.Driver");
    String myUrl = "jdbc:mysql://localhost/jspdb";
    Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

    String query = null;
    PreparedStatement preparedStmt = null;

    String bankingType  = request.getParameter("bankingType");
    String id           = request.getParameter("id");
    String carNumber    = request.getParameter("carNumber");
    String src_account  = request.getParameter("src_account");
    String dst_account  = request.getParameter("dst_account");
    String amount       = request.getParameter("amount");
    String isdone = "F";

    query = "insert into reservation(type,id,carnumber,src_account,dst_account,amount,isdone) values(?,?,?,?,?,?,?);";
    preparedStmt = conn.prepareStatement(query);

    preparedStmt.setString(1, bankingType);
    preparedStmt.setString(2, id);
    preparedStmt.setString(3, carNumber);
    preparedStmt.setString(4, src_account);
    preparedStmt.setString(5, dst_account);
    preparedStmt.setString(6, amount);
    preparedStmt.setString(7, isdone);
    preparedStmt.executeUpdate();

    conn.close();
    preparedStmt.close();

    pageContext.forward("control.jsp?type=reservation&action=select&from=mobile&userid="+id);
%>
