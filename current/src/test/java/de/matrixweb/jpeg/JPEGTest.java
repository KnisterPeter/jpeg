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
public class JPEGTest {

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

  /** */
  @Test
  public void test1() {
    assertThat(this.parser.parse("Start", "Hallo Welt!").matches(), is(true));
    assertThat(this.parser.parse("Start", "Hallo  Welt!").matches(), is(true));
    assertThat(this.parser.parse("Start", "Hallo   Welt!").matches(), is(true));
    assertThat(this.parser.parse("Start", "Hallo Welt\"").matches(), is(false));
    assertThat(this.parser.parse("Start", "Hello Welt!").matches(), is(true));
    assertThat(this.parser.parse("Start", "HelloWelt").matches(), is(false));
    assertThat(this.parser.parse("Start", "Hello Welt Welt!").matches(),
        is(true));
  }

  /** */
  @Test
  public void testMultiChoiceWithMultipleTokensPerChoice() {
    assertThat(this.parser.parse("MultiChoice", "cd").matches(), is(true));
  }

  /** */
  @Test
  public void testNotMatchOneOrMore() {
    assertThat(this.parser.parse("OneOrMore2", "a").matches(), is(false));
  }

  /** */
  @Test
  public void testOptionalMatch() {
    assertThat(this.parser.parse("Optional2", " ").matches(), is(true));
  }

  /** */
  @Test
  public void testEndOfInputFails() {
    assertThat(this.parser.parse("EOITest", "abc").matches(), is(false));
  }

  /** */
  @Test
  public void testTestParsingPartialInput() {
    assertThat(this.parser.parse("SomeDoubleQuotes", "\"\"\"\"\"").matches(),
        is(true));
  }

  /** */
  @Test(expected = JPEGParserException.class)
  public void testUnknownRule() {
    this.parser.parse("UnknownRule", "abc");
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
    JPEG.createParser(reader, new Java("de.matrixweb.jpeg.JPEG"));
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
  public void testParseJpegGrammar() throws IOException {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"),
        "UTF-8");
    try {
      final ParsingResult result = JPEG.createParser(reader,
          new Java("de.matrixweb.jpeg.JPEG")).parse(
          "JPEG",
          IOUtils.toString(JPEGTest.class
              .getResourceAsStream("/de/matrixweb/jpeg/test.jpeg"), "UTF-8"));
      assertThat(result.matches(), is(true));
      System.out.println(Utils.formatParsingTree(result));
    } finally {
      reader.close();
    }
  }

}
