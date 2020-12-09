package aspects.multithread.weave;


import org.prevayler.implementation.publishing.*;
import org.prevayler.Transaction;
import aspects.multithread.*;
/**
 * ThreadCentralPublisher
 */
privileged aspect ThreadCentralPublisher {

    private final Object CentralPublisher._pendingSubscriptionMonitor = new Object();
	private volatile int CentralPublisher._pendingPublications = 0;
	private final Object CentralPublisher._pendingPublicationsMonitor = new Object();

	private Turn CentralPublisher._nextTurn = Turn.first();
	private final Object CentralPublisher._nextTurnMonitor = new Object();
    
    
        
    
    private Turn CentralPublisher.nextTurn() {
       synchronized (_nextTurnMonitor) {
			Turn result = _nextTurn;
			_nextTurn = _nextTurn.next();
			return result;
		}
	}
   
    pointcut publish(CentralPublisher p, Transaction t) : 
        target(p) && args(t) && execution(private void publishWithoutWorryingAboutNewSubscriptions(Transaction));
	
	void around(CentralPublisher p, Transaction t) : publish(p, t) {
	    Turn myTurn = p.nextTurn();
		
	//	Date executionTime = realTime(myTurn);  //TODO realTime() and approve in the same turn.
	//	approve(transaction, executionTime, myTurn);
		p._logger.log(t, myTurn);
		p.notifySubscribers(t, myTurn);
	}
    

	/***
	 * Notify Subscribers. 
	 */ 
	private void CentralPublisher.notifySubscribers(Transaction transaction, Turn myTurn) {
	    notifySubscribers(transaction);
	}
	
	pointcut notify(Turn tu) : args(..,tu) && 
		execution(private void CentralPublisher.notifySubscribers(Transaction,.., Turn) );	
	
	void around( Turn tu) : notify(tu) {
	    try {
	        tu.start();
	        proceed( tu);	        
	    }
	    finally {
	        tu.end();
	    }
	}		
		
	/***
	 * Add subscriber
	 */
	pointcut addSub(CentralPublisher p, TransactionSubscriber s, long l) : 
	    	target(p) && args(s,l) && execution(public void addSubscriber(TransactionSubscriber, long ));
	
	void around(CentralPublisher p, TransactionSubscriber s, long l) : addSub(p, s, l) {
	    synchronized (p._pendingSubscriptionMonitor) {
			while (p._pendingPublications != 0) Thread.yield();
			proceed(p, s, l);
		}
	}
	
}
