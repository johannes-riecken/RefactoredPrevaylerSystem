package org.prevayler.demos.scalability;

public class QueryTestRun extends ScalabilityTestRun {

    public QueryTestRun(ScalabilityTestSubject subject, int numberOfObjects, int minThreads, int maxThreads) {
        super(subject, numberOfObjects, minThreads, maxThreads);
    }


    @Override
    protected String name() {
        return "Query Test";
    }


    @Override
    protected void executeOperation(Object connection, long operationSequence) {

        ((QueryConnection)connection).queryByName("NAME" + (operationSequence % 10000));

    }
}
