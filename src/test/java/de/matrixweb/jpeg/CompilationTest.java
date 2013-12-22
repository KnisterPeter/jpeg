package de.matrixweb.jpeg;

import java.io.File;
import java.io.IOException;

import org.eclipse.xtext.xbase.compiler.CompilationTestHelper.Result;
import org.junit.Test;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

import de.matrixweb.jpeg.XtendCompilerUtil.CompilerCallback;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
@SuppressWarnings("javadoc")
public class CompilationTest {

  private final XtendCompilerUtil compiler = XtendCompilerUtil
      .newXtendCompilerUtil();

  @Test
  public void testCompileJpeg() throws IOException {
    compile("src/test/java/jpeg/Jpeg.xtend", "jpeg.Parser");
  }

  @Test
  public void testCompileTypes() throws IOException {
    compile("src/test/java/types/Types.xtend", "types.Parser");
  }

  private void compile(final String input, final String parserClass)
      throws IOException {
    final String code = Files.toString(new File(input), Charsets.UTF_8);
    this.compiler.compile(code, new CompilerCallback() {
      @Override
      public void done(final Result result) {
        try {
          assertThat(result.getCompiledClass(parserClass).newInstance(),
              is(notNullValue()));
        } catch (final Exception e) {
          throw new RuntimeException(e);
        }
      }
    });
  }

}
