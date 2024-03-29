//Prevayler(TM) - The Free-Software Prevalence Layer.
//Copyright (C) 2001-2003 Klaus Wuestefeld
//This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//Contributions: Frederic Langlet

package org.prevayler.implementation.publishing;

import java.io.IOException;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.prevayler.Transaction;




/** This class provides basic subscriber addition and notification.
 */
public abstract class AbstractPublisher implements TransactionPublisher {



//    private Clock _clock;

    //TODO: made this field unfinal.
   // protected final Clock _clock;
    //private final List _subscribers = new LinkedList();
//	private List _subscribers = new LinkedList();
    private final List _subscribers;
    //= new LinkedList();

    //Irum added.
    public AbstractPublisher() {
        _subscribers = new LinkedList();
    }

//    public AbstractPublisher(Clock clock) {
//        _clock = clock;
//	}

//    public Clock clock() {
//        return _clock;
//    }

    //public synchronized void addSubscriber(TransactionSubscriber subscriber) throws IOException, ClassNotFoundException {
     public void addSubscriber(TransactionSubscriber subscriber) throws IOException, ClassNotFoundException {
        _subscribers.add(subscriber);
    }

    //public synchronized void removeSubscriber(TransactionSubscriber subscriber) {
     @Override
     public void removeSubscriber(TransactionSubscriber subscriber) {
        _subscribers.remove(subscriber);
    }

//    protected synchronized void notifySubscribers(Transaction transaction, Date timestamp) {
//		Iterator i = _subscribers.iterator();
//        while (i.hasNext()) ((TransactionSubscriber) i.next()).receive(transaction, timestamp);
//    }

//	protected synchronized void notifySubscribers(Transaction transaction) {
     protected void notifySubscribers(Transaction transaction) {

        Iterator i = _subscribers.iterator();
        while (i.hasNext()) ((TransactionSubscriber) i.next()).receive(transaction);
    }




}
