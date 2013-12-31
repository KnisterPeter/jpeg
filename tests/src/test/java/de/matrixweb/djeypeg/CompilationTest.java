package de.matrixweb.djeypeg;

import java.io.IOException;

import org.junit.Test;

import de.matrixweb.djeypeg.helper.AbstractCompilationTest;

/**
 * @author markusw
 */
@SuppressWarnings("javadoc")
public class CompilationTest extends AbstractCompilationTest {

  @Test
  public void testCompileDjeypeg() throws IOException {
    compile("djeypeg", "Parser.xtend", "Types.xtend");
  }

  @Test
  public void testCompileTypes() throws IOException {
    compile("types", "Parser.xtend", "Types.xtend");
  }

}
