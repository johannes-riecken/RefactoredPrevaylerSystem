package aspects.clock.weave;

import org.prevayler.implementation.publishing.TransactionSubscriber;
import java.util.Date;
import org.prevayler.*;

/**
 * ClockSubscriber
 */
public aspect ClockSubscriber {

    abstract public void TransactionSubscriber.receive(Transaction transaction, Date timestamp);
    
    

}
