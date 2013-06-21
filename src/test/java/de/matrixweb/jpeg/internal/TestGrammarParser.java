package de.matrixweb.jpeg.internal;

import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public class TestGrammarParser extends AbstractBaseTest {

  private static ParserDelegate testParser;

  /**
   * @throws Exception
   */
  @BeforeClass
  public static void createParser() throws Exception {
    testParser = createParserDelegate("de/matrixweb/jpeg/test.jpeg",
        "de.matrixweb.jpeg.TestParser");
  }

  /** */
  @Test
  public void testGrammarInputs() {
    testParser.parse("Start", "Hallo Welt!", true);
    testParser.parse("Start", "Hallo  Welt!", true);
    testParser.parse("Start", "Hallo   Welt!", true);
    testParser.parse("Start", "Hallo Welt\"", false);
    testParser.parse("Start", "Hello Welt!", true);
    testParser.parse("Start", "HelloWelt", false);
    testParser.parse("Start", "Hello Welt Welt!", true);
  }

  /** */
  @Test
  public void testMultiChoiceWithMultipleTokensPerChoice() {
    testParser.parse("MultiChoice", "cd", true);
  }

  /** */
  @Test
  public void testNotMatchOneOrMore() {
    testParser.parse("OneOrMore2", "a", false);
  }

  /** */
  @Test
  public void testOptionalMatch() {
    testParser.parse("Optional2", " ", true);
  }

  /** */
  @Test
  public void testEndOfInputFails() {
    testParser.parse("EOITest", "abc", false);
  }

  /** */
  @Test
  public void testTestParsingPartialInput() {
    testParser.parse("SomeDoubleQuotes", "\"\"\"\"\"", true);
  }

  /** */
  @Test
  public void testUnknownRule() {
    try {
      testParser.parse("UnknownRuleTest", "abc", true);
      fail("Expected JPEGParserException");
    } catch (final Exception e) {
      assertThat(e.getClass().getSimpleName(), is("JPEGParserException"));
    }
  }

}
