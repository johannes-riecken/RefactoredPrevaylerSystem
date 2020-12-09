//Prevayler(TM) - The Free-Software Prevalence Layer.
//Copyright (C) 2001-2003 Klaus Wuestefeld
//This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

package aspects.replication;

import java.io.IOException;
import java.net.ServerSocket;

import org.prevayler.implementation.publishing.TransactionPublisher;


/** Reserved for future implementation.
 */
//public class ServerListener extends Thread {
public class ServerListener  {

	private final TransactionPublisher _publisher;
	private final ServerSocket _serverSocket;


	public ServerListener(TransactionPublisher publisher, int port) throws IOException {
		_serverSocket = new ServerSocket(port);
		_publisher = publisher;
//		setDaemon(true);
//		start();
		run();
	} 


	public void run() {
		try {
			while (true) new ServerConnection(_publisher, _serverSocket.accept());
		} catch (IOException iox) {
			iox.printStackTrace();
		}
	}	
}
