package de.matrixweb.jpeg.internal.rules;

/**
 * @author markusw
 */
public class RuleMismatchException extends Exception {

  private static final long serialVersionUID = 2613836771515322358L;

  /**
   * @param position
   * @param context
   */
  public RuleMismatchException(final String position, final String context) {
    super("Parsing mismatch at " + position + "\n" + context);
  }

  /**
   * @param expected
   * @param position
   * @param context
   */
  public RuleMismatchException(final String expected, final String position,
      final String context) {
    super("Parsing mismatch at " + position + "\nExpected: " + expected
        + "\n   Found: " + context);
  }

}
