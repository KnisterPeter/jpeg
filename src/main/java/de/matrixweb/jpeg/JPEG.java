package de.matrixweb.jpeg;

import java.io.Reader;

import de.matrixweb.jpeg.internal.GrammarParser;

/**
 * @author markusw
 */
public class JPEG {

  private final GrammarParser parser;

  /**
   * @param reader
   *          A {@link Reader} to read the grammar from
   * @return Returns the parser defined in the given grammar
   */
  public static JPEG createParser(final Reader reader) {
    return new JPEG(reader);
  }

  private JPEG(final Reader reader) {
    this.parser = GrammarParser.create(reader);
  }

  /**
   * @param rule
   *          The start rule for the input
   * @param input
   *          The input to parse
   * @return Returns true if the parser accepts the given input
   */
  public ParsingResult parse(final String rule, final String input) {
    return new ParsingResult(this.parser.parse(rule, input));
  }

}
