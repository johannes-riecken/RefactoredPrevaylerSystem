package aspects.clock.weave;

import org.prevayler.*;
import java.util.Date;
/**
 * ClockTransaction
 */
public aspect ClockTransaction {
    abstract public void Transaction.executeOn(Object prevalentSystem, Date executionTime);

    abstract public Object Query.query(Object prevalentSystem, Date executionTime) throws Exception;
    
	abstract public Object TransactionWithQuery.executeAndQuery(Object prevalentSystem, Date executionTime) throws Exception;


}
