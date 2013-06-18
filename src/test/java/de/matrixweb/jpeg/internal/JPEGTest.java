package de.matrixweb.jpeg.internal;

import java.io.File;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.junit.Before;
import org.junit.Test;

import de.matrixweb.jpeg.JPEG;
import de.matrixweb.jpeg.JPEGParserException;
import de.matrixweb.jpeg.Java;

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
    if (Boolean.parseBoolean(System.getProperty("jpeg.debug", "false"))) {
      this.jpegParser = new ParserDelegate(
          new de.matrixweb.jpeg.test.JPEGTestParser());
    } else {
      this.jpegParser = createParserDelegate("de/matrixweb/jpeg/jpeg.jpeg",
          "de.matrixweb.jpeg.JPEGParser");
    }
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

    FileUtils.write(new File(target, name.replace('.', '/') + ".java"), source);

    return new URLClassLoader(new URL[] { target.toURI().toURL() }, null)
        .loadClass(name).newInstance();
  }

  private ParserDelegate createParserDelegate(final String grammarPath,
      final String name) throws Exception {
    return new ParserDelegate(createParser(IOUtils.toString(
        JPEGTest.class.getResourceAsStream("/" + grammarPath), "UTF-8"), name));
  }

  /**
   * @throws Exception
   */
  @Test
  public void testGrammarMatchers() throws Exception {
    this.jpegParser.validateGrammar("Terminal", "RuleMatcher#QUOTE",
        "OptionalMatcher#InTerminalChar", "RuleMatcher#QUOTE");

    this.jpegParser.validateGrammar("WS", "TerminalMatcher# ",
        "ChoiceMatcher#", "TerminalMatcher#\n", "ChoiceMatcher#",
        "TerminalMatcher#\t", "ChoiceMatcher#", "TerminalMatcher#\r");
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
    this.jpegParser.parse("WS", "\t", true);
    this.jpegParser.parse("WS", "\r", true);
    final Object res = this.jpegParser.parse("WS", "\n", true);
    this.jpegParser.validateResult(res, "{1}[0]('\n')");
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
    this.jpegParser.validateResult(result, "{3}[1]{2}");

    result = this.jpegParser.parse("Terminal",
        String.valueOf(new char[] { '\'', '\\', '\\', '\'' }), true);
    this.jpegParser.validateResult(result, "{3}[1]{1}");

    result = this.jpegParser.parse("Terminal",
        String.valueOf(new char[] { '\'', '\\', '\'', '\'' }), true);
    this.jpegParser.validateResult(result, "{3}[1]{1}");

    result = this.jpegParser.parse("Terminal",
        String.valueOf(new char[] { '\'', '\n', '\'' }), true);
    this.jpegParser.validateResult(result, "{3}[1]{1}");
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

  /**
   * @throws Exception
   */
  @Test
  public void testSubExpressions() throws Exception {
    final Object res = this.jpegParser.parse("ZeroOrMoreExpression", "(a b)*",
        true);
    this.jpegParser.validateResult(res,
        "{2}[0]{1}('AtomicExpression')[0]{3}('SubExpression')[0]('(')");
    this.jpegParser.validateResult(res,
        "{2}[0]{1}[0]{3}[1]('ChoiceExpression')");
    this.jpegParser.validateResult(res, "{2}[0]{1}[0]{3}[2](')')");

    // res = this.jpegParser.parse("NotPredicateExpression", "!'a'", true);
    // this.jpegParser.validateResult(res,
    // "{2}[1]{1}('AtomicExpression')[0]{3}('Terminal')");
  }

  /**
   * 
   */
  @Test
  public void testRangeExpression() {
    this.jpegParser.parse("RangeExpression", "[-]", true);
    this.jpegParser.parse("RangeExpression", "[a-z]", true);
    this.jpegParser.parse("RangeExpression", "[a-z0-9]", true);
    this.jpegParser.parse("RangeExpression", "[-a-z0-9]", true);
    this.jpegParser.parse("RangeExpression", "[ab]", true);
    this.jpegParser.parse("RangeExpression", "[-9]", true);
    this.jpegParser.parse("RangeExpression", "[a-]", false);
    this.jpegParser.parse("RangeExpression", "[ab-]", false);
  }

  /**
   * 
   */
  @Test
  public void testRuleComment() {
    this.jpegParser.parse("Rule", "// Some dumb comment\nRule: Body;", true);
    this.jpegParser.parse("Rule", "// Some dumb comment Rule: Body;", false);
    this.jpegParser.parse("Rule", "// Some dumb\ncomment\nRule: Body;", false);
  }

  private static class ParserDelegate {

    private final Object parser;

    /**
     * @param parser
     */
    public ParserDelegate(final Object parser) {
      this.parser = parser;
    }

    @SuppressWarnings("unchecked")
    public void validateGrammar(final String ruleName,
        final String... nodeValidators) throws Exception {
      Field field = this.parser.getClass().getDeclaredField("rules");
      field.setAccessible(true);
      final Map<String, Object> rules = (Map<String, Object>) field.get(null);
      final Object rule = rules.get(ruleName);
      field = rule.getClass().getDeclaredField("grammarNodes");
      field.setAccessible(true);
      final Object[] nodes = (Object[]) field.get(rule);
      assertThat("Expected " + nodeValidators.length + " nodes but got "
          + nodes.length, nodes.length, is(nodeValidators.length));
      for (int i = 0; i < nodes.length; i++) {
        final String[] val = nodeValidators[i].split("#", 2);
        final Object node = nodes[i];
        field = node.getClass().getDeclaredField("matcher");
        field.setAccessible(true);
        final Object matcher = field.get(node);
        assertThat("On position " + i + " expected " + val[0] + " but got "
            + matcher.getClass().getSimpleName(), matcher.getClass()
            .getSimpleName(), is(val[0]));
        field = node.getClass().getDeclaredField("value");
        field.setAccessible(true);
        final String value = (String) field.get(node);
        assertThat("On position " + i + " expected value " + val[1]
            + " but got " + value, value, is(val[1]));
      }
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

    public void validateResult(final Object parseTree,
        final String parseTreeExpression) throws Exception {
      final Object node = parseTree.getClass().getMethod("getParseTree")
          .invoke(parseTree);
      final String expr = validate0(node, parseTreeExpression,
          parseTreeExpression);
      if (expr.length() > 0) {
        fail("Expression " + expr.replace("\n", "\\n")
            + " not completly verified");
      }
    }

    String validate0(final Object node, final String expressionTail,
        final String parseTreeExpression) throws Exception {
      String expr = expressionTail;
      if (expr.startsWith("{")) {
        final int n = Integer.parseInt(expr.substring(1, expr.indexOf('}')));
        final Method m = node.getClass().getMethod("getChildren");
        m.setAccessible(true);
        final Object[] children = (Object[]) m.invoke(node);
        expr = expr.substring(expr.indexOf('}') + 1);
        assertThat(
            "Expected "
                + n
                + " children but got "
                + children.length
                + " at "
                + parseTreeExpression.substring(0, parseTreeExpression.length()
                    - expr.length()), children.length, is(n));
      }
      if (expr.startsWith("('")) {
        String test = expr.substring(2);
        test = test.substring(0, test.indexOf("')"));
        final Method m = node.getClass().getMethod("getValue");
        m.setAccessible(true);
        final String value = (String) m.invoke(node);
        assertThat(value, is(test));
        expr = expr.substring(test.length() + 4);
      }
      if (expr.startsWith("[")) {
        final int n = Integer.parseInt(expr.substring(1, expr.indexOf(']')));
        final Method m = node.getClass().getMethod("getChildren");
        m.setAccessible(true);
        final Object[] children = (Object[]) m.invoke(node);
        expr = validate0(children[n], expr.substring(expr.indexOf(']') + 1),
            parseTreeExpression);
      }
      return expr;
    }

  }

}
