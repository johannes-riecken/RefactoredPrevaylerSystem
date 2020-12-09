package aspects.persistentLogging.demo.weave;

import org.prevayler.demos.demo2.*;
import org.prevayler.Prevayler;
import org.prevayler.PrevaylerFactory;
import org.prevayler.demos.demo2.business.Bank;
import java.io.*;

/**
 * DemoMain
 */
privileged aspect DemoMain {
    
    pointcut prevCreate() : within(Main) && call(public static Prevayler createTransientPrevayler(Serializable));
    
    Prevayler around() : prevCreate() {
        try {
            return PrevaylerFactory.createPrevayler(new Bank(), "demo2");
        }
        catch(Exception e) {
            throw new org.aspectj.lang.SoftException(e);
        }
    }
    
    pointcut configTrans(PrevaylerFactory f) : target(f) &&  call(public void configureTransientMode(boolean));
    
    void around(PrevaylerFactory f) : configTrans(f) && ( within(MainReplica) || within(MainReplicaServer) || within(MainXml) ){
        f.configureTransientMode(false);
    }

}
