package aspects.clock.weave;

import org.prevayler.implementation.logging.*;
import org.prevayler.Transaction;
import java.util.*;
//import org.prevayler.foundation.*;
import org.prevayler.implementation.*;
import org.prevayler.implementation.publishing.*;


/**
 * ClockTransientLogger
 */
privileged aspect ClockTransientLogger {
    
    /***Presentation Part***/
    public void TransientLogger.log(Transaction transaction, Date executionTime) {        
        log(transaction);
    }

    private Date dateex;
    private Transaction transaction;
	  
    pointcut logDate(Transaction tr, Date ex, TransientLogger tl) :
        target(tl) &&
      call(public void log(Transaction, Date, ..)) && args(tr, ex, ..);
  
    before (Transaction tr, Date ex, TransientLogger tl) : logDate(tr, ex, tl) {
      dateex = ex;
      transaction = tr;
    }
   
    pointcut inLog() : withincode(public void TransientLogger.log(Transaction, ..));    
    pointcut logadd(TransientLogger t) : this(t) && call(public boolean add(Object));    
    boolean around(TransientLogger l) : inLog() && logadd(l) {
        return l.log.add(new TransactionTimestamp(transaction, dateex));
    }
    
    /***Presentation Part***/
    
    pointcut inupdate() :withincode(void TransientLogger.update(..)) ;

	pointcut receiveCall(TransactionSubscriber s) : target(s) && call(public void TransactionSubscriber.receive(Transaction)) ;
	
	/**
	 * Get transactiontimestamp entry.
	 */	
	pointcut listGet(): call(public Object java.util.List.get(int));
	private TransactionTimestamp entry; 	
	after() returning(Object o) : within(TransientLogger) && listGet() {
		entry = (TransactionTimestamp)o;
	}
	
	void around(TransactionSubscriber s) : 
	    inupdate() &&  receiveCall(s) {
	  	s.receive(entry.transaction(), entry.timestamp());
	}
	
}
