package de.matrixweb.jpeg.internal.java.matcher;

import de.matrixweb.jpeg.internal.java.Input;
import de.matrixweb.jpeg.internal.java.RuleMatchingContext;

/**
 * @author markusw
 */
abstract class AbstractPredicateMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    return context.getParser().parse(rule, new Input(input.getChars())) != null;
  }

}
