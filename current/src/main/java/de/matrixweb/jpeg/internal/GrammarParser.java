package de.matrixweb.jpeg.internal;

import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.RuleDescription;
import de.matrixweb.jpeg.RuleDescription.MatcherName;
import de.matrixweb.jpeg.internal.JPEGParser.ParsingResult;

/**
 * @author markusw
 */
public class GrammarParser {

  public static List<RuleDescription> create2(final Reader reader) {
    final ParsingResult result = JPEGParser.JPEG(IOUtils
        .readStreamAsString(reader));
    if (!result.matches()) {
      throw new JPEGParser.JPEGParserException("Failed to parser input");
    }
    return buildRuleDescriptions(result);
  }

  static List<RuleDescription> buildRuleDescriptions(final ParsingResult result) {
    final List<RuleDescription> descriptions = new ArrayList<RuleDescription>();
    for (final ParsingNode node : result.getParseTree().getChildren()) {
      if ("Rule".equals(node.getValue())) {
        descriptions.add(buildRuleDescription(node));
      }
    }
    return descriptions;
  }

  static RuleDescription buildRuleDescription(final ParsingNode rule) {
    String name = null;
    List<RuleDescription.NodeDescription> nodes = new ArrayList<RuleDescription.NodeDescription>();
    for (final ParsingNode subnode : rule.getChildren()) {
      if ("Name".equals(subnode.getValue())) {
        name = createString(subnode, "NameChar");
      } else if ("Body".equals(subnode.getValue())) {
        nodes = buildNodeDescriptions(subnode);
      }
    }
    return new RuleDescription(name,
        nodes.toArray(new RuleDescription.NodeDescription[nodes.size()]));
  }

  static String createString(final ParsingNode node, final String charnodeName) {
    final StringBuilder str = new StringBuilder();
    for (final ParsingNode subnode : node.getChildren()) {
      if (charnodeName.equals(subnode.getValue())) {
        for (final ParsingNode charnode : subnode.getChildren()) {
          str.append(charnode.getValue());
        }
      }
    }
    return str.toString();
  }

  static List<RuleDescription.NodeDescription> buildNodeDescriptions(
      final ParsingNode node) {
    final List<RuleDescription.NodeDescription> nodes = new ArrayList<RuleDescription.NodeDescription>();
    // System.out.println(JPEGParser.Utils.formatParsingNode(node, 0));

    if ("WS".equals(node.getValue())) {
      // Ignore whitespaces
    } else if ("OptionalExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.OPTIONAL,
          createString(node.getChildren()[0], "RuleReferenceChar")));
    } else if ("ChoiceExpressionPart".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.CHOICE, null));
      for (int i = 1; i < node.getChildren().length; i++) {
        nodes.addAll(buildNodeDescriptions(node.getChildren()[i]));
      }
    } else if ("OneOrMoreExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.ONE_OR_MORE,
          createString(node.getChildren()[0], "RuleReferenceChar")));
    } else if ("ZeroOrMoreExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.ZERO_OR_MORE,
          createString(node.getChildren()[0], "RuleReferenceChar")));
    } else if ("AndPredicateExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.AND_PREDICATE,
          createString(node.getChildren()[1], "RuleReferenceChar")));
    } else if ("NotPredicateExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.NOT_PREDICATE,
          createString(node.getChildren()[1], "RuleReferenceChar")));
    } else if ("AnyCharExpression".equals(node.getValue())) {
      nodes
          .add(new RuleDescription.NodeDescription(MatcherName.ANY_CHAR, null));
    } else if ("EndOfInputExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.EOI, null));
    } else if ("RuleReferenceExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.RULE,
          createString(node, "RuleReferenceChar")));
    } else if ("InTerminalChar".equals(node.getValue())) {

    } else if ("Terminal".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.TERMINAL,
          createString(node, "InTerminalChar").replace("\\\\", "\\")
              .replace("\\'", "'").replace("\\n", "\n").replace("\\r", "\r")
              .replace("\\t", "\t")));
    } else {
      if (node.getChildren().length == 0) {
        nodes.add(new RuleDescription.NodeDescription(MatcherName.TERMINAL,
            node.getValue()));
      } else {
        for (final ParsingNode child : node.getChildren()) {
          nodes.addAll(buildNodeDescriptions(child));
        }
      }
    }

    return nodes;
  }

  /**
   * @param reader
   * @return Returns the rules of the given grammar
   */
  public static List<RuleDescription> create(final Reader reader) {
    final List<RuleDescription> descriptions = new ArrayList<RuleDescription>();
    final Context context = new Context(IOUtils.readStreamAsCharArray(reader));
    RuleDescription descr = GrammarRuleFactory.create(context.getRuleContext());
    while (descr != null) {
      descriptions.add(descr);
      descr = GrammarRuleFactory.create(context.getRuleContext());
    }
    return descriptions;
  }

  static class Context {

    private final char[] input;

    private RuleContext ruleContext = null;

    /**
     * @param input
     */
    public Context(final char[] input) {
      this.input = input;
    }

    public RuleContext getRuleContext() {
      if (this.ruleContext == null) {
        this.ruleContext = new RuleContext(this, 0);
      }
      return this.ruleContext;
    }

    /**
     * @author markusw
     */
    class RuleContext {

      private final Context context;

      private int position;

      public RuleContext(final Context context, final int start) {
        this.context = context;
        this.position = start;
      }

      public String readUntil(final char c) {
        boolean found = false;
        final StringBuilder sb = new StringBuilder();
        int n = this.position;
        if (n < this.context.input.length) {
          char last = this.context.input[n++];
          while (last != c && n < this.context.input.length) {
            sb.append(last);
            last = this.context.input[n++];
          }
          sb.append(last);
          if (last == c) {
            this.position = n;
            found = true;
          }
        }
        return found ? sb.toString() : null;
      }

      public RuleContext consume() {
        this.context.ruleContext = new RuleContext(this.context, this.position);
        return this;
      }

    }

  }

}
