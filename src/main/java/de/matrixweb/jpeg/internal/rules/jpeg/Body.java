package de.matrixweb.jpeg.internal.rules.jpeg;

import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Type;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class Body implements Type {

  private List<Expression> expressions;

  /**
   * @return the expressions
   */
  public List<Expression> getExpressions() {
    return this.expressions;
  }

  /**
   * @param expressions
   *          the expressions to set
   */
  public void setExpressions(final List<Expression> expressions) {
    this.expressions = expressions;
  }

  /** */
  public static class GrammarRule extends ParserRule<Body> {

    private final List<Expression> expressions = new ArrayList<Expression>();

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Body consume(final InputReader reader)
        throws RuleMismatchException {
      // @formatter:off
      // (expressions+=ChoiceExpression WS*)+
      OneOrMore(reader, new RuleCallback() {
        @Override
        public void run(final InputReader reader) throws RuleMismatchException {
          // expressions+=ChoiceExpression
          GrammarRule.this.expressions.add(ChoiceExpression().match(reader));
          // WS*
          ZeroOrMore(reader, new RuleCallback() {
            @Override
            public void run(final InputReader reader) throws RuleMismatchException {
              // WS
              WS().match(reader);
            }
          });
        }
      });
      // @formatter:on

      final Body body = new Body();
      body.setExpressions(this.expressions);
      return body;
    }

  }

}
