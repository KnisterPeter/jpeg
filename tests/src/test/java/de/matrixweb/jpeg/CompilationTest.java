package de.matrixweb.jpeg;

import java.io.IOException;

import org.junit.Test;

import de.matrixweb.jpeg.helper.AbstractCompilationTest;

/**
 * @author markusw
 */
@SuppressWarnings("javadoc")
public class CompilationTest extends AbstractCompilationTest {

  @Test
  public void testCompileJpeg() throws IOException {
    compile("jpeg", "Parser.xtend", "Types.xtend");
  }

  @Test
  public void testCompileTypes() throws IOException {
    compile("types", "Parser.xtend", "Types.xtend");
  }

}
