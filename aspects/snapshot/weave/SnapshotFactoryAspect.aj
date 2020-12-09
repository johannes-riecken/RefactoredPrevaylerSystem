package aspects.snapshot.weave;

import aspects.snapshot.*;
import org.prevayler.implementation.*;
import org.prevayler.PrevaylerFactory;
import java.io.IOException;
import org.prevayler.implementation.publishing.*;
import java.io.Serializable;
import org.prevayler.Prevayler;

/**
 * SnapshotAspect
 */
privileged aspect SnapshotFactoryAspect {
    private SnapshotManager PrevaylerFactory._snapshotManager;    

	/** Configures the SnapshotManager to be used by the Prevayler created by this factory. The default is a SnapshotManager which uses plain Java serialization to create its .snapshot files.
	 */
	public void PrevaylerFactory.configureSnapshotManager(SnapshotManager snapshotManager) {
	   _snapshotManager = snapshotManager;
	}
	
	private SnapshotManager PrevaylerFactory.snapshotManager() throws ClassNotFoundException, IOException {
		return _snapshotManager != null
			? _snapshotManager
			: new SnapshotManager(prevalentSystem(), prevalenceBase());
	}	
	
	/*PrevaylerFactory advices 
	 */
	private TransactionPublisher PrevaylerFactory.publisher(SnapshotManager snapshotManager) throws IOException, ClassNotFoundException {
	 	//if (_remoteServerIpAddress != null) return new ClientPublisher(_remoteServerIpAddress, _remoteServerPort);
		//return new CentralPublisher(clock(), censor(snapshotManager), logger());
		//return new CentralPublisher(clock(), logger());
	    return new CentralPublisher(logger());
	}
	
	pointcut myCut(Serializable newPrevalentSystem, PrevaylerFactory factory) : target(factory) && args(newPrevalentSystem) && call(void configurePrevalentSystem(..)) && withincode(static Prevayler PrevaylerFactory.createTransientPrevayler(..)); 

	after (Serializable newPrevalentSystem, PrevaylerFactory factory) : myCut(newPrevalentSystem, factory)
	{
		factory.configureSnapshotManager(new NullSnapshotManager(newPrevalentSystem, "Transient Prevaylers are unable to take snapshots."));
	}	

	pointcut createFactory(PrevaylerFactory factory) : target(factory) && call(public Prevayler create()); 
	
	Prevayler around (PrevaylerFactory factory) throws IOException, ClassNotFoundException : createFactory(factory) 
	{
	    SnapshotManager snapshotManager = factory.snapshotManager();
	    TransactionPublisher publisher = factory.publisher(snapshotManager);
	    
//		if (factory._serverPort != -1) {
//		    new ServerListener(publisher, factory._serverPort);
//		}
	  
		return new PrevaylerImpl(snapshotManager, publisher);
	}
}
