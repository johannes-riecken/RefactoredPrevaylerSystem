package aspects.clock.demo.weave;

import java.util.Date;
import org.prevayler.demos.demo2.business.*;

import org.prevayler.demos.demo2.business.transactions.*;

/**
 * DemoTransactions
 */
privileged aspect DemoTransactions {
	
	//pointcut used for protection purposes. 
	pointcut notWithinDemoTrans() : !within(DemoTransactions+) ;
	
	
	/**
	 * Protection of AccountCreation and AccountDeletion methods. 
	 */
    public Object AccountCreation.executeAndQuery(Bank bank, Date ignored) throws Account.InvalidHolder {
		return executeAndQuery(bank);
	}
    
    public Object AccountDeletion.executeAndQuery(Bank bank, Date ignored) throws Bank.AccountNotFound {
		bank.deleteAccount(_accountNumber);
		return null;
	}
    
    declare error: call(Object AccountCreation.executeAndQuery(Bank, Date)) && notWithinDemoTrans() && !within(AccountCreation+) : "Method protected";
    declare error: call(Object AccountDeletion.executeAndQuery(Bank, Date)) && notWithinDemoTrans() && !within(AccountDeletion+) : "Method protected";    
    
    /**
     * Account Transaction Protected APIs. 
     */   
    public Object AccountTransaction.executeAndQuery(Bank bank, Date timestamp) throws Exception {
    	executeAndQuery(bank.findAccount(_accountNumber), timestamp);
		return null;
	}
	public abstract void AccountTransaction.executeAndQuery(Account account, Date timestamp) throws Exception;
	
	declare error: (call(Object AccountTransaction.executeAndQuery(Bank,Date)) 
					|| call(void AccountTransaction.executeAndQuery(Account,Date)) ) && notWithinDemoTrans() && !within(AccountTransaction+) : "Methods are protected";
	
	/**
     * Account Transaction Protected APIs. 
     */
	
					
	public Object BankTransaction.executeAndQuery(Object bank, Date timestamp) throws Exception {
	   if (this instanceof Transfer){
	     Transfer t = (Transfer)this;
	     return t.executeAndQuery((Bank)bank, timestamp);
	    }
	    return executeAndQuery((Bank)bank, timestamp);
	    
	}

	/***
	 * BankTransaction Protection. 
	 */
	public abstract Object BankTransaction.executeAndQuery(Bank bank, Date timestamp) throws Exception;

	declare error : call(Object BankTransaction.executeAndQuery(Bank , Date)) && notWithinDemoTrans() && !within(BankTransaction+) : 
		"Method protected";
	/***
	 * BankTransaction Protection. 
	 */
	
	
	public void Deposit.executeAndQuery(Account account, Date timestamp) throws Account.InvalidAmount {
	    account.deposit(_amount, timestamp);
	}
	
	public void HolderChange.executeAndQuery(Account account, Date ignored) throws Account.InvalidHolder {
		account.holder(_newHolder);
	}
	
	public Object Transfer.executeAndQuery(Bank bank, Date timestamp) throws Exception {	    
		bank.transfer(_originAccountNumber, _destinationAccountNumber, _amount, timestamp);
		return null;
	}
	
	public void Withdrawal.executeAndQuery(Account account, Date timestamp) throws Account.InvalidAmount {
		account.withdraw(_amount, timestamp);
	}
	
	


}
