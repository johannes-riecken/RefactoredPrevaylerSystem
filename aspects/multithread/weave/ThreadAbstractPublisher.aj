package aspects.multithread.weave;

import org.prevayler.implementation.publishing.*;
import org.prevayler.Transaction;


/**
 * ThreadAbstractPublisher
 */
privileged aspect ThreadAbstractPublisher extends SynchMethods{
    declare parents: AbstractPublisher implements SynchMethods.Synch;
    public pointcut synchCall() : 
        (
			execution(public void AbstractPublisher.addSubscriber(TransactionSubscriber)) || 
			execution(public void AbstractPublisher.removeSubscriber(TransactionSubscriber)) 
			|| execution(protected void AbstractPublisher.notifySubscribers(Transaction))
		);
		

    
    
}
