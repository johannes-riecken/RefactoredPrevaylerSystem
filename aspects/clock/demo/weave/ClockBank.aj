package aspects.clock.demo.weave;

import java.util.Date;
import org.prevayler.demos.demo2.business.*;
/**
 * ClockBank
 */
public aspect ClockBank {

    public void Bank.transfer(long sourceNumber, long destinationNumber, long amount, Date timestamp) throws Bank.AccountNotFound, Account.InvalidAmount {
		Account source = findAccount(sourceNumber);
		Account destination = findAccount(destinationNumber);

		source.withdraw(amount, timestamp);
		if (amount == 666) throw new RuntimeException("Runtime Exception simulated for rollback demonstration purposes.");
		destination.deposit(amount, timestamp);
	}

}
