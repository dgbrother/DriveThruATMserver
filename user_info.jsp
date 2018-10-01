
<ge import="java.sql.*" import="org.json.simple.*" import="java.util.*"
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
    case "select":
        String userId = request.getParameter("userid");

        query = "select * from customer where id = ?";
        preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1,userId);

        break;

    case "update":
        String userId = request.getParameter("userid");
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String account = request.getParameter("account");
        String carNumber = request.getParameter("carNumber");
        String nfcId = request.getParameter("nfcid");

        query = "update customer set id=?, password=?, name=?, carnumber=?, email=?, account=?, nfc=? where id=?";
        preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1,id);
        preparedStmt.setString(2,password);
        preparedStmt.setString(3,name);
        preparedStmt.setString(4,carnumber);
        preparedStmt.setString(5,email);
        preparedStmt.setString(6,account);
        preparedStmt.setString(7,nfc);
        preparedStmt.setString(8,userId);

        preparedStmt.executeUpdate();

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
%>:%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
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
    case "select":
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
