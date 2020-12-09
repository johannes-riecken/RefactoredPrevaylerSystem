package aspects.snapshot.weave;

import aspects.snapshot.*;
import org.prevayler.implementation.*;
import java.io.IOException;
import org.prevayler.implementation.publishing.*;
import org.prevayler.Prevayler;


privileged aspect SnapshotPrevaylerAspect {
    //private final SnapshotManager PrevaylerImpl._snapshotManager;
    private  SnapshotManager PrevaylerImpl._snapshotManager;
    
    declare error: 
        set(SnapshotManager PrevaylerImpl._snapshotManager) && 
        !withincode(PrevaylerImpl.new(..)): "Field is declared final and cannot be assigned outside constructor";
        
        
    
    public void PrevaylerImpl.takeSnapshot() throws IOException {
	   // synchronized (_prevalentSystem) {
	        _snapshotManager.writeSnapshot(_prevalentSystem, _systemVersion);
	    //}
	}
	
	public PrevaylerImpl.new(SnapshotManager snapshotManager, TransactionPublisher transactionPublisher) throws IOException, ClassNotFoundException {
	   
		_snapshotManager = snapshotManager;
		_prevalentSystem = _snapshotManager.recoveredPrevalentSystem();
		_systemVersion = _snapshotManager.recoveredVersion();

		_publisher = transactionPublisher;
		//_clock = _publisher.clock();

		_ignoreRuntimeExceptions = true;     //During pending transaction recovery (rolling forward), RuntimeExceptions are ignored because they were already thrown and handled during the first transaction execution.
		_publisher.addSubscriber(subscriber(), _systemVersion + 1);
		_ignoreRuntimeExceptions = false;
	}
	
	
	
	/** Produces a complete serialized image of the underlying PrevalentSystem.
	 * This will accelerate future system startups. Taking a snapshot once a day is enough for most applications.
	 * This method synchronizes on the prevalentSystem() in order to take the snapshot. This means that transaction execution will be blocked while the snapshot is taken.
	 * @throws IOException if there is trouble writing to the snapshot file.
	 */
	abstract public void Prevayler.takeSnapshot() throws IOException;

	
   
}
