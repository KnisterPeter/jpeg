class RuleMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    final ParsingNode result = context.getParser().parse(rule, input);
    if (result != null) {
      context.addParsingNode(result);
    }
    return result != null;
  }

}
