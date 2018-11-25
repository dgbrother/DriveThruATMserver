#!/bin/bash
javac -cp $WEBDIR/WEB-INF/lib/gcm.server.jar:$WEBDIR/WEB-INF/lib/json_simple-1.1.jar:$WEBDIR/WEB-INF/lib/websocket-api.jar $WEBDIR/WEB-INF/classes/hellozin/*.java
exit 0
