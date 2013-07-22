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
public class Rule implements Type<Rule> {

  private String name;

  private RuleReturns returns;

  private Body body;

  /**
   * @see de.matrixweb.jpeg.internal.type.Type#copy()
   */
  @Override
  public Rule copy() {
    final Rule copy = new Rule();
    copy.name = this.name != null ? this.name.copy() : null;
    copy.returns = this.returns != null ? this.returns.copy() : null;
    copy.body = this.body != null ? this.body.copy() : null;
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

  /**
   * @return the returns
   */
  public RuleReturns getReturns() {
    return this.returns;
  }

  /**
   * @param returns
   *          the returns to set
   */
  public void setReturns(final RuleReturns returns) {
    this.returns = returns;
  }

  /**
   * @return the body
   */
  public Body getBody() {
    return this.body;
  }

  /**
   * @param body
   *          the body to set
   */
  public void setBody(final Body body) {
    this.body = body;
  }

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public java.lang.String toString() {
    return getClass().getSimpleName() + "[name=" + this.name.getValue() + "]";
  }

  /** */
  public static class GrammarRule extends ParserRule<Rule> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#match(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected Rule consume(final InputReader reader)
        throws RuleMismatchException {
      Rule rule = new Rule();

      // @formatter:off
      // name=ID WS* returns=RuleReturns? WS* ':' WS* body=Body WS* ';' WS*
      {
        // name=ID
        rule.setName(ID().match(reader));
        // WS*
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
          }
        });
        // returns=RuleReturns?
        rule = Optional(rule, reader, new RuleCallback<Rule>() {
          @Override
          public Rule run(final Rule rule, final InputReader reader) throws RuleMismatchException {
            // returns=RuleReturns
            rule.setReturns(RuleReturns().match(reader));
            return rule;
          }
        });
        // WS*
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
          }
        });
        // ':'
        T(":").match(reader);
        // WS*
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
          }
        });
        // body=Body
        rule.setBody(Body().match(reader));
        // WS*
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
          }
        });
        // ':'
        T(";").match(reader);
        // WS*
        ZeroOrMore(null, reader, new RuleCallback<WS>() {
          @Override
          public WS run(final WS ws, final InputReader reader) throws RuleMismatchException {
            // WS
            return WS().match(reader);
          }
        });
      }
      // @formatter:on

      return rule;
    }

  }

}
