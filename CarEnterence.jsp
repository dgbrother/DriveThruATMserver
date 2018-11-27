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
    }
    else {
        jsonObject.put("action", "error");
        jsonObject.put("errorType", "NOT_FOUND_RESERVATION");
    }
}
else {
    jsonObject.put("action", "error");
    jsonObject.put("errorType", "NOT_FOUND_CARNUMBER_OR_NFCID");
}
String msgFromServer = jsonObject.toString();
    
message.Send(msgFromServer);
out.println("MSG from server : "+msgFromServer);
conn.close();
preparedStmt.close();

String from = request.getParameter("from");
if(from != null) {
    if(from.equals("viewer"))
        response.sendRedirect("Viewer.jsp");
}
%>