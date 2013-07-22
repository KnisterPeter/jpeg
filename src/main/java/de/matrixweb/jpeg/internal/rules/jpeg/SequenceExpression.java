package de.matrixweb.jpeg.internal.rules.jpeg;

import java.util.ArrayList;
import java.util.List;

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
public class SequenceExpression extends Expression {

  private List<Expression> expressions = new ArrayList<Expression>();

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
  public static class GrammarRule extends ParserRule<Expression> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<List<Expression>> expressions = new Mutable<List<Expression>>(
          new ArrayList<Expression>());

      // @formatter:off
      // (expressions+=(ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AtomicExpression) WS*)+
      OneOrMore(reader, new RuleCallback() {
        @Override
        public void run(final InputReader reader) throws RuleMismatchException {
          // expressions+=(ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AtomicExpression)
          Choice(reader, new RuleCallback() {
            @Override
            public void run(final InputReader reader) throws RuleMismatchException {
              // ActionExpression
              expressions.getValue().add(ActionExpression().match(reader));
            }
          }, new RuleCallback() {
            @Override
            public void run(final InputReader reader) throws RuleMismatchException {
              // AndPredicateExpression
              expressions.getValue().add(AndPredicateExpression().match(reader));
            }
          }, new RuleCallback() {
            @Override
            public void run(final InputReader reader) throws RuleMismatchException {
              // NotPredicateExpression
              expressions.getValue().add(NotPredicateExpression().match(reader));
            }
          }, new RuleCallback() {
            @Override
            public void run(final InputReader reader) throws RuleMismatchException {
              // OneOrMoreExpression
              expressions.getValue().add(OneOrMoreExpression().match(reader));
            }
          }, new RuleCallback() {
            @Override
            public void run(final InputReader reader) throws RuleMismatchException {
              // ZeroOrMoreExpression
              expressions.getValue().add(ZeroOrMoreExpression().match(reader));
            }
          }, new RuleCallback() {
            @Override
            public void run(final InputReader reader) throws RuleMismatchException {
              // OptionalExpression
              expressions.getValue().add(OptionalExpression().match(reader));
            }
          }, new RuleCallback() {
            @Override
            public void run(final InputReader reader) throws RuleMismatchException {
              // AtomicExpression
              expressions.getValue().add(AtomicExpression().match(reader));
            }
          });
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

      final SequenceExpression expression = new SequenceExpression();
      expression.setExpressions(expressions.getValue());
      return expression;
    }
  }

}
