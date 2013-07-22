package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class AssignableExpression extends Expression {

  private String property;

  private AssignmentOperator op;

  private Expression expr;

  /**
   * @return the property
   */
  public String getProperty() {
    return this.property;
  }

  /**
   * @param property
   *          the property to set
   */
  public void setProperty(final String property) {
    this.property = property;
  }

  /**
   * @return the op
   */
  public AssignmentOperator getOp() {
    return this.op;
  }

  /**
   * @param op
   *          the op to set
   */
  public void setOp(final AssignmentOperator op) {
    this.op = op;
  }

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
      // FIXME: This should include 'new String()' in the normal pattern
      final Mutable<String> property = new Mutable<String>();
      final Mutable<AssignmentOperator> op = new Mutable<AssignmentOperator>();
      final Mutable<Expression> expr = new Mutable<Expression>();

      // @formatter:off
      // (property=ID WS* op=('='|'+=') WS*)? expr=( SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression)
      {
        // (property=ID WS* op=('='|'+=') WS*)?
        Optional(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            final Mutable<String> property0 = new Mutable<String>(new String());
            final Mutable<AssignmentOperator> op0 = new Mutable<AssignmentOperator>();

            // property=ID 
            property0.getValue().add(ID().match(reader));
            // WS*
            ZeroOrMore(reader, new RuleCallback() {
              @Override
              public void run(final InputReader reader) throws RuleMismatchException {
                // WS
                WS().match(reader);
              }
            });
            // op=AssignmentOperator
            op0.setValue(AssignmentOperator().match(reader));
            // WS*
            ZeroOrMore(reader, new RuleCallback() {
              @Override
              public void run(final InputReader reader) throws RuleMismatchException {
                // WS
                WS().match(reader);
              }
            });
            
            property.setValue(property0.getValue());
            op.setValue(op0.getValue());
          }
        });
        // expr=(SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression)
        Choice(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // SubExpression
            expr.setValue(SubExpression().match(reader));
          }
        }, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // RangeExpression
            expr.setValue(RangeExpression().match(reader));
          }
        }, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // TerminalExpression
            expr.setValue(TerminalExpression().match(reader));
          }
        }, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // AnyCharExpression
            expr.setValue(AnyCharExpression().match(reader));
          }
        }, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // RuleReferenceExpression
            expr.setValue(RuleReferenceExpression().match(reader));
          }
        });
      }
      // @formatter:on

      final AssignableExpression assignableExpression = new AssignableExpression();
      assignableExpression.setProperty(property.getValue());
      assignableExpression.setOp(op.getValue());
      assignableExpression.setExpr(expr.getValue());
      return assignableExpression;
    }

  }

}
