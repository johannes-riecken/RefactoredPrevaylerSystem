package aspects.censorthread.weave;

import aspects.censorship.*;
/**
 * StrictCensorSynch
 */
privileged aspect StrictCensorSynch {
    
    pointcut inProduce(StrictTransactionCensor c) : this(c) && withincode(private void produceNewFoodTaster());
    pointcut callToWrite() : call(void writeSnapshot(..));
    
    void around(StrictTransactionCensor c) : inProduce(c) && callToWrite() {
        synchronized(c._king) {
            proceed(c);
        }
    }
     
}
