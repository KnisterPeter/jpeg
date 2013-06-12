package test;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import de.matrixweb.jpeg.AbstractParserTests;
import de.matrixweb.jpeg.JPEGParser;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public class ParserTest extends AbstractParserTests {

  /**
   * @see de.matrixweb.jpeg.AbstractParserTests#createParser()
   */
  @Override
  protected ParserDelegate createParser() {
    return new ParserDelegateImpl(new TestParser());
  }

  /**
   * @see de.matrixweb.jpeg.AbstractParserTests#createJPEGParser()
   */
  @Override
  protected ParserDelegate createJPEGParser() throws Exception {
    return new ParserDelegateImpl(new JPEGParser());
  }

  protected static class ParserDelegateImpl implements ParserDelegate {

    private final Object parser;

    /**
     * @param parser
     */
    public ParserDelegateImpl(final Object parser) {
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
        final Object res = m.invoke(this.parser, input);
        assertThat((Boolean) res.getClass().getMethod("matches").invoke(res),
            is(result));
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
