package de.matrixweb.jpeg.internal.rules;

import de.matrixweb.jpeg.internal.io.InputReader;

/**
 * @author markusw
 */
public final class RuleHelper {

  private RuleHelper() {
  }

  /**
   * @param reader
   * @param callback
   * @throws RuleMismatchException
   */
  public static void Optional(final InputReader reader,
      final RuleCallback callback) throws RuleMismatchException {
    final int mark = reader.mark();
    try {
      callback.run(reader);
    } catch (final RuleMismatchException e) {
      // Optional => ignore
      reader.reset(mark);
    }
  }

  /**
   * @param reader
   * @param callback
   * @throws RuleMismatchException
   */
  public static void OneOrMore(final InputReader reader,
      final RuleCallback callback) throws RuleMismatchException {
    int mark = reader.mark();
    try {
      callback.run(reader);
    } catch (final RuleMismatchException e) {
      reader.reset(mark);
      throw e;
    }
    boolean mismatch = false;
    while (!mismatch) {
      mark = reader.mark();
      try {
        callback.run(reader);
      } catch (final RuleMismatchException e) {
        reader.reset(mark);
        mismatch = true;
      }
    }
  }

  /**
   * @param reader
   * @param callback
   */
  public static void ZeroOrMore(final InputReader reader,
      final RuleCallback callback) {
    boolean mismatch = false;
    while (!mismatch) {
      final int mark = reader.mark();
      try {
        callback.run(reader);
      } catch (final RuleMismatchException e) {
        reader.reset(mark);
        mismatch = true;
      }
    }
  }

  /**
   * @param reader
   * @param callbacks
   * @throws RuleMismatchException
   */
  public static void Choice(final InputReader reader,
      final RuleCallback... callbacks) throws RuleMismatchException {
    RuleMismatchException error = null;
    for (final RuleCallback callback : callbacks) {
      final int mark = reader.mark();
      try {
        callback.run(reader);
        return;
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
  public static void And(final InputReader reader, final RuleCallback callback)
      throws RuleMismatchException {
    boolean caught = false;
    final int mark = reader.mark();
    try {
      callback.run(reader);
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
  public static void Not(final InputReader reader, final RuleCallback callback)
      throws RuleMismatchException {
    boolean caught = false;
    final int mark = reader.mark();
    try {
      callback.run(reader);
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
