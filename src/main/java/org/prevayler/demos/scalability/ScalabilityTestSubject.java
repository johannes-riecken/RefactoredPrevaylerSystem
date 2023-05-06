package org.prevayler.demos.scalability;

public interface ScalabilityTestSubject {

    String name();

    void replaceAllRecords(int records);

    Object createTestConnection();
}
