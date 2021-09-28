package org.prevayler.demos.scalability;

public interface TransactionConnection {

	void performTransaction(PrevaylerRecord recordToInsert, PrevaylerRecord recordToUpdate, long idToDelete);

}
