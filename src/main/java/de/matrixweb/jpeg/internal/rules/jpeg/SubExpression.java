package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class SubExpression extends Expression<SubExpression> {

  private Expression<?> expr;

  /**
   * @see de.matrixweb.jpeg.internal.rules.jpeg.Expression#copy()
   */
  @Override
  public SubExpression copy() {
    final SubExpression copy = new SubExpression();
    copy.expr = this.expr.copy();
    return copy;
  }

  /**
   * @return the expr
   */
  public Expression<?> getExpr() {
    return this.expr;
  }

  /**
   * @param expr
   *          the expr to set
   */
  public void setExpr(final Expression<?> expr) {
    this.expr = expr;
  }

  /** */
  public static class GrammarRule extends ParserRule<Expression<?>> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression<?> consume(final InputReader reader)
        throws RuleMismatchException {
      final SubExpression expression = new SubExpression();

      // @formatter:off
      // '(' WS* expr=ChoiceExpression WS* ')'
      {
        // '('
        T("(").match(reader);
        // WS*
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
          }
        });
        // expr=ChoiceExpression
        expression.setExpr(ChoiceExpression().match(reader));
        // WS*
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
          }
        });
        // ')'
        T(")").match(reader);
      }
      // @formatter:on

      return expression;
    }

  }

}
