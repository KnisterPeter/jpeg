package de.matrixweb.jpeg.internal;

import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.RuleDescription;

/**
 * @author markusw
 */
public class GrammarParser {

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
