package aspects.clock.demo.weave;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import org.prevayler.demos.demo2.gui.*;
/**
 * BankFrameClock
 */
privileged aspect BankFrameClock {

    private BankFrame bf;
    pointcut refClock(BankFrame f) : target(f) && call(private void refreshClock());
    before(BankFrame f) :refClock(f) {
        bf = f;
    }   
     
    pointcut inrefresh() : within(BankFrame) && withincode(public void Thread.run());    
    pointcut titleCall(): call(* setTitle(..));    
    void around() : titleCall() && inrefresh() {
        DateFormat format = new SimpleDateFormat("hh:mm:ss");
		
        bf.setTitle("Bank - " + format.format(bf._prevayler.clock().time()));
		        
    }
}
