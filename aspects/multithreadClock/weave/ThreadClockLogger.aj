package aspects.multithreadClock.weave;

import org.prevayler.implementation.logging.*;
import org.prevayler.Transaction;
import java.util.Date;
import aspects.multithread.*;

/**
 * 
 */
public aspect ThreadClockLogger {
    abstract public void TransactionLogger.log(Transaction transaction, Date executionTime, Turn threadSynchronizationTurn);
}
