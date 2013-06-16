package de.matrixweb.jpeg.internal.java.matcher;

import de.matrixweb.jpeg.internal.java.Input;
import de.matrixweb.jpeg.internal.java.ParsingNode;
import de.matrixweb.jpeg.internal.java.RuleMatchingContext;

/**
 * @author markusw
 */
public class OptionalMatcher implements GrammarNodeMatcher {

  @Override
  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    final Input newInput = new Input(input.getChars());
    final ParsingNode result = context.getParser().parse(rule, newInput);
    if (result != null) {
      context.addParsingNode(result);
      // context
      // .addParsingNode(new ParsingNode(rule, new ParsingNode[] { result }));
      input.setChars(newInput.getChars());
    }
    return true;
  }

}
