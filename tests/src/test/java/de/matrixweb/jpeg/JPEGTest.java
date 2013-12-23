package de.matrixweb.jpeg;

import java.io.File;
import java.io.IOException;

import jpeg.Jpeg;
import jpeg.ParseException;
import jpeg.Parser;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;
import org.junit.rules.TestName;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
@SuppressWarnings("javadoc")
public class JPEGTest {

  @Rule
  public TestName name = new TestName();

  @Rule
  public ExpectedException exception = ExpectedException.none();

  @Rule
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
    this.exception.expectMessage("Expected ';'");

    this.parser.Jpeg("Rule: []];");
  }

  @Test
  public void testUnclosedRangeExpression() {
    this.exception.expect(ParseException.class);
    this.exception.expectMessage("ParseException[1,4]");
    this.exception.expectMessage("Expected ']'");

    this.parser.RangeExpression("[abc");
  }

  @Test
  public void testParseRange() {
    final Jpeg r = this.parser.Jpeg("Rule: [\\]];");

    assertThat(r, is(notNullValue()));
  }

  @Test
  public void testJpegGrammar() throws IOException {
    final Jpeg r = this.parser.Jpeg(Files.toString(new File(
        "../parser/src/test/resources/de/matrixweb/jpeg/jpeg.jpeg"),
        Charsets.UTF_8));

    assertThat(r, is(notNullValue()));
  }

  @Test
  public void testEcmaScriptGrammar() throws IOException {
    final String parser = JPEG.generate(new File(
        "src/test/resources/ecmascript.jpeg"), "ecmascript");

    assertThat(parser, is(notNullValue()));
  }

}
