<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");

String carNumber = request.getParameter("carNumber");

Class.forName("com.mysql.jdbc.Driver");
String myUrl = "jdbc:mysql://localhost/jspdb";
Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

String query = "select nfc from customer where carnumber = ?";
PreparedStatement preparedStmt = conn.prepareStatement(query);
preparedStmt.setString(1,carNumber);
ResultSet resultSet = preparedStmt.executeQuery();

String msgFromServer = "false";
if(resultSet.next()) {
    String nfcId = resultSet.getString("nfc");
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("carNumber", carNumber);
    jsonObject.put("nfcId", nfcId);
    msgFromServer = jsonObject.toString();
}
    
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
.addData("carEntry", msgFromServer)
.build();

query = "select * from token";
preparedStmt = conn.prepareStatement(query);
resultSet = preparedStmt.executeQuery();

ArrayList<String> token = new ArrayList<>();
while(resultSet.next())
    token.add(resultSet.getString("token"));

Sender sender = new Sender(APIKEY);
MulticastResult mcresult = sender.send(message,token,RETRY);

conn.close();
preparedStmt.close();
%>