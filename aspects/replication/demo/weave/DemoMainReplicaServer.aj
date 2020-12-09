package aspects.replication.demo.weave;

import org.prevayler.PrevaylerFactory;
import org.prevayler.demos.demo2.MainReplicaServer;
import org.prevayler.Prevayler;
/**
 * DemoMainReplicaServer
 */
public aspect DemoMainReplicaServer {

    pointcut mainReplicaServer(PrevaylerFactory f) : 
    	target(f) &&
    	call (public Prevayler create()) &&
    	within(MainReplicaServer);

	before(PrevaylerFactory f) : mainReplicaServer(f) {
	    
	    //f.configureReplicationClient("localhost", PrevaylerFactory.DEFAULT_REPLICATION_PORT);
	    f.configureReplicationServer(PrevaylerFactory.DEFAULT_REPLICATION_PORT);
	}
}
