public static class JPEGParserException extends RuntimeException {

  private static final long serialVersionUID = 0;

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
