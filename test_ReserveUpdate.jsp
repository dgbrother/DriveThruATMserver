<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    Class.forName("com.mysql.jdbc.Driver");
    String myUrl = "jdbc:mysql://localhost/jspdb";
    Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

    String from = request.getParameter("from");
    String userId = null;
    String carNumber = null;
    String query = null;
    PreparedStatement preparedStmt = null;

    if(from.equals("mobile")) {
        userId = request.getParameter("userId");
        query = "select * from reservation where id=?";
        preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1,userId);
    }
    if(from.equals("machine")) {
        carNumber = request.getParameter("carNumber");
        query = "select * from reservation where carNumber=?";
        preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1,carNumber);
    }
    ResultSet resultSet = preparedStmt.executeQuery();
    
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

    if(from.equals("mobile"))
        out.print(jsonMain);

    if(from.equals("machine")) {
        String MESSAGE_ID = String.valueOf(Math.random() % 100 + 1);
        boolean SHOW_ON_IDLE = false;
        int LIVE_TIME = 1;
        int RETRY = 2;
        String APIKEY = "AIzaSyBb6h-ixtxx_TsZVudOEJTNDxOCE9V_y74";
        String GCMURL = "https://android.googleapis.com/fc/send";

        Sender sender = new Sender(APIKEY);
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

        MulticastResult mcresult = sender.send(message,token,RETRY);
    }
    conn.close();
%>
