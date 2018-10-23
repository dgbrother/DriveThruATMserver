<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    Class.forName("com.mysql.jdbc.Driver");
    String myUrl = "jdbc:mysql://localhost/jspdb";
    Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

    String reservationNo = request.getParameter("no");
    String query = null;
    PreparedStatement preparedStmt = null;

    query = "delete from reservation where no=?";
    preparedStmt = conn.prepareStatement(query);

    preparedStmt.setString(1,reservationNo);
    preparedStmt.executeUpdate();

    conn.close();
    preparedStmt.close();

    String userId = null;
    String carNumber = null;
    String from = request.getParameter("from");

    switch(from) {
        case "mobile":
            userId = request.getParameter("userId");
            pageContext.forward("control.jsp?type=reservation&action=select&from=mobile&userid="+userId);
            break;
        case "machine":
            carNumber = request.getParameter("carNumber");
            pageContext.forward("control.jsp?type=reservation&action=select&from=machine&carNumber="+carNumber);
            break;
    }
%>
