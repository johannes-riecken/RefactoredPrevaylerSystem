package aspects.clock.weave;

import org.prevayler.implementation.publishing.*;
import aspects.clock.*;
//import org.prevayler.foundation.Turn;
import java.util.*;
import org.prevayler.implementation.logging.TransactionLogger;
import org.prevayler.Transaction;
import java.util.LinkedList;


/**
 * ClockPublisher
 */
privileged aspect ClockPublisher {
    

    /** Returns a Clock which is consistent with the Transaction publishing time.
	 */
	abstract public Clock TransactionPublisher.clock();

	/** field originally protected. **/
	 
//   private Clock AbstractPublisher._clock;
	
	
	pointcut notwithin() : !within(AbstractPublisher+)&& !within(ClockPublisher+);
	
	public Clock AbstractPublisher._clock;
	
	//final field error. 
	declare error: 
	        set( Clock AbstractPublisher._clock) && 
	        !withincode(AbstractPublisher.new(..)): "Field is declared final and cannot be assigned outside constructor";
	    
	
	declare error: (set(public Clock AbstractPublisher._clock)
	 				||get(public Clock AbstractPublisher._clock)) 
					&& notwithin(): "Field AbstractPublisher._clock is protected";
					
	/** field originally protected. **/
	
	
	public Clock AbstractPublisher.clock() {
	    
	    return _clock;
	}
	
	public AbstractPublisher.new(Clock clock) {
	 
	    this();
	    _clock = clock;
	    //_subscribers = new LinkedList();
	}
	
	//private synchronized void AbstractPublisher.notifySubscribers(Transaction transaction, Date timestamp) {
	
	/** 
	 *  Method originally protected. - Aspect Protection. 
	 */
	public void AbstractPublisher.notifySubscribers(Transaction transaction, Date timestamp) {
	 
		Iterator i = _subscribers.iterator();
        while (i.hasNext()) ((TransactionSubscriber) i.next()).receive(transaction, timestamp);
    }
	declare error: call(void AbstractPublisher.notifySubscribers(Transaction, Date)) && notwithin() : "Method AbstractPublisher.notifySubscribers is protected";	
	
	/**
	 * End of Aspect protection.
	 */
	    
    private PausableClock CentralPublisher._pausableClock;
    declare error: 
        set(PausableClock CentralPublisher._pausableClock) && 
        !withincode(CentralPublisher.new(..)): "Field is declared final and cannot be assigned outside constructor";
  
	
	public CentralPublisher.new(Clock clock, TransactionLogger logger) {
	    /* AJSTATS super(new PausableClock(clock)); */
	   // this(logger);
		_pausableClock = (PausableClock)_clock; //This is just to avoid casting the inherited _clock every time.
		//_censor = censor;
		//this(logger);
		_logger = logger;
	}
	
	private Date CentralPublisher.realTime() {
		try {
		    //myTurn.start();
	   		return _pausableClock.realTime();
		} finally {	
		    //myTurn.end(); 
		}
	}
	
	pointcut publish(CentralPublisher p, Transaction t) : target(p) 
		&& args(t) && 
		execution(private void publishWithoutWorryingAboutNewSubscriptions(Transaction));
	
	void around(CentralPublisher p, Transaction t) : publish(p, t) {
	   
	    Date executionTime = p.realTime();  //TODO realTime() and approve in the same turn.
	    //	approve(transaction, executionTime, myTurn);
	    p._logger.log(t, executionTime);
	    p.notifySubscribers(t, executionTime);	    
	}
	

	/***
	 * Notify Subscribers
	 */
	private void CentralPublisher.notifySubscribers(Transaction transaction, Date executionTime) {
		notifySubscribers(transaction);	
	}
	
	private Date dateex;
	  
	pointcut notifyDate(Transaction tr, Date ex) : call(private void CentralPublisher.notifySubscribers(Transaction, Date, ..)) && args(tr, ex, ..);
	before (Transaction tr, Date ex) : notifyDate(tr, ex) {
	      dateex = ex;
	}
	
	pointcut notifyExec(CentralPublisher p, Transaction tr) : target(p) && args(tr) && execution(public void CentralPublisher.notifySubscribers(Transaction));
	
	void around(CentralPublisher p, Transaction t): notifyExec(p, t){
		p._pausableClock.advanceTo(dateex);
			p.notify(t, dateex);
	}
	 private void CentralPublisher.notify(Transaction t, Date ex) {
	     
	 	super.notifySubscribers(t, ex);
	 }
	
	pointcut publishCall(CentralPublisher p) : target(p) && execution(public void publish(Transaction)); 
	void around(CentralPublisher p) : publishCall(p) {
	  
	    try {	       
	        p.pauseClock();	        
	        proceed(p);
	    }
	    catch(Exception e) {
	        
	    }
	    finally {
	        p.resumeClock();
	    }	  
	}
	
	private void CentralPublisher.pauseClock() {
	    _pausableClock.pause();
	}
	
	private void CentralPublisher.resumeClock() {
	    _pausableClock.resume();
	}
}
