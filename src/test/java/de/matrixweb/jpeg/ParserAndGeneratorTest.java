package de.matrixweb.jpeg;

import java.io.File;
import java.io.IOException;

import org.junit.Test;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

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

}
