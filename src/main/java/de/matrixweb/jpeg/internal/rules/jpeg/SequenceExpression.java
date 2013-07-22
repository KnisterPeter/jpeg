package de.matrixweb.jpeg.internal.rules.jpeg;

import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class SequenceExpression extends Expression<SequenceExpression> {

  private List<Expression<?>> expressions = new ArrayList<Expression<?>>();

  /**
   * @see de.matrixweb.jpeg.internal.rules.jpeg.Expression#copy()
   */
  @Override
  public SequenceExpression copy() {
    final SequenceExpression copy = new SequenceExpression();
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
  public static class GrammarRule extends ParserRule<Expression<?>> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Override
    protected Expression<?> consume(final InputReader reader)
        throws RuleMismatchException {
      SequenceExpression expression = new SequenceExpression();

      // @formatter:off
      // (expressions+=(ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AtomicExpression) WS*)+
      expression = OneOrMore(expression, reader, new RuleCallback<SequenceExpression>() {
        @Override
        public SequenceExpression run(final SequenceExpression expression, final InputReader reader) throws RuleMismatchException {
          // expressions+=(ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AtomicExpression)
          expression.getExpressions().add(Choice(null, reader, new RuleCallback<Expression>() {
            @Override
            public Expression run(final Expression expression, final InputReader reader) throws RuleMismatchException {
              // ActionExpression
              return ActionExpression().match(reader);
            }
          }, new RuleCallback<Expression>() {
            @Override
            public Expression run(final Expression expression, final InputReader reader) throws RuleMismatchException {
              // AndPredicateExpression
              return AndPredicateExpression().match(reader);
            }
          }, new RuleCallback<Expression>() {
            @Override
            public Expression run(final Expression expression, final InputReader reader) throws RuleMismatchException {
              // NotPredicateExpression
              return NotPredicateExpression().match(reader);
            }
          }, new RuleCallback<Expression>() {
            @Override
            public Expression run(final Expression expression, final InputReader reader) throws RuleMismatchException {
              // OneOrMoreExpression
              return OneOrMoreExpression().match(reader);
            }
          }, new RuleCallback<Expression>() {
            @Override
            public Expression run(final Expression expression, final InputReader reader) throws RuleMismatchException {
              // ZeroOrMoreExpression
              return ZeroOrMoreExpression().match(reader);
            }
          }, new RuleCallback<Expression>() {
            @Override
            public Expression run(final Expression expression, final InputReader reader) throws RuleMismatchException {
              // OptionalExpression
              return OptionalExpression().match(reader);
            }
          }, new RuleCallback<Expression>() {
            @Override
            public Expression run(final Expression expression, final InputReader reader) throws RuleMismatchException {
              // AtomicExpression
              return AtomicExpression().match(reader);
            }
          }));
          // WS*
          ZeroOrMore(null, reader, new RuleCallback<WS>() {
            @Override
            public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
              // WS
              return WS().match(reader);
            }
          });
          
          return expression;
        }
      });
      // @formatter:on

      return expression;
    }
  }

}
