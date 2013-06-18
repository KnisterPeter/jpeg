class ParsingNode {

  private final boolean isRuleNode;

  private final String value;

  private final ParsingNode[] children;

  /**
   * @param isRuleNode
   * @param value
   * @param children
   */
  public ParsingNode(final boolean isRuleNode, final String value,
      final ParsingNode[] children) {
    this.isRuleNode = isRuleNode;
    this.value = value;
    this.children = children;
  }

  /**
   * @return the isRuleNode
   */
  public boolean isRuleNode() {
    return this.isRuleNode;
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

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public String toString() {
    return this.value + "[isRuleNode=" + this.isRuleNode + ", children="
        + (this.children == null ? 0 : this.children.length) + "]";
  }

}
