package de.matrixweb.jpeg.internal.type;

/**
 * @param <T>
 * @author markusw
 */
public class Mutable<T> {

  private T value;

  /**
   * 
   */
  public Mutable() {
  }

  /**
   * @param value
   */
  public Mutable(final T value) {
    this.value = value;
  }

  /**
   * @return the value
   */
  public T getValue() {
    return this.value;
  }

  /**
   * @param value
   *          the value to set
   */
  public void setValue(final T value) {
    this.value = value;
  }

}
