package aspects.multithreadClock.weave;


import aspects.multithread.*;
import org.prevayler.implementation.logging.*;
import org.prevayler.Transaction;
import java.util.Date;
/**
 * ThreadClockTransient
 */
public aspect ThreadClockTransient {
	
    public void TransientLogger.log(Transaction transaction, Date executionTime, Turn myTurn) {
        log(transaction);

    }
    
}
   
