package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class FQTN extends String {

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
      // ID ('.' ID)*
      {
        // ID
        string.add(ID().match(reader));
        // ('.' ID)*
        string = ZeroOrMore(string, reader, new RuleCallback<String>() {
          @Override
          public String run(final String string, final InputReader reader) throws RuleMismatchException {
            
            // '.' ID
            string.add(T('.').match(reader));
            // ID
            string.add(ID().match(reader));
            
            return string;
          }
        });
      }
      // @formatter:on

      return string;
    }

  }

}
