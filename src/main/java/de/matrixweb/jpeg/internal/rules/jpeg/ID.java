package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;

/**
 * @author markusw
 */
public class ID extends String {

  /** */
  public static class GrammarRule extends ParserRule<String> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected String consume(final InputReader reader)
        throws RuleMismatchException {
      String string = new String();

      // @formatter:off
      // [a-zA-Z_]([a-zA-Z0-9_])*
      {
        // [a-zA-Z_]
        string.add(Char("[a-zA-Z_]").match(reader));
        // ([a-zA-Z0-9_])*
        string = ZeroOrMore(string, reader, new RuleCallback<String>() {
          @Override
          public String run(final String string, final InputReader reader) throws RuleMismatchException {
            // [a-zA-Z0-9_]
            string.add(Char("[a-zA-Z0-9_]").match(reader));
            return string;
          }
        });
      }
      // @formatter:on

      return string;
    }

  }

}
