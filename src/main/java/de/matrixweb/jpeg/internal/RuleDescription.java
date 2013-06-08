package de.matrixweb.jpeg.internal;

import de.matrixweb.jpeg.internal.GrammarRuleFactory.MatcherName;

/**
 * @author markusw
 */
public class RuleDescription {

  private final String name;

  private final NodeDescription[] nodes;

  /**
   * @param name
   * @param nodes
   */
  public RuleDescription(final String name, final NodeDescription[] nodes) {
    this.name = name;
    this.nodes = nodes;
  }

  /**
   * @return the name
   */
  public String getName() {
    return this.name;
  }

  /**
   * @return the nodes
   */
  public NodeDescription[] getNodes() {
    return this.nodes;
  }

  /** */
  public static class NodeDescription {

    private final MatcherName matcher;

    private final String value;

    /**
     * @param matcher
     * @param value
     */
    public NodeDescription(final MatcherName matcher, final String value) {
      this.matcher = matcher;
      this.value = value;
    }

    /**
     * @return the matcher
     */
    public MatcherName getMatcher() {
      return this.matcher;
    }

    /**
     * @return the value
     */
    public String getValue() {
      return this.value;
    }

  }

}
