package de.matrixweb.jpeg;

/**
 * @author markusw
 */
public class JPEGParserException extends RuntimeException {

  private static final long serialVersionUID = 643518539969475932L;

  /**
   * @param message
   */
  public JPEGParserException(final String message) {
    super(message);
  }

  /**
   * @param message
   * @param cause
   */
  public JPEGParserException(final String message, final Throwable cause) {
    super(message, cause);
  }

}
