package de.matrixweb.jpeg.internal.rules.jpeg;

import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class ChoiceExpression extends Expression {

  private List<Expression> choices;

  /**
   * 
   */
  public ChoiceExpression() {
  }

  /**
   * @param choices
   */
  public ChoiceExpression(final List<Expression> choices) {
    this.choices = choices;
  }

  /**
   * @return the choices
   */
  public List<Expression> getChoices() {
    return this.choices;
  }

  /**
   * @param choices
   *          the choices to set
   */
  public void setChoices(final List<Expression> choices) {
    this.choices = choices;
  }

  /** */
  public static class GrammarRule extends ParserRule<Expression> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<List<Expression>> choices = new Mutable<List<Expression>>(
          new ArrayList<Expression>());

      // @formatter:off
      // choices+=SequenceExpression ('|' WS* choices+=SequenceExpression)*
      {
        // choices+=SequenceExpression 
        choices.getValue().add(SequenceExpression().match(reader));
        // ({choices+=current} ('|' WS* choices+=SequenceExpression)*)?
        // ('|' WS* choices+=SequenceExpression)*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // '|'
            T("|").match(reader);
            // WS*
            ZeroOrMore(reader, new RuleCallback() {
              @Override
              public void run(final InputReader reader) throws RuleMismatchException {
                // WS
                WS().match(reader);
              }
            });
            // choices+=SequenceExpression
            choices.getValue().add(SequenceExpression().match(reader));
          }
        });
      }
      // @formatter:on

      final ChoiceExpression expression = new ChoiceExpression();
      expression.setChoices(choices.getValue());
      return expression;
    }

  }

}
