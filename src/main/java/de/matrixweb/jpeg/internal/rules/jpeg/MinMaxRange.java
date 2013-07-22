package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;

/**
 * @author markusw
 */
public class MinMaxRange extends Range {

  private String min;

  private String max;

  /**
   * @return the min
   */
  public String getMin() {
    return this.min;
  }

  /**
   * @param min
   *          the min to set
   */
  public void setMin(final String min) {
    this.min = min;
  }

  /**
   * @return the max
   */
  public String getMax() {
    return this.max;
  }

  /**
   * @param max
   *          the max to set
   */
  public void setMax(final String max) {
    this.max = max;
  }

  /** */
  public static class GrammarRule extends ParserRule<Range> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#consume(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Range consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<String> min = new Mutable<String>(new String());
      final Mutable<String> max = new Mutable<String>(new String());

      // @formatter:off
      // !'-' min=. '-' !'-' max=.
      {
        // !'-'
        Not(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // '-'
            T("-").match(reader);
          }
        });
        // .
        min.getValue().add(Any().match(reader));
        // '-'
        T("-").match(reader);
        // !'-' 
        // !'-'
        Not(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // '-'
            T("-").match(reader);
          }
        });
        // .
        max.getValue().add(Any().match(reader));
      }
      // @formatter:on

      final MinMaxRange minmaxrange = new MinMaxRange();
      minmaxrange.setMin(min.getValue());
      minmaxrange.setMax(max.getValue());
      return minmaxrange;
    }

  }

}
