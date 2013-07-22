package de.matrixweb.jpeg.internal.rules;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.type.Type;

/**
 * @param <T>
 * @author markusw
 */
public interface RuleCallback<T extends Type<?>> {

  /**
   * @param result
   * @param reader
   * @return ...
   * @throws RuleMismatchException
   */
  T run(T result, InputReader reader) throws RuleMismatchException;

}
