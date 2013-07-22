package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;

/**
 * @author markusw
 */
public class AnyCharExpression extends Expression {

  private String _char;

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
  public static class GrammarRule extends ParserRule<Expression> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Expression consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<String> _char = new Mutable<String>(new String());

      // @formatter:off
      _char.getValue().add(T('.').match(reader));
      // @formatter:on

      final AnyCharExpression expression = new AnyCharExpression();
      expression.setChar(_char.getValue());
      return expression;
    }

  }

}
