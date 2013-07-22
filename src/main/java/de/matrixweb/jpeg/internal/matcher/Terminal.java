package de.matrixweb.jpeg.internal.matcher;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;

/**
 * @author markusw
 */
public class Terminal implements Matcher {

  private final String sequence;

  /**
   * @param sequence
   */
  public Terminal(final String sequence) {
    this.sequence = sequence;
  }

  /**
   * @param c
   */
  public Terminal(final char c) {
    this.sequence = String.valueOf(c);
  }

  @Override
  public String match(final InputReader reader) throws RuleMismatchException {
    final StringBuilder sb = new StringBuilder();
    final int mark = reader.mark();
    for (int i = 0, n = this.sequence.length(); i < n; i++) {
      final char s = this.sequence.charAt(i);
      if (reader.hasNext()) {
        final char c = reader.read();
        if (c != s) {
          final RuleMismatchException rme = new RuleMismatchException(
              this.sequence, reader.getPosition(), reader.toString());
          reader.reset(mark);
          throw rme;
        }
        sb.append(c);
      } else {
        final RuleMismatchException rme = new RuleMismatchException(
            this.sequence, reader.getPosition(), reader.toString());
        reader.reset(mark);
        throw rme;
      }
    }
    return sb.toString();
  }

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public String toString() {
    return "'"
        + this.sequence.replace("\n", "\\n").replace("\r", "\\r")
            .replace("\t", "\\t") + "'";
  }

}
