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
public class Comment implements Type<Comment> {

  /**
   * @see de.matrixweb.jpeg.internal.type.Type#copy()
   */
  @Override
  public Comment copy() {
    return new Comment();
  }

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
        ZeroOrMore(null, reader, new RuleCallback<Comment>() {
          @SuppressWarnings("rawtypes")
          @Override
          public Comment run(final Comment comment, final InputReader reader) throws RuleMismatchException {
            // !('\r'? '\n') .
            {
              // !('\r'? '\n')
              Not(reader, new RuleCallback() {
                @Override
                public Type run(final Type type, final InputReader reader) throws RuleMismatchException {
                  // '\r'? '\n'
                  {
                    // '\r'?
                    Optional(null, reader, new RuleCallback<Comment>() {
                      @Override
                      public Comment run(final Comment comment, final InputReader reader) throws RuleMismatchException {
                        // '\r'
                        T('\r').match(reader);
                        return comment;
                      }
                    });
                    // '\n'
                    T('\n').match(reader);
                  }
                  
                  return null;
                }
              });
              // .
              Any().match(reader);
            }
            return comment;
          }
        });
      }
      // @formatter:on

      return new Comment();
    }

  }

}
