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
public class ZeroOrMoreExpression extends Expression<ZeroOrMoreExpression> {

  private Expression<?> expr;

  /**
   * @see de.matrixweb.jpeg.internal.rules.jpeg.Expression#copy()
   */
  @Override
  public ZeroOrMoreExpression copy() {
    final ZeroOrMoreExpression copy = new ZeroOrMoreExpression();
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

    @Override
    protected Expression<?> consume(final InputReader reader)
        throws RuleMismatchException {
      final ZeroOrMoreExpression expression = new ZeroOrMoreExpression();

      // @formatter:off
      // expr=AtomicExpression WS* '*'
      {
        // expr=AtomicExpression
        expression.setExpr(AtomicExpression().match(reader));
        // WS*
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
          }
        });
        // '*'
        T("*").match(reader);
      }
      // @formatter:on

      return expression;
    }

  }

}
