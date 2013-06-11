package de.matrixweb.jpeg;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.junit.Test;

/**
 * @author markusw
 */
public class GenerateAndTestParser {

  /**
   * @throws IOException
   */
  @Test
  public void testGenerateParser() throws IOException {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/test.jpeg"),
        "UTF-8");
    try {
      final Java java = new Java("jpeg.TestParser");
      final String source = JPEG.createParser2(reader, java);

      final File target = new File("../next/src/main/java");
      final File subtarget = new File(target, "jpeg");
      FileUtils.deleteDirectory(subtarget);
      subtarget.mkdirs();
      target.mkdirs();
      IOUtils.write(source, new FileOutputStream(new File(target,
          "jpeg/TestParser.java")));
      java.compile(target, source);
    } finally {
      reader.close();
    }
  }

}
