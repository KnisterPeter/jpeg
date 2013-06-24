class ParsingNode {

  private final boolean isRuleNode;

  private final String value;

  private final ParsingNode[] children;

  private final JavaParser.Type object;

  /**
   * @param isRuleNode
   * @param value
   */
  public ParsingNode(final boolean isRuleNode, final String value) {
    this(isRuleNode, value, null);
  }

  /**
   * @param isRuleNode
   * @param value
   * @param children
   */
  public ParsingNode(final boolean isRuleNode, final String value,
      final ParsingNode[] children) {
    this(isRuleNode, value, children, null);
  }

  /**
   * @param isRuleNode
   * @param value
   * @param children
   * @param object
   */
  public ParsingNode(final boolean isRuleNode, final String value,
      final ParsingNode[] children, final JavaParser.Type object) {
    this.isRuleNode = isRuleNode;
    this.value = value;
    this.children = children;
    this.object = object;
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
   * @return the object
   */
  public JavaParser.Type getObject() {
    return this.object;
  }

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public String toString() {
    return this.value + "[isRuleNode=" + this.isRuleNode + ", children="
        + (this.children == null ? 0 : this.children.length) + ", object="
        + this.object + "]";
  }

}
