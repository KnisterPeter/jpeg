package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;

/**
 * @author markusw
 */
public class AnyCharExpression extends Expression<AnyCharExpression> {

  private String _char;

  /**
   * @see de.matrixweb.jpeg.internal.rules.jpeg.Expression#copy()
   */
  @Override
  public AnyCharExpression copy() {
    final AnyCharExpression copy = new AnyCharExpression();
    copy._char = this._char.copy();
    return copy;
  }

  /**
   * @return the _char
   */
  public String getChar() {
    return this._char;
  }

  /**
   * @param _char
   *          the _char to set
   */
  public void setChar(final String _char) {
    this._char = _char;
  }

  /** */
  public static class GrammarRule extends ParserRule<Expression<?>> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression<?> consume(final InputReader reader)
        throws RuleMismatchException {
      final AnyCharExpression expression = new AnyCharExpression();

      // @formatter:off
      // char='.'
      expression.setChar(T('.').match(reader));
      // @formatter:on

      return expression;
    }

  }

}
