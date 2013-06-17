package de.matrixweb.jpeg.internal;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author markusw
 */
public class JPEGParser {

  private static final Map<String, GrammarRule> rules = new HashMap<String, GrammarRule>();
  static {
        rules.put("JPEG", new GrammarRule("JPEG", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.ONE_OR_MORE, "Rule"),
                new GrammarNode(GrammarNodeMatcher.EOI, ""),
              }));
        rules.put("Rule", new GrammarRule("Rule", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.RULE, "Name"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
                new GrammarNode(GrammarNodeMatcher.RULE, "COLON"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
                new GrammarNode(GrammarNodeMatcher.RULE, "Body"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
                new GrammarNode(GrammarNodeMatcher.RULE, "SEMI"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
              }));
        rules.put("internal_Name_1", new GrammarRule("internal_Name_1", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.RULE, "WS"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "COLON"),
              }));
        rules.put("internal_Name_0", new GrammarRule("internal_Name_0", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.NOT_PREDICATE, "internal_Name_1"),
                new GrammarNode(GrammarNodeMatcher.ANY_CHAR, ""),
              }));
        rules.put("Name", new GrammarRule("Name", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.ONE_OR_MORE, "internal_Name_0"),
              }));
        rules.put("internal_Body_0", new GrammarRule("internal_Body_0", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.RULE, "ChoiceExpression"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
              }));
        rules.put("Body", new GrammarRule("Body", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.ONE_OR_MORE, "internal_Body_0"),
              }));
        rules.put("ChoiceExpression", new GrammarRule("ChoiceExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.RULE, "SequenceExpression"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "ChoiceExpressionPart"),
              }));
        rules.put("ChoiceExpressionPart", new GrammarRule("ChoiceExpressionPart", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "|"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
                new GrammarNode(GrammarNodeMatcher.RULE, "SequenceExpression"),
              }));
        rules.put("internal_SequenceExpression_1", new GrammarRule("internal_SequenceExpression_1", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.RULE, "Terminal"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "AnyCharExpression"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "EndOfInputExpression"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "AndPredicateExpression"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "NotPredicateExpression"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "OneOrMoreExpression"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "ZeroOrMoreExpression"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "OptionalExpression"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "AtomicExpression"),
              }));
        rules.put("internal_SequenceExpression_0", new GrammarRule("internal_SequenceExpression_0", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.RULE, "internal_SequenceExpression_1"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
              }));
        rules.put("SequenceExpression", new GrammarRule("SequenceExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.ONE_OR_MORE, "internal_SequenceExpression_0"),
              }));
        rules.put("AndPredicateExpression", new GrammarRule("AndPredicateExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "&"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
                new GrammarNode(GrammarNodeMatcher.RULE, "AtomicExpression"),
              }));
        rules.put("NotPredicateExpression", new GrammarRule("NotPredicateExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "!"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
                new GrammarNode(GrammarNodeMatcher.RULE, "AtomicExpression"),
              }));
        rules.put("OneOrMoreExpression", new GrammarRule("OneOrMoreExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.RULE, "AtomicExpression"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "+"),
              }));
        rules.put("ZeroOrMoreExpression", new GrammarRule("ZeroOrMoreExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.RULE, "AtomicExpression"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "*"),
              }));
        rules.put("OptionalExpression", new GrammarRule("OptionalExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.RULE, "AtomicExpression"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "?"),
              }));
        rules.put("AtomicExpression", new GrammarRule("AtomicExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.RULE, "SubExpression"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "RuleReferenceExpression"),
              }));
        rules.put("SubExpression", new GrammarRule("SubExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "("),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
                new GrammarNode(GrammarNodeMatcher.RULE, "ChoiceExpression"),
                new GrammarNode(GrammarNodeMatcher.ZERO_OR_MORE, "WS"),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, ")"),
              }));
        rules.put("AnyCharExpression", new GrammarRule("AnyCharExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "."),
              }));
        rules.put("EndOfInputExpression", new GrammarRule("EndOfInputExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "EOI"),
              }));
        rules.put("internal_RuleReferenceExpression_0", new GrammarRule("internal_RuleReferenceExpression_0", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.NOT_PREDICATE, "RuleReferenceEnd"),
                new GrammarNode(GrammarNodeMatcher.ANY_CHAR, ""),
              }));
        rules.put("RuleReferenceExpression", new GrammarRule("RuleReferenceExpression", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.ONE_OR_MORE, "internal_RuleReferenceExpression_0"),
              }));
        rules.put("RuleReferenceEnd", new GrammarRule("RuleReferenceEnd", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "+"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "*"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "?"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "|"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "QUOTE"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "&"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "!"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "SEMI"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.RULE, "WS"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "("),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, ")"),
              }));
        rules.put("Terminal", new GrammarRule("Terminal", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.RULE, "QUOTE"),
                new GrammarNode(GrammarNodeMatcher.OPTIONAL, "InTerminalChar"),
                new GrammarNode(GrammarNodeMatcher.RULE, "QUOTE"),
              }));
        rules.put("internal_InTerminalChar_0", new GrammarRule("internal_InTerminalChar_0", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "\\"),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "'"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "\\"),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "\\"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.NOT_PREDICATE, "QUOTE"),
                new GrammarNode(GrammarNodeMatcher.ANY_CHAR, ""),
              }));
        rules.put("InTerminalChar", new GrammarRule("InTerminalChar", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.ONE_OR_MORE, "internal_InTerminalChar_0"),
              }));
        rules.put("WS", new GrammarRule("WS", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, " "),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "\n"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "\t"),
                new GrammarNode(GrammarNodeMatcher.CHOICE, ""),
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "\r"),
              }));
        rules.put("COLON", new GrammarRule("COLON", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, ":"),
              }));
        rules.put("SEMI", new GrammarRule("SEMI", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, ";"),
              }));
        rules.put("QUOTE", new GrammarRule("QUOTE", new GrammarNode[] {
                new GrammarNode(GrammarNodeMatcher.TERMINAL, "'"),
              }));
      }

  /**
   * @param startRule
   * @param input
   * @return ...
   */
  ParsingNode parse(final String startRule, final Input input) {
    final GrammarRule rule = JPEGParser.rules.get(startRule);
    if (rule == null) {
      throw new JPEGParserException("Rule '" + startRule + "' is unknown");
    }
    return rule.match(this, input);
  }

    public static ParsingResult JPEG(final String input) {
    return new ParsingResult(new JPEGParser().parse("JPEG", new Input(input)));
  }
  
    public static ParsingResult Rule(final String input) {
    return new ParsingResult(new JPEGParser().parse("Rule", new Input(input)));
  }
  
    public static ParsingResult internal_Name_1(final String input) {
    return new ParsingResult(new JPEGParser().parse("internal_Name_1", new Input(input)));
  }
  
    public static ParsingResult internal_Name_0(final String input) {
    return new ParsingResult(new JPEGParser().parse("internal_Name_0", new Input(input)));
  }
  
    public static ParsingResult Name(final String input) {
    return new ParsingResult(new JPEGParser().parse("Name", new Input(input)));
  }
  
    public static ParsingResult internal_Body_0(final String input) {
    return new ParsingResult(new JPEGParser().parse("internal_Body_0", new Input(input)));
  }
  
    public static ParsingResult Body(final String input) {
    return new ParsingResult(new JPEGParser().parse("Body", new Input(input)));
  }
  
    public static ParsingResult ChoiceExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("ChoiceExpression", new Input(input)));
  }
  
    public static ParsingResult ChoiceExpressionPart(final String input) {
    return new ParsingResult(new JPEGParser().parse("ChoiceExpressionPart", new Input(input)));
  }
  
    public static ParsingResult internal_SequenceExpression_1(final String input) {
    return new ParsingResult(new JPEGParser().parse("internal_SequenceExpression_1", new Input(input)));
  }
  
    public static ParsingResult internal_SequenceExpression_0(final String input) {
    return new ParsingResult(new JPEGParser().parse("internal_SequenceExpression_0", new Input(input)));
  }
  
    public static ParsingResult SequenceExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("SequenceExpression", new Input(input)));
  }
  
    public static ParsingResult AndPredicateExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("AndPredicateExpression", new Input(input)));
  }
  
    public static ParsingResult NotPredicateExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("NotPredicateExpression", new Input(input)));
  }
  
    public static ParsingResult OneOrMoreExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("OneOrMoreExpression", new Input(input)));
  }
  
    public static ParsingResult ZeroOrMoreExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("ZeroOrMoreExpression", new Input(input)));
  }
  
    public static ParsingResult OptionalExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("OptionalExpression", new Input(input)));
  }
  
    public static ParsingResult AtomicExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("AtomicExpression", new Input(input)));
  }
  
    public static ParsingResult SubExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("SubExpression", new Input(input)));
  }
  
    public static ParsingResult AnyCharExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("AnyCharExpression", new Input(input)));
  }
  
    public static ParsingResult EndOfInputExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("EndOfInputExpression", new Input(input)));
  }
  
    public static ParsingResult internal_RuleReferenceExpression_0(final String input) {
    return new ParsingResult(new JPEGParser().parse("internal_RuleReferenceExpression_0", new Input(input)));
  }
  
    public static ParsingResult RuleReferenceExpression(final String input) {
    return new ParsingResult(new JPEGParser().parse("RuleReferenceExpression", new Input(input)));
  }
  
    public static ParsingResult RuleReferenceEnd(final String input) {
    return new ParsingResult(new JPEGParser().parse("RuleReferenceEnd", new Input(input)));
  }
  
    public static ParsingResult Terminal(final String input) {
    return new ParsingResult(new JPEGParser().parse("Terminal", new Input(input)));
  }
  
    public static ParsingResult internal_InTerminalChar_0(final String input) {
    return new ParsingResult(new JPEGParser().parse("internal_InTerminalChar_0", new Input(input)));
  }
  
    public static ParsingResult InTerminalChar(final String input) {
    return new ParsingResult(new JPEGParser().parse("InTerminalChar", new Input(input)));
  }
  
    public static ParsingResult WS(final String input) {
    return new ParsingResult(new JPEGParser().parse("WS", new Input(input)));
  }
  
    public static ParsingResult COLON(final String input) {
    return new ParsingResult(new JPEGParser().parse("COLON", new Input(input)));
  }
  
    public static ParsingResult SEMI(final String input) {
    return new ParsingResult(new JPEGParser().parse("SEMI", new Input(input)));
  }
  
    public static ParsingResult QUOTE(final String input) {
    return new ParsingResult(new JPEGParser().parse("QUOTE", new Input(input)));
  }
  
  
  // reference ParsingResult.template.java
