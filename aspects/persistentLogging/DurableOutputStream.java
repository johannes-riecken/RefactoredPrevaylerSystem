//Prevayler(TM) - The Free-Software Prevalence Layer.
//Copyright (C) 2001-2003 Klaus Wuestefeld
//This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

package aspects.persistentLogging;

import java.io.*;


public class DurableOutputStream {
	private static final int NOT_CLOSED = 0;
	private static final int CLOSE_CALLED = 1;
	private static final int REALLY_CLOSED = 2;

	private final File _file;
	private final ObjectOutputStream _objectOutputStream;
	private final FileOutputStream _fileOutputStream;
	private final FileDescriptor _fileDescriptor;

	private IOException _exceptionWhileClosing;
	private IOException _exceptionWhileSynching;
//
	private int _objectsWritten = 0;

	private int _closingState = NOT_CLOSED;


	public DurableOutputStream(File file) throws IOException {
		_file = file;
		_fileOutputStream = new FileOutputStream(file);
		_fileDescriptor = _fileOutputStream.getFD();
		_objectOutputStream = new ObjectOutputStream(new BufferedOutputStream(_fileOutputStream, 16 * 512)); //Arbitrarily large buffer. Should be a power of two multiplied by 512 bytes (disk sector size).
	}




	public void sync(Object object) throws IOException {
		writeObject(object);
		syncher();
	}

	private int writeObject(Object object) throws IOException {
		if (_closingState != NOT_CLOSED) {
			throw new IOException("stream is closing");
		}
		_objectOutputStream.writeObject(object);
		_objectsWritten++;
		return _objectsWritten;
	}

	public void close() throws IOException {
	   if (_closingState == NOT_CLOSED) {
			_closingState = CLOSE_CALLED;
		}

		//Refactoring note: IRUM added this line below for
		//accessing exceptionWhilecloseing pointcut
		IOException ex = _exceptionWhileClosing;
		if (ex != null) {
			throw ex;
		}
//		if (_exceptionWhileClosing != null) {
//			throw _exceptionWhileClosing;
//		}
	}

	private void syncher() {
	    try {
			_objectOutputStream.flush();
			_fileOutputStream.flush();
		}
	    catch(IOException duringSync) {
	        _exceptionWhileSynching = duringSync;
	    }

	}

	protected void finalize() {
		try {
			_objectOutputStream.close();
		} catch (IOException duringClose) {
			_exceptionWhileClosing = duringClose;
		}
		_closingState = REALLY_CLOSED;
		//notifyAll();


	}


	public File file() {
		return _file;
	}

	public  boolean reallyClosed() {
		return _closingState == REALLY_CLOSED;
	}

}
