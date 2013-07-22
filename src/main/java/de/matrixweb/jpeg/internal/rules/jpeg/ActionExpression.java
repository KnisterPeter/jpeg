package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class ActionExpression extends Expression {

  private String property;

  private AssignmentOperator op;

  private String name;

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
  public static class GrammarRule extends ParserRule<Expression> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<String> property = new Mutable<String>(new String());
      final Mutable<AssignmentOperator> op = new Mutable<AssignmentOperator>();
      final Mutable<String> name = new Mutable<String>(new String());

      // @formatter:off
      // '{' WS* (property=ID WS* op=('='|'+=') WS* 'current' WS* | name=FQTN) WS* '}'
      {
        // '{'
        T("{").match(reader);
        // WS*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // WS
            WS().match(reader);
          }
        });
        // (property=ID WS* op=('='|'+=') WS* 'current' WS* | name=FQTN)
        Choice(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            final Mutable<String> property0 = new Mutable<String>(new String());
            final Mutable<AssignmentOperator> op0 = new Mutable<AssignmentOperator>();
            
            // property=ID WS* op=('='|'+=') WS* 'current' WS*
            {
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
              // 'current' 
              T("current").match(reader);
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
          }
        }, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // name=FQTN
            name.getValue().add(FQTN().match(reader));
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
        // '}'
        T("}").match(reader);
      }
      // @formatter:on

      final ActionExpression expression = new ActionExpression();
      expression.setProperty(property.getValue());
      expression.setOp(op.getValue());
      expression.setName(name.getValue());
      return expression;
    }
  }

}
