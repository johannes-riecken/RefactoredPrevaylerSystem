package aspects.replicationClock.weave;

import aspects.clock.*;
import  aspects.replication.*;
import java.util.Date;
import org.prevayler.Transaction;
import org.prevayler.implementation.publishing.*;
import java.io.*;

/**
 * ClientClock
 */
privileged aspect ClientClock {
    private final BrokenClock ClientPublisher._clock = new BrokenClock();
    

	public Clock ClientPublisher.clock() {
		return _clock;
	}
	
	pointcut timestamp(ClientPublisher p) : target(p) && execution(private Date ClientPublisher.getTimeStamp());
	Date around (ClientPublisher p) throws IOException, ClassNotFoundException: timestamp(p) {
	    Date timestamp = (Date)p._fromServer.readObject();
		p._clock.advanceTo(timestamp);
		return timestamp;
	}
	
	
	
	
	  pointcut inreceive() : withincode(private long ClientPublisher.receiveTransactionFromServer());
	  pointcut inReceiveHelp() : withincode(* ClientPublisher.helperReceiveTransactionFromServer(..));
  	  pointcut receiveCall(ClientPublisher p) :this(p) && call(public void TransactionSubscriber.receive(Transaction)) ;

  	  pointcut candCall() :  call(private Object ClientPublisher.getTransactionCandidate());
  	  pointcut timeStampCall() : call(private Date getTimeStamp()); 
  	  
  	  Object transactionCandidate; 
  	  Date timestamp;
  	  
  	  after() returning(Object o ) : candCall() {
  	  	transactionCandidate = o;
  	  }
  	  
  	  after() returning (Date d ) : timeStampCall() &&  inReceiveHelp() { 
  	  	timestamp = d;
  	  }
  	  
  	  void around(ClientPublisher p) : receiveCall(p) &&  inReceiveHelp()  { 
  	  	if (transactionCandidate.equals(ServerConnection.REMOTE_TRANSACTION)) {
  	  		p._subscriber.receive(p._myTransaction, timestamp);
  	  	}
  	  	else {
  	  		p._subscriber.receive((Transaction)transactionCandidate, timestamp);
  	  	}
  	  }
  	 	
}
