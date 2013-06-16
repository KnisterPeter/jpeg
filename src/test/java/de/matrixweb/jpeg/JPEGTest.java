package de.matrixweb.jpeg;

import java.io.File;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public class JPEGTest {

  private ParserDelegate testParser;

  private ParserDelegate jpegParser;

  /**
   * @throws Exception
   */
  @Before
  public void setUp() throws Exception {
    this.testParser = createParserDelegate("de/matrixweb/jpeg/test.jpeg",
        "de.matrixweb.jpeg.TestParser");
    this.jpegParser = createParserDelegate("de/matrixweb/jpeg/jpeg.jpeg",
        "de.matrixweb.jpeg.JPEGParser");
  }

  @SuppressWarnings("resource")
  private Object createParser(final String grammar, final String name)
      throws Exception {
    final Java java = new Java(name);
    final String source = JPEG.createParser(new StringReader(grammar), java);

    final File target = new File("target/" + name.replace('.', '-'));
    FileUtils.deleteDirectory(target);
    target.mkdirs();
    java.compile(target, source);

    return new URLClassLoader(new URL[] { target.toURI().toURL() }, null)
        .loadClass(name).newInstance();
  }

  private ParserDelegate createParserDelegate(final String grammarPath,
      final String name) throws Exception {
    return new ParserDelegate(createParser(IOUtils.toString(
        JPEGTest.class.getResourceAsStream("/" + grammarPath), "UTF-8"), name));
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
    final ParserDelegate parser = createParserDelegate("whitespace.jpeg",
        "white.SpaceParser");
    parser.parse("WS", "\t", true);
    parser.parse("WS", "\r", true);
    final Object res = parser.parse("WS", "\n", true);
    parser.validate(res, "{1}[0](\n)");
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
    Object result = this.jpegParser.parse("Terminal",
        String.valueOf(new char[] { '\'', '\\', 'n', '\'' }), true);
    this.jpegParser.validate(result, "{4}");

    result = this.jpegParser.parse("Terminal",
        String.valueOf(new char[] { '\'', '\\', '\\', '\'' }), true);
    this.jpegParser.validate(result, "{3}");

    result = this.jpegParser.parse("Terminal",
        String.valueOf(new char[] { '\'', '\\', '\'', '\'' }), true);
    this.jpegParser.validate(result, "{3}");

    result = this.jpegParser.parse("Terminal",
        String.valueOf(new char[] { '\'', '\n', '\'' }), true);
    this.jpegParser.validate(result, "{3}");
  }

  /** */
  @Test
  public void test1() {
    this.testParser.parse("Start", "Hallo Welt!", true);
    this.testParser.parse("Start", "Hallo  Welt!", true);
    this.testParser.parse("Start", "Hallo   Welt!", true);
    this.testParser.parse("Start", "Hallo Welt\"", false);
    this.testParser.parse("Start", "Hello Welt!", true);
    this.testParser.parse("Start", "HelloWelt", false);
    this.testParser.parse("Start", "Hello Welt Welt!", true);
  }

  /** */
  @Test
  public void testMultiChoiceWithMultipleTokensPerChoice() {
    this.testParser.parse("MultiChoice", "cd", true);
  }

  /** */
  @Test
  public void testNotMatchOneOrMore() {
    this.testParser.parse("OneOrMore2", "a", false);
  }

  /** */
  @Test
  public void testOptionalMatch() {
    this.testParser.parse("Optional2", " ", true);
  }

  /** */
  @Test
  public void testEndOfInputFails() {
    this.testParser.parse("EOITest", "abc", false);
  }

  /** */
  @Test
  public void testTestParsingPartialInput() {
    this.testParser.parse("SomeDoubleQuotes", "\"\"\"\"\"", true);
  }

  /** */
  @Test
  public void testUnknownRule() {
    try {
      this.testParser.parse("UnknownRuleTest", "abc", true);
      fail("Expected JPEGParserException");
    } catch (final Exception e) {
      assertThat(e.getClass().getSimpleName(), is("JPEGParserException"));
    }
  }

  /**
   * @throws Exception
   */
  @Test
  public void testJpegGrammar() throws Exception {
    this.jpegParser.parse("JPEG", IOUtils.toString(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/test.jpeg"),
        "UTF-8"), true);
  }

  private static class ParserDelegate {

    private final Object parser;

    /**
     * @param parser
     */
    public ParserDelegate(final Object parser) {
      this.parser = parser;
    }

    public Object parse(final String rule, final String input,
        final boolean result) {
      try {
        final Method m = this.parser.getClass().getMethod(rule, String.class);
        final Object res = m.invoke(this.parser, input);
        assertThat((Boolean) res.getClass().getMethod("matches").invoke(res),
            is(result));
        return res;
      } catch (final NoSuchMethodException e) {
        throw new RuntimeException(e);
      } catch (final IllegalAccessException e) {
        throw new RuntimeException(e);
      } catch (final InvocationTargetException e) {
        final Throwable t = e.getTargetException();
        if (t instanceof RuntimeException) {
          throw (RuntimeException) t;
        }
        throw new RuntimeException(e);
      }
    }

    public void validate(final Object parseTree,
        final String parseTreeExpression) throws Exception {
      final Object node = parseTree.getClass().getMethod("getParseTree")
          .invoke(parseTree);
      final String expr = validate0(node, parseTreeExpression);
      if (expr.length() > 0) {
        fail(expr.replace("\n", "\\n"));
      }
    }

    String validate0(final Object node, final String parseTreeExpression)
        throws Exception {
      String expr = parseTreeExpression;
      if (expr.startsWith("{")) {
        final int n = Integer.parseInt(expr.substring(1, expr.indexOf('}')));
        final Method m = node.getClass().getMethod("getChildren");
        m.setAccessible(true);
        final Object[] children = (Object[]) m.invoke(node);
        assertThat(children.length, is(n));
        expr = expr.substring(expr.indexOf('}') + 1);
      }
      if (expr.startsWith("[")) {
        final int n = Integer.parseInt(expr.substring(1, expr.indexOf(']')));
        final Method m = node.getClass().getMethod("getChildren");
        m.setAccessible(true);
        final Object[] children = (Object[]) m.invoke(node);
        expr = validate0(children[n], expr.substring(expr.indexOf(']') + 1));
      }
      if (expr.startsWith("(")) {
        final String test = expr.substring(1, expr.indexOf(')'));
        final Method m = node.getClass().getMethod("getValue");
        m.setAccessible(true);
        final String value = (String) m.invoke(node);
        assertThat(value, is(test));
        expr = expr.substring(expr.indexOf(')') + 1);
      }
      return expr;
    }

  }

}