package de.matrixweb.jpeg.internal;

import de.matrixweb.jpeg.JPEGParserException;
import de.matrixweb.jpeg.Parser;
import de.matrixweb.jpeg.ParsingResult;
import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Type;

/**
 * @author markusw
 */
public class ParserImpl implements Parser {

  /**
   * @see de.matrixweb.jpeg.Parser#parse(java.lang.String, java.lang.String)
   */
  @Override
  public ParsingResult parse(final String startRule, final String input) {
    final ParsingResultImpl result = new ParsingResultImpl();
    try {
      final InputReader reader = new InputReader(input);
      result.tree = createStartRule(startRule).match(reader);
      if (reader.hasNext()) {
        result.error = new JPEGParserException(
            "Unexpected parse end before input end");
      }
    } catch (final RuleMismatchException e) {
      result.error = e;
    } catch (final JPEGParserException e) {
      result.error = e;
    }
    return result;
  }

  @SuppressWarnings("unchecked")
  private ParserRule<? extends Type> createStartRule(final String startRule) {
    try {
      return (ParserRule<? extends Type>) Class
          .forName(
              "de.matrixweb.jpeg.internal.rules.jpeg." + startRule
                  + "$GrammarRule").newInstance();
    } catch (final InstantiationException e) {
      throw new JPEGParserException("Failed to create parser rule '"
          + startRule + "'", e);
    } catch (final IllegalAccessException e) {
      throw new JPEGParserException("Failed to create parser rule '"
          + startRule + "'", e);
    } catch (final ClassNotFoundException e) {
      throw new JPEGParserException("Failed to create parser rule '"
          + startRule + "'", e);
    }
  }

  private class ParsingResultImpl implements ParsingResult {

    private Type tree;

    private Exception error;

    /**
     * @see de.matrixweb.jpeg.ParsingResult#getTree()
     */
    @Override
    public Type getTree() {
      return this.tree;
    }

    /**
     * @see de.matrixweb.jpeg.ParsingResult#isSuccess()
     */
    @Override
    public boolean isSuccess() {
      return this.error == null;
    }

    /**
     * @see de.matrixweb.jpeg.ParsingResult#getError()
     */
    @Override
    public Exception getError() {
      return this.error;
    }

  }

}
