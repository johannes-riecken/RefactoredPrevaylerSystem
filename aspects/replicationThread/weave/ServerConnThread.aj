package aspects.replicationThread.weave;

import aspects.replication.*;
import java.io.*;
/**
 * ServerConnThread
 */
privileged aspect ServerConnThread {

    declare parents :  ServerConnection extends Thread;

	pointcut tar(ServerConnection s) : target(s);
	
	pointcut sendExec() : execution(private void send(Object)); 
	
	void around (ServerConnection s): tar(s) && sendExec() { 
	   synchronized (s._toRemote) {
	       proceed(s);
	   }
	}
	
	//Receive function.
	pointcut inReceive(ServerConnection s) : this(s) && withincode(public void receive(..));
	pointcut writeObj() : call(void ObjectOutputStream.writeObject(..));
	
	void around(ServerConnection s) : inReceive(s) && writeObj() {
	    synchronized (s._toRemote) {
			proceed(s);
	    }
	}

	//TEST DELETE
	
	
	//TEST DELETE
	
	//Send clock ticks.
	pointcut clockTicks() : execution(private void sendClockTicks());
	
	void around(final ServerConnection s) : tar(s) && clockTicks() {
	    Thread clockTickSender = new Thread() {
			public void run() {
			    proceed(s);
			}
	    };	
	    clockTickSender.setDaemon(true);
	    clockTickSender.start();	
		
	}
	
	
//	ServerConnection serverConn;
//	pointcut sendClockTicksCall(ServerConnection s) : target(s) && call( private void sendClockTicks());
//	before(ServerConnection s) : sendClockTicksCall(s) {
//	    serverConn = s;
//	}   
	    
	pointcut insendClockTicks() : within(ServerConnection) && withincode(private void sendClockTicks() );    
	pointcut writeObjCall(): call(void writeObject(..));
	
//	void around() : insendClockTicks() && writeObjCall() {
//	    try {
//	        synchronized (serverConn._toRemote) {
//	            proceed();
//	        }
//	    
//	        Thread.sleep(1000);
//	    }
//	    catch(Exception e) {
//	        e.printStackTrace();
//	    }
//		
//	}	
	
	void around(ServerConnection s_) : this(s_) && insendClockTicks() && writeObjCall() {
	    try {
	        synchronized (s_._toRemote) {
	            proceed(s_);
	        }
	    
	        Thread.sleep(1000);
	    }
	    catch(Exception e) {
	        e.printStackTrace();
	    }
		
	}	
	
	//Constructor call. 
	pointcut inConstr() : withincode(ServerConnection.new(..));
	pointcut callRun() : call(void run(..));
	
	void around(ServerConnection s) : tar(s) && inConstr() && callRun() {
	 
	    s.setDaemon(true);
	    s.start();
	}
}
