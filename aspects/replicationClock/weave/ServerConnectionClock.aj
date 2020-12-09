package aspects.replicationClock.weave;

import java.util.Date;
import org.prevayler.Transaction;
import aspects.replication.*;
import java.io.*;

/**
 * ServerConnectionClock
 */
privileged aspect ServerConnectionClock {
    public void ServerConnection.receive(Transaction transaction, Date timestamp) {
		try {
		   //synchronized (_toRemote) {
				_toRemote.writeObject(transaction == _remoteTransaction
					? (Object)REMOTE_TRANSACTION
					: transaction
				);
				_toRemote.writeObject(timestamp);
			//}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

    pointcut insendClockTicks(ServerConnection s) : this(s) && withincode(private void sendClockTicks());    
    pointcut writeObjCall(ObjectOutputStream to): target(to) && call(* writeObject(..));    
    after(ObjectOutputStream to, ServerConnection s) : insendClockTicks(s) && writeObjCall(to) {
        try {
          
            to.writeObject(s._publisher.clock().time());
          
        }  catch (Exception ex) {
			ex.printStackTrace();
		}
        
    }
}
