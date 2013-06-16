package de.matrixweb.jpeg;

import java.io.File;
import java.util.List;

import de.matrixweb.jpeg.internal.JavaGenerator;

/**
 * @author markusw
 */
public class Java implements CodeGenerator {

  private final String name;

  /**
   * @param name
   */
  public Java(final String name) {
    this.name = name;
  }

  /**
   * @see de.matrixweb.jpeg.CodeGenerator#build(java.util.List)
   */
  @Override
  public String build(final List<RuleDescription> rules) {
    return new JavaGenerator(this.name).build(rules);
  }

  /**
   * @param target
   * @param source
   */
  public void compile(final File target, final String source) {
    new JavaGenerator(this.name).compile(target, source);
  }

}
