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
String userId = request.getParameter("userid");

query = "select * from customer where id = ?";
preparedStmt = conn.prepareStatement(query);
preparedStmt.setString(1,userId);
 
ResultSet rs = null;
if(preparedStmt != null){
    rs = preparedStmt.executeQuery();

    //  ResultSet 결과를 JSON 형식으로 변환
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

    //  Android로 변환된 JSON 출력
    out.println(jsonMain);
}
conn.close();

/**
*   JSON 구조 :
*   |JSONObject(jsonMain)    =================================|
*   |    |- JSONArray(jsonArray) name:"data"  ================|
*   |    |    |- JSONObject(jsonObject) DB Column: "DB Value" |
*   ===========================================================
*/

/**
*   {"data":
*        [{
*            "password":"PW1234!!",
*            "carnumber":"CAR0012",
*            "name":"hellozinad",
*            "nfc":"nfc1234",
*            "id":"ID1234",
*            "email":"paul@gmail.com",
*            "account":"00-000-00-0"
*        }]
*    }
*/
%>