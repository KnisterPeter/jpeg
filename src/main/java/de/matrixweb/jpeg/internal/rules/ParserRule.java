package de.matrixweb.jpeg.internal.rules;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.type.Type;

/**
 * @param <T>
 *          The result type of this parser rule
 * 
 * @author markusw
 */
public abstract class ParserRule<T extends Type<?>> {

  /**
   * @param reader
   * @return Returns the matched input tokens
   * @throws RuleMismatchException
   */
  public final T match(final InputReader reader) throws RuleMismatchException {
    final int mark = reader.mark();
    try {
      return consume(reader);
    } catch (final RuleMismatchException e) {
      reader.reset(mark);
      throw e;
    }
  }

  protected abstract T consume(InputReader reader) throws RuleMismatchException;

}
