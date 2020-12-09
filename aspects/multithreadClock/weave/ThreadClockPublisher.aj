package aspects.multithreadClock.weave;
//package aspects.clock.weave;

import org.prevayler.implementation.publishing.*;
import aspects.multithread.*;
import java.util.*;
import org.prevayler.Transaction;
import aspects.multithread.weave.SynchMethods;



/**
 * ThreadClockPublisher
 */
privileged aspect ThreadClockPublisher extends SynchMethods{

	declare precedence: ThreadClockPublisher, aspects.clock.weave.ClockPublisher;
	declare precedence: ThreadClockPublisher, aspects.multithread.weave.ThreadCentralPublisher;
    
    pointcut publish(CentralPublisher p) : target(p) && cflow(withincode(public void publish(Transaction)));
    
    pointcut pauseClock() : call(private void pauseClock());
    
    pointcut resumeClock() : call(private void resumeClock());
    
    void around(CentralPublisher p) : publish(p) && pauseClock()  {
        
        synchronized (p._pendingSubscriptionMonitor) {  //Blocks all new publications until the subscription is over.
			synchronized (p._pendingPublicationsMonitor) {
				if (p._pendingPublications == 0) proceed(p);
				p._pendingPublications++;
			}
		}
    }
    
    void around(CentralPublisher p) : publish(p) && resumeClock() {
        
       synchronized (p._pendingPublicationsMonitor) {
			p._pendingPublications--;
			if (p._pendingPublications == 0) proceed(p);
		}
	}
    
    private Date CentralPublisher.realTime(Turn myTurn) {
	    try {
	        myTurn.start();
	        return realTime();
	    } finally {	myTurn.end(); }
	}

  
    private void CentralPublisher.notifySubscribers(Transaction transaction, Date executionTime, Turn myTurn) {
     	notifySubscribers(transaction);
	}
    
    pointcut publishWithoutWorry(CentralPublisher p, Transaction t) : 
        target(p) && args(t) && execution(private void publishWithoutWorryingAboutNewSubscriptions(Transaction));
	
	void around(CentralPublisher p, Transaction t) :  publishWithoutWorry(p, t) { 
		Turn myTurn = p.nextTurn();
	
		Date executionTime = p.realTime(myTurn);  //TODO realTime() and approve in the same turn.
			
	//	approve(transaction, executionTime, myTurn);
		p._logger.log(t, executionTime,  myTurn);
		p.notifySubscribers(t,executionTime,  myTurn);
	}
	
	//Abstract Publisher synchronize call.
//	pointcut synchCall2() : execution(private void notifySubscribers(Transaction, Date) );
//	pointcut absTarget(AbstractPublisher a) : target(a) ;
//	void around(AbstractPublisher a):
//        synchCall2() && absTarget(a)
//        { 
//        	
//        	synchronized(a) {
//        	    proceed(a);
//        	}
//        }

	public pointcut synchCall() : execution(private void AbstractPublisher.notifySubscribers(Transaction, Date) );
    
}
