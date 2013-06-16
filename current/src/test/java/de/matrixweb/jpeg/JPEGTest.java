package de.matrixweb.jpeg;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;

import org.apache.commons.io.IOUtils;
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

  /**
   * @throws IOException
   */
  @Test
  public void testJpegParseTree() throws IOException {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"),
        "UTF-8");
    try {
      final Parser jpeg = JPEG.createParser(reader, new Java(
          "de.matrixweb.jpeg.JPEG"));
      final ParsingResult result = jpeg.parse("JPEG", IOUtils.toString(
          JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"),
          "UTF-8"));
      assertThat(result.matches(), is(true));
      System.out.println(Utils.formatParsingTree(result));
    } finally {
      reader.close();
    }
  }

  /**
   * @throws IOException
   */
  @Test
  public void testWhiteSpaces() throws IOException {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/whitespace.jpeg"), "UTF-8");
    final Parser parser = JPEG.createParser(reader, new Java("WhiteSpace"));
    assertThat(parser.parse("WS", "\n").matches(), is(true));
    assertThat(parser.parse("WS", "\t").matches(), is(true));
    assertThat(parser.parse("WS", "\r").matches(), is(true));

    final ParsingResult res = parser.parse("WS", "\n");
    System.out.println(Utils.formatParsingTree(res));
    assertThat(res.getParseTree().getChildren().length, is(1));
    assertThat(res.getParseTree().getChildren()[0].getValue(), is("\n"));
  }

  /**
   * @throws IOException
   */
  @Test
  public void testNewlines() throws IOException {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/newlines.jpeg"), "UTF-8");
    final Parser parser = JPEG.createParser(reader, new Java("Newlines"));
    assertThat(parser.parse("rule1", "a\nb").matches(), is(true));
    assertThat(parser.parse("rule1", "a b").matches(), is(false));
  }

  /**
   * @throws IOException
   */
  @Test
  public void testEscapesParseTree() throws IOException {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"),
        "UTF-8");
    try {
      final Parser parser = JPEG.createParser(reader, new Java(
          "de.matrixweb.jpeg.JPEG"));

      ParsingResult result = parser.parse("Terminal",
          String.valueOf(new char[] { '\'', '\\', 'n', '\'' }));
      assertThat(result.matches(), is(true));
      assertThat(result.getParseTree().getChildren().length, is(4));
      System.out.println(Utils.formatParsingTree(result));

      result = parser.parse("Terminal",
          String.valueOf(new char[] { '\'', '\\', '\\', '\'' }));
      assertThat(result.matches(), is(true));
      assertThat(result.getParseTree().getChildren().length, is(3));
      System.out.println(Utils.formatParsingTree(result));

      result = parser.parse("Terminal",
          String.valueOf(new char[] { '\'', '\\', '\'', '\'' }));
      assertThat(result.matches(), is(true));
      assertThat(result.getParseTree().getChildren().length, is(3));
      System.out.println(Utils.formatParsingTree(result));

      result = parser.parse("Terminal",
          String.valueOf(new char[] { '\'', '\n', '\'' }));
      assertThat(result.matches(), is(true));
      assertThat(result.getParseTree().getChildren().length, is(3));
      System.out.println(Utils.formatParsingTree(result));
    } finally {
      reader.close();
    }
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
