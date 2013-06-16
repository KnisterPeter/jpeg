package de.matrixweb.jpeg.internal.java.matcher;

import de.matrixweb.jpeg.internal.java.Input;
import de.matrixweb.jpeg.internal.java.ParsingNode;
import de.matrixweb.jpeg.internal.java.RuleMatchingContext;

/**
 * @author markusw
 */
public class RuleMatcher implements GrammarNodeMatcher {

  @Override
  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    final ParsingNode result = context.getParser().parse(rule, input);
    if (result != null) {
      context.addParsingNode(result);
    }
    return result != null;
  }

}
