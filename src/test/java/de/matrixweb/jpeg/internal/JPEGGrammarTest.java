package de.matrixweb.jpeg.internal;

import java.io.IOException;
import java.io.Reader;

import org.apache.commons.io.IOUtils;
import org.junit.BeforeClass;
import org.junit.Test;

import de.matrixweb.jpeg.JPEG;
import de.matrixweb.jpeg.JPEGParserException;
import de.matrixweb.jpeg.Java;

/**
 * @author markusw
 */
public class JPEGGrammarTest extends AbstractBaseTest {

  private static ParserDelegate jpegParser;

  /**
   * @throws Exception
   */
  @BeforeClass
  public static void createParser() throws Exception {
    if (Boolean.parseBoolean(System.getProperty("jpeg.debug", "false"))) {
      jpegParser = new ParserDelegate(
          new de.matrixweb.jpeg.test.JPEGTestParser());
    } else {
      jpegParser = createParserDelegate("de/matrixweb/jpeg/jpeg.jpeg",
          "de.matrixweb.jpeg.JPEGParser");
    }
  }

  /**
   * @throws Exception
   */
  @Test
  public void testGrammarMatchers() throws Exception {
    // this.jpegParser.validateGrammar("Terminal", "TerminalMatcher#'",
    // "OptionalMatcher#InTerminalChar", "TerminalMatcher#'");

    jpegParser.validateGrammar("WS", "TerminalMatcher# ", "ChoiceMatcher#",
        "TerminalMatcher#\n", "ChoiceMatcher#", "TerminalMatcher#\t",
        "ChoiceMatcher#", "TerminalMatcher#\r");
  }

  /** */
  @Test(expected = JPEGParserException.class)
  public void testInputReadFailure() {
    final Reader reader = new Reader() {
      @Override
      public int read(final char[] cbuf, final int off, final int len)
          throws IOException {
        throw new IOException("Failed");
      }

      @Override
      public void close() throws IOException {
      }
    };
    JPEG.createParser(reader, new Java(""));
  }

  /**
   * @throws Exception
   */
  @Test
  public void testWhiteSpaces() throws Exception {
    jpegParser.parse("WS", "\t", true);
    jpegParser.parse("WS", "\r", true);
    final Object res = jpegParser.parse("WS", "\n", true);
    jpegParser.validateResult(res, "{1}[0]('\n')");
  }

  /**
   * @throws Exception
   */
  @Test
  public void testNewlines() throws Exception {
    final ParserDelegate parser = createParserDelegate("newlines.jpeg",
        "lines.Newlines");
    parser.parse("rule1", "a\nb", true);
    parser.parse("rule1", "a b", false);
  }

  /**
   * @throws Exception
   */
  @Test
  public void testEscapesParseTree() throws Exception {
    Object result = jpegParser.parse("Terminal",
        String.valueOf(new char[] { '\'', '\\', 'n', '\'' }), true);
    jpegParser.validateResult(result, "{3}[1]{2}");

    result = jpegParser.parse("Terminal",
        String.valueOf(new char[] { '\'', '\\', '\\', '\'' }), true);
    jpegParser.validateResult(result, "{3}[1]{2}");

    result = jpegParser.parse("Terminal",
        String.valueOf(new char[] { '\'', '\\', '\'', '\'' }), true);
    jpegParser.validateResult(result, "{3}[1]{2}");

    result = jpegParser.parse("Terminal",
        String.valueOf(new char[] { '\'', '\n', '\'' }), true);
    jpegParser.validateResult(result, "{3}[1]{1}");
  }

  /**
   * @throws Exception
   */
  @Test
  public void testParsingJPEGGrammarWithJPEGParser() throws Exception {
    jpegParser.parse("JPEG", IOUtils.toString(JPEGGrammarTest.class
        .getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"), "UTF-8"), true);
  }

  /**
   * @throws Exception
   */
  @Test
  public void testSubExpressions() throws Exception {
    jpegParser.parse("ZeroOrMoreExpression", "(a b)*", true);
    jpegParser.parse("NotPredicateExpression", "!'a'", true);
  }

  /**
   * 
   */
  @Test
  public void testRangeExpression() {
    jpegParser.parse("RangeExpression", "[-]", true);
    jpegParser.parse("RangeExpression", "[a-z]", true);
    jpegParser.parse("RangeExpression", "[a-z0-9]", true);
    jpegParser.parse("RangeExpression", "[-a-z0-9]", true);
    jpegParser.parse("RangeExpression", "[ab]", true);
    jpegParser.parse("RangeExpression", "[-9]", true);
    jpegParser.parse("RangeExpression", "[a-]", false);
    jpegParser.parse("RangeExpression", "[ab-]", false);
  }

  /**
   * @throws Exception
   */
  @Test
  public void testGrammarComment() throws Exception {
    jpegParser.parse("JPEG", "// Some dumb comment\nRule: Body;", true);
    final Object res = jpegParser.parse("JPEG",
        "// Some dumb comment Rule: Body;", true);
    jpegParser.validateResult(res, "{1}[0]{1}[0]{31}");
    jpegParser.parse("JPEG", "// Some dumb\ncomment\nRule: Body;", false);
  }

  /**
   * 
   */
  @Test
  public void testRuleNameAssignment() {
    jpegParser.parse("RuleName", "SomeRuleName", true);
  }

}
