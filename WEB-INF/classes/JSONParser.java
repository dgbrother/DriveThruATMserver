package dgbrother;

import org.json.simple.*; 
import java.util.*;
 
public class JSONParser {
    public static JSONArray resultSetToJsonArray(ResultSet rs) {
	JSONArray jsonArray = new JSONArray();
	
	while(rs.next()){
	    int numColumns = rs.getMetaData().getColumnCount();
	    JSONObject jsonObject = new JSONObject();
	    for(int i = 1; i <= numColumns; i++) {
		String columnName = rs.getMetaData().getColumnName(i);
		jsonObject.put(columnName, rs.getObject(columnName));
	    }
	    jsonArray.add(jsonObject);
	}
	return jsonArray;
    }
}
