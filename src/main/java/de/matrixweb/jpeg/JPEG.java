package de.matrixweb.jpeg;

import java.io.Reader;

import de.matrixweb.jpeg.internal.ParserImpl;
import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.rules.jpeg.Rule;

/**
 * This is the main entry point for the JPGE parser generator.
 * 
 * @author markusw
 */
public class JPEG {

  private final InputReader reader;

  /**
   * @param grammar
   *          The grammar to parse
   * @return Returns a generated {@link Parser} for the given grammar
   */
  public static Parser create(final Reader grammar) {
    return new JPEG(new InputReader(grammar)).read();
  }

  /**
   * @param grammar
   *          The grammar to parse
   * @return Returns a generated {@link Parser} for the given grammar
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
      generate(jpeg);
      final ParserImpl parser = new ParserImpl();
      return parser;
    } catch (final UnexpectedEndOfInputException e) {
      throw new JPEGParserException("Failed to create parser from grammar", e);
    } catch (final RuleMismatchException e) {
      throw new JPEGParserException("Failed to create parser from grammar", e);
    }
  }

  private void generate(final de.matrixweb.jpeg.internal.rules.jpeg.JPEG jpeg) {
    // TODO: Start code generation and add to ParserImpl
    for (final Rule rule : jpeg.getRules()) {
      System.out.println("Rule:\n" + rule);
    }
  }

}
