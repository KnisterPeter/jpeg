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
public class RuleReturns implements Type<RuleReturns> {

  private String name;

  /**
   * @see de.matrixweb.jpeg.internal.type.Type#copy()
   */
  @Override
  public RuleReturns copy() {
    final RuleReturns copy = new RuleReturns();
    copy.name = this.name.copy();
    return copy;
  }

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
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
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
