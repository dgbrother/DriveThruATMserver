<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>Testing websockets</title>
    <style>
	    #log {
	    width: 40%;
	    float: left;
	    }
	    
	    #log textarea {
	    width: 95%;
	    height: 600px;
	    margin: 0 auto;
	    font-size: x-large;
	    }
	    
	    #log input {
	    font-size: x-large;
	    }
	    
	    #tables {
	    width: 50%;
	    float: right;
	    }
    </style>
</head>
<body>
	
	<div id = "log">
	<h2>Drive Thru ATM Log</h2>
	<fieldset>
        <textarea id="messageWindow" rows="10" cols="50" readonly="true" autofocus="autofocus"></textarea>
        <br/>
        <input type="button" value="clear" onclick="logClear()" />
    </fieldset>
	</div>
	
	<div id="tables">
	<h2>Drive Thru ATM Tables</h2>
	
		<div id="customer">
		<table border="1">
		<%
		Class.forName("com.mysql.jdbc.Driver");
		String myUrl = "jdbc:mysql://localhost/jspdb";
		Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

		String query = "select * from customer";
		PreparedStatement preparedStmt = conn.prepareStatement(query);
		ResultSet resultSet = preparedStmt.executeQuery();
		
		while(rs.next()) {
            String id       = resultSet.getString("id");
            String name     = resultSet.getString("name");
        
		%>
        <tr>
            <td width="100"><%=id%></td>
            <td width="100"><%=name%></td>
        </tr>
        <%
        }
        %>
		</table>
		</div>
		<div id="reservation">
		reservation
		</div>
	</div>
</body>
    <script type="text/javascript">
        var textarea = document.getElementById("messageWindow");
        var webSocket = new WebSocket('ws://localhost:8080/broadcasting');
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
	        textarea.value += event.data + "\n";
	        textarea.scrollTop = textarea.scrollHeight;
	    }
	    function onOpen(event) {
	        textarea.value += "로그 대기중...\n";
	    }
	    function onError(event) {
	      alert(event.data);
	    }
	    function logClear() {
	    	textarea.value = "로그 대기중...\n";
	        inputMessage.value = "";
	    }
  </script>
</html>