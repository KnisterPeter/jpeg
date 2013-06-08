package de.matrixweb.jpeg.internal;

import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.internal.GrammarParser.Context.RuleContext;
import de.matrixweb.jpeg.internal.RuleDescription.NodeDescription;

/**
 * @author markusw
 */
class GrammarRuleFactory {

  enum MatcherName {
    /** */
    TERMINAL,
    /** */
    CHOICE,
    /** */
    ONE_OR_MORE,
    /** */
    ZERO_OR_MORE,
    /** */
    OPTIONAL,
    /** */
    ANY_CHAR,
    /** */
    EOI,
    /** */
    AND_PREDICATE,
    /** */
    NOT_PREDICATE,
    /** */
    RULE
  }

  static RuleDescription create(final RuleContext context) {
    RuleDescription rule = null;
    String token = context.readUntil(':');
    if (token != null) {
      final String name = token.substring(0, token.length() - 1).trim();

      token = readRuleBody(context);
      if (token != null) {
        final NodeDescription[] grammarNodes = parseGrammarNodes(token
            .substring(0, token.length() - 1).trim());

        context.consume();
        rule = new RuleDescription(name, grammarNodes);
      }
    }
    return rule;
  }

  private static String readRuleBody(final RuleContext context) {
    final StringBuilder sb = new StringBuilder();
    boolean done = false;
    String part = context.readUntil(';');
    while (!done) {
      if (part == null) {
        done = true;
      } else {
        sb.append(part);
        done = countChar(sb, '\'') % 2 == 0;
        if (!done) {
          part = context.readUntil(';');
        }
      }
    }
    return sb.length() > 0 ? sb.toString() : null;
  }

  private static int countChar(final StringBuilder sb, final char c) {
    int index = sb.indexOf(String.valueOf(c), 0);
    int count = 0;
    while (index != -1) {
      count++;
      index = sb.indexOf(String.valueOf(c), index + 1);
    }
    return count;
  }

  private static NodeDescription[] parseGrammarNodes(final String body) {
    final List<NodeDescription> list = new ArrayList<NodeDescription>();

    final StringBuilder sb = new StringBuilder();
    int n = 0;
    boolean wasSpace = false;
    boolean inTerminal = false;
    boolean inToken = false;
    MatcherName matcher = null;
    while (n < body.length()) {
      final char c = body.charAt(n++);
      if (inTerminal) {
        sb.append(c);
        if (c == '\'') {
          inTerminal = false;
          addGrammarNode(list, MatcherName.TERMINAL,
              sb.substring(1, sb.length() - 1));
          sb.setLength(0);
        }
      } else {
        switch (c) {
        case '\'':
          inTerminal = true;
          sb.append(c);
          break;
        case '|':
          addGrammarNode(list, matcher, sb.toString());
          list.add(new NodeDescription(MatcherName.CHOICE, null));
          sb.setLength(0);
          break;
        case '+':
          addGrammarNode(list, MatcherName.ONE_OR_MORE, sb.toString());
          sb.setLength(0);
          break;
        case '*':
          addGrammarNode(list, MatcherName.ZERO_OR_MORE, sb.toString());
          sb.setLength(0);
          break;
        case '?':
          addGrammarNode(list, MatcherName.OPTIONAL, sb.toString());
          sb.setLength(0);
          break;
        case '.':
          list.add(new NodeDescription(MatcherName.ANY_CHAR, null));
          sb.setLength(0);
          break;
        case '#':
          list.add(new NodeDescription(MatcherName.EOI, null));
          sb.setLength(0);
          break;
        case '&':
          inToken = true;
          matcher = MatcherName.AND_PREDICATE;
          break;
        case '!':
          inToken = true;
          matcher = MatcherName.NOT_PREDICATE;
          break;
        case ' ':
          if (inToken) {
            addGrammarNode(list, matcher != null ? matcher : MatcherName.RULE,
                sb.toString());
            matcher = null;
            sb.setLength(0);
          }
          wasSpace = true;
          inToken = false;
          break;
        default:
          if (wasSpace) {
            wasSpace = false;
            addGrammarNode(list, MatcherName.RULE, sb.toString());
            sb.setLength(0);
          }
          inToken = true;
          sb.append(c);
          break;
        }
      }
    }
    if (sb.length() > 0) {
      addGrammarNode(list, MatcherName.RULE, sb.toString());
    }

    return list.toArray(new NodeDescription[list.size()]);
  }

  private static void addGrammarNode(final List<NodeDescription> list,
      final MatcherName matcher, final String token) {
    if (token.length() > 0) {
      list.add(new NodeDescription(matcher, token));
    }
  }

}
