package de.matrixweb.jpeg.internal.rules.jpeg;

import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Type;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class JPEG implements Type<JPEG> {

  private List<Rule> rules = new ArrayList<Rule>();

  /**
   * @see de.matrixweb.jpeg.internal.type.Type#copy()
   */
  @Override
  public JPEG copy() {
    final JPEG copy = new JPEG();
    for (final Rule rule : this.rules) {
      copy.rules.add(rule);
    }
    return copy;
  }

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
      JPEG jpeg = new JPEG();

      // @formatter:off
      // (rules+=Matcher | Comment WS*)+ EOI
      {
        // (rules+=Matcher | Comment WS*)+
        jpeg = OneOrMore(jpeg, reader, new RuleCallback<JPEG>() {
          @SuppressWarnings("unchecked")
          @Override
          public JPEG run(JPEG jpeg, final InputReader reader) throws RuleMismatchException {
            // rules+=Matcher | Comment WS*
            jpeg = Choice(jpeg, reader, new RuleCallback<JPEG>() {
              @Override
              public JPEG run(final JPEG jpeg, final InputReader reader) throws RuleMismatchException {
                // rules+=Matcher
                jpeg.getRules().add(Rule().match(reader));
                return jpeg;
              }
            }, new RuleCallback<JPEG>() {
              @Override
              public JPEG run(final JPEG jpeg, final InputReader reader) throws RuleMismatchException {
                // Comment
                Comment().match(reader);
                // WS*
                ZeroOrMore(null, reader, new RuleCallback<WS>() {
                  @Override
                  public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
                    // WS
                    return WS().match(reader);
                  }
                });
                return jpeg;
              }
            });
            return jpeg;
          }
        });
        // EOI
        EOI().match(reader);
      }
      // @formatter:on

      return jpeg;
    }

  }

}
