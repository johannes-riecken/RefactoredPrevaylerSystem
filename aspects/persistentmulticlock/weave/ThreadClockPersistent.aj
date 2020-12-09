package aspects.persistentmulticlock.weave;

import aspects.persistentLogging.*;
import org.prevayler.Transaction;
import java.util.Date;
import aspects.multithread.Turn;

/**
 * ThreadClockPersistent
 */
privileged aspect ThreadClockPersistent {
    public void PersistentLogger.log(Transaction transaction, Date executionTime, Turn myTurn) {
       log(transaction);
    }

}
