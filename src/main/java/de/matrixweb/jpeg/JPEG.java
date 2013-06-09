package de.matrixweb.jpeg;

import java.io.Reader;

import de.matrixweb.jpeg.internal.GrammarParser;

/**
 * @author markusw
 */
public class JPEG {

  /**
   * @param reader
   *          A {@link Reader} to read the grammar from
   * @param generator
   *          The code generator to use
   * @return Returns the parser defined in the given grammar
   */
  public static Parser createParser(final Reader reader,
      final CodeGenerator generator) {
    return generator.buildInterpreter(GrammarParser.create(reader));
  }

  public static String createParser2(final Reader reader,
      final CodeGenerator generator) {
    return generator.build(GrammarParser.create(reader));
  }

}
