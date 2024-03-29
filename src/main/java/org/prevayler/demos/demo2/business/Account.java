package org.prevayler.demos.demo2.business;

import java.util.*;

public class Account implements java.io.Serializable {

    private long number;
    private String holder;
    private long balance = 0;
    private final List transactionHistory = new ArrayList();
    private transient Set listeners;

    private Account() {
    }

    Account(long number, String holder) throws InvalidHolder {
        this.number = number;
        holder(holder);
    }

    public long number() {
        return number;
    }

    @Override
    public String toString() { //Returns something like "00123 - John Smith"
        return numberString() + " - " + holder;
    }

    public String numberString() {
        return numberString(number);
    }

    static String numberString(long number) {
        return (new java.text.DecimalFormat("00000").format(number));
    }

    public String holder() {
        return holder;
    }

    public void holder(String holder) throws InvalidHolder {
        verify(holder);
        this.holder = holder;
        notifyListeners();
    }

    public long balance() {
        return balance;
    }

//	public void deposit(long amount, Date timestamp) throws InvalidAmount {
//		verify(amount);
//        register(amount, timestamp);
//	}
//
//	public void withdraw(long amount, Date timestamp) throws InvalidAmount {
//		verify(amount);
//        register(-amount, timestamp);
//	}

    public void deposit(long amount) throws InvalidAmount {
        verify(amount);
        register(amount);
    }

    public void withdraw(long amount) throws InvalidAmount {
        verify(amount);
        register(-amount);
    }


//    private void register(long amount, Date timestamp) {
//		balance += amount;
//        transactionHistory.add(new AccountEntry(amount, timestamp));
//		notifyListeners();
//	}

    private void register(long amount) {
        balance += amount;
        transactionHistory.add(new AccountEntry(amount));
        notifyListeners();
    }

    private void verify(long amount) throws InvalidAmount {
        if (amount <= 0) throw new InvalidAmount("Amount must be greater than zero.");
        if (amount > 10000) throw new InvalidAmount("Amount maximum (10000) exceeded.");
    }

    public List transactionHistory() {
        return transactionHistory;
    }

    public void addAccountListener(AccountListener listener) {
        listeners().add(listener);
    }

    public void removeAccountListener(AccountListener listener) {
        listeners().remove(listener);
    }

    private Set listeners() {
        if (listeners == null) listeners = new HashSet();
        return listeners;
    }

    private void notifyListeners() {
        Iterator it = listeners().iterator();
        while (it.hasNext()) {
            ((AccountListener)it.next()).accountChanged();
        }
    }

    public class InvalidAmount extends Exception {
        InvalidAmount(String message) {
            super(message);
        }
    }

    private void verify(String holder) throws InvalidHolder {
        if (holder == null || holder.equals("")) throw new InvalidHolder();
    }

    public class InvalidHolder extends Exception {
        InvalidHolder() {
            super("Invalid holder name.");
        }
    }
}
