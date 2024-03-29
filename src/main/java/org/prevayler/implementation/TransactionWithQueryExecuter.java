//Prevayler(TM) - The Free-Software Prevalence Layer.
//Copyright (C) 2001-2003 Klaus Wuestefeld
//This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

package org.prevayler.implementation;

//import java.util.Date;

import org.prevayler.*;


public class TransactionWithQueryExecuter implements Transaction {

    static final long serialVersionUID = 0L;

    private TransactionWithQuery _delegate;

    private transient Object _result;
    private transient Exception _exception;


    private TransactionWithQueryExecuter() {} //Necessary for Skaringa XML serialization
    TransactionWithQueryExecuter(TransactionWithQuery transactionWithQuery) {
        _delegate = transactionWithQuery;
    }

//	public final void executeOn(Object prevalentSystem, Date timestamp) {
//		try {
//			_result = _delegate.executeAndQuery(prevalentSystem, timestamp);
//		} catch (RuntimeException rx) {
//			throw rx;   //This is necessary because of the rollback feature.
//		} catch (Exception ex) {
//			_exception = ex;
//		}
//	}

    @Override
    public final void executeOn(Object prevalentSystem) {
        try {

            _result = _delegate.executeAndQuery(prevalentSystem);
        } catch (RuntimeException rx) {
            throw rx;   //This is necessary because of the rollback feature.
        } catch (Exception ex) {
            _exception = ex;
        }
    }
    Object result() throws Exception {
        if (_exception != null) throw _exception;
        return _result;
    }

}
