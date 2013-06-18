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

  /**
   * @param reader
   *          The grammar to read
   * @return Returns a {@link List} of parsed {@link RuleDescription}s for code
   *         generation
   */
  public static List<RuleDescription> create(final Reader reader) {
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
        descriptions.add(buildRuleDescription(descriptions, node));
      }
    }
    return descriptions;
  }

  static RuleDescription buildRuleDescription(
      final List<RuleDescription> descriptions, final ParsingNode rule) {
    String name = null;
    List<RuleDescription.NodeDescription> nodes = new ArrayList<RuleDescription.NodeDescription>();
    final MutableInteger n = new MutableInteger(0);
    for (final ParsingNode subnode : rule.getChildren()) {
      if ("RuleName".equals(subnode.getValue())) {
        name = createString(subnode);
      } else if ("Body".equals(subnode.getValue())) {
        nodes = buildNodeDescriptions(descriptions, subnode, name, n);
      }
    }
    return new RuleDescription(name,
        nodes.toArray(new RuleDescription.NodeDescription[nodes.size()]));
  }

  static String createString(final ParsingNode node) {
    final StringBuilder str = new StringBuilder();
    for (final ParsingNode child : node.getChildren()) {
      if (child.getChildren().length == 0) {
        str.append(child.getValue());
      } else {
        str.append(createString(child));
      }
    }
    return str.toString();
  }

  @Deprecated
  static String createString(final ParsingNode node, final String charnodeName) {
    final StringBuilder str = new StringBuilder();
    for (final ParsingNode subnode : node.getChildren()) {
      if (charnodeName.equals(subnode.getValue())) {
        for (final ParsingNode charnode : subnode.getChildren()) {
          str.append(charnode.getValue());
        }
      } else {
        str.append(createString(subnode, charnodeName));
      }
    }
    return str.toString();
  }

  static List<RuleDescription.NodeDescription> buildNodeDescriptions(
      final List<RuleDescription> descriptions, final ParsingNode node,
      final String nodeName, final MutableInteger n) {
    final List<RuleDescription.NodeDescription> nodes = new ArrayList<RuleDescription.NodeDescription>();
    //System.out.println(JPEGParser.Utils.formatParsingNode(node, 0));

    if ("WS".equals(node.getValue())) {
      // Ignore whitespaces
    } else if ("RuleAnnotationHidden".equals(node.getValue())) {
      throw new UnsupportedOperationException();
    } else if ("RangeExpression".equals(node.getValue())) {
      final String name = "internal_" + nodeName + '_' + n.n++;

      final List<RuleDescription.NodeDescription> sub = new ArrayList<RuleDescription.NodeDescription>();
      final ParsingNode[] children = node.getChildren();
      for (int i = 1; i < children.length - 1; i++) {
        sub.addAll(buildNodeDescriptions(descriptions, children[i], nodeName, n));
      }
      sub.remove(0);
      final RuleDescription internal = new RuleDescription(name,
          sub.toArray(new RuleDescription.NodeDescription[sub.size()]));
      descriptions.add(internal);
      nodes.add(new RuleDescription.NodeDescription(MatcherName.RULE, name));
    } else if ("RangeExpressionDash".equals(node.getValue())) {
      throw new UnsupportedOperationException();
    } else if ("RangeExpressionRange".equals(node.getValue())) {
      char from = node.getChildren()[0].getValue().charAt(0);
      char to = node.getChildren()[2].getValue().charAt(0);
      if (from > to) {
        final char temp = from;
        from = to;
        to = temp;
      }
      for (char i = from; i <= to; i++) {
        nodes
            .add(new RuleDescription.NodeDescription(MatcherName.CHOICE, null));
        nodes.add(new RuleDescription.NodeDescription(MatcherName.TERMINAL,
            String.valueOf(i)));
      }
    } else if ("RangeExpressionChar".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.CHOICE, null));
      nodes.add(new RuleDescription.NodeDescription(MatcherName.TERMINAL, node
          .getChildren()[0].getValue()));
    } else if ("ChoiceExpressionPart".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.CHOICE, null));
      final ParsingNode[] children = node.getChildren();
      for (int i = 1; i < children.length; i++) {
        nodes.addAll(buildNodeDescriptions(descriptions, children[i], nodeName,
            n));
      }
    } else if ("OptionalExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.OPTIONAL,
          buildNodeDescriptions(descriptions, node.getChildren()[0], nodeName,
              n).get(0).getValue()));
    } else if ("OneOrMoreExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.ONE_OR_MORE,
          buildNodeDescriptions(descriptions, node.getChildren()[0], nodeName,
              n).get(0).getValue()));
    } else if ("ZeroOrMoreExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.ZERO_OR_MORE,
          buildNodeDescriptions(descriptions, node.getChildren()[0], nodeName,
              n).get(0).getValue()));
    } else if ("AndPredicateExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.AND_PREDICATE,
          buildNodeDescriptions(descriptions, node.getChildren()[1], nodeName,
              n).get(0).getValue()));
    } else if ("NotPredicateExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.NOT_PREDICATE,
          buildNodeDescriptions(descriptions, node.getChildren()[1], nodeName,
              n).get(0).getValue()));
    } else if ("AnyCharExpression".equals(node.getValue())) {
      nodes
          .add(new RuleDescription.NodeDescription(MatcherName.ANY_CHAR, null));
    } else if ("EndOfInputExpression".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.EOI, null));
    } else if ("RuleName".equals(node.getValue())) {
      nodes.add(new RuleDescription.NodeDescription(MatcherName.RULE,
          createString(node)));
    } else if ("Terminal".equals(node.getValue())) {
      final StringBuilder str = new StringBuilder();
      final ParsingNode[] children = node.getChildren();
      for (int i = 1; i < children.length - 1; i++) {
        str.append(createString(children[i]));
      }
      nodes.add(new RuleDescription.NodeDescription(MatcherName.TERMINAL, str
          .toString().replace("\\\\", "\\").replace("\\'", "'")
          .replace("\\n", "\n").replace("\\r", "\r").replace("\\t", "\t")));
    } else if ("SubExpression".equals(node.getValue())) {
      final String name = "internal_" + nodeName + '_' + n.n++;
      final List<RuleDescription.NodeDescription> sub = new ArrayList<RuleDescription.NodeDescription>();
      final ParsingNode[] children = node.getChildren();
      for (int i = 1; i < children.length - 1; i++) {
        sub.addAll(buildNodeDescriptions(descriptions, children[i], nodeName, n));
      }
      final RuleDescription internal = new RuleDescription(name,
          sub.toArray(new RuleDescription.NodeDescription[sub.size()]));
      descriptions.add(internal);
      nodes.add(new RuleDescription.NodeDescription(MatcherName.RULE, name));
    } else {
      for (final ParsingNode child : node.getChildren()) {
        nodes.addAll(buildNodeDescriptions(descriptions, child, nodeName, n));
      }
    }

    return nodes;
  }

  private static class MutableInteger {

    private int n;

    MutableInteger(final int n) {
      this.n = n;
    }

  }

}
