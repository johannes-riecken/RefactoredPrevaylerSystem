package aspects.replicationClock.weave;

import aspects.replication.POBox;
import java.util.Date;
import org.prevayler.Transaction;
import org.prevayler.implementation.TransactionTimestamp;
import org.prevayler.implementation.publishing.*;

/**
 * POBOXClock
 */
privileged aspect POBOXClock {

    //public synchronized void POBox.receive(Transaction transaction, Date timestamp) {
    public void POBox.receive(Transaction transaction, Date timestamp) {
		_queue.add(new TransactionTimestamp(transaction, timestamp));
		//notify();
	}
    
    
    pointcut inrun() : withincode(public void POBox.run());
    pointcut waitCall(POBox p) : this(p) && call(TransactionTimestamp *.waitForNotification()); 
    
    after(POBox p) returning(TransactionTimestamp s): inrun() && waitCall(p) {
       p._delegate.receive(s.transaction(), s.timestamp());
    }
    
    void around() : inrun() && call(void TransactionSubscriber.receive(Transaction)) {
        //have taken care of this above. so dont do anything here. 
    }

}
