package aspects.censorthread.weave;

import org.prevayler.implementation.publishing.*;
import org.prevayler.*;
import aspects.multithread.*;
import org.prevayler.implementation.logging.*;

privileged aspect CensorPublisherThread {

	 private void CentralPublisher.approve(Transaction transaction, Turn tu) throws RuntimeException, Error {
		approve(transaction);
	 }
	  
	  pointcut inapprove(CentralPublisher p, Transaction tr, Turn tu):
	  	args(tr, .., tu) && execution(private void approve(Transaction,.., Turn)) && target(p);
	  
	  void around(CentralPublisher p, Transaction tr, Turn tu) : inapprove(p, tr, tu) { 
	  	try {
	  	    tu.start();
			proceed(p, tr, tu);
			tu.end();
	  	} catch (RuntimeException r) { tu.alwaysSkip(); throw r;
		} catch (Error e) {	tu.alwaysSkip(); throw e; }
	  	
	  }
	  
	  
	  /**call approve before log**/
	  private CentralPublisher publisher;
	  pointcut pubWorry(CentralPublisher p) : target(p) && call(private void publishWithoutWorryingAboutNewSubscriptions(..));	  
	  before(CentralPublisher p) : pubWorry(p) {
	      publisher = p;
	  }
	  	  
	  pointcut centralPubCut(Transaction t, Turn tu) : args(t,tu) &&  
	  	call (public void TransactionLogger.log(Transaction, Turn));
	 	
	  before (Transaction t, Turn tu) :     centralPubCut( t,tu)
	  {
			publisher.approve(t, tu);
	  }
	  /**end call approve before log**/
	  
	  
}
