class ChoiceMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    if (context.isMatch()) {
      context.endRuleMatching();
    }
    return true;
  }

}
