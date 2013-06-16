package de.matrixweb.jpeg.internal.java;

import de.matrixweb.jpeg.internal.java.matcher.GrammarNodeMatcher;

/**
 * @author markusw
 */
public class GrammarNode {

  private final GrammarNodeMatcher matcher;

  private final String value;

  /**
   * @param matcher
   * @param value
   */
  public GrammarNode(final GrammarNodeMatcher matcher, final String value) {
    this.matcher = matcher;
    this.value = value;
  }

  /**
   * @return the matcher
   */
  public GrammarNodeMatcher getMatcher() {
    return this.matcher;
  }

  boolean matches(final RuleMatchingContext context, final Input input) {
    return this.matcher.matches(context, this.value, input);
  }

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public String toString() {
    return this.matcher.getClass().getSimpleName() + '[' + this.value + ']';
  }

}
