package aspects.censorclock.weave;

import org.prevayler.implementation.logging.TransactionLogger;
import org.prevayler.implementation.publishing.*;
import aspects.censorship.*;
import org.prevayler.*;
import aspects.clock.*;
import aspects.snapshot.*;
import java.util.*;

/**
 * ClockPublisher
 */
privileged aspect ClockPublisher {
	  public CentralPublisher.new(Clock clock, TransactionCensor censor, TransactionLogger logger) {
	   	/* AJSTATS super(new PausableClock(clock)); */
	  	
		_pausableClock = (PausableClock)_clock; //This is just to avoid casting the inherited _clock every time.
//
		_censor = censor;
		 // this(logger);
		_logger = logger;   
		
	  }
	  
	  
	  private SnapshotManager snapshot; 
	
	  
	  pointcut a(PrevaylerFactory f, SnapshotManager sm) : this(f) && args(sm) && execution(private TransactionPublisher publisher(SnapshotManager));

	  before(PrevaylerFactory f, SnapshotManager sm) : a(f, sm) {
		    snapshot = (SnapshotManager)(thisJoinPoint.getArgs())[0];
	  }
	  
	  private PrevaylerFactory _factory;
	  pointcut createFactory(PrevaylerFactory factory) : target(factory) && call(public Prevayler create()); 
	  before(PrevaylerFactory f): createFactory(f) {
		    _factory = f;
	  }
	
	  pointcut factoryPublish():call (CentralPublisher.new(Clock, TransactionLogger));

	  CentralPublisher around() : factoryPublish() {
	      return new CentralPublisher(_factory.clock(), _factory.censor(snapshot), _factory.logger());
	  }
	  
	  private void CentralPublisher.approve(Transaction transaction, Date executionTime) throws RuntimeException, Error {
	    approve(transaction);
//		try {
//			myTurn.start();
//			_censor.approve(transaction, executionTime);
//			myTurn.end();
//		} catch (RuntimeException r) { myTurn.alwaysSkip(); throw r;
//		} catch (Error e) {	myTurn.alwaysSkip(); throw e; }
	  }
	  
	  private CentralPublisher publisher;
	  private Date dateex;
	  
	  pointcut approveDate(Transaction tr, Date ex) : call(private void CentralPublisher.approve(Transaction, Date, ..)) && args(tr, ex, ..);
	  before (Transaction tr, Date ex) : approveDate(tr, ex) {
	      dateex = ex;
	  }
	  
	  pointcut inapprove( Transaction tr): args(tr, ..) && withincode(private void CentralPublisher.approve(Transaction,  ..));
	  pointcut callapprove() : call(public void TransactionCensor.approve(..));

	  void around(Transaction tr) : inapprove( tr) && callapprove() {
	      publisher._censor.approve(tr, dateex);
	  }
	    
	  pointcut pubWorry(CentralPublisher p) : target(p) && call(private void publishWithoutWorryingAboutNewSubscriptions(..));	  
	  before(CentralPublisher p) : pubWorry(p) {
	      publisher = p;
	  }
	  
	  pointcut centralPubCut(Transaction t, Date exTime) : args(t,exTime) &&  call (public void TransactionLogger.log(Transaction, Date));
	 	
	  before (Transaction t, Date exTime) :     centralPubCut( t, exTime)
	  {
			publisher.approve(t, exTime);
	  }		
}

