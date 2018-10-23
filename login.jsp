<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");

// action : login(login 성공여부)
String action = request.getParameter("action");

/**
*   DataBase Connection
*/
Class.forName("com.mysql.jdbc.Driver");
String myUrl = "jdbc:mysql://localhost/jspdb";
Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

String query = null;
PreparedStatement preparedStmt = null;

String inputId = request.getParameter("inputId");
String inputPassword = request.getParameter("inputPassword");

query = "select * from customer where id = ?";
preparedStmt = conn.prepareStatement(query);
preparedStmt.setString(1,inputId);

ResultSet rs = preparedStmt.executeQuery();
String confirmPassword = "";

if(rs.next())
    confirmPassword = rs.getString("password");

JSONObject jsonObject = new JSONObject();
if(inputPassword.equals(confirmPassword)) {
    jsonObject.put("isConfirm","true");
    
    query = "select * from customer where id = ?";
    preparedStmt = conn.prepareStatement(query);
    preparedStmt.setString(1,inputId);

    rs = null;
    if(preparedStmt != null){
        rs = preparedStmt.executeQuery();
        //  ResultSet 결과를 JSON 형식으로 변환
        if(rs.next()) {
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
}
else
    jsonObject.put("isConfirm","false");

out.print(jsonObject);
conn.close();
%>


