package aspects.replicationThread.weave;

import aspects.replication.*;
import org.prevayler.Transaction;
import org.prevayler.implementation.publishing.*;

import aspects.multithread.weave.SynchMethods;
/**
 * ClientPubThread
 */
privileged aspect ClientPubThread extends SynchMethods{
    //TODO: made these unfinal. 
//    private final Object _upToDateMonitor = new Object();
    private final Object ClientPublisher._upToDateMonitor = new Object();
    //private final Object _myTransactionMonitor = new Object();
    private final Object ClientPublisher._myTransactionMonitor = new Object();
	
	

    // Synchronized.
    declare parents: ClientPublisher implements SynchMethods.Synch;
    public pointcut synchCall() : 
        execution(public void ClientPublisher.addSubscriber(TransactionSubscriber, long)) 
        || execution(public void ClientPublisher.publish(Transaction));
    // Synchronized.
    
    pointcut ClientTarget(ClientPublisher p) : target(p);    
//    pointcut syncPoints() : 
//        execution(public void addSubscriber(TransactionSubscriber, long)) 
//        || execution(public void publish(Transaction));
//    
//    void around(ClientPublisher p) : ClientTarget(p) && syncPoints() {
//        synchronized(p) {
//            proceed(p);
//        }
//    }
    
   
   
    
    pointcut listenCall() : execution(private void startListening()); 
    void around(final ClientPublisher p) : ClientTarget(p) && listenCall() {
        Thread listener = new Thread() {
			public void run() {
				 proceed(p);				
			}
		};
		listener.setDaemon(true);
		listener.start();
    }
    
    /*** Add Subscriber synch-wait call**/
    pointcut inAddSub(ClientPublisher p) : this(p) && withincode(public void ClientPublisher.addSubscriber(TransactionSubscriber,long));
    
    pointcut writeObj() : call(void java.io.ObjectOutputStream.writeObject(Object)); 
    
    void around(ClientPublisher p) : inAddSub(p) && writeObj() {
        synchronized (p._upToDateMonitor) {
			proceed(p);
			ClientPublisher.wait(p._upToDateMonitor);
		}
    }        
    /*** Add Subscriber synch-wait call**/
    
    
    /***ReceiveTransactionFrom Server Notify call***/
        
    pointcut receiveExec(ClientPublisher p) : target(p) && call(private void helperReceiveTransactionFromServer(..));

    Object transactionCandidate;
    
    pointcut inReceive(ClientPublisher p) : target(p) && withincode(private void receiveTransactionFromServer());
    pointcut inHelperReceive(ClientPublisher p) : target(p) && withincode(private void helperReceiveTransactionFromServer(..));
    pointcut getCand() : call(* ClientPublisher.getTransactionCandidate());
    
    after() returning (Object o) :  getCand() { 
        transactionCandidate = o;
    }
    
    
   void  around(ClientPublisher p) : receiveExec(p) {        
    
		if (transactionCandidate.equals(ServerConnection.SUBSCRIBER_UP_TO_DATE)) {
			synchronized (p._upToDateMonitor) { p._upToDateMonitor.notify(); }
			return;
		}
		
		if (transactionCandidate instanceof RuntimeException) {
			p._myTransactionRuntimeException = (RuntimeException)transactionCandidate;
			p.notifyMyTransactionMonitor();
			return;
		}
		if (transactionCandidate instanceof Error) {
			p._myTransactionError = (Error)transactionCandidate;
			p.notifyMyTransactionMonitor();
			return;
		}
		proceed(p);

    }
    
//    pointcut receiveCall() :call(public void TransactionSubscriber.receive(..)) ;
//  
//    after(ClientPublisher p) : inHelperReceive(p) && receiveCall() {
//        if (transactionCandidate.equals(ServerConnection.REMOTE_TRANSACTION)) {	
//            p.notifyMyTransactionMonitor();
//        }
//  	}
//    
       
    pointcut helperExec(ClientPublisher p) : target(p) &&  execution(private void ClientPublisher.helperReceiveTransactionFromServer(..));
 
    after(ClientPublisher p) returning() : helperExec(p) {
    
        if (transactionCandidate.equals(ServerConnection.REMOTE_TRANSACTION)) {	
            p.notifyMyTransactionMonitor();
        }
  	}
    
    
  
    /***Publish***/
    pointcut publishHelper(ClientPublisher p) : this(p) && call(private void ClientPublisher.publishHelper(..));
    void around(ClientPublisher p) : publishHelper(p) {
        synchronized (p._myTransactionMonitor) {
            proceed(p);
        }
    }
  
    pointcut inPubHelper() : withincode(private void ClientPublisher.publishHelper(..));
    pointcut callStackTrace() : call(* *.printStackTrace(..));
  
    after() : inPubHelper() && callStackTrace() {
	      while (true) Thread.yield();
	}
    
    pointcut callThrow(ClientPublisher p): this(p) && call (* *.throwEventualErrors(..));
    
    before(ClientPublisher p) : callThrow(p) && inPubHelper() {
        ClientPublisher.wait(p._myTransactionMonitor);        
    }
    
    /***Wait and Notify Method calls.***/
    private static void ClientPublisher.wait(Object monitor) {
		try {
			monitor.wait();
		} catch (InterruptedException ix) {
			throw new RuntimeException("Unexpected InterruptedException.");
		}
	}


	private void ClientPublisher.notifyMyTransactionMonitor() {
		synchronized (_myTransactionMonitor) {
			_myTransactionMonitor.notify();
		}
	}
        
}
