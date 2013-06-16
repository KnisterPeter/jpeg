public static class ParsingResult {

  private final ParsingNode parseTree;

  /**
   * @param parseTree
   */
  public ParsingResult(final ParsingNode parseTree) {
    this.parseTree = parseTree;
  }

  /**
   * @return True if parsing was successful, false otherwise
   */
  public boolean matches() {
    return this.parseTree != null;
  }

  /**
   * @return the parseTree
   */
  public ParsingNode getParseTree() {
    return this.parseTree;
  }

}
