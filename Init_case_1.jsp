<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    Class.forName("com.mysql.jdbc.Driver");
    String myUrl = "jdbc:mysql://localhost/jspdb";
    Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

    String query = "update customer set amount=?";
    PreparedStatement preparedStmt = conn.prepareStatement(query);
    preparedStmt.setString(1, "10000");
    preparedStmt.executeUpdate();
    
    query = "update reservation set isdone=?";
    preparedStmt = conn.prepareStatement(query);
    preparedStmt.setString(1, "T");
    preparedStmt.executeUpdate();

    query = "insert into reservation(type,id,carnumber,src_account,dst_account,amount,isdone) values(?,?,?,?,?,?,?);";
    preparedStmt = conn.prepareStatement(query);
    preparedStmt.setString(1, "withdraw");
    preparedStmt.setString(2, "ID1859");
    preparedStmt.setString(3, "28무0218");
    preparedStmt.setString(4, "111111111111");
    preparedStmt.setString(5, "-");
    preparedStmt.setString(6, "1000");
    preparedStmt.setString(7, "F");
    preparedStmt.executeUpdate();

    preparedStmt.setString(1, "send");
    preparedStmt.setString(2, "ID1859");
    preparedStmt.setString(3, "28무0218");
    preparedStmt.setString(4, "111111111111");
    preparedStmt.setString(5, "222222222222");
    preparedStmt.setString(6, "2000");
    preparedStmt.setString(7, "F");
    preparedStmt.executeUpdate();

    preparedStmt.setString(1, "send");
    preparedStmt.setString(2, "ID1859");
    preparedStmt.setString(3, "28무0218");
    preparedStmt.setString(4, "111111111111");
    preparedStmt.setString(5, "333333333333");
    preparedStmt.setString(6, "3000");
    preparedStmt.setString(7, "F");
    preparedStmt.executeUpdate();

    preparedStmt.setString(1, "deposit");
    preparedStmt.setString(2, "ID1859");
    preparedStmt.setString(3, "28무0218");
    preparedStmt.setString(4, "111111111111");
    preparedStmt.setString(5, "-");
    preparedStmt.setString(6, "-");
    preparedStmt.setString(7, "F");
    preparedStmt.executeUpdate();

    response.sendRedirect("Viewer.jsp");
%>
