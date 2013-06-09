package de.matrixweb.jpeg;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author markusw
 */
public class TestParser {

  private static final Map<String, GrammarRule> rules = new HashMap<String, GrammarRule>();
  static {
    rules.put("Start", new GrammarRule("Start",
        new GrammarNode[] { new GrammarNode(GrammarNodeMatcher.ONE_OR_MORE,
            "Bla") }));
  }

  /**
   * @param startRule
   * @param input
   * @return ...
   */
  public ParsingNode parse(final String startRule, final String input) {
    return parse(startRule, new Input(input));
  }

  /**
   * @param startRule
   * @param input
   * @return ...
   */
  ParsingNode parse(final String startRule, final Input input) {
    final GrammarRule rule = TestParser.rules.get(startRule);
    if (rule == null) {
      throw new JPEGParserException("Rule '" + startRule + "' is unknown");
    }
    return rule.match(this, input);
  }

  public ParsingNode Start(final String input) {
    return parse("Start", new Input(input));
  }

}

class Input {

  private String chars;

  /**
   * @param chars
   */
  public Input(final String chars) {
    this.chars = chars;
  }

  /**
   * @return the chars
   */
  public String getChars() {
    return this.chars;
  }

  /**
   * @param chars
   *          the chars to set
   */
  public void setChars(final String chars) {
    this.chars = chars;
  }

}

class ParsingNode {

  private final String value;

  private final ParsingNode[] children;

  /**
   * @param value
   * @param children
   */
  public ParsingNode(final String value, final ParsingNode[] children) {
    this.value = value;
    this.children = children;
  }

  /**
   * @return the value
   */
  public String getValue() {
    return this.value;
  }

  /**
   * @return the children
   */
  public ParsingNode[] getChildren() {
    return this.children != null ? this.children : new ParsingNode[0];
  }

}

class RuleMatchingContext {

  private final TestParser parser;

  private boolean match = true;

  private int grammarRuleIndex = 0;

  private List<ParsingNode> parsingNodes;

  /**
   * @param parser
   */
  public RuleMatchingContext(final TestParser parser) {
    this.parser = parser;
  }

  /**
   * @return the parser
   */
  public TestParser getParser() {
    return this.parser;
  }

  /**
   * @return the match
   */
  public boolean isMatch() {
    return this.match;
  }

  /**
   * @param match
   *          the match to set
   */
  public void setMatch(final boolean match) {
    this.match = match;
  }

  /**
   * @return the grammarRuleIndex
   */
  public int getGrammarRuleIndex() {
    return this.grammarRuleIndex;
  }

  /**
   * @return the next grammarRuleIndex
   */
  int incGrammarRuleIndex() {
    return this.grammarRuleIndex++;
  }

  /**
   * @param grammarRuleIndex
   *          the grammarRuleIndex to set
   */
  public void setGrammarRuleIndex(final int grammarRuleIndex) {
    this.grammarRuleIndex = grammarRuleIndex;
  }

  /**
   * 
   */
  public void endRuleMatching() {
    this.grammarRuleIndex = Integer.MAX_VALUE;
  }

  /**
   * @return Returns the parsed child nodes
   */
  public ParsingNode[] getParsingNodes() {
    return this.parsingNodes != null ? this.parsingNodes
        .toArray(new ParsingNode[this.parsingNodes.size()]) : null;
  }

  /**
   * @param node
   */
  public void addParsingNode(final ParsingNode node) {
    if (this.parsingNodes == null) {
      this.parsingNodes = new ArrayList<ParsingNode>();
    }
    this.parsingNodes.add(node);
  }

  void clearParsingNodes() {
    this.parsingNodes = null;
  }

}

class GrammarRule {

  private final String name;

  private final GrammarNode[] grammarNodes;

  public GrammarRule(final String name, final GrammarNode[] grammarNodes) {
    this.name = name;
    this.grammarNodes = grammarNodes;
  }

  /**
   * @return the name
   */
  public String getName() {
    return this.name;
  }

  /**
   * @return the grammarNodes
   */
  public GrammarNode[] getGrammarNodes() {
    return this.grammarNodes;
  }

  public ParsingNode match(final TestParser parser, final Input input) {
    final RuleMatchingContext context = new RuleMatchingContext(parser);
    String tail = input.getChars();
    while (hasNodes(context.getGrammarRuleIndex(), this.grammarNodes)) {
      final Input newInput = new Input(tail);
      context.setMatch(getNextNode(context).matches(context, newInput));
      if (context.isMatch()) {
        tail = newInput.getChars();
      } else if (hasNodes(context.getGrammarRuleIndex(), this.grammarNodes)) {
        context.setGrammarRuleIndex(nextChoiceNode(this.grammarNodes,
            context.getGrammarRuleIndex()));
        context.clearParsingNodes();
      }
    }
    ParsingNode result = null;
    if (context.isMatch()) {
      result = new ParsingNode(this.name, context.getParsingNodes());
      input.setChars(tail);
    }
    return result;
  }

