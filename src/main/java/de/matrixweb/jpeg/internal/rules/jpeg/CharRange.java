package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;

/**
 * @author markusw
 */
public class CharRange extends Range {

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
  public static class GrammarRule extends ParserRule<Range> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#consume(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Range consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<String> _char = new Mutable<String>(new String());

      // @formatter:off
      // !'-' .
      {
        // !'-'
        Not(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // '-'
            T("-").match(reader);
          }
        });
        // .
        _char.getValue().add(Any().match(reader));
      }
      // @formatter:on

      final CharRange charrange = new CharRange();
      charrange.setChar(_char.getValue());
      return charrange;
    }

  }

}
