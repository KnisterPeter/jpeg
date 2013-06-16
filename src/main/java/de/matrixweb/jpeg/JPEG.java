package de.matrixweb.jpeg;

import java.io.Reader;

import de.matrixweb.jpeg.internal.GrammarParser;

/**
 * @author markusw
 */
public class JPEG {

  /**
   * @param reader
   *          The grammar to parse
   * @param generator
   *          The code generator to use
   * @return Returns the source code of the created parser
   */
  public static String createParser(final Reader reader,
      final CodeGenerator generator) {
    return generator.build(GrammarParser.create(reader));
  }

}
