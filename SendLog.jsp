<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" 
%>
<% request.setCharacterEncoding("utf-8"); %>
<%
String log = request.getParameter("log");
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>Testing websockets</title>
</head>
<body>
<script type="text/javascript">
        var webSocket = new WebSocket("ws://35.200.117.1:8080/broadcasting");
        var inputMessage = "<%=log%>";
    webSocket.onerror = function(event) {
        onError(event)
    };
    webSocket.onopen = function(event) {
      onOpen(event)
    };
    webSocket.onmessage = function(event) {
      onMessage(event)
    };
    function onMessage(event) {
    	console.log(event.data);
    }
    function onOpen(event) {
    	webSocket.send(inputMessage);
        inputMessage = "";
    }
    function onError(event) {
    	alert(event.data);
    }
    function send() {
        webSocket.send(inputMessage);
        inputMessage = "";
    }
  </script>
</body>
</html>