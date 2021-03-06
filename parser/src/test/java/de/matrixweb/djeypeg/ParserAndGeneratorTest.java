package de.matrixweb.djeypeg;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.Map.Entry;

import org.junit.Test;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

/**
 * @author markusw
 */
@SuppressWarnings("javadoc")
public class ParserAndGeneratorTest {

  @Test
  public void testParseAndGenerate() throws IOException {
    generate("de/matrixweb/djeypeg/djeypeg.djeypeg", "djeypeg", "djeypeg");
  }

  @Test
  public void testTypeEvaluation() throws IOException {
    generate("de/matrixweb/djeypeg/types.djeypeg", "types", "types");
  }

  private void generate(final String input, final String packageName,
      final String output) throws IOException {
    final Map<String, CharSequence> files = DJEYPEG.generate(new File(
        "src/test/resources", input), packageName);
    final File target = new File("../tests/src/main/java", output);
    target.mkdirs();
    for (final Entry<String, CharSequence> file : files.entrySet()) {
      Files.write(file.getValue(), new File(target, file.getKey()),
          Charsets.UTF_8);
    }
  }

}
