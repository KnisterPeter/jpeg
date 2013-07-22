package de.matrixweb.jpeg.internal.type;

/**
 * @author markusw
 */
public class String implements Type {

  private StringBuilder value;

  /**
   * 
   */
  public String() {
    this.value = new StringBuilder();
  }

  /**
   * @param value
   */
  public String(final java.lang.String value) {
    this.value = new StringBuilder(value);
  }

  /**
   * @return the value
   */
  public java.lang.String getValue() {
    return this.value.toString();
  }

  /**
   * @param value
   *          the value to set
   */
  public void setValue(final String value) {
    setValue(value.getValue());
  }

  /**
   * @param value
   *          the value to set
   */
  public void setValue(final java.lang.String value) {
    this.value = new StringBuilder(value);
  }

  /**
   * @param value
   */
  public void add(final String value) {
    add(value.getValue());
  }

  /**
   * @param value
   */
  public void add(final java.lang.String value) {
    this.value.append(value);
  }

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public java.lang.String toString() {
    return getValue();
  }

}
