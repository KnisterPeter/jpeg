package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
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
      final Mutable<String> value = new Mutable<String>(new String());

      // @formatter:off
      // ID ('.' ID)*
      {
        // ID
        value.getValue().add(ID().match(reader));
        // ('.' ID)*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            final Mutable<String> value0 = new Mutable<String>(new String());
            
            // '.' ID
            value0.getValue().add(T('.').match(reader));
            // ID
            value0.getValue().add(ID().match(reader));
            
            value.getValue().add(value0.getValue());
          }
        });
      }
      // @formatter:on

      final String string = new String();
      string.setValue(value.getValue());
      return string;
    }

  }

}