public static class ParsingResult {

  private final ParsingNode parseTree;

  /**
   * @param parseTree
   */
  public ParsingResult(final ParsingNode parseTree) {
    this.parseTree = parseTree;
  }

  /**
   * @return True if parsing was successful, false otherwise
   */
  public boolean matches() {
    return this.parseTree != null;
  }

  /**
   * @return the parseTree
   */
  public ParsingNode getParseTree() {
    return this.parseTree;
  }

}
  // reference Utils.template.java
public static class Utils {

  /**
   * @param result
   * @return Returns the parsing tree as {@link String}
   */
  public static String formatParsingTree(final ParsingResult result) {
    final StringBuilder sb = new StringBuilder();
    sb.append(formatParsingNode(result.getParseTree(), 0));
    return sb.toString();
  }

  /**
   * @param node The {@link ParsingNode} to print out
   * @param n The indention level
   * @return Returns the {@link ParsingNode} as {@link String}
   */
  public static String formatParsingNode(final ParsingNode node, final int n) {
    final StringBuilder indent = new StringBuilder();
    for (int i = 0; i < n; i++) {
      indent.append('\t');
    }

    final StringBuilder sb = new StringBuilder();
    sb.append(indent).append(node.getValue()).append('\n');
    for (final ParsingNode child : node.getChildren()) {
      sb.append(formatParsingNode(child, n + 1));
    }
    return sb.toString();
  }

}
  // reference JPEGParserException.template.java
