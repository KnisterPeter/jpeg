package de.matrixweb.jpeg.internal.rules.jpeg;

import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import de.matrixweb.jpeg.internal.type.Type;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class JPEG implements Type {

  private List<Rule> rules;

  /**
   * @return the rules
   */
  public List<Rule> getRules() {
    return this.rules;
  }

  /**
   * @param rules
   *          the rules to set
   */
  public void setRules(final List<Rule> rules) {
    this.rules = rules;
  }

  /** */
  public static class GrammarRule extends ParserRule<JPEG> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected JPEG consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<List<Rule>> rules = new Mutable<List<Rule>>(
          new ArrayList<Rule>());

      // @formatter:off
      // (rules+=Matcher | Comment WS*)+ EOI
      {
        // (rules+=Matcher | Comment WS*)+
        OneOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // rules+=Matcher | Comment WS*
            {
              final int mark = reader.mark();
              try {
                // rules+=Matcher
                rules.getValue().add(Rule().match(reader));
              } catch (final RuleMismatchException e) {
                reader.reset(mark);
                // Comment
                Comment().match(reader);
                // WS*
                ZeroOrMore(reader, new RuleCallback() {
                  @Override
                  public void run(final InputReader reader) throws RuleMismatchException {
                    // WS
                    WS().match(reader);
                  }
                });
              }
            }
          }
        });
        // EOI
        EOI().match(reader);
      }
      // @formatter:on

      final JPEG jpeg = new JPEG();
      jpeg.setRules(rules.getValue());
      return jpeg;
    }

  }

}
