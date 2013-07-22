package de.matrixweb.jpeg.internal.type;

/**
 * @param <T>
 * 
 * @author markusw
 */
public interface Type<T extends Type<T>> {

  /**
   * @return Returns a deep-copy of this
   */
  T copy();

}
