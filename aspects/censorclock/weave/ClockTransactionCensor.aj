package aspects.censorclock.weave;

import aspects.censorship.*;
import java.util.Date;
import org.prevayler.*;

privileged aspect ClockTransactionCensor {
	abstract public void TransactionCensor.approve(Transaction transaction, Date executionTime) throws RuntimeException, Error;
	
	public void LiberalTransactionCensor.approve(Transaction transaction, Date executionTime) throws RuntimeException, Error {
	}
	
	public void StrictTransactionCensor.approve(Transaction transaction, Date executionTime) throws RuntimeException, Error {
	    approve(transaction);
	}
	
	private Date date; 
	pointcut StrictApproveCall(Date d, StrictTransactionCensor s): 
	    target(s) && args(.., d) && call(public void approve(Transaction, Date));
	
	before(Date d, StrictTransactionCensor s) : StrictApproveCall(d, s) {	    
	    date = d;   
	}
	
	pointcut inapprove() :	withincode(public void StrictTransactionCensor.approve(Transaction));
	
	pointcut execCall(Transaction tr, StrictTransactionCensor s) : this(s) && target(tr) && call(public void executeOn(..)); 
	
	void around(Transaction tr1, StrictTransactionCensor s) :
		inapprove() && execCall(tr1, s) { 
		tr1.executeOn(s.royalFoodTaster(), date);
	}
}
