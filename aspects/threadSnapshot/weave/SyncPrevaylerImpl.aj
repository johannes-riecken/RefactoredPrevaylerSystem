package aspects.threadSnapshot.weave;

import org.prevayler.implementation.*;
/**
 * SyncPrevaylerImpl
 */
privileged aspect SyncPrevaylerImpl {
    
    pointcut synchTake(PrevaylerImpl p) : target(p) && execution(public void takeSnapshot());
    
    void around(PrevaylerImpl p) : synchTake(p) {
       synchronized(p._prevalentSystem) {
            proceed(p);
        }
    }
    
}
