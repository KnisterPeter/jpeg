class AnyCharMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    final boolean match = input.getChars().length() > 0;
    if (match) {
      context.addParsingNode(new ParsingNode(input.getChars().substring(0, 1),
          null));
      input.setChars(input.getChars().substring(1));
    }
    return match;
  }

}
