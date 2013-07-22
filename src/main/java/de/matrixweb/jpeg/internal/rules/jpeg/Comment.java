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
public class Comment implements Type {

  /** */
  public static class GrammarRule extends ParserRule<Comment> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Comment consume(final InputReader reader)
        throws RuleMismatchException {
      // @formatter:off
      // '//' (!('\r'? '\n') .)*
      {
        // '//'
        T("//").match(reader);
        // (!('\r'? '\n') .)*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // !('\r'? '\n') .
            {
              // !('\r'? '\n')
              Not(reader, new RuleCallback() {
                @Override
                public void run(final InputReader reader) throws RuleMismatchException {
                  // '\r'? '\n'
                  {
                    // '\r'?
                    Optional(reader, new RuleCallback() {
                      @Override
                      public void run(final InputReader reader) throws RuleMismatchException {
                        // '\r'
                        T('\r').match(reader);
                      }
                    });
                    // '\n'
                    T('\n').match(reader);
                  }
                }
              });
              // .
              Any().match(reader);
            }
          }
        });
      }
      // @formatter:on

      return new Comment();
    }

  }

}
