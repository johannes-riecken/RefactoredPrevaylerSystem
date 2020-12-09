package aspects.multithread.weave;

import aspects.multithread.*;
import org.prevayler.Transaction;
import org.prevayler.implementation.logging.*;

/**
 * ThreadLogger
 */
public aspect ThreadLogger {
    abstract public void TransactionLogger.log(Transaction transaction, Turn threadSynchronizationTurn);

}
