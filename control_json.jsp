<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");
String action = request.getParameter("action");

Class.forName("com.mysql.jdbc.Driver");
String myUrl = "jdbc:mysql://localhost/jspdb";
Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

String query = null;
PreparedStatement preparedStmt = null;

switch(action) {
    case "userinfo":
	String userId = request.getParameter("userid");

	query = "select * from customer where id = ?";
	preparedStmt = conn.prepareStatement(query);
	preparedStmt.setString(1,userId);

	break;

    default:
	break;
}
 
ResultSet rs = null;
if(preparedStmt != null){
    rs = preparedStmt.executeQuery();

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

JSONObject jsonMain = new JSONObject();
jsonMain.put("data", jsonArray);

out.println(jsonMain);
}
conn.close();
%>
