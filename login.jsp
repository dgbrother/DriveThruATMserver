<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");

// action : login(login 성공여부)
String action = request.getParameter("action");

/**
*   DataBase Connection
*/
Class.forName("com.mysql.jdbc.Driver");
String myUrl = "jdbc:mysql://localhost/jspdb";
Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

String query = null;
PreparedStatement preparedStmt = null;

String inputId = request.getParameter("inputId");
String inputPassword = request.getParameter("inputPassword");

switch(action) {
    //   현재User의 User정보를 가져온다.
    case "login":
        query = "select password from customer where id = ?";
        preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1,inputId);
        
        ResultSet rs = preparedStmt.executeQuery();
        String confirmPassword = "";

        while(rs.next())
            confirmPassword = rs.getString("password");
        
	JSONObject jsonObject = new JSONObject();
	if(inputPassword.equals(confirmPassword))
	    jsonObject.put("isConfirm","true");
	else
	    jsonObject.put("isConfirm","false");
    out.print(jsonObject);
	break;

    default:
        break;
}
conn.close();
%>
