package de.matrixweb.jpeg.internal.matcher;

import de.matrixweb.jpeg.internal.io.InputReader;

/**
 * @author markusw
 */
public class AnyChar implements Matcher {

  @Override
  public String match(final InputReader reader) {
    return String.valueOf(reader.read());
  }

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public String toString() {
    return ".";
  }

}
