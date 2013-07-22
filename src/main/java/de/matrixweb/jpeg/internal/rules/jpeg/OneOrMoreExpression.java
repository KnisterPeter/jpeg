package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class OneOrMoreExpression extends Expression {

  private Expression expr;

  /**
   * @return the expr
   */
  public Expression getExpr() {
    return this.expr;
  }

  /**
   * @param expr
   *          the expr to set
   */
  public void setExpr(final Expression expr) {
    this.expr = expr;
  }

  /** */
  public static class GrammarRule extends ParserRule<Expression> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<Expression> expr = new Mutable<Expression>();

      // @formatter:off
      // expr=AtomicExpression WS* '+'
      {
        // expr=AtomicExpression
        expr.setValue(AtomicExpression().match(reader));
        // WS*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // WS
            WS().match(reader);
          }
        });
        // '+'
        T("+").match(reader);
      }
      // @formatter:on

      final OneOrMoreExpression expression = new OneOrMoreExpression();
      expression.setExpr(expr.getValue());
      return expression;
    }

  }

}
