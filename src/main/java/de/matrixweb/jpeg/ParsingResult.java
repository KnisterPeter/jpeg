package de.matrixweb.jpeg;

import de.matrixweb.jpeg.internal.type.Type;

/**
 * @author markusw
 */
public interface ParsingResult {

  /**
   * @return Returns true if the parsing finished without error, false otherwise
   */
  boolean isSuccess();

  /**
   * @return Returns a parser error occured during parsing
   */
  Exception getError();

  /**
   * @return Returns the parse tree (AST) if there was no error during parsing,
   *         null otherwise
   */
  Type<?> getTree();

}
