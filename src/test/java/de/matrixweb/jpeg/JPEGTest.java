package de.matrixweb.jpeg;

import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.commons.io.IOUtils;
import org.junit.BeforeClass;
import org.junit.Test;

import de.matrixweb.jpeg.internal.rules.jpeg.Rule;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public class JPEGTest {

  private static Parser parser;

  /**
   * @throws IOException
   */
  @BeforeClass
  public static void setUpParser() throws IOException {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"));
    final String input = IOUtils.toString(reader);
    parser = JPEG.create(input);
  }

  /**
   * @throws IOException
   */
  @Test
  public void testCreateJpegParser() throws IOException {
    final InputStreamReader reader = new InputStreamReader(getClass()
        .getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"));
    final String input = IOUtils.toString(reader);
    assertThat(parser.parse("JPEG", input).isSuccess(), is(true));
  }

  /**
   * @throws IOException
   */
  @Test
  public void testJPEGParsing() throws IOException {
    assertThat(parser.parse("JPEG", "A:B;C:D;").isSuccess(), is(true));
    assertThat(parser.parse("JPEG", "// comment\nRule:'a';").isSuccess(),
        is(true));
    assertThat(parser.parse("JPEG", "// comment\nRule:'a'").isSuccess(),
        is(false));
    assertThat(parser.parse("JPEG", "// comment\n:'a';abc").isSuccess(),
        is(false));
  }

  /**
   * @throws IOException
   */
  @Test
  public void testSimpleRuleParsing() throws IOException {
    final ParsingResult result = parser.parse("Rule", "A:B;");
    assertThat(result.isSuccess(), is(true));
    assertThat(result.getTree(), is(Rule.class));
    final Rule rule = (Rule) result.getTree();
    System.out.println(rule.getBody().getExpressions());
    // TODO: check that body just contains rule-call to B
  }

  /**
   * @throws IOException
   */
  @Test
  public void testRuleParsing() throws IOException {
    assertThat(parser.parse("Rule", "JPEG :((Matcher | Comment) WS*)+ EOI;")
        .isSuccess(), is(true));
  }

  /**
   * @throws IOException
   */
  @Test
  public void testRuleReturnsParsing() throws IOException {
    assertThat(parser.parse("RuleReturns", "returns String").isSuccess(),
        is(true));
    assertThat(parser.parse("RuleReturns", "return String").isSuccess(),
        is(false));
  }

  /**
   * @throws IOException
   */
  @Test
  public void testBodyParsing() throws IOException {
    assertThat(parser.parse("Body", "((Matcher | Comment) WS*)+ EOI")
        .isSuccess(), is(true));
  }

  /**
   * @throws IOException
   */
  @Test
  public void testChoiceExpressionParsing() throws IOException {
    assertThat(parser.parse("ChoiceExpression", "Matcher | Comment")
        .isSuccess(), is(true));
  }

  /**
   * @throws IOException
   */
  @Test
  public void testIDParsing() throws IOException {
    assertThat(parser.parse("ID", "Rule123").isSuccess(), is(true));
    assertThat(parser.parse("ID", "_Rule123").isSuccess(), is(true));
    assertThat(parser.parse("ID", "123").isSuccess(), is(false));
    assertThat(parser.parse("ID", "-123").isSuccess(), is(false));
    assertThat(parser.parse("ID", "_abcAbc-abcAbc").isSuccess(), is(false));
  }

  /**
   * @throws IOException
   */
  @Test
  public void testFQTNParsing() throws IOException {
    assertThat(parser.parse("FQTN", "a.b.c").isSuccess(), is(true));
    assertThat(parser.parse("FQTN", "a.b.").isSuccess(), is(false));
    assertThat(parser.parse("FQTN", ".a.b.c").isSuccess(), is(false));
  }

}
