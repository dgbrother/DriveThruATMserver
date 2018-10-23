<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*"
    contentType="text/html;charset=UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");

/**
*   DataBase Connection
*/
Class.forName("com.mysql.jdbc.Driver");
String myUrl = "jdbc:mysql://localhost/jspdb";
Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

String query = null;
PreparedStatement preparedStmt = null;

String userId = request.getParameter("userid");
//  현재User의 User정보를 Parameter값으로 업데이트한다.
//  Android에서 넘어온 Parameter 저장
String id           = request.getParameter("id");
String password     = request.getParameter("password");
String name         = request.getParameter("name");
String email        = request.getParameter("email");
String account      = request.getParameter("account");
String carNumber    = request.getParameter("carNumber");
String nfcId        = request.getParameter("nfcid");

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

conn.close();
preparedStmt.close();
//  업데이트 후 리스트뷰에 다시 보여주기 위한 Select 쿼리
pageContext.forward("control.jsp?type=user&action=select&userid="+id);
%>
