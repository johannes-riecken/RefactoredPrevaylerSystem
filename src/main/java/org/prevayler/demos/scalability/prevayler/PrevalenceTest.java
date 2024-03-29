package org.prevayler.demos.scalability.prevayler;

import java.io.File;
import java.io.FileFilter;


public class PrevalenceTest {

    static public void delete(String dir) {
        delete(new File(dir));
    }

    static private void delete(File file) {
        if (file.isDirectory()) deleteDirectoryContents(file);
        if (!file.delete()) {
            System.gc();
        }
    }

    static private void deleteDirectoryContents(File directory) {
        File[] files = directory.listFiles(new PrevalenceFilter());
        if (files == null) return;
        for (int i = 0; i < files.length; i++) delete(files[i]);
    }

    static private class PrevalenceFilter implements FileFilter {
        @Override
        public boolean accept(File file) {
            return file.getName().endsWith("transactionLog")
                || file.getName().endsWith("snapshot")
                || file.isDirectory();
        }
    }

}
