package de.matrixweb.jpeg;

import java.io.File;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.io.Writer;

import org.apache.commons.io.FileUtils;
import org.junit.Test;

/**
 * @author markusw
 */
public class GenerateParserTest {

  private final boolean forTest = true;

  /**
   * @throws Exception
   */
  @Test
  public void generate() throws Exception {
    if (this.forTest) {
      generate("src/test/java", "de.matrixweb.jpeg.test.JPEGTestParser");
    } else {
      generate("src/main/java", "de.matrixweb.jpeg.internal.JPEGParser");
    }
  }

  private void generate(final String target, final String name)
      throws Exception {
    final Java java = new Java(name);
    final String source = JPEG.createParser(new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"),
        "UTF-8"), java);

    File file = new File(target + "/" + name.replace('.', '/') + ".java");
    file.getParentFile().mkdirs();
    final Writer writer = new FileWriter(file);
    writer.write(source);
    writer.close();

    file = new File("target/gen-parser-classes");
    FileUtils.deleteDirectory(file);
    file.mkdirs();
    java.compile(file, source);
  }

}
