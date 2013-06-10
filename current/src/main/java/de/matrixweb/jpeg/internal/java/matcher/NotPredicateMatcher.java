package de.matrixweb.jpeg.internal.java.matcher;

import de.matrixweb.jpeg.internal.java.Input;
import de.matrixweb.jpeg.internal.java.RuleMatchingContext;

/**
 * @author markusw
 */
public class NotPredicateMatcher extends AbstractPredicateMatcher {

  @Override
  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    return !super.matches(context, value, input);
  }

}
