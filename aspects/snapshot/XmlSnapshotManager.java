//Prevayler(TM) - The Free-Software Prevalence Layer.
//Copyright (C) 2001-2003 Klaus Wuestefeld
//This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//Contributions: Alexandre Nodari

package aspects.snapshot;
import java.io.*;

import javax.xml.transform.stream.*;

import com.skaringa.javaxml.*;

/**
 * Writes and reads snapshots to/from XML files.
 *
 * <p>This implementation requires the <a href="http://www.skaringa.com/">Skaringa</a>
 * Java and XML language binding framework which provides for Java object XML serialization.</p>
 *
 * <p>Note that Skaringa has some dependencies of its own.  It requires the standard XML API's
 * (xml-apis.jar from the <a href="http://xml.apache.org/xerces2-j/">Apache Xerces-j</a> project or j2sdk1.4.x),
 * an XML Transformation engine (<a href="http://xml.apache.org/xalan-j/">Apache Xalan-j</a>),
 * and a logging api (<a href="http://jakarta.apache.org/commons/logging.html">Apache Jakarta Commons Logging</a>),
 * and, if desired, a logging implementation (<a href="http://jakarta.apache.org/log4j/">Apache Jakarta Log4j</a> or j2sdk1.4.x logging).</p>
 *
 * <p>One more quick note.  j2sdk1.4.x comes with an old buggy version of Xalan which you should override using the
 * endorsed package override mechanism.  To do this, add your preferred version of xalan.jar to JAVA_HOME/jre/lib/endorsed.
 * You will need to create the 'endorsed' directory if it doesn't already exist.  That is the *only* way to override packages
 * that the JDK already provides in j2sdk1.4.x and above.  In JDK1.3.x, this isn't a problem, although you will need to supply
 * everything mentioned above on the classpath.</p>
 *
 * @see org.prevayler.implementation.snapshot.SnapshotManager
 */
public class XmlSnapshotManager extends SnapshotManager {


    public XmlSnapshotManager(Object newPrevalentSystem, String snapshotDirectoryName) throws ClassNotFoundException, IOException {
        super(newPrevalentSystem, snapshotDirectoryName);
    }


    /**
     * @see org.prevayler.implementation.snapshot.SnapshotManager#readSnapshot(InputStream)
     */
    public Object readSnapshot(InputStream in) throws IOException {
        StreamSource source = new StreamSource(in);
        try {
            return transformer().deserialize(source);
        } catch (DeserializerException de) {
            throw new IOException("Unable to deserialize with Skaringa: " + de.getMessage());
        } finally {
            source.getInputStream().close();
        }
    }


    /**
     * @see org.prevayler.implementation.snapshot.SnapshotManager#suffix()
     */
    protected String suffix() {
        return "xml";
    }


    /**
     * @see org.prevayler.implementation.snapshot.SnapshotManager#writeSnapshot(Object, OutputStream)
     */
    public void writeSnapshot(Object prevalentSystem, OutputStream out) throws IOException {
        StreamResult result = new StreamResult(out);
        try {
            transformer().serialize(prevalentSystem, result);
        } catch (SerializerException se) {
            throw new IOException("Unable to serialize with Skaringa: " + se.getMessage());
        } finally {
            result.getOutputStream().close();
        }
    }


    private ObjectTransformer transformer() throws IOException {
        try {
            return ObjectTransformerFactory.getInstance().getImplementation();
//			Other options you can try:
//			trans.setProperty(javax.xml.transform.OutputKeys.INDENT, "yes");
//			trans.setProperty(javax.xml.transform.OutputKeys.ENCODING, "ISO-8859-1");
//			trans.setProperty(com.skaringa.javaxml.PropertyKeys.OMIT_XSI_TYPE, "true");
        }
        catch (NoImplementationException nie) {
            throw new IOException("Unable to start Skaringa: " + nie.getMessage());
        }
    }
}
