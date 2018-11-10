package hellozin;

import java.util.*;
import java.lang.*;
import com.google.android.gcm.server.*;
import java.sql.ResultSet;

public class FCMSender {
	String MESSAGE_ID = String.valueOf(Math.random() % 100 + 1);
	boolean SHOW_ON_IDLE = false;
	int LIVE_TIME = 1;
	int RETRY = 2;
	String APIKEY = "AIzaSyBb6h-ixtxx_TsZVudOEJTNDxOCE9V_y74";
	String GCMURL = "https://android.googleapis.com/fc/send";
	Message message;

	public FCMSender() {}

	public void Send(String msgFromServer) {
		message = new Message.Builder()
		.collapseKey(MESSAGE_ID)
		.delayWhileIdle(SHOW_ON_IDLE)
		.timeToLive(LIVE_TIME)
		.addData("msgFromServer", msgFromServer)
		.build();

		DBManager manager = new DBManager();
		ResultSet resultSet = manager.executeQuery("select * from token");

		ArrayList<String> token = new ArrayList<>();
		while(resultSet.next())
			token.add(resultSet.getString("token"));

		Sender sender = new Sender(APIKEY);
		sender.send(message, token, RETRY);
	}
}
