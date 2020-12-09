package aspects.multithreadClock.weave;

import aspects.clock.*;
import java.util.Date;
import aspects.multithread.weave.SynchMethods;

/**
 * BrokenClockSynch
 */
public aspect BrokenClockSynch extends SynchMethods{
	
    declare parents: BrokenClock implements SynchMethods.Synch;

	
//  	pointcut advance(BrokenClock b) : target(b) && execution(public void advanceTo(Date));
	public pointcut synchCall() : execution(public void BrokenClock.advanceTo(Date));
//  void around(BrokenClock b) : advance(b) {
//      synchronized(b) {
//          proceed(b);
//      }
//  }
}
