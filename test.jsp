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

    String msg = "msg from server";
    Sender sender = new Sender(APIKEY);
    Message message = new Message.Builder()
    .collapseKey(MESSAGE_ID)
    .delayWhileIdle(SHOW_ON_IDLE)
    .timeToLive(LIVE_TIME)
    .addData("message", msg)
    .build();

    ArrayList<String> token = new ArrayList<>();
    token.add("fbypC9j0RtI:APA91bHJQtL7uL2BpNg8R_EADkTmrWl55oJdN7xMzYlPB1OsTRz2loBfAaIyosVV_INf26ywA80XLijmjUfE3U3maQv670xooJLrEFt-spJEbY-SOxLY_cMA0x3gKO-6mNnAndPVMyS2");
    MulticastResult result = sender.send(message,token,RETRY);
    if(result != null) {
        List<Result> resultList = result.getResults();
        for(Result result : resultList) {
            System.out.println(result.getErrorCodeName());
        }
    }

    out.println("test ok");
%>

