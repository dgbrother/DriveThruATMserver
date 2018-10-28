<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
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

/*********************************************************
* NFC 카드 정보를 Parameter로 입력받아서
* 해당 NFC 정보와 일치하는 차량번호를 DB에서 가져옴
**********************************************************/
String nfcId = request.getParameter("nfcId");
query = "select carnumber from customer where nfc=?";
preparedStmt = conn.prepareStatement(query);
preparedStmt.setString(1,nfcId);
ResultSet nfcResult = preparedStmt.executeQuery();

String carNumber = "";
if(nfcResult.next())
    carNumber = nfcResult.getString("carnumber");

/*********************************************************
* 차량번호로 예약된 업무 목록을 DB에서 가져옴
* 이미 실행 된 업무는 가져오지 않음 (isdone = 'F' 만 가져옴)
**********************************************************/
query = "select * from reservation where carnumber = ? and isdone=?";
preparedStmt = conn.prepareStatement(query);
preparedStmt.setString(1,carNumber);
preparedStmt.setString(2, "F");
 
ResultSet reservationResults = null;
if(preparedStmt != null){
    reservationResults = preparedStmt.executeQuery();
   
   JSONArray jsonResultArray = new JSONArray();
    while(reservationResults.next()) {
        JSONObject jsonResultMsg = new JSONObject();
        String type = reservationResults.getString("type");
        String no = reservationResults.getString("no");
        switch(type) {
            case "deposit":
            jsonResultMsg.put("no", no);
            jsonResultMsg.put("result", "true");
            jsonResultMsg.put("msg", "");
            jsonResultArray.add(jsonResultMsg);
            break;
            
            case "send":
            String dstAccount = reservationResults.getString("dst_account");
            query = "select amount from customer where account=?";
            preparedStmt = conn.prepareStatement(query);
            preparedStmt.setString(1, dstAccount);
           
            ResultSet dstAmountResult = preparedStmt.executeQuery();
            if(dstAmountResult.next()) {
                String currentAmount = dstAmountResult.getString("amount");
                String withdrawAmount = reservationResults.getString("amount");
                String newAmount = String.valueOf(Integer.parseInt(currentAmount) + Integer.parseInt(withdrawAmount));
                
                String srcAccount = reservationResults.getStirng("src_account");
                query = "select amount from customer where account=?";
                preparedStmt = conn.preparedStmt(query);
                preparedStmt.setString(1, srcAccount);
                
                ResultSet srcAmountResult = preparedStmt.executeQuery();
                String srcAmount = "";
                if(srcAmountResult.next())
                    srcAmount = srcAmountResult.getStirng("amount");

                int newSrcAmount = Integer.parseInt(srcAmount) - Integer.parseInt(withdrawAmount);
                if(newSrcAmount < 0) {
                    jsonResultMsg.put("no", no);
                    jsonResultMsg.put("result", "false");
                    jsonResultMsg.put("msg", "잔액이 부족합니다.");
                    jsonResultArray.add(jsonResultMsg);
                    break;
                }

                query = "update customer set amount=? where account=?";
                preparedStmt = conn.prepareStatement(query);
                preparedStmt.setString(1, newAmount);
                preparedStmt.setString(2, dstAccount);
                preparedStmt.executeUpdate();
                
                jsonResultMsg.put("no", no);
                jsonResultMsg.put("result", "true");
                jsonResultMsg.put("msg", "");
                jsonResultArray.add(jsonResultMsg);

            }
            else {
                jsonResultMsg.put("no", no);
                jsonResultMsg.put("result", "false");
                jsonResultMsg.put("msg", "송금 계좌가 존재하지 않습니다.");
                jsonResultArray.add(jsonResultMsg);
                break;
            }
            break;

            case "withdraw":
            query = "select amount from customer where carnumber=?";
            preparedStmt = conn.prepareStatement(query);
            preparedStmt.setString(1, carNumber);
            ResultSet srcAmountResult = preparedStmt.executeQuery();
            if(srcAmountResult.next()) {
                String currentAmount = srcAmountResult.getString("amount");
                String withdrawAmount = reservationResults.getString("amount");
                String newAmount = String.valueOf(Integer.parseInt(currentAmount) - Integer.parseInt(withdrawAmount));
                
                if(Integer.parseInt(newAmount) < 0) {
                    jsonResultMsg.put("no", no);
                    jsonResultMsg.put("result", "false");
                    jsonResultMsg.put("msg", "잔액이 부족합니다.");
                    jsonResultArray.add(jsonResultMsg);
                    break;
                }

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
                
                jsonResultMsg.put("no", no);
                jsonResultMsg.put("result", "true");
                jsonResultMsg.put("msg", "");
                jsonResultArray.add(jsonResultMsg);
            }
            else {
                jsonResultMsg.put("no", no);
                jsonResultMsg.put("result", "false");
                jsonResultMsg.put("msg", "등록되지 않은 차량번호 입니다.");
                jsonResultArray.add(jsonResultMsg);
            }
            break;
        }
    }
    
    String MESSAGE_ID = String.valueOf(Math.random() % 100 + 1);
    boolean SHOW_ON_IDLE = false;
    int LIVE_TIME = 1;
    int RETRY = 2;
    String APIKEY = "AIzaSyBb6h-ixtxx_TsZVudOEJTNDxOCE9V_y74";
    String GCMURL = "https://android.googleapis.com/fc/send";

    JSONObject jsonMain = new JSONObject();
    jsonMain.put("data", jsonResultArray);
    out.println(jsonMain.toString());

    Message message = new Message.Builder()
    .collapseKey(MESSAGE_ID)
    .delayWhileIdle(SHOW_ON_IDLE)
    .timeToLive(LIVE_TIME)
    .addData("msgFromServer", jsonMain.toString())
    .build();
    
    query = "select * from token";
    preparedStmt = conn.prepareStatement(query);
    ResultSet resultSet = preparedStmt.executeQuery();

    ArrayList<String> token = new ArrayList<>();
    while(resultSet.next())
        token.add(resultSet.getString("token"));

    Sender sender = new Sender(APIKEY);
    MulticastResult mcresult = sender.send(message,token,RETRY);
}
conn.close();
preparedStmt.close();
%>