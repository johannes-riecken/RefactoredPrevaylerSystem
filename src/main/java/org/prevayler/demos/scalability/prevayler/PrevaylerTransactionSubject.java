package org.prevayler.demos.scalability.prevayler;

import java.io.File;

import org.prevayler.PrevaylerFactory;
//import org.prevayler.implementation.PrevalenceTest;

public class PrevaylerTransactionSubject extends PrevaylerScalabilitySubject {

    public PrevaylerTransactionSubject(String logDirectory) throws java.io.IOException, ClassNotFoundException {
        if (new File(logDirectory).exists()) PrevalenceTest.delete(logDirectory);
        prevayler = PrevaylerFactory.createPrevayler(new TransactionSystem(), logDirectory);  //No snapshot is generated by the test.
    }


    @Override
    public Object createTestConnection() {
        return new PrevaylerTransactionConnection(prevayler);
    }
}
