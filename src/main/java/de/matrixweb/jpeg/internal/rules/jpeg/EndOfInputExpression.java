package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;

/**
 * @author markusw
 */
public class EndOfInputExpression extends Expression {

  /** */
  public static class GrammarRule extends ParserRule<Expression> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression consume(final InputReader reader)
        throws RuleMismatchException {
      // @formatter:off
      T("EOI").match(reader);
      // @formatter:on

      return new EndOfInputExpression();
    }

  }

}
