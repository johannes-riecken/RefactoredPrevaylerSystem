package aspects.censorship.weave;
import org.prevayler.implementation.logging.TransactionLogger;
//import org.prevayler.Clock;
import org.prevayler.Transaction;
//import java.util.Date;
import org.prevayler.implementation.publishing.*;
import aspects.censorship.*;

/**
 * CensorPublisherAspect
 */
privileged aspect CensorPublisherAspect {
    //  TODO:IRUM made this unfinal
    //  private final TransactionCensor CentralPublisher._censor;
    private TransactionCensor CentralPublisher._censor;
    
    declare error: 
        set(TransactionCensor CentralPublisher._censor) && 
        !withincode(CentralPublisher.new(..)): "Field is declared final and cannot be assigned outside constructor";
  
    
//    private void CentralPublisher.approve(Transaction transaction, Date executionTime, Turn myTurn) throws RuntimeException, Error {
//		try {
//		  
//			myTurn.start();
//			_censor.approve(transaction, executionTime);
//			myTurn.end();
//		} catch (RuntimeException r) { myTurn.alwaysSkip(); throw r;
//		} catch (Error e) {	myTurn.alwaysSkip(); throw e; }
//	}
    
    private void CentralPublisher.approve(Transaction transaction) throws RuntimeException, Error {
		//try {
		   
			//myTurn.start();
			//_censor.approve(transaction, executionTime);
		   
		    _censor.approve(transaction);
			//myTurn.end();
		//} catch (RuntimeException r) { myTurn.alwaysSkip(); throw r;
		//} catch (Error e) {	myTurn.alwaysSkip(); throw e; }
	}
    
//    public CentralPublisher.new(Clock clock, TransactionCensor censor, TransactionLogger logger) {
//        this(clock,logger);
//		_censor = censor;
//		
//	}
    
    public CentralPublisher.new(TransactionCensor censor, TransactionLogger logger) {
      //  this(logger);
        _logger = logger; 
		_censor = censor;
		
	}
    
//    pointcut centralPubCut(CentralPublisher pub, Transaction t, Date exTime, Turn tu) : this(pub) &&
//	args(t,exTime,tu) &&  call (public void TransactionLogger.log(Transaction, Date, Turn));
// 	
//	before (CentralPublisher publisher, Transaction t, Date exTime, Turn tu) : centralPubCut(publisher, t, exTime, tu)
//	{
//	
//			publisher.approve(t, exTime, tu);
//	}
	
    pointcut centralPubCut(CentralPublisher pub, Transaction t) : this(pub) &&
	args(t) &&  call (public void TransactionLogger.log(Transaction));
 	
	before (CentralPublisher publisher, Transaction t) : centralPubCut(publisher, t)
	{
		publisher.approve(t);
	}
	
}
