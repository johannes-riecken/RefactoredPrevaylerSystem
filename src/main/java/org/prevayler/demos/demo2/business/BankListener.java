package org.prevayler.demos.demo2.business;

public interface BankListener {

    void accountCreated(Account account);

    void accountDeleted(Account account);

}