<%@ page import="java.sql.*" import="org.json.simple.*" %>
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
String msg = null;
while(rs.next())
	msg = rs.getString(1);

JSONObject jsonMain = new JSONObject();
JSONArray jArray = new JSONArray();

JSONObject jobject = new JSONObject();
jobject.put("msg: ", msg);
jArray.add(0,jobject);
jsonMain.put("List",jArray);
out.println(jsonMain.toJSONString());
conn.close();
%>
