/*
 * Created on 14-Jun-2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package aspects.replication.weave;

import aspects.replication.ServerListener;
import aspects.replication.ClientPublisher;
import org.prevayler.implementation.publishing.*;
import java.io.IOException;
import org.prevayler.*;

/**
 * @author igodil
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
privileged aspect ReplicationAspect {
		private int PrevaylerFactory._serverPort = -1;
		private String PrevaylerFactory._remoteServerIpAddress;
		private int PrevaylerFactory._remoteServerPort;
		public static final int PrevaylerFactory.DEFAULT_REPLICATION_PORT = 8756;
		
		/** Reserved for future implementation.
		 */
		public void PrevaylerFactory.configureReplicationClient(String remoteServerIpAddress, int remoteServerPort) {
			_remoteServerIpAddress = remoteServerIpAddress;
			_remoteServerPort = remoteServerPort;
		}

		/** Reserved for future implementation.
		 */
		public void PrevaylerFactory.configureReplicationServer(int port) {
			_serverPort = port;
		}
		
		TransactionPublisher around(PrevaylerFactory prev) /* AJSTATS throws IOException, ClassNotFoundException */ : target(prev) && execution(TransactionPublisher publisher() /* AJSTATS throws IOException, ClassNotFoundException */) 
		{	
		    
			if (prev._remoteServerIpAddress != null)
			 return new ClientPublisher(prev._remoteServerIpAddress, prev._remoteServerPort);
			else {
				return proceed(prev);
			}
		}
		
		
		after(PrevaylerFactory prev) returning(TransactionPublisher publisher) /* AJSTATS throws IOException, ClassNotFoundException */: target(prev) && call(TransactionPublisher publisher() /* AJSTATS throws IOException, ClassNotFoundException */) && withincode(Prevayler PrevaylerFactory.create() /* AJSTATS throws IOException, ClassNotFoundException */)
		{
		    if (prev._serverPort != -1) new ServerListener(publisher, prev._serverPort);
		}

}
