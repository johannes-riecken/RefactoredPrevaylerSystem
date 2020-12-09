package aspects.replicationThread.weave;

import aspects.replication.*;

/**
 * ServerListenerThread
 */
public aspect ServerListenerThread {
    declare parents: ServerListener extends Thread;

	pointcut inConstr(ServerListener s) : target(s) && withincode(ServerListener.new(..));
	pointcut runCall() : call( void run()); 
	void around(ServerListener s) : inConstr(s) && runCall() {
	    s.setDaemon(true);
		s.start();
	}
}
