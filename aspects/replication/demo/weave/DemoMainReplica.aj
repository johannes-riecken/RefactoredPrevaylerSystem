package aspects.replication.demo.weave;

import org.prevayler.PrevaylerFactory;
import org.prevayler.demos.demo2.MainReplica;
import org.prevayler.Prevayler;

/**
 * DemoMainReplica
 */
privileged aspect DemoMainReplica {
    pointcut mainReplica(PrevaylerFactory f) : 
        	target(f) &&
        	call (public Prevayler create()) &&
        	within(MainReplica);
    
    before(PrevaylerFactory f) : mainReplica(f) {
    	f.configureReplicationClient("localhost", PrevaylerFactory.DEFAULT_REPLICATION_PORT);     	    
    }
}


