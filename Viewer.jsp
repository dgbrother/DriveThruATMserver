<%@ page import="java.sql.*" import="org.json.simple.*" import="java.util.*" import="com.google.android.gcm.server.*"
    contentType="text/html;charset=UTF-8" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>Testing websockets</title>
    <style>
    	#init_button {
    	margin: 0 auto;
    	width: 65%;
    	}
	    #tables {
	    width: 65%;
	    margin: 0 auto;
	    }

		#tables table {
		width: 100%;
		}
    </style>
</head>
<body>
	<div id="init_button">
		<h2>DB Setting</h2>
		모든업무 성공<input type="button" value="초기화" onclick="initcase(1);" /><br/>
		일부업무 실패<input type="button" value="초기화" onclick="initcase(2);" /><br/>
		모든업무 실패<input type="button" value="초기화" onclick="initcase(3);" /><br/>
		모든 예약정보 삭제<input type="button" value="초기화" onclick="initcase(0);" /><br/>
	</div>

	<div id="tables">
	<h2>Drive Thru ATM Tables</h2>
	
		<div id="customer">
		
		<h3>고객 테이블</h3>

		<table border="1">
        <tr>
            <th>ID</th><th>이름</th><th>계좌</th><th>잔고</th><th>차량번호</th><th>NFC</th>
        </tr>
		<%
		Class.forName("com.mysql.jdbc.Driver");
		String myUrl = "jdbc:mysql://localhost/jspdb";
		Connection conn = DriverManager.getConnection(myUrl, "root", "ghqkrth");

		String query = "select * from customer";
		PreparedStatement preparedStmt = conn.prepareStatement(query);
		ResultSet resultSet = preparedStmt.executeQuery();
		
		while(resultSet.next()) {
            String id       = resultSet.getString("id");
            String name     = resultSet.getString("name");
            String account  = resultSet.getString("account");
            String amount   = resultSet.getString("amount");
            String carNumber= resultSet.getString("carnumber");
            String nfc      = resultSet.getString("nfc");
		%>
        <tr>
            <td style="text-align: center"><%=id%></td>
            <td style="text-align: center"><%=name%></td>
            <td style="text-align: center"><%=account%></td>
            <td style="text-align: right"><%=amount%> 원</td>
            <td style="text-align: center"><%=carNumber%></td>
            <td style="text-align: center"><%=nfc%></td>
        </tr>
        <%
        }
        %>
		</table>
		</div>
		<div id="reservation">

			<h3>예약 테이블</h3>

			<table border="1">
			<tr>
				<th>No</th><th>Type</th><th>id</th><th>차량번호</th><th>본인계좌</th><th>상대계좌</th><th>금액</th><th>처리상태</th>
			</tr>
			<%
			query = "select * from reservation order by no desc";
			preparedStmt = conn.prepareStatement(query);
			resultSet = preparedStmt.executeQuery();
			while(resultSet.next()) {
				String no       = resultSet.getString("no");
				String type     = resultSet.getString("type");
				String id		= resultSet.getString("id");
				String carNumber  = resultSet.getString("carnumber");
				String srcAccount = resultSet.getString("src_account");
				String dstAccount = resultSet.getString("dst_account");
				String amount	= resultSet.getString("amount");
				String isDone	= resultSet.getString("isdone");
			%>
			<%if(isDone.equals("F")) {%>
			<tr bgcolor="#ffd1d1">
			<%} else if(isDone.equals("T")) {%>
			<tr bgcolor="#eff0ff">
			<%}%>
				<td style="text-align: center"><%=no%></td>
				<td style="text-align: center"><%switch(type){case "deposit": %>입금<%break; case "withdraw": %>출금<%break; case "send":%>송금<% break;}%></td>
				<td style="text-align: center"><%=id%></td>
				<td style="text-align: center"><%=carNumber%></td>
				<td style="text-align: center"><%=srcAccount%></td>
				<td style="text-align: center"><%=dstAccount%></td>
				<td style="text-align: right"><%=amount%> 원</td>
				<td style="text-align: center"><%switch(isDone){case "T": %>처리 완료<%break; case "F": %>예약중<%}%></td>
			</tr>
			<%
			}
			preparedStmt.close();
			conn.close();
			%>
			</table>
		</div>
	</div>
</body>
<script>
    function initcase(i) {
		if(i == 1)
			document.location.href ='./Init_case_1.jsp';
		else if(i == 2)
			document.location.href ='./Init_case_2.jsp';
		else if(i == 3)
			document.location.href ='./Init_case_3.jsp'; 
		else if(i == 0)
			document.location.href ='./Init_delete.jsp'; 
}
</script>
</html>
