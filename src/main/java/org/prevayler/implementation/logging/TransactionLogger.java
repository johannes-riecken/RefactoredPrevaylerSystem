package org.prevayler.implementation.logging;

import java.io.IOException;

import org.prevayler.Transaction;
import org.prevayler.implementation.publishing.TransactionSubscriber;

public interface TransactionLogger {

    //public void log(Transaction transaction, Date executionTime, Turn threadSynchronizationTurn);
    //public void log(Transaction transaction, Turn threadSynchronizationTurn);

    void log(Transaction transaction);

    void update(TransactionSubscriber subscriber, long initialTransaction) throws IOException, ClassNotFoundException;

    void close() throws IOException;

}
