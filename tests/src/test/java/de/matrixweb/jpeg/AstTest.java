package de.matrixweb.jpeg;

import java.io.File;
import java.io.IOException;

import jpeg.ChoiceExpression;
import jpeg.Jpeg;
import jpeg.ParseException;
import jpeg.Parser;
import jpeg.Rule;
import jpeg.RuleReferenceExpression;
import jpeg.TerminalExpression;

import org.junit.Before;
import org.junit.Test;
import org.junit.rules.ExpectedException;
import org.junit.rules.TestName;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

import de.matrixweb.jpeg.helper.StopwatchRule;

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
    final Jpeg r = this.parser.Jpeg("Rule:'a';");

    assertThat(r, is(notNullValue()));
    assertThat(r.getRules().size(), is(1));
    assertThat(r.getRules().get(0).getName().getParsed(), is("Rule"));
  }

  @Test
  public void testParse2() {
    final Jpeg r = this.parser.Jpeg("Rule:Rule2|'a';\nRule2:'b';");

    assertThat(r, is(notNullValue()));
    assertThat(r.getRules().size(), is(2));
  }

  @Test
  public void testParseError() {
    this.exception.expect(ParseException.class);
    this.exception.expectMessage("ParseException[1,9]");
    this.exception.expectMessage("Expected");
    this.exception.expectMessage("';'");

    this.parser.Jpeg("Rule: []];");
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
    final Jpeg r = this.parser.Jpeg("Rule: [\\]];");

    assertThat(r, is(notNullValue()));
  }

  @Test
  public void testCommentInSequnce() {
    final Jpeg jpeg = this.parser.Jpeg("Rule: 'a' //'b' \n  'c';");

    assertThat(jpeg, is(notNullValue()));
    final Rule rule = jpeg.getRules().get(0);
    // Expect two terminal exp
    assertThat(rule.getBody().getExpressions().size(), is(2));
    assertThat(rule.getBody().getExpressions().get(0),
        is(instanceOf(TerminalExpression.class)));
    assertThat(rule.getBody().getExpressions().get(1),
        is(instanceOf(TerminalExpression.class)));
  }

  @Test
  public void testSimpleRule() {
    final Jpeg jpeg = this.parser.Jpeg("A: B | C;");

    assertThat(jpeg, is(notNullValue()));
    assertThat(jpeg.getRules().get(0).getBody().getExpressions().size(), is(1));
    assertThat(jpeg.getRules().get(0).getBody().getExpressions().get(0),
        is(instanceOf(ChoiceExpression.class)));
    final ChoiceExpression expr = (ChoiceExpression) jpeg.getRules().get(0)
        .getBody().getExpressions().get(0);
    assertThat(expr.getChoices().size(), is(2));
    // Expect two rule-ref exp
    assertThat(expr.getChoices().get(0),
        is(instanceOf(RuleReferenceExpression.class)));
    assertThat(expr.getChoices().get(1),
        is(instanceOf(RuleReferenceExpression.class)));
  }

  @Test
  public void testJpegGrammar() throws IOException {
    final Jpeg r = this.parser.Jpeg(Files.toString(new File(
        "../parser/src/test/resources/de/matrixweb/jpeg/jpeg.jpeg"),
        Charsets.UTF_8));

    assertThat(r, is(notNullValue()));
  }

}
