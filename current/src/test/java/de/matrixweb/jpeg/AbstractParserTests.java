package de.matrixweb.jpeg;

import org.junit.Test;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public abstract class AbstractParserTests {

  protected abstract ParserDelegate createParser();

  protected abstract ParserDelegate createParser(String grammarPath);

  /** */
  @Test
  public void test1() {
    createParser().parse("Start", "Hallo Welt!", true);
    createParser().parse("Start", "Hallo  Welt!", true);
    createParser().parse("Start", "Hallo   Welt!", true);
    createParser().parse("Start", "Hallo Welt\"", false);
    createParser().parse("Start", "Hello Welt!", true);
    createParser().parse("Start", "HelloWelt", false);
    createParser().parse("Start", "Hello Welt Welt!", true);
  }

  /** */
  @Test
  public void testMultiChoiceWithMultipleTokensPerChoice() {
    createParser().parse("MultiChoice", "cd", true);
  }

  /** */
  @Test
  public void testNotMatchOneOrMore() {
    createParser().parse("OneOrMore2", "a", false);
  }

  /** */
  @Test
  public void testOptionalMatch() {
    createParser().parse("Optional2", " ", true);
  }

  /** */
  @Test
  public void testEndOfInputFails() {
    createParser().parse("EOITest", "abc", false);
  }

  /** */
  @Test
  public void testTestParsingPartialInput() {
    createParser().parse("SomeDoubleQuotes", "\"\"\"\"\"", true);
  }

  /** */
  @Test
  public void testUnknownRule() {
    try {
      createParser().parse("UnknownRuleTest", "abc", true);
      fail("Expected JPEGParserException");
    } catch (final Exception e) {
      assertThat(e.getClass().getSimpleName(), is("JPEGParserException"));
    }
  }

  protected static interface ParserDelegate {

    void parse(String rule, String input, boolean result);

  }

}
