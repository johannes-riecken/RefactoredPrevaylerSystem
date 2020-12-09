package aspects.clock.weave;

import org.prevayler.implementation.TransactionTimestamp;
import org.prevayler.Transaction;
import java.util.Date;
/**
 * ClockTransactionTimeStamp
 */
privileged aspect ClockTransactionTimeStamp {

    //TODO: made this unfinal
  	private long TransactionTimestamp.timestamp;
  	declare error: 
        set(long TransactionTimestamp.timestamp) && 
        !withincode(TransactionTimestamp.new(..)): "Field is declared final and cannot be assigned outside constructor";


	public TransactionTimestamp.new(Transaction transaction, Date timestamp) {
	    this(transaction);
	    this.timestamp = timestamp.getTime();
		
	}
  
    public Date TransactionTimestamp.timestamp() {
        return new Date(this.timestamp);
    }
}
