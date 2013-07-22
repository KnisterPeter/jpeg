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
import static de.matrixweb.jpeg.internal.rules.jpeg.StaticRules.*;

/**
 * @author markusw
 */
public class Rule implements Type {

  private String name;

  private RuleReturns returns;

  private Body body;

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
      final Mutable<String> name = new Mutable<String>(new String());
      final Mutable<RuleReturns> returns = new Mutable<RuleReturns>();
      final Mutable<Body> body = new Mutable<Body>();

      // @formatter:off
      // name=ID WS* returns=RuleReturns? WS* ':' WS* body=Body WS* ';' WS*
      {
        // name=ID
        name.getValue().add(ID().match(reader));
        // WS*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // WS
            WS().match(reader);
          }
        });
        // returns=RuleReturns?
        Optional(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // returns=RuleReturns
            returns.setValue(RuleReturns().match(reader));
          }
        });
        // WS*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // WS
            WS().match(reader);
          }
        });
        // ':'
        T(":").match(reader);
        // WS*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // WS
            WS().match(reader);
          }
        });
        // body=Body
        body.setValue(Body().match(reader));
        // WS*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // WS
            WS().match(reader);
          }
        });
        // ':'
        T(";").match(reader);
        // WS*
        ZeroOrMore(reader, new RuleCallback() {
          @Override
          public void run(final InputReader reader) throws RuleMismatchException {
            // WS
            WS().match(reader);
          }
        });
      }
      // @formatter:on

      final Rule rule = new Rule();
      rule.setName(name.getValue());
      rule.setReturns(returns.getValue());
      rule.setBody(body.getValue());
      return rule;
    }

  }

}
