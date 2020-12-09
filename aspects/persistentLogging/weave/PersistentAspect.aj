package aspects.persistentLogging.weave;

import aspects.persistentLogging.*;
import org.prevayler.PrevaylerFactory;
import org.prevayler.Prevayler;
import java.io.Serializable;

import java.io.IOException;
import org.prevayler.implementation.logging.TransactionLogger;

/**
 * PersistentAspect
 */
privileged aspect PersistentAspect {
    

	private long PrevaylerFactory._transactionLogSizeThreshold;
	private long PrevaylerFactory._transactionLogAgeThreshold;
	
    pointcut logCall(PrevaylerFactory f) : this(f) && execution(private TransactionLogger logger());
    
    TransactionLogger around(PrevaylerFactory f) throws IOException, ClassNotFoundException : logCall(f) {
        if (!f._transientMode) {
            return new PersistentLogger(f.prevalenceBase(), f._transactionLogSizeThreshold, f._transactionLogAgeThreshold);
            
        }
        else {
            return proceed(f);
        }
    }
	
    
    /** Creates a Prevayler that will use a directory called "PrevalenceBase" under the current directory to read and write its .snapshot and .transactionLog files.
 	 * @param newPrevalentSystem The newly started, "empty" prevalent system that will be used as a starting point for every system startup, until the first snapshot is taken.
	 */
	public static Prevayler PrevaylerFactory.createPrevayler(Serializable newPrevalentSystem) throws IOException, ClassNotFoundException {
		return createPrevayler(newPrevalentSystem, "PrevalenceBase");
	}


	/** Creates a Prevayler that will use the given prevalenceBase directory to read and write its .snapshot and .transactionLog files.
	 * @param newPrevalentSystem The newly started, "empty" prevalent system that will be used as a starting point for every system startup, until the first snapshot is taken.
	 * @param prevalenceBase The directory where the .snapshot files and .transactionLog files will be read and written.
	 */
	public static Prevayler PrevaylerFactory.createPrevayler(Serializable newPrevalentSystem, String prevalenceBase) throws IOException, ClassNotFoundException {
		PrevaylerFactory factory = new PrevaylerFactory();
		factory.configurePrevalentSystem(newPrevalentSystem);
		factory.configurePrevalenceBase(prevalenceBase);
		return factory.create();
	}

    public void PrevaylerFactory.configureTransactionLogFileSizeThreshold(long sizeInBytes) {
		_transactionLogSizeThreshold = sizeInBytes;
	}

	
	public void PrevaylerFactory.configureTransactionLogFileAgeThreshold(long ageInMilliseconds) {
		_transactionLogAgeThreshold = ageInMilliseconds;
	}
}
