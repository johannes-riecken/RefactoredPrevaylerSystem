package aspects.persistentmultithread.weave;



import aspects.persistentLogging.DurableOutputStream;
import java.io.*;
import aspects.multithread.*;
import aspects.multithread.weave.SynchMethods;


privileged aspect  ThreadingDurableAspect extends SynchMethods {
	
	private int DurableOutputStream._objectsSynced = 0;
	private int DurableOutputStream._fileSyncCount = 0;
	
	
	
	after(DurableOutputStream stream) :
		target(stream) && withincode(DurableOutputStream.new(File) throws IOException) 
		&& set(ObjectOutputStream DurableOutputStream._objectOutputStream){
		stream.startSyncher();
			
	}
	
	private void DurableOutputStream.startSyncher() {
	    Thread syncher = new Thread() {
			public void run() {			    
				syncher();
			}
		};
		syncher.setDaemon(true);
		syncher.start();
	}




	public void DurableOutputStream.sync(Object object, Turn myTurn) throws IOException {
		int thisWrite;
		try {
			myTurn.start();
			thisWrite = writeObject(object);
		} finally {
			myTurn.end();
		}
	
		waitUntilSynced(thisWrite);
	}

	
	pointcut writeObjectCut(DurableOutputStream s) : withincode(private int writeObject(Object) throws IOException)
									&& this(s)
									//&& within(DurableOutputStream) 
									&& set(int DurableOutputStream._objectsWritten);
	
	after(DurableOutputStream s) : writeObjectCut(s) {
			s.notifyAll();
			
	}
	
	private synchronized void DurableOutputStream.waitUntilSynced(int thisWrite) throws IOException {
	    	while (_objectsSynced < thisWrite && _exceptionWhileSynching == null) {
				Cool.wait(this);
			}
			if (_objectsSynced < thisWrite) {
				throw _exceptionWhileSynching;
			}
	}
					
	pointcut syncherExec(DurableOutputStream stream) : target(stream) &&
				execution(void syncher());
				
	pointcut setClosingState() : set(int DurableOutputStream._closingState) ;
	pointcut getExceptionWhileClosing(): get(IOException DurableOutputStream._exceptionWhileClosing);
	
	/**
	 * Synchronized
	 * 
	 * */
	//	pointcut reallyClosedExec(DurableOutputStream stream) : target(stream) &&
	//	execution(boolean reallyClosed());

	//	pointcut closeExec(DurableOutputStream stream) : target(stream)
	//		&& execution(void close() throws IOException);
	
	//	pointcut writeObjectExec(DurableOutputStream stream) : target(stream) &&
	//	execution(int writeObject(Object) throws IOException);		
	declare parents: DurableOutputStream implements SynchMethods.Synch;
	public pointcut synchCall() :
		execution(void DurableOutputStream.close()) || execution(boolean DurableOutputStream.reallyClosed()) 
		|| execution(int DurableOutputStream.writeObject(Object));	
	/**
	 * End Synchronized
	 *
	 */
		
//	void around(DurableOutputStream stream):
//		closeExec(stream) 
//	{ 
//	   
//		 synchronized(stream) {
//			proceed(stream);
//		 }
//	}
	
//	boolean around(DurableOutputStream stream) : reallyClosedExec(stream) {
//		synchronized(stream) {		    
//			return proceed(stream);
//		}
//	}
	
//	int around(DurableOutputStream stream) : writeObjectExec(stream) {
//		synchronized(stream) {		    
//			return proceed(stream);
//		}
//	}
	 
	pointcut closeExec2(DurableOutputStream stream) : this(stream) && withincode(void close() throws IOException);
	
	 
	 
	after(DurableOutputStream stream) : closeExec2(stream) && setClosingState() {
	    stream.notifyAll();	
	}

	before(DurableOutputStream stream): closeExec2(stream)&& getExceptionWhileClosing() {
	    
		while (stream._closingState != DurableOutputStream.REALLY_CLOSED) {
			//Cool.wait(this);
		    Cool.wait(stream);
		}
	}
		
	//we dont want to do anything here, as it is part of the thread closing.  
	void around(DurableOutputStream d) : target(d) && execution(protected void finalize()) {		
	}
	
	public synchronized int DurableOutputStream.fileSyncCount() {
		return _fileSyncCount;
	}
	
	
	/****Syncher ****/
	
	void around(DurableOutputStream stream): syncherExec(stream) 
	{ 
		 synchronized(stream) {
			try {
			    while (true) {
					while (stream._objectsSynced == stream._objectsWritten && stream._closingState == DurableOutputStream.NOT_CLOSED) {
						Cool.wait(stream);
					}
					if (stream._objectsSynced == stream._objectsWritten) {
						break;
					}					
					proceed(stream);
					Thread.currentThread().setPriority(Thread.MIN_PRIORITY);
					stream._fileDescriptor.sync();
		
					Thread.currentThread().setPriority(Thread.NORM_PRIORITY);
		
					stream._objectsSynced = stream._objectsWritten;
					stream._fileSyncCount++;					
					stream.notifyAll();
				}					
			}
			catch (IOException duringSync) {
				stream._exceptionWhileSynching = duringSync;
			}
			finally {
				try {	
					stream._objectOutputStream.close();
				} catch (IOException duringClose) {
					stream._exceptionWhileClosing = duringClose;
				}
				stream._closingState = DurableOutputStream.REALLY_CLOSED;				
				stream.notifyAll();
		 	}
		}
	}
	
}
