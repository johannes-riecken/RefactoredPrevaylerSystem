package aspects.clock.weave;

import org.prevayler.implementation.TransactionWithQueryExecuter;
import java.util.Date;
/**
 * ClockTransactionWithQueryExecuter
 */
privileged aspect ClockTransactionWithQueryExecuter {

    public final void TransactionWithQueryExecuter.executeOn(Object prevalentSystem, Date timestamp) {
		try {
		    
			_result = _delegate.executeAndQuery(prevalentSystem, timestamp);
		} catch (RuntimeException rx) {
			throw rx;   //This is necessary because of the rollback feature.
		} catch (Exception ex) {
			_exception = ex;
		}
	}
}
