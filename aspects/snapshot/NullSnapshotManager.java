//Prevayler(TM) - The Free-Software Prevalence Layer.
//Copyright (C) 2001-2003 Klaus Wuestefeld
//This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

package aspects.snapshot;

import java.io.IOException;

public class NullSnapshotManager extends SnapshotManager {

    private final String _snapshotAttemptErrorMessage;

    public NullSnapshotManager(Object newPrevalentSystem, String snapshotAttemptErrorMessage) {
        super(newPrevalentSystem);
        _snapshotAttemptErrorMessage = snapshotAttemptErrorMessage;
    }

    public void writeSnapshot(Object prevalentSystem, long version) throws IOException {
        throw new IOException(_snapshotAttemptErrorMessage);
    }

}
