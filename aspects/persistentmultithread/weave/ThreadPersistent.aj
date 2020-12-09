package aspects.persistentmultithread.weave;

import aspects.persistentLogging.*;
import org.prevayler.Transaction;
import aspects.multithread.Turn;
import java.io.*;

/**

/**
 * ThreadPersistent
 */
privileged aspect ThreadPersistent {
    public void PersistentLogger.log(Transaction transaction, Turn myTurn) {
       log(transaction);
    }
    
    private Turn turn;
 
    pointcut logTurn(Turn tu, PersistentLogger tl) :
        target(tl) && call(public void log(Transaction, ..,Turn)) && args(..,tu);

    before (Turn tu, PersistentLogger tl) : logTurn(tu, tl){
        turn = tu;
    }


    pointcut inLog() : withincode(public void PersistentLogger.log(Transaction, ..));    
  
//    pointcut inLog(PersistentLogger p, Transaction tr, Turn tu) : this(p) && args(tr, .., tu)
//		&& withincode(public void PersistentLogger.log(Transaction,.., Turn)); 
//    
    pointcut callhelper(): call(private void loghelper1(..)) || call(private void logHelper2(..));
      
    void around() : inLog() && callhelper() {
    	try {
    	    turn.start();
    		proceed();
    	}
    	finally {
    	    turn.end();
    	}
    }
    
    pointcut callSync(DurableOutputStream stream, Object o, PersistentLogger p) : 
        this(p) && target(stream) && args(o) && call(public void sync(Object,..)); 
    
    void around(PersistentLogger p, DurableOutputStream s, Object o) : callSync(s, o, p) && inLog() {
    	try {
        	s.sync(o, turn);
        } catch (IOException iox) {
			p.handleExceptionWhileWriting(iox, p._outputLog.file());
		}
    }
    
    /**
     * Thread call around hang.
     */
    pointcut hang():  withincode(static private void PersistentLogger.hang(IOException, String));
    pointcut printCall() : call(* println(..));
    
    after() : hang() && printCall() {
        while (true) Thread.yield();
	}
}
