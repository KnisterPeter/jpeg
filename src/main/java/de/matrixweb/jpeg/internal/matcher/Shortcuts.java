package de.matrixweb.jpeg.internal.matcher;

/**
 * @author markusw
 */
public final class Shortcuts {

  private Shortcuts() {
  }

  /**
   * @return ...
   */
  public static AnyChar Any() {
    return new AnyChar();
  }

  /**
   * @param sequence
   * @return ...
   */
  public static Terminal T(final String sequence) {
    return new Terminal(sequence);
  }

  /**
   * @param c
   * @return ...
   */
  public static Terminal T(final char c) {
    return new Terminal(c);
  }

  /**
   * @param range
   * @return ...
   */
  public static CharRange Char(final String range) {
    return new CharRange(range);
  }

  /**
   * @return ...
   */
  public static EndOfInput EOI() {
    return new EndOfInput();
  }

}
