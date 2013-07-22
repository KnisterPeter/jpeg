package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class AssignableExpression extends Expression<AssignableExpression> {

  private String property;

  private AssignmentOperator op;

  private Expression<?> expr;

  /**
   * @see de.matrixweb.jpeg.internal.rules.jpeg.Expression#copy()
   */
  @Override
  public AssignableExpression copy() {
    final AssignableExpression copy = new AssignableExpression();
    copy.property = this.property != null ? this.property.copy() : null;
    copy.op = this.op != null ? this.op.copy() : null;
    copy.expr = this.expr != null ? this.expr.copy() : null;
    return copy;
  }

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

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    @Override
    protected Expression<?> consume(final InputReader reader)
        throws RuleMismatchException {
      AssignableExpression assignableExpression = new AssignableExpression();

      // @formatter:off
      // (property=ID WS* op=('='|'+=') WS*)? expr=( SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression)
      {
        // (property=ID WS* op=('='|'+=') WS*)?
        assignableExpression = Optional(assignableExpression, reader, new RuleCallback<AssignableExpression>() {
          @Override
          public AssignableExpression run(final AssignableExpression assignableExpression, final InputReader reader) throws RuleMismatchException {
            // property=ID 
            assignableExpression.setProperty(ID().match(reader));
            // WS*
            ZeroOrMore(null, reader, new RuleCallback<WS>() {
              @Override
              public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
                // WS
                return WS().match(reader);
              }
            });
            // op=AssignmentOperator
            assignableExpression.setOp(AssignmentOperator().match(reader));
            // WS*
            ZeroOrMore(null, reader, new RuleCallback<WS>() {
              @Override
              public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
                // WS
                return WS().match(reader);
              }
            });
            
            return assignableExpression;
          }
        });
        // expr=(SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression)
        assignableExpression.setExpr(Choice(null, reader, new RuleCallback<Expression>() {
          @Override
          public Expression run(final Expression expr, final InputReader reader) throws RuleMismatchException {
            // SubExpression
            return SubExpression().match(reader);
          }
        }, new RuleCallback<Expression>() {
          @Override
          public Expression run(final Expression expr, final InputReader reader) throws RuleMismatchException {
            // RangeExpression
            return RangeExpression().match(reader);
          }
        }, new RuleCallback<Expression>() {
          @Override
          public Expression run(final Expression expr, final InputReader reader) throws RuleMismatchException {
            // TerminalExpression
            return TerminalExpression().match(reader);
          }
        }, new RuleCallback<Expression>() {
          @Override
          public Expression run(final Expression expr, final InputReader reader) throws RuleMismatchException {
            // AnyCharExpression
            return AnyCharExpression().match(reader);
          }
        }, new RuleCallback<Expression>() {
          @Override
          public Expression run(final Expression expr, final InputReader reader) throws RuleMismatchException {
            // RuleReferenceExpression
            return RuleReferenceExpression().match(reader);
          }
        }));
      }
      // @formatter:on

      return assignableExpression;
    }

  }

}
