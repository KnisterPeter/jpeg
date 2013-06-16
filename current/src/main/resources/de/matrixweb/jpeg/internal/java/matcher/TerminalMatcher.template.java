class TerminalMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context,
      final String terminal, final Input input) {
    final boolean match = input.getChars().startsWith(terminal);
    if (match) {
      context.addParsingNode(new ParsingNode(terminal, null));
      input.setChars(input.getChars().substring(terminal.length()));
    }
    return match;
  }

}
