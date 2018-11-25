<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");
String nfcId = request.getParameter("nfcId");

Class.forName("com.mysql.jdbc.Driver");
String myUrl = "jdbc:mysql://localhost/jspdb";
Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

String query = "select carnumber from customer where nfc = ?";
PreparedStatement preparedStmt = conn.prepareStatement(query);
preparedStmt.setString(1,nfcId);
ResultSet resultSet = preparedStmt.executeQuery();

String logMsg = "";

String msgFromServer = "";
JSONObject jsonObject = new JSONObject();
if(resultSet.next()) {
    String carNumber = resultSet.getString("carnumber");
    jsonObject.put("action", "nfcTag");
    jsonObject.put("nfcId", nfcId);
    jsonObject.put("carNumber", carNumber);
    logMsg = "[알림] NFC 카드가 태그되었습니다.\nNFC ID: "+nfcId;
}
else {
    jsonObject.put("action", "error");
    jsonObject.put("errorType", "NOT_FOUND_NFCID");
    logMsg = "[알림] NFC 카드가 태그되었습니다.\nNFC 정보를 찾을 수 없습니다.";
}
msgFromServer = jsonObject.toString();
    
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
.addData("msgFromServer", msgFromServer)
.build();

query = "select * from token";
preparedStmt = conn.prepareStatement(query);
resultSet = preparedStmt.executeQuery();

ArrayList<String> token = new ArrayList<>();
while(resultSet.next())
    token.add(resultSet.getString("token"));

Sender sender = new Sender(APIKEY);
MulticastResult mcresult = sender.send(message,token,RETRY);
if(mcresult != null) {
    List<Result> resultList = mcresult.getResults();
    for(Result mr : resultList)
        out.println(mr.getErrorCodeName());
}
out.println("MSG from server : "+msgFromServer);
conn.close();
preparedStmt.close();

pageContext.forward("SendLog.jsp?log="+logMsg);
%>