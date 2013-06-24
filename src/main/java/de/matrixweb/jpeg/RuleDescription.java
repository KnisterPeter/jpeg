package de.matrixweb.jpeg;

/**
 * @author markusw
 */
public class RuleDescription {

  /**
   * @author markusw
   */
  public enum MatcherName {
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

  private final String name;

  private final String type;

  private final NodeDescription[] nodes;

  /**
   * @param name
   * @param returnType
   * @param nodes
   */
  public RuleDescription(final String name, final String returnType,
      final NodeDescription[] nodes) {
    this.name = name;
    this.type = returnType;
    this.nodes = nodes;
  }

  /**
   * @return the name
   */
  public String getName() {
    return this.name;
  }

  /**
   * @return the returnType
   */
  public String getType() {
    return this.type;
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
      // FIXME: This is a dirty hack
      return this.value != null ? this.value.replace("\\", "\\\\")
          .replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r")
          .replace("\t", "\\t") : "";
    }
  }

}
