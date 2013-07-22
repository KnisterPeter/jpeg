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
public class Body implements Type<Body> {

  private List<Expression<?>> expressions = new ArrayList<Expression<?>>();

  /**
   * @see de.matrixweb.jpeg.internal.type.Type#copy()
   */
  @Override
  public Body copy() {
    final Body copy = new Body();
    for (final Expression<?> expression : this.expressions) {
      copy.expressions.add(expression.copy());
    }
    return copy;
  }

  /**
   * @return the expressions
   */
  public List<Expression<?>> getExpressions() {
    return this.expressions;
  }

  /**
   * @param expressions
   *          the expressions to set
   */
  public void setExpressions(final List<Expression<?>> expressions) {
    this.expressions = expressions;
  }

  /** */
  public static class GrammarRule extends ParserRule<Body> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Body consume(final InputReader reader)
        throws RuleMismatchException {
      Body body = new Body();

      // @formatter:off
      // (expressions+=ChoiceExpression WS*)+
      body = OneOrMore(body, reader, new RuleCallback<Body>() {
        @Override
        public Body run(final Body body, final InputReader reader) throws RuleMismatchException {
          // expressions+=ChoiceExpression
          body.getExpressions().add(ChoiceExpression().match(reader));
          // WS*
          ZeroOrMore(null, reader, new RuleCallback<WS>() {
            @Override
            public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
              // WS
              return WS().match(reader);
            }
          });
          return body;
        }
      });
      // @formatter:on

      return body;
    }

  }

}
