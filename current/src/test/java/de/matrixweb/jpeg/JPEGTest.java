package de.matrixweb.jpeg;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public class JPEGTest extends AbstractParserTests {

  private Parser parser;

  /**
   * @throws IOException
   */
  @Before
  public void setUp() throws IOException {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/test.jpeg"),
        "UTF-8");
    try {
      this.parser = JPEG.createParser(reader,
          new Java("de.matrixweb.jpeg.Test"));
    } finally {
      reader.close();
    }
  }

  /**
   * @see de.matrixweb.jpeg.AbstractParserTests#createParser()
   */
  @Override
  protected ParserDelegate createParser() {
    return new ParserDelegateImpl(this.parser);
  }

  /**
   * @see de.matrixweb.jpeg.AbstractParserTests#createJPEGParser()
   */
  @Override
  protected ParserDelegate createJPEGParser() throws Exception {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"),
        "UTF-8");
    try {
      return new ParserDelegateImpl(JPEG.createParser(reader, new Java(
          "de.matrixweb.jpeg.JPEG")));
    } finally {
      reader.close();
    }
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

  /** */
  @Test
  public void testParseTree() {
    final ParsingResult result = this.parser.parse("Start", "Hallo Welt!");
    assertThat(result.matches(), is(true));
    System.out.println(Utils.formatParsingTree(result));
  }

  protected static class ParserDelegateImpl implements ParserDelegate {

    private final Parser parser;

    /**
     * @param parser
     */
    public ParserDelegateImpl(final Parser parser) {
      this.parser = parser;
    }

    /**
     * @see de.matrixweb.jpeg.AbstractParserTests.ParserDelegate#parse(java.lang.String,
     *      java.lang.String, boolean)
     */
    @Override
    public void parse(final String rule, final String input,
        final boolean result) {
      assertThat(this.parser.parse(rule, input).matches(), is(result));
    }

  }

}
