package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.type.String;
import de.matrixweb.jpeg.internal.type.Type;

/**
 * @author markusw
 */
public class Range implements Type<Range> {

  private String min;

  private String max;

  private String _char;

  /**
   * @see de.matrixweb.jpeg.internal.type.Type#copy()
   */
  @Override
  public Range copy() {
    final Range copy = new Range();
    copy.min = this.min != null ? this.min.copy() : null;
    copy.max = this.max != null ? this.max.copy() : null;
    copy._char = this._char != null ? this._char.copy() : null;
    return copy;
  }

  /**
   * @return the min
   */
  public String getMin() {
    return this.min;
  }

  /**
   * @param min
   *          the min to set
   */
  public void setMin(final String min) {
    this.min = min;
  }

  /**
   * @return the max
   */
  public String getMax() {
    return this.max;
  }

  /**
   * @param max
   *          the max to set
   */
  public void setMax(final String max) {
    this.max = max;
  }

  /**
   * @return the _char
   */
  public String getChar() {
    return this._char;
  }

  /**
   * @param _char
   *          the _char to set
   */
  public void setChar(final String _char) {
    this._char = _char;
  }

}
