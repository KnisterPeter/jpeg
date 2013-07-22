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
public class InTerminalChar implements Type<InTerminalChar> {

  /**
   * @see de.matrixweb.jpeg.internal.type.Type#copy()
   */
  @Override
  public InTerminalChar copy() {
    return new InTerminalChar();
  }

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
      // ('\\' '\'' | '\\' '\\' | !'\'' .)+
      string = OneOrMore(string, reader, new RuleCallback<String>() {
        @SuppressWarnings("unchecked")
        @Override
        public String run(String string, final InputReader reader) throws RuleMismatchException {
          // '\\' '\'' | '\\' '\\' | !'\'' .
          string = Choice(string, reader, new RuleCallback<String>() {
            @Override
            public String run(final String string, final InputReader reader) throws RuleMismatchException {
              // '\\' 
              string.add(T("\\").match(reader));
              // '\''
              string.add(T("'").match(reader));
              
              return string;
            }
          }, new RuleCallback<String>() {
            @Override
            public String run(final String string, final InputReader reader) throws RuleMismatchException {
              // '\\'
              string.add(T("\\").match(reader));
              // '\\'
              string.add(T("\\").match(reader));
              
              return string;
            }
          }, new RuleCallback<String>() {
            @SuppressWarnings("rawtypes")
            @Override
            public String run(final String string, final InputReader reader) throws RuleMismatchException {
              // !'\''
              Not(reader, new RuleCallback() {
                @Override
                public Type run(final Type type, final InputReader reader) throws RuleMismatchException {
                  // '\''
                  return T("'").match(reader);
                }
              });
              // .
              string.add(Any().match(reader));
              
              return string;
            }
          });
          
          return string;
        }
      });
      // @formatter:on

      return string;
    }
  }

}
