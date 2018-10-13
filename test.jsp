<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String MESSAGE_ID = String.valueOf(Math.random() % 100 + 1);
    boolean SHOW_ON_IDLE = false;
    int LIVE_TIME = 1;
    int RETRY = 2;
    String APIKEY = "AIzaSyBb6h-ixtxx_TsZVudOEJTNDxOCE9V_y74";
    String GCMURL = "https://android.googleapis.com/fc/send";

    String carNumber = request.getParameter("carNumber");
    Sender sender = new Sender(APIKEY);
    Message message = new Message.Builder()
    .collapseKey(MESSAGE_ID)
    .delayWhileIdle(SHOW_ON_IDLE)
    .timeToLive(LIVE_TIME)
    .addData("carNumber", carNumber)
    .build();

    Class.forName("com.mysql.jdbc.Driver");
    String myUrl = "jdbc:mysql://localhost/jspdb";
    Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");
    
    String query = "select * from token";
    PreparedStatement preparedStmt = conn.prepareStatement(query);
    ResultSet resultSet = preparedStmt.executeQuery();

    ArrayList<String> token = new ArrayList<>();
    while(resultSet.next())
        token.add(resultSet.getString("token"));
    conn.close();

    out.println("Car Number: "+ carNumber);
    out.println("token : "+token.get(0));

    MulticastResult mcresult = sender.send(message,token,RETRY);
    if(mcresult != null) {
        List<Result> resultList = mcresult.getResults();
        for(Result result : resultList) {
            System.out.println(result.getErrorCodeName());
        }
    }
%>
