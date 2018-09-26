<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"%>
<%

Class.forName("com.mysql.jdbc.Driver");
String myUrl = "jdbc:mysql://localhost/jspdb";
Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");
 
String query = "select * from customer";
 
PreparedStatement preparedStmt = conn.prepareStatement(query);
ResultSet rs = preparedStmt.executeQuery();

JSONArray jsonArray = new JSONArray();
ResultSetMetaData rsmd = rs.getMetaData();

while(rs.next()) {
	int numColumns = rsmd.getColumnCount();
	JSONObject jsonObject = new JSONObject();
	for(int i = 1; i <= numColumns; i++) {
		String column_name = rsmd.getColumnName(i);
		jsonObject.put(column_name, rs.getObject(column_name));
	}
	jsonArray.add(jsonObject);
}
out.println(jsonArray.get(0).toString());
conn.close();
%>
