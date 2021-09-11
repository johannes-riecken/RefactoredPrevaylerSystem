package org.prevayler.demos.scalability.prevayler;

import java.util.Date;

import org.prevayler.Transaction;
import org.prevayler.demos.scalability.PrevaylerRecord;

class TestTransaction implements Transaction {

	private final PrevaylerRecord recordToInsert;
	private final PrevaylerRecord recordToUpdate;
	private final long idToDelete;

	TestTransaction(PrevaylerRecord recordToInsert, PrevaylerRecord recordToUpdate, long idToDelete) {
		this.recordToInsert = recordToInsert;
		this.recordToUpdate = recordToUpdate;
		this.idToDelete = idToDelete;
	}

	public void executeOn(Object system, Date ignored) {
		((TransactionSystem)system).performTransaction(recordToInsert, recordToUpdate, idToDelete);
	}

	// TODO
	@Override
	public void executeOn(Object prevalentSystem) {

	}
}
