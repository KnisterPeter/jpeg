package jpeg;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import jpeg.TestParser.ParsingResult;
import de.matrixweb.jpeg.AbstractParserTests;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public class JPEGTest extends AbstractParserTests {

  /**
   * @see de.matrixweb.jpeg.AbstractParserTests#createParser()
   */
  @Override
  protected ParserDelegate createParser() {
    return new TestParserDelegateImpl(new TestParser());
  }

  /**
   * @see de.matrixweb.jpeg.AbstractParserTests#createParser(java.lang.String)
   */
  @Override
  protected ParserDelegate createParser(final String grammarPath) {
    throw new UnsupportedOperationException();
  }

  protected static class TestParserDelegateImpl implements ParserDelegate {

    private final TestParser parser;

    /**
     * @param parser
     */
    public TestParserDelegateImpl(final TestParser parser) {
      this.parser = parser;
    }

    /**
     * @see de.matrixweb.jpeg.AbstractParserTests.ParserDelegate#parse(java.lang.String,
     *      java.lang.String, boolean)
     */
    @Override
    public void parse(final String rule, final String input,
        final boolean result) {
      try {
        final Method m = this.parser.getClass().getMethod(rule, String.class);
        final ParsingResult res = (ParsingResult) m.invoke(this.parser, input);
        assertThat(res.matches(), is(result));
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

  }

}
