package aspects.clock.demo.weave;
import java.util.Date;
import org.prevayler.demos.demo2.business.*;


/**
 * ClockAccount
 */
privileged aspect ClockAccount {
    public void Account.deposit(long amount, Date timestamp) throws Account.InvalidAmount {
		verify(amount);
        register(amount, timestamp);
	}

	public void Account.withdraw(long amount, Date timestamp) throws Account.InvalidAmount {
		verify(amount);
        register(-amount, timestamp);
	}
	
	private void Account.register(long amount, Date timestamp) {
		balance += amount;
        transactionHistory.add(new AccountEntry(amount, timestamp));
		notifyListeners();
	}
}
