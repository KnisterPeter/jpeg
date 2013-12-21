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
public class ParserAndGeneratorTest {

  @Test
  public void testParseAndGenerate() throws IOException {
    final JPEG subject = new JPEG();
    final String code = subject.generate(new File(
        "src/main/resources/de/matrixweb/jpeg/jpeg.jpeg"), "jpeg");
    assertThat(code, is(notNullValue()));

    final File target = new File("src/test/java/jpeg/Jpeg.xtend");
    target.getParentFile().mkdirs();
    Files.write(code, target, Charsets.UTF_8);
  }

  @Test
  public void testTypeEvaluation() throws IOException {
    final JPEG subject = new JPEG();
    final String code = subject.generate(new File(
        "src/test/resources/de/matrixweb/jpeg/types.jpeg"), "types");

    final File target = new File("src/test/java/types/Types.xtend");
    target.getParentFile().mkdirs();
    Files.write(code, target, Charsets.UTF_8);
  }

  @Test
  public void testCompile() throws IOException {
    final XtendCompilerUtil compiler = XtendCompilerUtil.newXtendCompilerUtil();
    final String code = Files.toString(
        new File("src/test/java/jpeg/Jpeg.xtend"), Charsets.UTF_8);
    compiler.compile(code, new CompilerCallback() {
      @Override
      public void done(final Result result) {
        try {
          assertThat(result.getCompiledClass("jpeg.Parser").newInstance(),
              is(notNullValue()));
        } catch (final Exception e) {
          throw new RuntimeException(e);
        }
      }
    });
  }

}
