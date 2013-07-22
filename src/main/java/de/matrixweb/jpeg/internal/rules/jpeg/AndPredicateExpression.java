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
public class AndPredicateExpression extends Expression<AndPredicateExpression> {

  private Expression<?> expr;

  /**
   * @see de.matrixweb.jpeg.internal.rules.jpeg.Expression#copy()
   */
  @Override
  public AndPredicateExpression copy() {
    final AndPredicateExpression copy = new AndPredicateExpression();
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
      final AndPredicateExpression expression = new AndPredicateExpression();

      // @formatter:off
      // '&' WS* expr=AtomicExpression
      {
        // '&'
        T("&").match(reader);
        // WS*
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
          }
        });
        // expr=AtomicExpression
        expression.setExpr(AtomicExpression().match(reader));
      }
      // @formatter:on

      return expression;
    }

  }

}
