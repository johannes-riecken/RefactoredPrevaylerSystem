package aspects.snapshot.demo.weave;

import org.prevayler.PrevaylerFactory;
import aspects.snapshot.XmlSnapshotManager;
import org.prevayler.demos.demo2.MainXml;
import org.prevayler.demos.demo2.business.Bank;
import org.prevayler.Prevayler;

/**
 * DemoMainXml
 */
privileged aspect DemoMainXml {

    pointcut mainxml(PrevaylerFactory factory) : 
        target(factory) && within(MainXml) && 
        call (public Prevayler create());
    
//    before (PrevaylerFactory f) throws Exception : mainxml(f) {
//        f.configureSnapshotManager(new XmlSnapshotManager(new Bank(), "demo2Xml"));
//    	
//    }
    
    before (PrevaylerFactory f)  : mainxml(f) {
        try{
            f.configureSnapshotManager(new XmlSnapshotManager(new Bank(), "demo2Xml"));
		}catch(Exception e){
			throw new org.aspectj.lang.SoftException (e);
		}
        
    }

}

	


