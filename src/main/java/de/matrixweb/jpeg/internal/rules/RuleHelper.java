package de.matrixweb.jpeg.internal.rules;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.type.Type;

/**
 * @author markusw
 */
public final class RuleHelper {

  private RuleHelper() {
  }

  /**
   * @param result
   * @param reader
   * @param callback
   * @return ...
   * @throws RuleMismatchException
   */
  public static <T extends Type<T>> T Optional(T result,
      final InputReader reader, final RuleCallback<T> callback)
      throws RuleMismatchException {
    final int mark = reader.mark();
    try {
      result = callback.run(result != null ? result.copy() : null, reader);
    } catch (final RuleMismatchException e) {
      // Optional => ignore
      reader.reset(mark);
    }
    return result;
  }

  /**
   * @param result
   * @param reader
   * @param callback
   * @return ...
   * @throws RuleMismatchException
   */
  public static <T extends Type<T>> T OneOrMore(T result,
      final InputReader reader, final RuleCallback<T> callback)
      throws RuleMismatchException {
    int mark = reader.mark();
    try {
      result = callback.run(result != null ? result.copy() : null, reader);
    } catch (final RuleMismatchException e) {
      reader.reset(mark);
      throw e;
    }
    boolean mismatch = false;
    while (!mismatch) {
      mark = reader.mark();
      try {
        result = callback.run(result != null ? result.copy() : null, reader);
      } catch (final RuleMismatchException e) {
        reader.reset(mark);
        mismatch = true;
      }
    }
    return result;
  }

  /**
   * @param result
   * @param reader
   * @param callback
   * @return ...
   */
  public static <T extends Type<T>> T ZeroOrMore(T result,
      final InputReader reader, final RuleCallback<T> callback) {
    boolean mismatch = false;
    while (!mismatch) {
      final int mark = reader.mark();
      try {
        result = callback.run(result != null ? result.copy() : null, reader);
      } catch (final RuleMismatchException e) {
        reader.reset(mark);
        mismatch = true;
      }
    }
    return result;
  }

  /**
   * @param result
   * @param reader
   * @param callbacks
   * @return ...
   * @throws RuleMismatchException
   */
  public static <T extends Type<T>> T Choice(final T result,
      final InputReader reader, final RuleCallback<T>... callbacks)
      throws RuleMismatchException {
    RuleMismatchException error = null;
    for (final RuleCallback<T> callback : callbacks) {
      final int mark = reader.mark();
      try {
        return callback.run(result != null ? result.copy() : null, reader);
      } catch (final RuleMismatchException e) {
        reader.reset(mark);
        error = e;
      }
    }
    throw error;
  }

  /**
   * @param reader
   * @param callback
   * @throws RuleMismatchException
   */
  public static void And(final InputReader reader,
      final RuleCallback<?> callback) throws RuleMismatchException {
    boolean caught = false;
    final int mark = reader.mark();
    try {
      callback.run(null, reader);
    } catch (final RuleMismatchException e) {
      caught = true;
    } finally {
      reader.reset(mark);
    }
    if (caught) {
      throw new RuleMismatchException(reader.getPosition(), reader.toString());
    }
  }

  /**
   * @param reader
   * @param callback
   * @throws RuleMismatchException
   */
  public static void Not(final InputReader reader,
      final RuleCallback<?> callback) throws RuleMismatchException {
    boolean caught = false;
    final int mark = reader.mark();
    try {
      callback.run(null, reader);
    } catch (final RuleMismatchException e) {
      caught = true;
    } finally {
      reader.reset(mark);
    }
    if (!caught) {
      throw new RuleMismatchException(reader.getPosition(), reader.toString());
    }
  }

}
