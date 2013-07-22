package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class RuleReferenceExpression extends
    Expression<RuleReferenceExpression> {

  private String name;

  /**
   * @see de.matrixweb.jpeg.internal.rules.jpeg.Expression#copy()
   */
  @Override
  public RuleReferenceExpression copy() {
    final RuleReferenceExpression copy = new RuleReferenceExpression();
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

  /** */
  public static class GrammarRule extends ParserRule<Expression<?>> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression<?> consume(final InputReader reader)
        throws RuleMismatchException {
      final RuleReferenceExpression expression = new RuleReferenceExpression();

      // @formatter:off
      // name=ID
      expression.setName(ID().match(reader));
      // @formatter:on

      return expression;
    }

  }

}
