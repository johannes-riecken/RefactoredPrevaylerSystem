package org.prevayler.demos.demo2.business.transactions;

//import java.util.Date;

import org.prevayler.demos.demo2.business.*;


public abstract class AccountTransaction extends BankTransaction {

    private long _accountNumber;


    AccountTransaction() {} //Necessary for Skaringa XML serialization.  This would normally be private, but must be package visible (or protected) in this case in order for subclasses to supply private default constructors and actually compile.
    protected AccountTransaction(Account account) {
        _accountNumber = account.number();
    }

//	protected Object executeAndQuery(Bank bank, Date timestamp) throws Exception {
//		executeAndQuery(bank.findAccount(_accountNumber), timestamp);
//		return null;
//	}
//
//	protected abstract void executeAndQuery(Account account, Date timestamp) throws Exception;

    @Override
    protected Object executeAndQuery(Bank bank) throws Exception {
        executeAndQuery(bank.findAccount(_accountNumber));
        return null;
    }

    protected abstract void executeAndQuery(Account account) throws Exception;

}
