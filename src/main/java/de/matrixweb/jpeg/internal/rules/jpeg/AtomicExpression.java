package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class AtomicExpression extends Expression<AtomicExpression> {

  /**
   * @see de.matrixweb.jpeg.internal.rules.jpeg.Expression#copy()
   */
  @Override
  public AtomicExpression copy() {
    return new AtomicExpression();
  }

  /** */
  public static class GrammarRule extends ParserRule<Expression<?>> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Override
    protected Expression<?> consume(final InputReader reader)
        throws RuleMismatchException {
      Expression expression = null;

      // @formatter:off
      // EndOfInputExpression | AssignableExpression
      expression = Choice(expression, reader, new RuleCallback<Expression>() {
        @Override
        public Expression run(final Expression expression, final InputReader reader) throws RuleMismatchException {
          // EndOfInputExpression
          return EndOfInputExpression().match(reader);
        }
      }, new RuleCallback<Expression>() {
        @Override
        public Expression run(final Expression expression, final InputReader reader) throws RuleMismatchException {
          // AssignableExpression
          return AssignableExpression().match(reader);
        }
      });
      // @formatter:on

      return expression;
    }

  }

}
