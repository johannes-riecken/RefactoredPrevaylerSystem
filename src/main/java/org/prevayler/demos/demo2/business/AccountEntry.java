package org.prevayler.demos.demo2.business;

import java.io.Serializable;
//import java.util.Date;

public class AccountEntry implements Serializable {

        private long amount;
//        private Date timestamp;

        private AccountEntry() {
        }

//        AccountEntry(long amount, Date timestamp) {
//            this.amount = amount;
//            this.timestamp = timestamp;
//        }

        AccountEntry(long amount) {
            this.amount = amount;
            //this.timestamp = timestamp;
        }

        @Override
        public String toString() {
            //return timestampString() + "      Amount: " + amount;
           return "      Amount: " + amount;
        }

//        private String timestampString() {
//            return new java.text.SimpleDateFormat("yyyy/MM/dd  hh:mm:ss.SSS").format(timestamp);
//        }
}
