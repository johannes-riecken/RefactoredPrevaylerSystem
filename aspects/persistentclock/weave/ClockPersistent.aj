package aspects.persistentclock.weave;

import aspects.persistentLogging.*;
import org.prevayler.Transaction;
import java.util.Date;
import org.prevayler.implementation.*;
import org.prevayler.implementation.publishing.*;
/**
 * ClockPersistent
 */
privileged aspect ClockPersistent {
    
	
    public void PersistentLogger.log(Transaction transaction, Date executionTime) {    	
    	log(transaction);
    }
    
    Date logDate;
    pointcut logCall(Date ex, PersistentLogger p,Transaction tr) : target(p) && args(tr,ex,..) &&  call(public void log(Transaction,Date,..));
    before(Date ex, PersistentLogger p,Transaction tr) : logCall(ex, p, tr) {
        logDate = ex;
    }
     
    pointcut inLog() : withincode(public void PersistentLogger.log(Transaction));
    pointcut callTransactionStamp(Transaction tr) : args(tr) && call(TransactionTimestamp.new(Transaction));

    TransactionTimestamp around(Transaction tr ) : callTransactionStamp(tr)&& inLog()  {
	 	return new TransactionTimestamp(tr, logDate);
	}

//    pointcut inLog(PersistentLogger p, Transaction tr, Date ex) : this(p) && args(tr,ex)
//		&& withincode(public void PersistentLogger.log(Transaction,Date)); 
//
//    pointcut callTransactionStamp() : call(TransactionTimestamp.new(Transaction));
//   
//    TransactionTimestamp around(PersistentLogger p, Transaction tr, Date ex) : 
//    	callTransactionStamp()&& cflow(inLog(p, tr,ex)) {
//       
//    	return new TransactionTimestamp(tr, ex);
//    }
 
    //pointcut callSync(DurableOutputStream stream) : target(stream) && call(public void sync(..)); 
    
//    void around(PersistentLogger p, Transaction tr, Date ex, DurableOutputStream s) : 
//    	callSync(s)&& cflow(inLog(p, tr,ex)) {
//    	try {
//        	s.sync(new TransactionTimestamp(tr, ex));
//        } catch (IOException iox) {
//			p.handleExceptionWhileWriting(iox, p._outputLog.file());
//		}
//
//    }
//    
    
    
//    pointcut inrecover(TransactionSubscriber s) : withincode(private long PersistentLogger.recoverPendingTransactions(TransactionSubscriber, ..))
//		&& args(s);
//    
//    pointcut receiveCall() : call(public void TransactionSubscriber.receive(Transaction)) ;
//    
//    pointcut setentry(TransactionTimestamp e) : args(e) && set(TransactionTimestamp entry);
//    
//    private TransactionTimestamp entry; 
//    
//    after(TransactionSubscriber s, TransactionTimestamp e) : inrecover(s) && setentry(e) { 
//    	entry = e;
//    }
//    
//    void around(TransactionSubscriber s) : inrecover(s) &&  receiveCall() { 
//    	s.receive(entry.transaction(), entry.timestamp());
//    }
    
//    pointcut inrecover(TransactionSubscriber s) : 
//        withincode(private long PersistentLogger.recoverPendingTransactions(TransactionSubscriber, ..))
//		&& args(s);
	
    pointcut inrecover() : withincode(private long PersistentLogger.recoverPendingTransactions(..));	
	pointcut receiveCall(TransactionSubscriber s) :target(s) && call(public void TransactionSubscriber.receive(Transaction)) ;
	pointcut readObjectCall(SimpleInputStream s) :target(s) && call(public Object readObject());
	
	private TransactionTimestamp entry; 

	after(SimpleInputStream st) returning(Object o) : 
		  inrecover() && readObjectCall(st) {
			entry = (TransactionTimestamp)o;
	}

	
	void around(TransactionSubscriber s) : 
	     inrecover() && receiveCall(s) {
			s.receive(entry.transaction(), entry.timestamp());
	}

		
}
