package aspects.censorship.weave;
import aspects.censorship.*;
import org.prevayler.PrevaylerFactory;
import aspects.snapshot.*;
import org.prevayler.implementation.publishing.*;
import org.prevayler.implementation.logging.*;
/**
 * CensorAspect
 */
privileged aspect CensorFactoryAspect {
    
      private boolean PrevaylerFactory._transactionFiltering = true;
    
    /** Determines whether the Prevayler created by this factory should filter out all Transactions that would throw a RuntimeException or Error if executed on the Prevalent System (default is true). This requires enough RAM to hold another copy of the prevalent system.
	 */
	public void PrevaylerFactory.configureTransactionFiltering(boolean transactionFiltering) {
		_transactionFiltering = transactionFiltering;
	}
	
	private TransactionCensor PrevaylerFactory.censor(SnapshotManager snapshotManager) {
	    return _transactionFiltering
			? (TransactionCensor) new StrictTransactionCensor(snapshotManager)
			: new LiberalTransactionCensor(); 
	}
	
    
	pointcut a(PrevaylerFactory f, SnapshotManager sm) : this(f) && args(sm) && execution(private TransactionPublisher publisher(SnapshotManager));

	private SnapshotManager snapshot; 
	before(PrevaylerFactory f, SnapshotManager sm) : a(f, sm) {
	    snapshot = (SnapshotManager)(thisJoinPoint.getArgs())[0];
	}
	
	pointcut factoryPublish(PrevaylerFactory f) : this(f) && call (CentralPublisher.new(TransactionLogger));		

	CentralPublisher around(PrevaylerFactory f) : factoryPublish(f) {
	    //return new CentralPublisher(f.clock(), f.censor(snapshot), f.logger());
	    return new CentralPublisher(f.censor(snapshot), f.logger());
	}


}
