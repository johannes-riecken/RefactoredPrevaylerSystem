package aspects.replicationsnapshot.weave;

import aspects.snapshot.*;
import org.prevayler.PrevaylerFactory;
import org.prevayler.implementation.publishing.TransactionPublisher;
import aspects.replication.*;
import java.io.IOException;
import org.prevayler.*;
/**
 * ReplicationSnapshot
 */
privileged aspect ReplicationSnapshot {

    private PrevaylerFactory factory;
	pointcut publishercall(PrevaylerFactory f, SnapshotManager sm) : this(f) && args(sm) && execution(private TransactionPublisher publisher(SnapshotManager));
	
	TransactionPublisher around(PrevaylerFactory f, SnapshotManager sm) /* AJSTATS throws IOException, ClassNotFoundException */ : publishercall(f, sm) {
	    if (f._remoteServerIpAddress != null) return new ClientPublisher(f._remoteServerIpAddress, f._remoteServerPort);
		return proceed(f, sm);
	}
	
//	after(PrevaylerFactory prev) returning(TransactionPublisher publisher) /* AJSTATS throws IOException, ClassNotFoundException */ : this(prev) && call(TransactionPublisher publisher(SnapshotManager) /* AJSTATS throws IOException, ClassNotFoundException */)
//	{
//		if (prev._serverPort != -1) new ServerListener(publisher, prev._serverPort);
//	}
	
	pointcut createFactory(PrevaylerFactory factory) : target(factory) && call(public Prevayler create()); 
	before(PrevaylerFactory f): createFactory(f) {
	    factory = f;
	}
	
	after() returning(TransactionPublisher publisher) /* AJSTATS throws IOException */: call(TransactionPublisher publisher(SnapshotManager) /* AJSTATS throws IOException, ClassNotFoundException */)
	{
	    if (factory._serverPort != -1) new ServerListener(publisher, factory._serverPort);
	}

}
