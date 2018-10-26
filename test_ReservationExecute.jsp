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
out.println("in");
String query = null;
PreparedStatement preparedStmt = null;
String carNumber = request.getParameter("carNumber");

query = "select * from reservation where carnumber = ? and isdone=?";
preparedStmt = conn.prepareStatement(query);
preparedStmt.setString(1,carNumber);
preparedStmt.setString(2, "F");
 
ResultSet reservationResults = null;
if(preparedStmt != null){
    reservationResults = preparedStmt.executeQuery();

    while(reservationResults.next()) {
        String type = reservationResults.getString("type");
        out.println("type : "+type);
        switch(type) {
            case "deposit":

            break;
            
            case "send":
            String dstAccount = reservationResults.getString("dst_account");
            query = "select amount from customer where account=?";
            preparedStmt = conn.prepareStatement(query);
            preparedStmt.setString(1, dstAccount);
            ResultSet amountResult = preparedStmt.executeQuery();
            if(amountResult.next()) {
                String currentAmount = amountResult.getString("amount");
                String withdrawAmount = reservationResults.getString("amount");
                String newAmount = String.valueOf(Integer.parseInt(currentAmount) + Integer.parseInt(withdrawAmount));
                
                query = "update customer set amount=? where account=?";
                preparedStmt = conn.prepareStatement(query);
                preparedStmt.setString(1, newAmount);
                preparedStmt.setString(2, dstAccount);
                preparedStmt.executeUpdate();
            }

            case "withdraw":
            query = "select amount from customer where carnumber=?";
            preparedStmt = conn.prepareStatement(query);
            preparedStmt.setString(1, carNumber);
            ResultSet amountResult = preparedStmt.executeQuery();
            if(amountResult.next()) {
                String currentAmount = amountResult.getString("amount");
                String withdrawAmount = reservationResults.getString("amount");
                String newAmount = String.valueOf(Integer.parseInt(currentAmount) - Integer.parseInt(withdrawAmount));
                
                query = "update customer set amount=? where carNumber=?";
                preparedStmt = conn.prepareStatement(query);
                preparedStmt.setString(1, newAmount);
                preparedStmt.setString(2, carNumber);
                preparedStmt.executeUpdate();

                query = "update reservation set isdone=? where carNumber=?";
                preparedStmt = conn.prepareStatement(query);
                preparedStmt.setString(1, "T");
                preparedStmt.setString(2, carNumber);
                preparedStmt.executeUpdate();
            }
            break;
        }
    }
}
conn.close();
preparedStmt.close();
%>