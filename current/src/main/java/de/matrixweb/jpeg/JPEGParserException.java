package de.matrixweb.jpeg;

/**
 * @author markusw
 */
public class JPEGParserException extends RuntimeException {

  private static final long serialVersionUID = -515426932749919690L;

  /**
   * @param message
   * @param cause
   */
  public JPEGParserException(final String message, final Throwable cause) {
    super(message, cause);
  }

  /**
   * @param message
   */
  public JPEGParserException(final String message) {
    super(message);
  }

}
