package aspects.clock.weave;

import aspects.clock.*;
import org.prevayler.*;
import org.prevayler.implementation.PrevaylerImpl;
import org.prevayler.implementation.publishing.*;
import java.util.Date;


/**
 * ClockPrevayler
 */
privileged aspect ClockPrevayler {
    
    //Field is final. 
    private  Clock PrevaylerImpl._clock;
    declare error: 
        set(Clock PrevaylerImpl._clock) && 
        !withincode(PrevaylerImpl.new(..)) 
        && !withincode( void ClockPrevayler.setPrevaylerImplClock(TransactionPublisher, PrevaylerImpl))
        : "Field is declared final and cannot be assigned outside constructor";
  
    
    private PrevaylerImpl prevaylerImpl;
    
	public Clock PrevaylerImpl.clock() {
	
	    return _clock; 
	}
	
	pointcut implConstr(PrevaylerImpl p) : this(p)&& withincode (PrevaylerImpl.new(..));
	
	pointcut setClock(TransactionPublisher pub): args(pub) &&  set(TransactionPublisher PrevaylerImpl._publisher) ;
	
	after(TransactionPublisher pub, PrevaylerImpl p) : implConstr(p) && setClock(pub) {
	    prevaylerImpl = p;
	    //p._clock = pub.clock();
	    //Irum refactored above line into the helper method to be declared for the final field !within
	    setPrevaylerImplClock(pub, p);
	}
	
	private void setPrevaylerImplClock(TransactionPublisher pub, PrevaylerImpl p) { 
	    p._clock = pub.clock();
	}
    
    /** Returns the Clock used to determine the execution time of all Transaction and Queries executed using this Prevayler. This Clock is useful only to Communication Objects and must NOT be used by Transactions, Queries or Business Objects, since that would make them become non-deterministic. Instead, Transactions, Queries and Business Objects must use the executionTime parameter which is passed on their execution.
	 */
	abstract public Clock Prevayler.clock();
	

	/***Presentation show**/
	public void PrevaylerImpl.Subscriber.receive(Transaction transaction, Date executionTime) {
		receive(transaction);
	}
	
	  private Date dateex;
	  
	  pointcut receiveDate(Transaction tr, Date ex, TransactionSubscriber s) :
	      target(s) &&
	      call(public void receive(Transaction, Date, ..)) && args(tr, ex, ..);
	  
	  before (Transaction tr, Date ex, TransactionSubscriber s) : receiveDate(tr, ex, s) {
	     dateex = ex;
	  }
	
	 pointcut subReceive() : call(private TransactionSubscriber PrevaylerImpl.subscriber()) ;
	  
	  before(PrevaylerImpl p): implConstr(p) && subReceive() {
	      prevaylerImpl = p;
	  }
	  
	  pointcut inreceive() :withincode(public void TransactionSubscriber.receive(Transaction)); 
	  pointcut callexec(Transaction tr): target(tr) &&  call(public void executeOn(Object));
		
	  void around(Transaction tr2) :
		   	inreceive() && callexec(tr2) {
		tr2.executeOn(prevaylerImpl._prevalentSystem, dateex);
	
	  }
	
	  /***Presentation show**/

	pointcut execQuery(PrevaylerImpl p) : target(p) && withincode(public Object execute(Query));
	
	pointcut queryCall(Query q) : target(q) && call(public Object query(Object));
	
	Object around(Query q, PrevaylerImpl p) throws Exception: execQuery( p ) && queryCall(q)
	{
		return q.query(p._prevalentSystem, p.clock().time());
		
	}
}
