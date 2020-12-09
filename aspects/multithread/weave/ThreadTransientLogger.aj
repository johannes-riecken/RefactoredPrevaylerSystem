package aspects.multithread.weave;


import aspects.multithread.*;
import org.prevayler.implementation.logging.*;
import org.prevayler.Transaction;
import org.prevayler.implementation.publishing.*;
import aspects.multithread.weave.SynchMethods;
/**
 * ThreadTransientLogger
 */
public aspect ThreadTransientLogger extends SynchMethods{

    
    public void TransientLogger.log(Transaction transaction, Turn myTurn) {
        log(transaction);
    }
    
    private Turn turn;
    	  
    pointcut logTurn(Turn tu, TransientLogger tl) :
        target(tl) && call(public void log(Transaction, ..,Turn)) && args(..,tu);
  
    before (Turn tu, TransientLogger tl) : logTurn(tu, tl){
      turn = tu;
    }
    
    pointcut inLog() : execution(public void TransientLogger.log(Transaction));    
    pointcut logadd(TransientLogger t) : this(t) && call(public boolean add(Object));
    
    void around() : inLog() {
         try {            
            turn.start();            
            proceed();
        }
        finally {
            turn.end();    
        }
    }
    
    /**Synchronized**/
    
//    pointcut updateExec(TransientLogger l) :     
//        target(l) && execution(public void update(TransactionSubscriber, long));
//    
//    void around(TransientLogger l):  updateExec(l) 
//    { 

//        synchronized(l) {
//            proceed(l);
//        }
//    }
    
    declare parents: TransientLogger implements SynchMethods.Synch;
    public pointcut synchCall():execution(public void TransientLogger.update(TransactionSubscriber, long));
   

    
	
}
