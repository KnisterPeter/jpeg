package de.matrixweb.jpeg.internal.rules.jpeg;

import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class ChoiceExpression extends Expression<ChoiceExpression> {

  private List<Expression<?>> choices = new ArrayList<Expression<?>>();

  /**
   * @see de.matrixweb.jpeg.internal.type.Type#copy()
   */
  @Override
  public ChoiceExpression copy() {
    final ChoiceExpression copy = new ChoiceExpression();
    for (final Expression<?> expression : this.choices) {
      copy.choices.add(expression.copy());
    }
    return copy;
  }

  /**
   * @return the choices
   */
  public List<Expression<?>> getChoices() {
    return this.choices;
  }

  /**
   * @param choices
   *          the choices to set
   */
  public void setChoices(final List<Expression<?>> choices) {
    this.choices = choices;
  }

  /** */
  public static class GrammarRule extends ParserRule<Expression<?>> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression<?> consume(final InputReader reader)
        throws RuleMismatchException {
      ChoiceExpression expression = new ChoiceExpression();

      // @formatter:off
      // choices+=SequenceExpression ('|' WS* choices+=SequenceExpression)*
      {
        // choices+=SequenceExpression 
        expression.getChoices().add(SequenceExpression().match(reader));
        // ('|' WS* choices+=SequenceExpression)*
        expression = ZeroOrMore(expression, reader, new RuleCallback<ChoiceExpression>() {
          @Override
          public ChoiceExpression run(final ChoiceExpression expression, final InputReader reader) throws RuleMismatchException {
            // '|'
            T("|").match(reader);
            // WS*
            ZeroOrMore(null, reader, new RuleCallback<WS>() {
              @Override
              public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
                // WS
                return WS().match(reader);
              }
            });
            // choices+=SequenceExpression
            expression.getChoices().add(SequenceExpression().match(reader));
            
            return expression;
          }
        });
      }
      // @formatter:on

      return expression;
    }

  }

}
