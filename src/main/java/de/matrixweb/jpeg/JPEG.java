package de.matrixweb.jpeg;

import java.io.Reader;

import de.matrixweb.jpeg.internal.ParserImpl;
import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.rules.jpeg.Rule;

/**
 * @author markusw
 */
public class JPEG {

  private final InputReader reader;

  /**
   * @param grammar
   * @return
   */
  public static Parser create(final Reader grammar) {
    return new JPEG(new InputReader(grammar)).read();
  }

  /**
   * @param grammar
   * @return
   */
  public static Parser create(final String grammar) {
    return new JPEG(new InputReader(grammar)).read();
  }

  private JPEG(final InputReader reader) {
    this.reader = reader;
  }

  private Parser read() {
    try {
      final de.matrixweb.jpeg.internal.rules.jpeg.JPEG jpeg = new de.matrixweb.jpeg.internal.rules.jpeg.JPEG.GrammarRule()
          .match(this.reader);
      // TODO: Start code generation and add to ParserImpl
      for (final Rule rule : jpeg.getRules()) {
        System.out.println("Rule:\n" + rule);
      }
      final ParserImpl parser = new ParserImpl();
      return parser;
    } catch (final UnexpectedEndOfInputException e) {
      throw new JPEGParserException("Failed to create parser from grammar", e);
    } catch (final RuleMismatchException e) {
      throw new JPEGParserException("Failed to create parser from grammar", e);
    }
  }

}
