package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;
import de.matrixweb.jpeg.internal.type.Type;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class RuleReturns implements Type {

  private String name;

  /**
   * @return the name
   */
  public String getName() {
    return this.name;
  }

  /**
   * @param name
   *          the name to set
   */
  public void setName(final String name) {
    this.name = name;
  }

  /** */
  public static class GrammarRule extends ParserRule<RuleReturns> {

    private String name;

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected RuleReturns consume(final InputReader reader)
        throws RuleMismatchException {
      // @formatter:off
      // 'returns' WS* name=FQTN
      {
        // 'returns'
        T("returns").match(reader);
        // WS*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // WS
            WS().match(reader);
          }
        });
        // name=FQTN
        this.name = FQTN().match(reader);
      }
      // @formatter:on

      final RuleReturns ruleReturns = new RuleReturns();
      ruleReturns.setName(this.name);
      return ruleReturns;
    }

  }

}
