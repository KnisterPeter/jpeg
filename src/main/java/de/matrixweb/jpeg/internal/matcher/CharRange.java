package de.matrixweb.jpeg.internal.matcher;

import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;

/**
 * @author markusw
 */
public class CharRange implements Matcher {

  private final List<RangeDef> ranges = new ArrayList<CharRange.RangeDef>();

  /**
   * @param range
   */
  public CharRange(final java.lang.String range) {
    java.lang.String def = range.substring(1, range.length() - 1);
    while (def.length() > 0) {
      if (def.length() > 1 && def.charAt(1) == '-') {
        this.ranges.add(new RangeDef(def.substring(0, 3)));
        def = def.substring(3);
      } else {
        this.ranges.add(new RangeDef(def.substring(0, 1)));
        def = def.substring(1);
      }
    }
  }

  @Override
  public String match(final InputReader reader) throws RuleMismatchException {
    Character character = null;
    final int mark = reader.mark();
    if (reader.hasNext()) {
      final char c = reader.read();
      for (int i = 0, l = this.ranges.size(); character == null && i < l; i++) {
        if (this.ranges.get(i).contains(c)) {
          character = c;
        }
      }
    }
    if (character == null) {
      reader.reset(mark);
      throw new RuleMismatchException(this.ranges.toString(),
          reader.getPosition(), reader.toString());
    }
    return new String(character);
  }

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public java.lang.String toString() {
    final StringBuilder sb = new StringBuilder();
    sb.append("[");
    for (final RangeDef range : this.ranges) {
      sb.append(range);
    }
    sb.append("]");
    return sb.toString();
  }

  private static class RangeDef {

    private final char min;

    private final char max;

    /**
     * @param range
     */
    public RangeDef(final java.lang.String range) {
      if (range.length() == 1) {
        this.min = this.max = range.charAt(0);
      } else {
        this.min = range.charAt(0);
        this.max = range.charAt(2);
      }
    }

    boolean contains(final char c) {
      return this.min <= c && c <= this.max;
    }

    /**
     * @see java.lang.Object#toString()
     */
    @Override
    public java.lang.String toString() {
      return this.min != this.max ? this.min + "-" + this.max
          : java.lang.String.valueOf(this.min);
    }

  }

}
