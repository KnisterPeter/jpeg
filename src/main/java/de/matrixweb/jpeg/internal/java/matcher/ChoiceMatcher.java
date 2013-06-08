package de.matrixweb.jpeg.internal.java.matcher;

import de.matrixweb.jpeg.internal.java.Input;
import de.matrixweb.jpeg.internal.java.RuleMatchingContext;

/**
 * @author markusw
 */
public class ChoiceMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    if (context.isMatch()) {
      context.endRuleMatching();
    }
    return true;
  }

}
