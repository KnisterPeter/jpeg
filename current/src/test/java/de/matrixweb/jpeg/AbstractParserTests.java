package de.matrixweb.jpeg;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;

import org.apache.commons.io.IOUtils;
import org.junit.Test;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public abstract class AbstractParserTests {

  protected abstract ParserDelegate createParser();

  protected abstract ParserDelegate createParser(String grammarPath);

  protected abstract ParserDelegate createParser(Reader grammar);

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
      createParser().parse("UnknownRule", "abc", true);
      fail("Expected JPEGParserException");
    } catch (final Exception e) {
      assertThat(e.getClass().getSimpleName(), is("JPEGParserException"));
    }
  }

  /** */
  @Test
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
    try {
      createParser(reader);
      fail("Expected JPEGParserException");
    } catch (final Exception e) {
      assertThat(e.getClass().getSimpleName(), is("JPEGParserException"));
    }
  }

  /**
   * @throws IOException
   */
  @Test
  public void testParseJpegGrammar() throws IOException {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"),
        "UTF-8");
    try {
      createParser(reader).parse(
          "JPEG",
          IOUtils.toString(JPEGTest.class
              .getResourceAsStream("/de/matrixweb/jpeg/test.jpeg"), "UTF-8"),
          true);
    } finally {
      reader.close();
    }
  }

  protected static interface ParserDelegate {

    void parse(String rule, String input, boolean result);

  }

}
