package de.matrixweb.jpeg.internal.matcher;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.type.String;

/**
 * @author markusw
 */
public class AnyChar implements Matcher {

  @Override
  public String match(final InputReader reader) {
    return new String(reader.read());
  }

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public java.lang.String toString() {
    return ".";
  }

}
