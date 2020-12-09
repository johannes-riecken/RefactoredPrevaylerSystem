package aspects.clock.weave;

import org.prevayler.implementation.logging.*;
import java.util.*;
import org.prevayler.*;
//import org.prevayler.foundation.*;
/**
 * ClockLogger
 */
public aspect ClockLogger {
    abstract public void TransactionLogger.log(Transaction transaction, Date executionTime);
}
