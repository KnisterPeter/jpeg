package de.matrixweb.jpeg.internal;

import java.io.IOException;
import java.io.Reader;
import java.util.HashMap;
import java.util.Map;

import de.matrixweb.jpeg.JPEGParserException;
import de.matrixweb.jpeg.internal.java.GrammarNode;
import de.matrixweb.jpeg.internal.java.GrammarRule;
import de.matrixweb.jpeg.internal.java.Input;
import de.matrixweb.jpeg.internal.java.ParsingNode;
import de.matrixweb.jpeg.internal.java.matcher.GrammarNodeMatcher;

/**
 * @author markusw
 */
public class GrammarParser {

  private final Map<String, GrammarRule> rules = new HashMap<String, GrammarRule>();

  /**
   * @param reader
   * @return Returns the parser
   */
  public static GrammarParser create(final Reader reader) {
    final GrammarParser parser = new GrammarParser();
    final Context context = new Context(parser.readStream(reader));
    GrammarRule rule = create(GrammarRuleFactory.create(context
        .getRuleContext()));
    while (rule != null) {
      parser.rules.put(rule.getName(), rule);
      rule = create(GrammarRuleFactory.create(context.getRuleContext()));
    }
    return parser;
  }

  private static GrammarRule create(final RuleDescription description) {
    if (description != null) {
      final GrammarNode[] nodes = new GrammarNode[description.getNodes().length];
      for (int i = 0; i < description.getNodes().length; i++) {
        GrammarNodeMatcher matcher = null;
        switch (description.getNodes()[i].getMatcher()) {
        case AND_PREDICATE:
          matcher = GrammarNodeMatcher.AND_PREDICATE;
          break;
        case ANY_CHAR:
          matcher = GrammarNodeMatcher.ANY_CHAR;
          break;
        case CHOICE:
          matcher = GrammarNodeMatcher.CHOICE;
          break;
        case EOI:
          matcher = GrammarNodeMatcher.EOI;
          break;
        case NOT_PREDICATE:
          matcher = GrammarNodeMatcher.NOT_PREDICATE;
          break;
        case ONE_OR_MORE:
          matcher = GrammarNodeMatcher.ONE_OR_MORE;
          break;
        case OPTIONAL:
          matcher = GrammarNodeMatcher.OPTIONAL;
          break;
        case RULE:
          matcher = GrammarNodeMatcher.RULE;
          break;
        case TERMINAL:
          matcher = GrammarNodeMatcher.TERMINAL;
          break;
        case ZERO_OR_MORE:
          matcher = GrammarNodeMatcher.ZERO_OR_MORE;
          break;
        }
        nodes[i] = new GrammarNode(matcher,
            description.getNodes()[i].getValue());
      }
      return new GrammarRule(description.getName(), nodes);
    }
    return null;
  }

  private char[] readStream(final Reader reader) {
    try {
      final StringBuilder sb = new StringBuilder();
      final char[] buf = new char[512];
      int len = reader.read(buf);
      while (len > -1) {
        sb.append(buf, 0, len);
        len = reader.read(buf);
      }
      return sb.toString().toCharArray();
    } catch (final IOException e) {
      throw new JPEGParserException("Failed to read input", e);
    }
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
  public ParsingNode parse(final String startRule, final Input input) {
    final GrammarRule rule = this.rules.get(startRule);
    if (rule == null) {
      throw new JPEGParserException("Rule '" + startRule + "' is unknown");
    }
    return rule.match(this, input);
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
