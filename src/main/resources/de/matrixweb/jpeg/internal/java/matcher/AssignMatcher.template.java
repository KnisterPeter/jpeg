class AssignMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    final ParsingNode result = context.getParser().parse(rule, input);
    System.out.println("Matching Result to Assign: " + result);
    if (result != null) {
      context.addParsingNode(result);
    }
    return result != null;
  }

}
