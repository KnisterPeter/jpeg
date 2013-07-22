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
public class CharRange extends Range {

  /** */
  public static class GrammarRule extends ParserRule<Range> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#consume(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @SuppressWarnings("rawtypes")
    @Override
    protected Range consume(final InputReader reader)
        throws RuleMismatchException {
      final Range range = new Range();

      // @formatter:off
      // !'-' .
      {
        // !'-'
        Not(reader, new RuleCallback() {
          @Override
          public Type run(final Type t, final InputReader reader) throws RuleMismatchException {
            // '-'
            return T("-").match(reader);
          }
        });
        // .
        range.setChar(Any().match(reader));
      }
      // @formatter:on

      return range;
    }

  }

}
