package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import de.matrixweb.jpeg.internal.type.String;
import de.matrixweb.jpeg.internal.type.Type;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;

/**
 * @author markusw
 */
public class InTerminalChar implements Type {

  /** */
  public static class GrammarRule extends ParserRule<String> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected String consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<String> value = new Mutable<String>(new String());

      // @formatter:off
      // ('\\' '\'' | '\\' '\\' | !'\'' .)+
      OneOrMore(reader, new RuleCallback() {
        @Override
        public void run(final InputReader reader) throws RuleMismatchException {
          // '\\' '\'' | '\\' '\\' | !'\'' .
          Choice(reader, new RuleCallback() {
            @Override
            public void run(final InputReader reader) throws RuleMismatchException {
              final Mutable<String> value0 = new Mutable<String>(new String());
              
              // '\\' 
              value0.getValue().add(T("\\").match(reader));
              // '\''
              value0.getValue().add(T("'").match(reader));
              
              value.getValue().add(value0.getValue());
            }
          }, new RuleCallback() {
            @Override
            public void run(final InputReader reader) throws RuleMismatchException {
              final Mutable<String> value0 = new Mutable<String>(new String());
              
              // '\\'
              value0.getValue().add(T("\\").match(reader));
              // '\\'
              value0.getValue().add(T("\\").match(reader));
              
              value.getValue().add(value0.getValue());
            }
          }, new RuleCallback() {
            @Override
            public void run(final InputReader reader) throws RuleMismatchException {
              final Mutable<String> value0 = new Mutable<String>(new String());
              
              // !'\''
              Not(reader, new RuleCallback() {
                @Override
                public void run(final InputReader reader) throws RuleMismatchException {
                  // '\''
                  T("'").match(reader);
                }
              });
              // .
              value0.getValue().add(Any().match(reader));
              
              value.getValue().add(value0.getValue());
            }
          });
        }
      });
      // @formatter:on

      final String string = new String();
      string.setValue(value.getValue());
      return string;
    }
  }

}
