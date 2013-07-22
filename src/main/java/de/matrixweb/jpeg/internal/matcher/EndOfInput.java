package de.matrixweb.jpeg.internal.matcher;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;

/**
 * @author markusw
 */
public class EndOfInput implements Matcher {

  @Override
  public String match(final InputReader reader) throws RuleMismatchException {
    if (reader.hasNext()) {
      throw new RuleMismatchException("EOI", reader.getPosition(),
          reader.toString());
    }
    return null;
  }

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public java.lang.String toString() {
    return "EOI";
  }

}