  private GrammarNode getNextNode(final RuleMatchingContext context) {
    return this.grammarNodes[context.incGrammarRuleIndex()];
  }

  private boolean hasNodes(final int n, final GrammarNode[] grammarNodes) {
    return n < grammarNodes.length;
  }

  private int nextChoiceNode(final GrammarNode[] grammarNodes, int n) {
    GrammarNode grammarNode = grammarNodes[n];
    while (grammarNode.getMatcher() != GrammarNodeMatcher.CHOICE
        && n + 1 < grammarNodes.length) {
      grammarNode = grammarNodes[++n];
    }
    return grammarNode.getMatcher() == GrammarNodeMatcher.CHOICE ? n
        : grammarNodes.length;
  }

}

class GrammarNode {

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

  /**
   * @return the value
   */
  public String getValue() {
    return this.value;
  }

  boolean matches(final RuleMatchingContext context, final Input input) {
    return getMatcher().matches(context, getValue(), input);
  }

}

interface GrammarNodeMatcher {

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

class OneOrMoreMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    final List<ParsingNode> parsingNodes = new ArrayList<ParsingNode>();
    final Input newInput = new Input(input.getChars());
    final ParsingNode result = context.getParser().parse(rule, newInput);
    if (result != null) {
      parsingNodes.add(result);
      newInput.setChars(newInput.getChars());

      ParsingNode nextMatch = context.getParser().parse(rule, newInput);
      while (nextMatch != null) {
        parsingNodes.add(nextMatch);
        newInput.setChars(newInput.getChars());
        nextMatch = context.getParser().parse(rule, newInput);
      }
    }
    if (parsingNodes.size() > 0) {
      context.addParsingNode(new ParsingNode(rule, parsingNodes
          .toArray(new ParsingNode[parsingNodes.size()])));
    }
    input.setChars(newInput.getChars());
    return result != null;
  }

}

class TerminalMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context,
      final String terminal, final Input input) {
    final boolean match = input.getChars().startsWith(terminal);
    if (match) {
      context.addParsingNode(new ParsingNode('\'' + terminal + '\'', null));
      input.setChars(input.getChars().substring(terminal.length()));
    }
    return match;
  }

}

class ChoiceMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    if (context.isMatch()) {
      context.endRuleMatching();
    }
    return true;
  }

}

class ZeroOrMoreMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    final List<ParsingNode> parsingNodes = new ArrayList<ParsingNode>();
    final Input newInput = new Input(input.getChars());
    ParsingNode result = context.getParser().parse(rule, newInput);
    while (result != null) {
      parsingNodes.add(result);
      newInput.setChars(newInput.getChars());
      result = context.getParser().parse(rule, newInput);
    }
    if (parsingNodes.size() > 0) {
      context.addParsingNode(new ParsingNode(rule, parsingNodes
          .toArray(new ParsingNode[parsingNodes.size()])));
    }
    input.setChars(newInput.getChars());
    return true;
  }

}

class OptionalMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    final Input newInput = new Input(input.getChars());
    final ParsingNode result = context.getParser().parse(rule, newInput);
    if (result != null) {
      context
          .addParsingNode(new ParsingNode(rule, new ParsingNode[] { result }));
      input.setChars(newInput.getChars());
    }
    return true;
  }

}

class AnyCharMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    final boolean match = input.getChars().length() > 0;
    if (match) {
      context.addParsingNode(new ParsingNode('\'' + input.getChars().substring(
          0, 1) + '\'', null));
      input.setChars(input.getChars().substring(1));
    }
    return match;
  }

}

class EndOfInputMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    return input.getChars().length() == 0;
  }

}

class RuleMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    final ParsingNode result = context.getParser().parse(rule, input);
    if (result != null) {
      context.addParsingNode(result);
    }
    return result != null;
  }

}

abstract class AbstractPredicateMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    return context.getParser().parse(rule, new Input(input.getChars())) != null;
  }

}

class AndPredicateMatcher extends AbstractPredicateMatcher {

  @Override
  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    return super.matches(context, value, input);
  }

}

class NotPredicateMatcher extends AbstractPredicateMatcher {

  @Override
  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    return !super.matches(context, value, input);
  }

}
