package de.matrixweb.djeypeg.internal;

import org.junit.Test;
import org.junit.rules.ExpectedException;

/**
 * @author markusw
 */
@SuppressWarnings("javadoc")
public class AstValidatorTest {

  @org.junit.Rule
  public ExpectedException exception = ExpectedException.none();

  @Test
  public void testUnknownRuleReference() {
    this.exception.expect(ParseException.class);
    this.exception.expectMessage("Reference 'Undefined' undefined");

    final Parser parser = new Parser();

    final ID id = new ID();
    id.setParsed("Undefined");
    final RuleReferenceExpression expression = new RuleReferenceExpression();
    expression.setName(id);
    final ID name = new ID();
    name.setParsed("Rule");
    final Body body = new Body();
    body.add(expression);
    final Rule rule = new Rule();
    rule.setName(name);
    rule.setBody(body);
    final Djeypeg djeypeg = new Djeypeg();
    djeypeg.add(rule);

    AstValidator.validate(djeypeg, parser);
  }

}
