package aspects.multithread.weave;


/**
 * SynchMethods
 */
abstract public aspect SynchMethods {
    
    public interface Synch {}    
    public abstract pointcut synchCall();
    
    Object around(Synch s): target(s) && synchCall() 
    {     
          	synchronized(s) {
        	    return proceed(s);
        	}
    }    
}
