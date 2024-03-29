//Prevayler(TM) - The Free-Software Prevalence Layer.
//Copyright (C) 2001-2003 Klaus Wuestefeld
//This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

package org.prevayler.implementation;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

//import org.prevayler.Clock;
import org.prevayler.Prevayler;
import org.prevayler.Query;
import org.prevayler.Transaction;
import org.prevayler.TransactionWithQuery;
import org.prevayler.implementation.publishing.TransactionPublisher;
import org.prevayler.implementation.publishing.TransactionSubscriber;
//import org.prevayler.implementation.snapshot.SnapshotManager;


public class PrevaylerImpl implements Prevayler {

    //TODO:IRUM> made these unfinal.
    //private final Object _prevalentSystem;
    private final Object _prevalentSystem;
    private long _systemVersion = 0;

    //private final Clock _clock;

    //TODO:IRUM> made these unfinal.
    //private  Clock _clock;


    //private final SnapshotManager _snapshotManager;

    //TODO:IRUM> made these unfinal.
    //private final TransactionPublisher _publisher;
    private final TransactionPublisher _publisher;
    private boolean _ignoreRuntimeExceptions;


    /** Creates a new Prevayler
     * @param snapshotManager The SnapshotManager that will be used for reading and writing snapshot files.
     * @param transactionPublisher The TransactionPublisher that will be used for publishing transactions executed with this PrevaylerImpl.
     */
//	public PrevaylerImpl(SnapshotManager snapshotManager, TransactionPublisher transactionPublisher) throws IOException, ClassNotFoundException {
//		_snapshotManager = snapshotManager;
//		_prevalentSystem = _snapshotManager.recoveredPrevalentSystem();
//		_systemVersion = _snapshotManager.recoveredVersion();
//
//		_publisher = transactionPublisher;
//		_clock = _publisher.clock();
//
//		_ignoreRuntimeExceptions = true;     //During pending transaction recovery (rolling forward), RuntimeExceptions are ignored because they were already thrown and handled during the first transaction execution.
//		_publisher.addSubscriber(subscriber(), _systemVersion + 1);
//		_ignoreRuntimeExceptions = false;
//	}

    public PrevaylerImpl(TransactionPublisher transactionPublisher, Object prevalentSystem) throws IOException, ClassNotFoundException {


        _prevalentSystem = prevalentSystem;
        _publisher = transactionPublisher;
        //_clock = _publisher.clock();

        _ignoreRuntimeExceptions = true;     //During pending transaction recovery (rolling forward), RuntimeExceptions are ignored because they were already thrown and handled during the first transaction execution.
        _publisher.addSubscriber(subscriber(), _systemVersion + 1);
        _ignoreRuntimeExceptions = false;
    }

    @Override
    public Object prevalentSystem() { return _prevalentSystem; }


    //public Clock clock() { return _clock; }


    @Override
    public void execute(Transaction transaction) {
        publish((Transaction)deepCopy(transaction));
    }


    private void publish(Transaction transaction) {
        _publisher.publish(transaction);
    }


    @Override
    public Object execute(Query sensitiveQuery) throws Exception {
        //synchronized (_prevalentSystem) {
            //return sensitiveQuery.query(_prevalentSystem, clock().time());
        //}
        return sensitiveQuery.query(_prevalentSystem);
    }


    @Override
    public Object execute(TransactionWithQuery transactionWithQuery) throws Exception {
        TransactionWithQuery copy = (TransactionWithQuery)deepCopy(transactionWithQuery);
        TransactionWithQueryExecuter executer = new TransactionWithQueryExecuter(copy);
        publish(executer);
        return executer.result();
    }


//	public void takeSnapshot() throws IOException {
//	    synchronized (_prevalentSystem) {
//	        _snapshotManager.writeSnapshot(_prevalentSystem, _systemVersion);
//	    }
//	}


    @Override
    public void close() throws IOException { _publisher.close(); }


    private Object deepCopy(Object transaction) {   //TODO Optimizations: 1) Publish the byte array of the serialized transaction (this will save the Censor and the Logger from having to serialize the transaction again). This is also a step towards transaction multiplexing (useful to avoid hickups due to very large transactions). The Censor can use the actual given transaction if it is Immutable instead of deserializing a new one from the byte array. 2) Make the baptism fail-fast feature optional (default is on). If it is off, the given transaction can be used instead of deserializing a new one from the byte array.
        //return _snapshotManager.deepCopy(transaction, "Unable to produce a deep copy of the transaction. Deep copies of transactions are executed instead of the transactions themselves so that the behaviour of the system during transaction execution is exactly the same as during transaction recovery from the log.");
        //TODO: IRum added by irum here
        return deepCopy(transaction, "Unable to produce a deep copy of the transaction. Deep copies of transactions are executed instead of the transactions themselves so that the behaviour of the system during transaction execution is exactly the same as during transaction recovery from the log.");
    }

    //TODO: Irum...introduced by irum.
    public Object deepCopy(Object original, String errorMessage) {
        try {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            //writeSnapshot(original, out);

            ObjectOutputStream stream = new ObjectOutputStream(out);
            stream.writeObject(original);

        //	return readSnapshot(new ByteArrayInputStream(out.toByteArray()));

            ObjectInputStream ois = new ObjectInputStream(new ByteArrayInputStream(out.toByteArray()));
            return ois.readObject();
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException(errorMessage);
        }
    }

//	private TransactionSubscriber subscriber() {
//		return new TransactionSubscriber() {
//
//			public void receive(Transaction transaction, Date executionTime) {
//				synchronized (_prevalentSystem) {
//					_systemVersion++;
//					try {
//						transaction.executeOn(_prevalentSystem, executionTime);
//					} catch (RuntimeException rx) {
//						if (!_ignoreRuntimeExceptions) throw rx;
//					}
//				}
//			}
//
//		};
//	}

//	private TransactionSubscriber subscriber() {
//		return new TransactionSubscriber() {
//
//			public void receive(Transaction transaction) {
//				synchronized (_prevalentSystem) {
//					_systemVersion++;
//					try {
//						transaction.executeOn(_prevalentSystem);
//					} catch (RuntimeException rx) {
//						if (!_ignoreRuntimeExceptions) throw rx;
//					}
//				}
//			}
//
//		};
//	}


    public class Subscriber implements TransactionSubscriber {

        public Subscriber(){

        }
        @Override
        public void receive(Transaction transaction) {
//			synchronized (_prevalentSystem) {
                _systemVersion++;
                try {
                    transaction.executeOn(_prevalentSystem);
                } catch (RuntimeException rx) {
                    if (!_ignoreRuntimeExceptions) throw rx;
                }
            //}
        }
    }


    private TransactionSubscriber subscriber() {
        return new Subscriber();
    }



}
