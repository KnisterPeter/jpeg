package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class ActionExpression extends Expression<ActionExpression> {

  private String property;

  private AssignmentOperator op;

  private String name;

  /**
   * @see de.matrixweb.jpeg.internal.rules.jpeg.Expression#copy()
   */
  @Override
  public ActionExpression copy() {
    final ActionExpression copy = new ActionExpression();
    copy.property = this.property.copy();
    copy.op = this.op.copy();
    copy.name = this.name.copy();
    return copy;
  }

  /**
   * @return the name
   */
  public String getName() {
    return this.name;
  }

  /**
   * @param name
   *          the name to set
   */
  public void setName(final String name) {
    this.name = name;
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

  /** */
  public static class GrammarRule extends ParserRule<Expression<?>> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @SuppressWarnings("unchecked")
    @Override
    protected Expression<?> consume(final InputReader reader)
        throws RuleMismatchException {
      ActionExpression expression = new ActionExpression();

      // @formatter:off
      // '{' WS* (property=ID WS* op=('='|'+=') WS* 'current' WS* | name=FQTN) WS* '}'
      {
        // '{'
        T("{").match(reader);
        // WS*
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
          }
        });
        // (property=ID WS* op=('='|'+=') WS* 'current' WS* | name=FQTN)
        expression = Choice(expression, reader, new RuleCallback<ActionExpression>() {
          @Override
          public ActionExpression run(final ActionExpression expression, final InputReader reader) throws RuleMismatchException {
            
            // property=ID WS* op=('='|'+=') WS* 'current' WS*
            {
              // property=ID 
              expression.setProperty(ID().match(reader));
              // WS*
              ZeroOrMore(null, reader, new RuleCallback<WS>() {
                @Override
                public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
                  // WS
                  return WS().match(reader);
                }
              });
              // op=AssignmentOperator
              expression.setOp(AssignmentOperator().match(reader));
              // WS*
              ZeroOrMore(null, reader, new RuleCallback<WS>() {
                @Override
                public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
                  // WS
                  return WS().match(reader);
                }
              });
              // 'current' 
              T("current").match(reader);
              // WS*
              ZeroOrMore(null, reader, new RuleCallback<WS>() {
                @Override
                public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
                  // WS
                  return WS().match(reader);
                }
              });
              
            }
            return expression;
          }
        }, new RuleCallback<ActionExpression>() {
          @Override
          public ActionExpression run(final ActionExpression expression, final InputReader reader) throws RuleMismatchException {
            // name=FQTN
            expression.setName(FQTN().match(reader));
            return expression;
          }
        });
        // WS*
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
          }
        });
        // '}'
        T("}").match(reader);
      }
      // @formatter:on

      return expression;
    }
  }

}
