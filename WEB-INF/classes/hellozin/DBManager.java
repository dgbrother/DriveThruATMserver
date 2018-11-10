package hellozin;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class DBManager {
	final String JDBC_URL = "jdbc:mysql://localhost/jspdb?serverTimezone=UTC&useUnicode=true&characterEncoding=utf8";
	final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	public DBManager() {}
	
	private void connect() {
		try {
			Class.forName(JDBC_DRIVER);
			conn = DriverManager.getConnection(JDBC_URL, "root", "ghqkrth");
		}  catch (SQLException | ClassNotFoundException ex) {
			ex.printStackTrace();
		}
	}
	
	private void disconnect() {
		try {
			if(pstmt != null)
				pstmt.close();
			if(conn != null)
				conn.close();
		}  catch (SQLException ex) {
			ex.printStackTrace();
		}
	}
	
	public ArrayList<String> executeQuery(String query) {
		connect();
		ArrayList<String> tokenList = null;
		try {
			pstmt = conn.prepareStatement(query);
            ResultSet resultSet = pstmt.executeQuery();
            tokenList = new ArrayList<>();
            while(resultSet.next()) {
                tokenList.add(resultSet.getString("token"));
            }
		} catch (SQLException e) {
			e.printStackTrace();
		}
		disconnect();
		return tokenList;
	}
}
