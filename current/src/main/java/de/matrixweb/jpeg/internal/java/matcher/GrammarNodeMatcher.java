package de.matrixweb.jpeg.internal.java.matcher;

import de.matrixweb.jpeg.internal.java.Input;
import de.matrixweb.jpeg.internal.java.RuleMatchingContext;

/**
 * @author markusw
 */
public interface GrammarNodeMatcher {

  /** */
  public static final GrammarNodeMatcher TERMINAL = new TerminalMatcher();
  /** */
  public static final GrammarNodeMatcher CHOICE = new ChoiceMatcher();
  /** */
  public static final GrammarNodeMatcher ONE_OR_MORE = new OneOrMoreMatcher();
  /** */
  public static final GrammarNodeMatcher ZERO_OR_MORE = new ZeroOrMoreMatcher();
  /** */
  public static final GrammarNodeMatcher OPTIONAL = new OptionalMatcher();
  /** */
  public static final GrammarNodeMatcher ANY_CHAR = new AnyCharMatcher();
  /** */
  public static final GrammarNodeMatcher EOI = new EndOfInputMatcher();
  /** */
  public static final GrammarNodeMatcher RULE = new RuleMatcher();
  /** */
  public static final GrammarNodeMatcher AND_PREDICATE = new AndPredicateMatcher();
  /** */
  public static final GrammarNodeMatcher NOT_PREDICATE = new NotPredicateMatcher();

  /**
   * @param context
   *          The current evaluation context of the calling rule
   * @param value
   *          The rule body value part triggering this matcher
   * @param input
   *          The input to check against
   * @return Returns true if this matcher matches, false otherwise
   */
  boolean matches(RuleMatchingContext context, final String value,
      final Input input);

}
