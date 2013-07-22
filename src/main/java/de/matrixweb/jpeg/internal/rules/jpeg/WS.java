package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;
import de.matrixweb.jpeg.internal.type.Type;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;

/**
 * @author markusw
 */
public class WS implements Type<WS> {

  private String _char;

  /**
   * @see de.matrixweb.jpeg.internal.type.Type#copy()
   */
  @Override
  public WS copy() {
    final WS copy = new WS();
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
  public static class GrammarRule extends ParserRule<WS> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @SuppressWarnings("unchecked")
    @Override
    protected WS consume(final InputReader reader) throws RuleMismatchException {
      final WS ws = new WS();

      // @formatter:off
      // char=(' ' | '\n' | '\t' | '\r')
      ws.setChar(Choice(new String(), reader, new RuleCallback<String>() {
        @Override
        public String run(final String string, final InputReader reader) throws RuleMismatchException {
          // ' '
          return T(" ").match(reader);
        }
      }, new RuleCallback<String>() {
        @Override
        public String run(final String string, final InputReader reader) throws RuleMismatchException {
          // '\n'
          return T("\n").match(reader);
        }
      }, new RuleCallback<String>() {
        @Override
        public String run(final String string, final InputReader reader) throws RuleMismatchException {
          // '\t'
          return T("\t").match(reader);
        }
      }, new RuleCallback<String>() {
        @Override
        public String run(final String string, final InputReader reader) throws RuleMismatchException {
          // '\r'
          return T("\r").match(reader);
        }
      }));
      // @formatter:on

      return ws;
    }

    /**
     * @see java.lang.Object#toString()
     */
    @Override
    public java.lang.String toString() {
      return "WS";
    }

  }

}
