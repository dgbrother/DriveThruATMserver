<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");
/**
*   DataBase Connection
*/
Class.forName("com.mysql.jdbc.Driver");
String myUrl = "jdbc:mysql://localhost/jspdb";
Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

String query = null;
PreparedStatement preparedStmt = null;
String userId = request.getParameter("userId");

query = "select * from customer where id = ?";
preparedStmt = conn.prepareStatement(query);
preparedStmt.setString(1,userId);
 
ResultSet rs = null;
if(preparedStmt != null){
    rs = preparedStmt.executeQuery();
    //  ResultSet 결과를 JSON 형식으로 변환
    JSONObject jsonObject = null;

    if(rs.next()) {
        jsonObject = new JSONObject();
        ResultSetMetaData rsmd = rs.getMetaData();
        int numColumns = rsmd.getColumnCount();

        for(int i = 1; i <= numColumns; i++) {
            String column_name = rsmd.getColumnName(i);
            jsonObject.put(column_name, rs.getObject(column_name));
        }
        //  Android로 변환된 JSON 출력
        out.println(jsonObject);
    }
}
conn.close();
preparedStmt.close();
%>