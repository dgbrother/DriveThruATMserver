<%@ page import="java.sql.*" %>
<%
Class.forName("com.mysql.jdbc.Driver");
String myUrl = "jdbc:mysql://localhost/jspdb";
Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");
 
// the mysql insert statement
String query = "select * from test";
 
// create the mysql insert preparedstatement
PreparedStatement preparedStmt = conn.prepareStatement(query);
// execute the preparedstatement
ResultSet rs = preparedStmt.executeQuery();
while(rs.next())
	out.print(rs.getString(1));
 
conn.close();
%>
