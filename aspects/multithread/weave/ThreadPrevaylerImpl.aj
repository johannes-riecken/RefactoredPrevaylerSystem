
package aspects.multithread.weave;
import org.prevayler.*;
import org.prevayler.implementation.*;


privileged aspect ThreadPrevaylerImpl {

    PrevaylerImpl prevaylerImpl;    
    pointcut implConstr(PrevaylerImpl p) : target(p)&& execution (PrevaylerImpl.new(..));
	
	before(PrevaylerImpl p) : implConstr(p) {
	    
	    prevaylerImpl = p;    
	}
	
//	pointcut subCall(PrevaylerImpl p) : target(p) && call(* subscriber());
//	before(PrevaylerImpl p) : subCall(p) {

//	    prevaylerImpl = p;
//	}
  
	pointcut inreceive() : execution(public void PrevaylerImpl.Subscriber.receive(Transaction));
	
	void around() : inreceive() {
	   synchronized (prevaylerImpl._prevalentSystem) {
	        proceed();
	   }
	}
	
	pointcut execQuery(PrevaylerImpl p) : target(p) && execution(public Object PrevaylerImpl.execute(Query));

	Object around(PrevaylerImpl p): execQuery( p )
	{
		synchronized (p._prevalentSystem) {
			return proceed(p);
		}
	}
	
}
