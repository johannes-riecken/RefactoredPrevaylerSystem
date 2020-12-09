package aspects.snapshot.demo.weave;

import org.prevayler.Prevayler;
import org.prevayler.demos.demo2.*;



/**
 * SnapshotDemoMain
 */
privileged aspect SnapshotDemoMain {

    pointcut takeSnapshot(Prevayler p) : args(p) &&  within(Main) && execution(static void startSnapshots(Prevayler));
    
    after (Prevayler prevayler) /* AJSTATS throws Exception */ : takeSnapshot(prevayler) {
       while (true) {
			Thread.sleep(1000 * 20);
    	  
			prevayler.takeSnapshot();
			Main.out("Snapshot taken at " + new java.util.Date() + "...");
		}
    }
    



}
