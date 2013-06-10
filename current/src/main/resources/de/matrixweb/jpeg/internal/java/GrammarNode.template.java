class GrammarNode {

  private final GrammarNodeMatcher matcher;

  private final String value;

  /**
   * @param matcher
   * @param value
   */
  public GrammarNode(final GrammarNodeMatcher matcher, final String value) {
    this.matcher = matcher;
    this.value = value;
  }

  /**
   * @return the matcher
   */
  public GrammarNodeMatcher getMatcher() {
    return this.matcher;
  }

  /**
   * @return the value
   */
  public String getValue() {
    return this.value;
  }

  boolean matches(final RuleMatchingContext context, final Input input) {
    return getMatcher().matches(context, getValue(), input);
  }

}
