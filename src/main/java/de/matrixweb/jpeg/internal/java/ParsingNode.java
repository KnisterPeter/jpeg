package de.matrixweb.jpeg.internal.java;

/**
 * @author markusw
 */
public class ParsingNode {

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
