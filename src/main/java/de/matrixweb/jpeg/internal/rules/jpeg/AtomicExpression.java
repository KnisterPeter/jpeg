package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class AtomicExpression extends Expression {

  /** */
  public static class GrammarRule extends ParserRule<Expression> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<Expression> expression = new Mutable<Expression>();

      // @formatter:off
      // EndOfInputExpression | AssignableExpression
      Choice(reader, new RuleCallback() {
        @Override
        public void run(final InputReader reader) throws RuleMismatchException {
          // EndOfInputExpression
          expression.setValue(EndOfInputExpression().match(reader));
        }
      }, new RuleCallback() {
        @Override
        public void run(final InputReader reader) throws RuleMismatchException {
          // AssignableExpression
          expression.setValue(AssignableExpression().match(reader));
        }
      });
      // @formatter:on

      return expression.getValue();
    }

  }

}
