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
    if(from.equals("mobile")) {
        userId = request.getParameter("userId");
        query = "select * from reservation where id=? and isDone=?";
        preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1,userId);
        preparedStmt.setString(2,"F");
    }
    if(from.equals("machine")) {
        carNumber = request.getParameter("carNumber");
        query = "select * from reservation where carNumber=? and isDone=?";
        preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1,carNumber);
        preparedStmt.setString(2,"F");
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

    /*
    * mobile(모바일 앱), machine(ATM) 일 경우 JSON 결과 전송
    * raspberry(차량 접근) 일 경우 FCM으로 JSON 결과 전송
    */
    switch(from) {
        case "mobile":
        case "machine":
            out.print(jsonMain);
            break;
        case "raspberry":
            String MESSAGE_ID = String.valueOf(Math.random() % 100 + 1);
            boolean SHOW_ON_IDLE = false;
            int LIVE_TIME = 1;
            int RETRY = 2;
            String APIKEY = "AIzaSyBb6h-ixtxx_TsZVudOEJTNDxOCE9V_y74";
            String GCMURL = "https://android.googleapis.com/fc/send";

            Message message = new Message.Builder()
            .collapseKey(MESSAGE_ID)
            .delayWhileIdle(SHOW_ON_IDLE)
            .timeToLive(LIVE_TIME)
            .addData("carNumber", jsonMain.toString())
            .build();
            
            query = "select * from token";
            preparedStmt = conn.prepareStatement(query);
            resultSet = preparedStmt.executeQuery();

            ArrayList<String> token = new ArrayList<>();
            while(resultSet.next())
                token.add(resultSet.getString("token"));

            Sender sender = new Sender(APIKEY);
            MulticastResult mcresult = sender.send(message,token,RETRY);
            // mcresult : send 결과
            break;
    }
    conn.close();
    preparedStmt.close();
%>
