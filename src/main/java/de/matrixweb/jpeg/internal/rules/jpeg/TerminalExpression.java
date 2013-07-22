package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class TerminalExpression extends Expression<TerminalExpression> {

  private String value;

  /**
   * @see de.matrixweb.jpeg.internal.rules.jpeg.Expression#copy()
   */
  @Override
  public TerminalExpression copy() {
    final TerminalExpression copy = new TerminalExpression();
    copy.value = this.value != null ? this.value.copy() : null;
    return copy;
  }

  /**
   * @return the value
   */
  public String getValue() {
    return this.value;
  }

  /**
   * @param value
   *          the value to set
   */
  public void setValue(final String value) {
    this.value = value;
  }

  /** */
  public static class GrammarRule extends ParserRule<Expression<?>> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression<?> consume(final InputReader reader)
        throws RuleMismatchException {
      TerminalExpression expression = new TerminalExpression();

      // @formatter:off
      // '\'' value=InTerminalChar? '\''
      {
        // '\''
        T("'").match(reader);
        // value=InTerminalChar?
        expression = Optional(expression, reader, new RuleCallback<TerminalExpression>() {
          @Override
          public TerminalExpression run(final TerminalExpression expression, final InputReader reader) throws RuleMismatchException {
            // value=InTerminalChar
            expression.setValue(InTerminalChar().match(reader));
            
            return expression;
          }
        });
        // '\''
        T("'").match(reader);
      }
      // @formatter:on

      return expression;
    }

  }

}
