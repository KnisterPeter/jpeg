public static class Utils {

  /**
   * @param result
   * @return Returns the parsing tree as {@link String}
   */
  public static String formatParsingTree(final ParsingResult result) {
    final StringBuilder sb = new StringBuilder();
    sb.append(formatParsingNode(result.getParseTree(), 0));
    return sb.toString();
  }

  /**
   * @param node The {@link ParsingNode} to print out
   * @param n The indention level
   * @return Returns the {@link ParsingNode} as {@link String}
   */
  public static String formatParsingNode(final ParsingNode node, final int n) {
    final StringBuilder indent = new StringBuilder();
    for (int i = 0; i < n; i++) {
      indent.append('\t');
    }

    final StringBuilder sb = new StringBuilder();
    sb.append(indent).append(node.getValue()).append('\n');
    for (final ParsingNode child : node.getChildren()) {
      sb.append(formatParsingNode(child, n + 1));
    }
    return sb.toString();
  }

}
