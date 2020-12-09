
package aspects.censorclockthread.weave;

import org.prevayler.implementation.publishing.*;
import org.prevayler.*;
import aspects.multithread.*;
import java.util.*;
import org.prevayler.implementation.logging.*;

privileged aspect CensorClockThread {
	private void CentralPublisher.approve(Transaction transaction, Date executionTime, Turn myTurn) throws RuntimeException, Error {
	   
		approve(transaction);
//		try {
//			myTurn.start();
//			_censor.approve(transaction, executionTime);
//			myTurn.end();
//		} catch (RuntimeException r) { myTurn.alwaysSkip(); throw r;
//		} catch (Error e) {	myTurn.alwaysSkip(); throw e; }
	}
	
   
  
  /**call approve before log**/
  private CentralPublisher publisher;
  pointcut pubWorry(CentralPublisher p) : target(p) && call(private void publishWithoutWorryingAboutNewSubscriptions(..));	  
  before(CentralPublisher p) : pubWorry(p) {
      publisher = p;
  }
  	  
  pointcut centralPubCut(Transaction t, Date exTime, Turn tu) : args(t, exTime, tu) &&  
  	call (public void TransactionLogger.log(Transaction, Date,Turn));
 	
  before (Transaction t, Date exTime, Turn tu) :     centralPubCut( t,exTime, tu)
  {
		
		publisher.approve(t,exTime,  tu);
  }
  /**end call approve before log**/
  

}
