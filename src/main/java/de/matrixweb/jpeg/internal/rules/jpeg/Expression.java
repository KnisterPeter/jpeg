package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.type.Type;

/**
 * @param <T>
 * 
 * @author markusw
 */
public abstract class Expression<T extends Expression<T>> implements Type<T> {

  /**
   * @see de.matrixweb.jpeg.internal.type.Type#copy()
   */
  @Override
  public abstract T copy();

}
