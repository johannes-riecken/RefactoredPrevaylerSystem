package aspects.prevalenceBase.weave;
import org.prevayler.PrevaylerFactory;
import org.prevayler.demos.demo2.*;
import org.prevayler.Prevayler;


/**
 * DemoWeave
 */
public aspect DemoWeave {
    pointcut prevSysConfig(PrevaylerFactory f) : target(f) && call(public void configurePrevalentSystem(Object));

	after(PrevaylerFactory f) : prevSysConfig(f) && within(MainReplica) {
	    f.configurePrevalenceBase("demo2Replica");
	}
	
	after(PrevaylerFactory f) : prevSysConfig(f) && within(MainReplicaServer) {
	    f.configurePrevalenceBase("demo2");
	}
	
	pointcut mainxml(PrevaylerFactory factory) : 
        target(factory) && within(MainXml) && 
        call (public Prevayler create());
   
	before(PrevaylerFactory f) : mainxml(f) {
	    f.configurePrevalenceBase("demo2Xml");
	}
}
