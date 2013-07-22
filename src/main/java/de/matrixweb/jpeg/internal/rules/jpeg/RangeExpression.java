package de.matrixweb.jpeg.internal.rules.jpeg;

import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class RangeExpression extends Expression {

  private String dash;

  private List<Range> ranges;

  /**
   * @return the dash
   */
  public String getDash() {
    return this.dash;
  }

  /**
   * @param dash
   *          the dash to set
   */
  public void setDash(final String dash) {
    this.dash = dash;
  }

  /**
   * @return the ranges
   */
  public List<Range> getRanges() {
    return this.ranges;
  }

  /**
   * @param ranges
   *          the ranges to set
   */
  public void setRanges(final List<Range> ranges) {
    this.ranges = ranges;
  }

  /** */
  public static class GrammarRule extends ParserRule<Expression> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<String> dash = new Mutable<String>(new String());
      final Mutable<List<Range>> ranges = new Mutable<List<Range>>(
          new ArrayList<Range>());

      // @formatter:off
      // '[' '-'? (!']'(!'-' . '-' !'-' . | !'-' .))* ']'
      {
        // '['
        T("[").match(reader);
        // '-'?
        Optional(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // '-'
            dash.getValue().add(T("-").match(reader));
          }
        });
        // (!']'(!'-' . '-' !'-' . | !'-' .))*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // !']'
            Not(reader, new RuleCallback() {
              @Override
              public void run(final InputReader reader) throws RuleMismatchException {
                // ']'
                T("]").match(reader);
              }
            });
            // (!'-' . '-' !'-' . | !'-' .)
            Choice(reader, new RuleCallback() {
              @Override
              public void run(final InputReader reader) throws RuleMismatchException {
                // !'-' . '-' !'-' .
                ranges.getValue().add(MinMaxRange().match(reader));
              }
            }, new RuleCallback() {
              @Override
              public void run(final InputReader reader) throws RuleMismatchException {
                // !'-' .
                ranges.getValue().add(CharRange().match(reader));
              }
            });
          }
        });
        // ']'
        T("]").match(reader);
      }
      // @formatter:on

      final RangeExpression expression = new RangeExpression();
      expression.setDash(dash.getValue());
      expression.setRanges(ranges.getValue());
      return expression;
    }
  }

}
