package de.matrixweb.jpeg.internal.rules.jpeg;

/**
 * @author markusw
 */
public final class StaticRules {

  private StaticRules() {
  }

  /**
   * @return
   */
  public static final ActionExpression.GrammarRule ActionExpression() {
    return new ActionExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final AndPredicateExpression.GrammarRule AndPredicateExpression() {
    return new AndPredicateExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final AnyCharExpression.GrammarRule AnyCharExpression() {
    return new AnyCharExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final AtomicExpression.GrammarRule AtomicExpression() {
    return new AtomicExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final AssignableExpression.GrammarRule AssignableExpression() {
    return new AssignableExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final AssignmentOperator.GrammarRule AssignmentOperator() {
    return new AssignmentOperator.GrammarRule();
  }

  /**
   * @return
   */
  public static final Body.GrammarRule Body() {
    return new Body.GrammarRule();
  }

  /**
   * @return
   */
  public static final CharRange.GrammarRule CharRange() {
    return new CharRange.GrammarRule();
  }

  /**
   * @return
   */
  public static final ChoiceExpression.GrammarRule ChoiceExpression() {
    return new ChoiceExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final Comment.GrammarRule Comment() {
    return new Comment.GrammarRule();
  }

  /**
   * @return
   */
  public static final EndOfInputExpression.GrammarRule EndOfInputExpression() {
    return new EndOfInputExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final FQTN.GrammarRule FQTN() {
    return new FQTN.GrammarRule();
  }

  /**
   * @return
   */
  public static final ID.GrammarRule ID() {
    return new ID.GrammarRule();
  }

  /**
   * @return
   */
  public static final InTerminalChar.GrammarRule InTerminalChar() {
    return new InTerminalChar.GrammarRule();
  }

  /**
   * @return
   */
  public static final MinMaxRange.GrammarRule MinMaxRange() {
    return new MinMaxRange.GrammarRule();
  }

  /**
   * @return
   */
  public static final NotPredicateExpression.GrammarRule NotPredicateExpression() {
    return new NotPredicateExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final OneOrMoreExpression.GrammarRule OneOrMoreExpression() {
    return new OneOrMoreExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final OptionalExpression.GrammarRule OptionalExpression() {
    return new OptionalExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final RangeExpression.GrammarRule RangeExpression() {
    return new RangeExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final Rule.GrammarRule Rule() {
    return new Rule.GrammarRule();
  }

  /**
   * @return
   */
  public static final RuleReferenceExpression.GrammarRule RuleReferenceExpression() {
    return new RuleReferenceExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final RuleReturns.GrammarRule RuleReturns() {
    return new RuleReturns.GrammarRule();
  }

  /**
   * @return
   */
  public static final SequenceExpression.GrammarRule SequenceExpression() {
    return new SequenceExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final SubExpression.GrammarRule SubExpression() {
    return new SubExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final TerminalExpression.GrammarRule TerminalExpression() {
    return new TerminalExpression.GrammarRule();
  }

  /**
   * @return
   */
  public static final WS.GrammarRule WS() {
    return new WS.GrammarRule();
  }

  /**
   * @return
   */
  public static final ZeroOrMoreExpression.GrammarRule ZeroOrMoreExpression() {
    return new ZeroOrMoreExpression.GrammarRule();
  }

}
