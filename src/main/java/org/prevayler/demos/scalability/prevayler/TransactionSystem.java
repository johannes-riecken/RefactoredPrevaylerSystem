package org.prevayler.demos.scalability.prevayler;

import java.util.HashMap;
import java.util.Map;

import org.prevayler.demos.scalability.PrevaylerRecord;
import org.prevayler.demos.scalability.RecordIterator;

class TransactionSystem implements ScalabilitySystem {

    private final Map recordsById = new HashMap();

    public void performTransaction(PrevaylerRecord recordToInsert, PrevaylerRecord recordToUpdate, long idToDelete) {
        synchronized (recordsById) {
            put(recordToInsert);
            put(recordToUpdate);
            recordsById.remove(new Long(idToDelete));
        }
    }

    private Object put(PrevaylerRecord newRecord) {
        Object key = new Long(newRecord.getId());
        return recordsById.put(key, newRecord);
    }

    @Override
    public void replaceAllRecords(RecordIterator newRecords) {
        recordsById.clear();

        while (newRecords.hasNext()) {
            put(newRecords.next());
        }
    }
}
