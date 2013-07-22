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
public class TerminalExpression extends Expression {

  private String value;

  /**
   * @return the value
   */
  public String getValue() {
    return this.value;
  }

  /**
   * @param value
   *          the value to set
   */
  public void setValue(final String value) {
    this.value = value;
  }

  /** */
  public static class GrammarRule extends ParserRule<Expression> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<String> value = new Mutable<String>(new String());

      // @formatter:off
      // '\'' value=InTerminalChar? '\''
      {
        // '\''
        T("'").match(reader);
        // InTerminalChar?
        Optional(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // InTerminalChar
            value.getValue().add(InTerminalChar().match(reader));
          }
        });
        // '\''
        T("'").match(reader);
      }
      // @formatter:on

      final TerminalExpression expression = new TerminalExpression();
      expression.setValue(value.getValue());
      return expression;
    }

  }

}
