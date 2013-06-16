class AbstractPredicateMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    return context.getParser().parse(rule, new Input(input.getChars())) != null;
  }

}
