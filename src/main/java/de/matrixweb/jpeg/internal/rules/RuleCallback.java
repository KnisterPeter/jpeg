package de.matrixweb.jpeg.internal.rules;

import de.matrixweb.jpeg.internal.io.InputReader;

/**
 * @author markusw
 */
public interface RuleCallback {

  /**
   * @param reader
   * @throws RuleMismatchException
   */
  void run(InputReader reader) throws RuleMismatchException;

}
