package org.prevayler.demos.scalability;

import java.util.List;

public interface QueryConnection {

    /** Returns the List of all PrevaylerRecord with the given name.
    */
    List queryByName(String name);

}
