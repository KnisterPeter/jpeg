package de.matrixweb.jpeg;

/**
 * @author markusw
 */
public class UnexpectedEndOfInputException extends JPEGParserException {

  private static final long serialVersionUID = -9209564372753698493L;

  /**
   * @param message
   */
  public UnexpectedEndOfInputException(final String message) {
    super(message);
  }

  /**
   * @param message
   * @param cause
   */
  public UnexpectedEndOfInputException(final String message,
      final Throwable cause) {
    super(message, cause);
  }

}
