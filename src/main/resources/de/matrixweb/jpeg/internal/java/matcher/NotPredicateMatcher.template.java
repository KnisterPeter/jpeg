class NotPredicateMatcher extends AbstractPredicateMatcher {

  @Override
  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    return !super.matches(context, value, input);
  }

}
