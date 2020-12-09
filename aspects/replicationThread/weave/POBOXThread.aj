package aspects.replicationThread.weave;

import aspects.replication.*;
import org.prevayler.implementation.TransactionTimestamp;
import aspects.multithread.weave.SynchMethods;
/**
 * POBOXThread
 */
privileged aspect POBOXThread extends SynchMethods{
	
    declare parents: POBox extends Thread;

	pointcut inConstr(POBox p) : target(p) && withincode(POBox.new(..));
	pointcut run() : call(public void run());
	
	void around(POBox p) : inConstr(p) && run() {	    
	    p.setDaemon(true);	    
		p.start();
	}
	
	
	
	pointcut POBoxTarget(POBox p) : target(p);    
	//pointcut receiveExec() : execution(public void receive(..) );
	
	    
//	void around(POBox p) : POBoxTarget(p) && receiveExec() {
//	        
//	       synchronized(p) {
//	           proceed(p);
//	       }
//	}
	declare parents: POBox implements SynchMethods.Synch;
	public pointcut synchCall() : execution(public void POBox.receive(..) ); 
	//||execution(private TransactionTimestamp POBox.waitForNotification()) ;
	
	TransactionTimestamp around(POBox p) : POBoxTarget(p) && waitNotifExec() {
        
       synchronized(p) {
           return proceed(p);
       }
	}
	
	pointcut inReceive(POBox p) :this(p) && withincode(public void receive(..));
	pointcut callAdd() : call(* *.add(..));
	
	after(POBox p) : inReceive(p) && callAdd(){ 
	    p.notify();	    
	}
	
	pointcut waitNotifExec() : execution(private TransactionTimestamp waitForNotification());
	before(POBox p) : POBoxTarget(p)  && waitNotifExec() { 
	    while (p._queue.size() == 0) p.waitWithoutInterruptions();    
	}
	
	pointcut inWaitWithoutInter(): execution(void waitWithoutInterruptions());
	
	void around(POBox p): POBoxTarget(p) && inWaitWithoutInter() { 
	    try {
		   p.wait();
		} catch (InterruptedException e) {
			throw new RuntimeException("Unexpected InterruptedException.");
		}
	}

//	private void POBox.waitWithoutInterruptions() {
//		try {
//			((POBox)this).wait();
//		} catch (InterruptedException e) {
//			throw new RuntimeException("Unexpected InterruptedException.");
//		}
//	}

	    
	
}
