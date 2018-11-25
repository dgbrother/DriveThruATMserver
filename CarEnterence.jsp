<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<jsp:useBean id="message" class="hellozin.FCMSender"/>
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

String logMsg = "";

JSONObject jsonObject = new JSONObject();
if(resultSet.next()) {
    query = "select no from reservation where carnumber = ?";
    preparedStmt = conn.prepareStatement(query);
    preparedStmt.setString(1,carNumber);
    ResultSet rsvResultSet = preparedStmt.executeQuery();

    if(rsvResultSet.next()) {
        String nfcId = resultSet.getString("nfc");
        jsonObject.put("action", "carEntry");
        jsonObject.put("carNumber", carNumber);
        jsonObject.put("nfcId", nfcId);
        logMsg = "[알림] 차량이 진입하였습니다. 차량번호 : "+carNumber;
    }
    else {
        jsonObject.put("action", "error");
        jsonObject.put("errorType", "NOT_FOUND_RESERVATION");
        logMsg = "[알림] 차량이 진입하였습니다. 해당 차량으로 예약된 업무를 찾을 수 없습니다.";
    }
}
else {
    jsonObject.put("action", "error");
    jsonObject.put("errorType", "NOT_FOUND_CARNUMBER_OR_NFCID");
    logMsg = "[알림] 차량이 진입하였습니다. 등록되지 않은 차량번호입니다.";
}
String msgFromServer = jsonObject.toString();
    
message.Send(msgFromServer);
out.println("MSG from server : "+msgFromServer);
conn.close();
preparedStmt.close();

pageContext.forward("SendLog.jsp?log="+logMsg);
%>