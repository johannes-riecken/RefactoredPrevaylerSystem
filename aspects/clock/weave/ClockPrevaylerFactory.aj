package aspects.clock.weave;

import org.prevayler.PrevaylerFactory;
import aspects.clock.*;
import org.prevayler.implementation.publishing.*;
import org.prevayler.implementation.logging.*;
/**
 * ClockPrevaylerFactory
 */
privileged aspect ClockPrevaylerFactory {
    private Clock PrevaylerFactory._clock;
    
    private Clock PrevaylerFactory.clock() {       
		return _clock != null ? _clock : new MachineClock();
	}

    /** Configures the Clock that will be used by the created Prevayler. The Clock interface can be implemented by the application if it requires Prevayler to use a special time source other than the machine clock (default).
	 */
	public void PrevaylerFactory.configureClock(Clock clock) {
		_clock = clock;
	}
	
	pointcut factoryPublish(PrevaylerFactory f) : this(f) && withincode(private TransactionPublisher publisher(..))&&  call (CentralPublisher.new(TransactionLogger));		

	CentralPublisher around(PrevaylerFactory f) : factoryPublish(f) {
	    //return new CentralPublisher(f.clock(), f.censor(snapshot), f.logger());
	    return new CentralPublisher(f.clock(), f.logger());
	}
}
