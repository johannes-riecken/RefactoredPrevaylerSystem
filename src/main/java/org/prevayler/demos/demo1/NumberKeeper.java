package org.prevayler.demos.demo1;

import java.util.*;


/**
 * The NumberKeeper and all its references are the prevalent system.
 * i.e: They are the "business objects" and will be transparently persisted by Prevayler.
 */
public class NumberKeeper implements java.io.Serializable {

  private final List numbers = new ArrayList();


  void keep(int nextNumber) {
    numbers.add(new Integer(nextNumber));
  }

  List numbers() {
    return numbers;
  }

  int lastNumber() {
    return numbers.isEmpty()
      ? 0
      : ((Integer)numbers.get(numbers.size() - 1)).intValue();
  }

}
