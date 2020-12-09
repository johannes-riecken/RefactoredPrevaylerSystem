package aspects.prevalenceBase.weave;

import org.prevayler.PrevaylerFactory;
import org.prevayler.Prevayler;
/**
 * PrevalenceBase
 */
privileged aspect PrevalenceBase {
	private String PrevaylerFactory._prevalenceBase;
	

	/** Configures the directory where the created Prevayler will read and write its .transactionLog and .snapshot files. The default is a directory called "PrevalenceBase" under the current directory.
	 * @param prevalenceBase Will be ignored for the .snapshot files if a SnapshotManager is configured.
	 */
	public void PrevaylerFactory.configurePrevalenceBase(String prevalenceBase) {
		_prevalenceBase = prevalenceBase;
	}
	
	private String PrevaylerFactory.prevalenceBase() {
		return _prevalenceBase != null ? _prevalenceBase : "PrevalenceBase";
	}
	
	pointcut factBase(PrevaylerFactory f, String dir) : target(f) && args(dir) && withincode(public static Prevayler createCheckpointPrevayler(.., String)) && 
	        call(public void configurePrevalentSystem(Object));
	
	after(PrevaylerFactory f, String dir) : factBase(f, dir) {
	    f.configurePrevalenceBase(dir);
	}
		
	
	
}
