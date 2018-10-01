<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");

// action : select(User 정보 조회), update(User 정보 업데이트)
String action = request.getParameter("action");

/**
*   DataBase Connection
*/
Class.forName("com.mysql.jdbc.Driver");
String myUrl = "jdbc:mysql://localhost/jspdb";
Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

String query = null;
PreparedStatement preparedStmt = null;

String userId = request.getParameter("userid");

switch(action) {
    //   현재User의 User정보를 가져온다.
    case "select":
        query = "select * from customer where id = ?";
        preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1,userId);
        break;

    //  현재User의 User정보를 Parameter값으로 업데이트한다.
    case "update":
        //  Android에서 넘어온 Parameter 저장
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String account = request.getParameter("account");
        String carNumber = request.getParameter("carNumber");
        String nfcId = request.getParameter("nfcid");

        //  새로운 User정보로 업데이트 쿼리 작성
        query = "update customer set id=?, password=?, name=?, carnumber=?, email=?, account=?, nfc=? where id=?";
        preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1,id);
        preparedStmt.setString(2,password);
        preparedStmt.setString(3,name);
        preparedStmt.setString(4,carNumber);
        preparedStmt.setString(5,email);
        preparedStmt.setString(6,account);
        preparedStmt.setString(7,nfcId);
        preparedStmt.setString(8,userId);

        preparedStmt.executeUpdate();

        //  업데이트 후 리스트뷰에 다시 보여주기 위한 Select 쿼리
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

/**
*   JSON 구조 :
*   |JSONObject(jsonMain)    =================================|
*   |    |- JSONArray(jsonArray) name:"data"  ================|
*   |    |    |- JSONObject(jsonObject) DB Column: "DB Value" |
*   ===========================================================
*/

JSONObject jsonMain = new JSONObject();
jsonMain.put("data", jsonArray);

//  Android로 변환된 JSON 출력
out.println(jsonMain);
}
conn.close();
%>
