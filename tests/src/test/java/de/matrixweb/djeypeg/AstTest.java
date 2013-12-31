package de.matrixweb.djeypeg;

import java.io.File;
import java.io.IOException;

import org.junit.Before;
import org.junit.Test;
import org.junit.rules.ExpectedException;
import org.junit.rules.TestName;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

import de.matrixweb.djeypeg.helper.StopwatchRule;
import djeypeg.ChoiceExpression;
import djeypeg.Djeypeg;
import djeypeg.ParseException;
import djeypeg.Parser;
import djeypeg.Rule;
import djeypeg.RuleReferenceExpression;
import djeypeg.SequenceExpression;
import djeypeg.TerminalExpression;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
@SuppressWarnings("javadoc")
public class AstTest {

  @org.junit.Rule
  public TestName name = new TestName();

  @org.junit.Rule
  public ExpectedException exception = ExpectedException.none();

  @org.junit.Rule
  public StopwatchRule stopwatch = new StopwatchRule();

  private Parser parser;

  @Before
  public void setUp() {
    this.parser = new Parser();
  }

  @Test
  public void testParse() {
    final Djeypeg r = this.parser.Djeypeg("Rule <- 'a';");

    assertThat(r, is(notNullValue()));
    assertThat(r.getRules().size(), is(1));
    assertThat(r.getRules().get(0).getName().getParsed(), is("Rule"));
  }

  @Test
  public void testParse2() {
    final Djeypeg r = this.parser
        .Djeypeg("Rule <- Rule2 / 'a';\nRule2 <- 'b';");

    assertThat(r, is(notNullValue()));
    assertThat(r.getRules().size(), is(2));
  }

  @Test
  public void testParseError() {
    this.exception.expect(ParseException.class);
    this.exception.expectMessage("ParseException[1,11]");
    this.exception.expectMessage("Expected");
    this.exception.expectMessage("';'");

    this.parser.Djeypeg("Rule <- []];");
  }

  @Test
  public void testUnclosedRangeExpression() {
    this.exception.expect(ParseException.class);
    this.exception.expectMessage("ParseException[1,4]");
    this.exception.expectMessage("Expected");
    this.exception.expectMessage("']'");

    this.parser.RangeExpression("[abc");
  }

  @Test
  public void testParseRange() {
    final Djeypeg r = this.parser.Djeypeg("Rule <- [\\]];");

    assertThat(r, is(notNullValue()));
  }

  @Test
  public void testCommentInSequence() {
    final Djeypeg djeypeg = this.parser.Djeypeg("Rule <- 'a' //'b' \n  'c';");

    assertThat(djeypeg, is(notNullValue()));
    final Rule rule = djeypeg.getRules().get(0);
    // Expect one sequence
    assertThat(rule.getBody().getExpressions().size(), is(1));
    assertThat(rule.getBody().getExpressions().get(0),
        is(instanceOf(SequenceExpression.class)));
    final SequenceExpression seq = (SequenceExpression) rule.getBody()
        .getExpressions().get(0);
    // Expect two terminal exp
    assertThat(seq.getExpressions().size(), is(2));
    assertThat(seq.getExpressions().get(0),
        is(instanceOf(TerminalExpression.class)));
    assertThat(seq.getExpressions().get(1),
        is(instanceOf(TerminalExpression.class)));
  }

  @Test
  public void testSimpleRule() {
    final Djeypeg djeypeg = this.parser.Djeypeg("A <- B / C;");

    assertThat(djeypeg, is(notNullValue()));
    assertThat(djeypeg.getRules().get(0).getBody().getExpressions().size(),
        is(1));
    assertThat(djeypeg.getRules().get(0).getBody().getExpressions().get(0),
        is(instanceOf(ChoiceExpression.class)));
    final ChoiceExpression expr = (ChoiceExpression) djeypeg.getRules().get(0)
        .getBody().getExpressions().get(0);
    assertThat(expr.getChoices().size(), is(2));
    // Expect two rule-ref exp
    assertThat(expr.getChoices().get(0),
        is(instanceOf(RuleReferenceExpression.class)));
    assertThat(expr.getChoices().get(1),
        is(instanceOf(RuleReferenceExpression.class)));
  }

  @Test
  public void testDjeypegGrammar() throws IOException {
    final Djeypeg r = this.parser.Djeypeg(Files.toString(new File(
        "../parser/src/test/resources/de/matrixweb/djeypeg/djeypeg.djeypeg"),
        Charsets.UTF_8));

    assertThat(r, is(notNullValue()));
  }

}
