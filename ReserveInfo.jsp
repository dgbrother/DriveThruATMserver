<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    /*
    * DB Connection 및 기본 변수 설정
    */
    Class.forName("com.mysql.jdbc.Driver");
    String myUrl = "jdbc:mysql://localhost/jspdb";
    Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

    String from = request.getParameter("from");
    String userId = null;
    String carNumber = null;
    String query = null;
    PreparedStatement preparedStmt = null;

    /*
    * mobile(모바일 앱)에서 보낸 요청 일 경우 user id,
    * machine(ATM) 에서 보낸 요청 일 경우 car number를
    * 사용해 예약 정보 select 쿼리 실행
    */
    switch(from) {
        case "mobile":
            userId = request.getParameter("userId");
            query = "select * from reservation where id=? and isDone=?";
            preparedStmt = conn.prepareStatement(query);
            preparedStmt.setString(1,userId);
            preparedStmt.setString(2,"F");
            break;

        case "machine":
            carNumber = request.getParameter("carNumber");
            query = "select * from reservation where carNumber=? and isDone=?";
            preparedStmt = conn.prepareStatement(query);
            preparedStmt.setString(1,carNumber);
            preparedStmt.setString(2,"F");
            break;
    }
    
    ResultSet resultSet = preparedStmt.executeQuery();
    /*
    * 쿼리 결과를 JSON 형식으로 저장
    */
    JSONArray jsonArray = new JSONArray();
    ResultSetMetaData rsmd = resultSet.getMetaData();
    while(resultSet.next()) {
        int numColumns = rsmd.getColumnCount();
        JSONObject jsonObject = new JSONObject();
        for(int i = 1; i <= numColumns; i++) {
            String column_name = rsmd.getColumnName(i);
            jsonObject.put(column_name, resultSet.getObject(column_name));
        }
        jsonArray.add(jsonObject);
    }

    JSONObject jsonMain = new JSONObject();
    jsonMain.put("data", jsonArray);
    out.print(jsonMain);

    conn.close();
    preparedStmt.close();
%>
