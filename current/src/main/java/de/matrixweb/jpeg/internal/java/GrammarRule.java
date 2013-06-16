package de.matrixweb.jpeg.internal.java;

import java.util.Arrays;

import de.matrixweb.jpeg.internal.java.JavaGenerator.JavaParser;
import de.matrixweb.jpeg.internal.java.matcher.GrammarNodeMatcher;

/**
 * @author markusw
 */
class GrammarRule {

  @Deprecated
  private static int indent = 0;

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

  public ParsingNode match(final JavaParser parser, final Input input) {
    indent++;
    // System.out.println("Matches "
    // + this.name
    // + " << '"
    // + input.getChars()
    // .substring(0, Math.min(20, input.getChars().length()))
    // .replace("\n", "\\n") + "...'");
    final RuleMatchingContext context = new RuleMatchingContext(parser);
    String tail = input.getChars();
    while (hasNodes(context.getGrammarRuleIndex(), this.grammarNodes)) {
      final Input newInput = new Input(tail);
      final GrammarNode next = getNextNode(context);
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
      // System.out.println(getIndent()
      // + "Matched "
      // + this.name
      // + " <= \""
      // + input.getChars()
      // .substring(0, input.getChars().length() - tail.length())
      // .replace("\n", "\\n") + "\"");
      result = new ParsingNode(this.name, context.getParsingNodes());
      input.setChars(tail);
    }
    indent--;
    return result;
  }

  private String getIndent() {
    final StringBuilder sb = new StringBuilder();
    for (int i = 0; i < indent; i++) {
      sb.append("  ");
    }
    return sb.toString();
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

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public String toString() {
    return getName() + '{' + Arrays.toString(getGrammarNodes()) + '}';
  }

}
