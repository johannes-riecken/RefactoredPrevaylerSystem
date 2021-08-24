package org.prevayler.demos.scalability;

public interface TransactionConnection {

	public void performTransaction(PrevaylerRecord recordToInsert, PrevaylerRecord recordToUpdate, long idToDelete);

}
