package de.matrixweb.jpeg.internal.rules.jpeg;

import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;
import de.matrixweb.jpeg.internal.type.Type;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class RangeExpression extends Expression<RangeExpression> {

  private String dash;

  private List<Range> ranges = new ArrayList<Range>();

  /**
   * @see de.matrixweb.jpeg.internal.rules.jpeg.Expression#copy()
   */
  @Override
  public RangeExpression copy() {
    final RangeExpression copy = new RangeExpression();
    copy.dash = this.dash != null ? this.dash.copy() : null;
    for (final Range range : this.ranges) {
      copy.ranges.add(range.copy());
    }
    return copy;
  }

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
  public static class GrammarRule extends ParserRule<Expression<?>> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression<?> consume(final InputReader reader)
        throws RuleMismatchException {
      RangeExpression expression = new RangeExpression();

      // @formatter:off
      // '[' dash='-'? (!']' ranges+=(MinMaxRange | CharRange))* ']'
      {
        // '['
        T("[").match(reader);
        // dash='-'?
        expression.setDash(Optional(null, reader, new RuleCallback<String>() {
          @Override
          public String run(final String string, final InputReader reader) throws RuleMismatchException {
            // dash='-'
            return T("-").match(reader);
          }
        }));
        // (!']' ranges+=(MinMaxRange | CharRange))*
        expression = ZeroOrMore(expression, reader, new RuleCallback<RangeExpression>() {
          @SuppressWarnings({ "unchecked", "rawtypes" })
          @Override
          public RangeExpression run(final RangeExpression expression, final InputReader reader) throws RuleMismatchException {
            // !']'
            Not(reader, new RuleCallback() {
              @Override
              public Type run(final Type type, final InputReader reader) throws RuleMismatchException {
                // ']'
                return T("]").match(reader);
              }
            });
            // ranges+=(MinMaxRange | CharRange)
            expression.getRanges().add(Choice(null, reader, new RuleCallback<Range>() {
              @Override
              public Range run(final Range range, final InputReader reader) throws RuleMismatchException {
                // MinMaxRange
                return MinMaxRange().match(reader);
              }
            }, new RuleCallback<Range>() {
              @Override
              public Range run(final Range range, final InputReader reader) throws RuleMismatchException {
                // CharRange
                return CharRange().match(reader);
              }
            }));
            
            return expression;
          }
        });
        // ']'
        T("]").match(reader);
      }
      // @formatter:on

      return expression;
    }
  }

}
