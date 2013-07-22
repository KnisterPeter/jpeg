package de.matrixweb.jpeg;

import de.matrixweb.jpeg.internal.type.Type;

/**
 * @author markusw
 */
public interface ParsingResult {

  /**
   * @return
   */
  boolean isSuccess();

  /**
   * @return
   */
  Exception getError();

  /**
   * @return
   */
  Type getTree();

}
