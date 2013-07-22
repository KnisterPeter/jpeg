package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Type;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;

/**
 * @author markusw
 */
public class WS implements Type {

  /** */
  public static class GrammarRule extends ParserRule<WS> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected WS consume(final InputReader reader) throws RuleMismatchException {
      // @formatter:off
      // ' ' | '\n' | '\t' | '\r'
      Choice(reader, new RuleCallback() {
        @Override
        public void run(final InputReader reader) throws RuleMismatchException {
          // ' '
          T(" ").match(reader);
        }
      }, new RuleCallback() {
        @Override
        public void run(final InputReader reader) throws RuleMismatchException {
          // '\n'
          T("\n").match(reader);
        }
      }, new RuleCallback() {
        @Override
        public void run(final InputReader reader) throws RuleMismatchException {
          // '\t'
          T("\t").match(reader);
        }
      }, new RuleCallback() {
        @Override
        public void run(final InputReader reader) throws RuleMismatchException {
          // '\r'
          T("\r").match(reader);
        }
      });
      // @formatter:on

      return new WS();
    }

    /**
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
      return "WS";
    }

  }

}
