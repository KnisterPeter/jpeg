package de.matrixweb.jpeg.internal.matcher;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;

/**
 * @author markusw
 */
public interface Matcher {

  /**
   * @param reader
   * @return Returns the matched character data
   * @throws RuleMismatchException
   */
  String match(InputReader reader) throws RuleMismatchException;

}