public static class JPEGParserException extends RuntimeException {

  private static final long serialVersionUID = 0;

  /**
   * @param message
   * @param cause
   */
  public JPEGParserException(final String message, final Throwable cause) {
    super(message, cause);
  }

  /**
   * @param message
   */
  public JPEGParserException(final String message) {
    super(message);
  }

}

}
// reference ParsingNode.template.java
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
// reference GrammarNode.template.java
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

  boolean matches(final RuleMatchingContext context, final Input input) {
    return this.matcher.matches(context, this.value, input);
  }

  @Override
  public String toString() {
    return this.matcher.getClass().getSimpleName() + '[' + this.value + ']';
  }

}
// reference GrammarRule.template.java
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

  public ParsingNode match(final JPEGParser parser, final Input input) {
    final RuleMatchingContext context = new RuleMatchingContext(parser);
    String tail = input.getChars();
    while (hasNodes(context.getGrammarRuleIndex(), this.grammarNodes)) {
      final Input newInput = new Input(tail);
      GrammarNode next = getNextNode(context);
      context.setMatch(next.matches(context, newInput));
      if (context.isMatch()) {
        tail = newInput.getChars();
      } else if (hasNodes(context.getGrammarRuleIndex(), this.grammarNodes)) {
        tail = input.getChars();
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

  @Override
  public String toString() {
    return getName() + '{' + Arrays.toString(getGrammarNodes()) + '}';
  }

}
// reference Input.template.java
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
// reference RuleMatchingContext.template.java
class RuleMatchingContext {

  private final JPEGParser parser;

  private boolean match = true;

  private int grammarRuleIndex = 0;

  private List<ParsingNode> parsingNodes;

  /**
   * @param parser
   */
  public RuleMatchingContext(final JPEGParser parser) {
    this.parser = parser;
  }

  /**
   * @return the parser
   */
  public JPEGParser getParser() {
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
// reference matcher/AbstractPredicateMatcher.template.java
class AbstractPredicateMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String rule,
      final Input input) {
    return context.getParser().parse(rule, new Input(input.getChars())) != null;
  }

}
// reference matcher/AndPredicateMatcher.template.java
class AndPredicateMatcher extends AbstractPredicateMatcher {

  @Override
  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    return super.matches(context, value, input);
  }

}
// reference matcher/AnyCharMatcher.template.java
class AnyCharMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    final boolean match = input.getChars().length() > 0;
    if (match) {
      context.addParsingNode(new ParsingNode(input.getChars().substring(0, 1),
          null));
      input.setChars(input.getChars().substring(1));
    }
    return match;
  }

}
// reference matcher/ChoiceMatcher.template.java
class ChoiceMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    if (context.isMatch()) {
      context.endRuleMatching();
    }
    return true;
  }

}
// reference matcher/EndOfInputMatcher.template.java
class EndOfInputMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    return input.getChars().length() == 0;
  }

}
// reference matcher/GrammarNodeMatcher.template.java
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
// reference matcher/NotPredicateMatcher.template.java
class NotPredicateMatcher extends AbstractPredicateMatcher {

  @Override
  public boolean matches(final RuleMatchingContext context, final String value,
      final Input input) {
    return !super.matches(context, value, input);
  }

}
// reference matcher/OneOrMoreMatcher.template.java
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
      for (final ParsingNode node : parsingNodes) {
        context.addParsingNode(node);
      }
    }
    input.setChars(newInput.getChars());
    return result != null;
  }

}
// reference matcher/OptionalMatcher.template.java
class OptionalMatcher implements GrammarNodeMatcher {

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
// reference matcher/RuleMatcher.template.java
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
// reference matcher/TerminalMatcher.template.java
class TerminalMatcher implements GrammarNodeMatcher {

  public boolean matches(final RuleMatchingContext context,
      final String terminal, final Input input) {
    final boolean match = input.getChars().startsWith(terminal);
    if (match) {
      context.addParsingNode(new ParsingNode(terminal, null));
      input.setChars(input.getChars().substring(terminal.length()));
    }
    return match;
  }

}
// reference matcher/ZeroOrMoreMatcher.template.java
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
      for (final ParsingNode node : parsingNodes) {
        context.addParsingNode(node);
      }
    }
    input.setChars(newInput.getChars());
    return true;
  }

}
