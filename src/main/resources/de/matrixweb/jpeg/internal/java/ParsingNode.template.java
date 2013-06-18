class ParsingNode {

  private final boolean ruleNode;

  private final String value;

  private final ParsingNode[] children;

  /**
   * @param value
   * @param children
   */
  public ParsingNode(final String value, final ParsingNode[] children) {
    this(false, value, children);
  }

  /**
   * @param value
   * @param children
   */
  public ParsingNode(final boolean ruleNode, final String value, final ParsingNode[] children) {
    this.ruleNode = ruleNode;
    this.value = value;
    this.children = children;
  }

  public boolean isRuleNode() {
    return this.ruleNode;
  }

  /**
   * @return the value
   */
  public String getValue() {
    return this.value;
  }

  /**
   * @return the children
   */
  public ParsingNode[] getChildren() {
    return this.children != null ? this.children : new ParsingNode[0];
  }

}
