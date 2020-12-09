package aspects.clock.demo.weave;

import org.prevayler.demos.demo2.business.*;
import java.util.Date;

/**
 * ClockAccountEntry
 */
privileged aspect ClockAccountEntry {
    private Date AccountEntry.timestamp;

	AccountEntry.new(long amount, Date timestamp) {
        this(amount);
        this.timestamp = timestamp;
    }
    
    private String AccountEntry.timestampString() {
        return new java.text.SimpleDateFormat("yyyy/MM/dd  hh:mm:ss.SSS").format(timestamp);
    }
    
    pointcut toStringCut(AccountEntry a) : target(a) && call(public String toString());
      
   
    String around(AccountEntry a) : toStringCut(a) {
        return a.timestampString() + proceed(a);
    }
}
