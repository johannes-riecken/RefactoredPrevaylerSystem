package org.prevayler.demos.scalability.prevayler;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.prevayler.demos.scalability.PrevaylerRecord;
import org.prevayler.demos.scalability.RecordIterator;

class QuerySystem implements ScalabilitySystem {

    private final Map recordsByName = new HashMap();


    public List queryByName(String name) {
        return (List)recordsByName.get(name);
    }


    @Override
    public void replaceAllRecords(RecordIterator newRecords) {
        recordsByName.clear();

        while (newRecords.hasNext()) {
            put(newRecords.next());
        }

        makeReadOnly();
    }


    private void put(PrevaylerRecord newRecord) {
        List records = queryByName(newRecord.getName());
        if (records == null) {
            records = new ArrayList();
            recordsByName.put(newRecord.getName(), records);
        }

        records.add(newRecord);
    }


    /** This is necessary so that the clients cannot alter the Lists they receive as query results.
    */
    private void makeReadOnly() {
        Iterator entries = recordsByName.entrySet().iterator();
        while (entries.hasNext()) {
            Map.Entry entry = (Map.Entry)entries.next();
            entry.setValue(Collections.unmodifiableList((List)entry.getValue()));
        }
    }
}
