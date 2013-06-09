class EndOfInputMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    return input.getChars().length() == 0;
  }

}
