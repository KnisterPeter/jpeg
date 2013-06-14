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
  public void testGenerateTestParser() throws IOException {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/test.jpeg"),
        "UTF-8");
    try {
      final Java java = new Java("test.TestParser");
      final String source = JPEG.createParser2(reader, java);

      final File target = new File("../next/src/main/java");
      target.mkdirs();
      final File subtarget = new File(target, "test");
      FileUtils.deleteDirectory(subtarget);
      subtarget.mkdirs();
      IOUtils.write(source, new FileOutputStream(new File(target,
          "test/TestParser.java")));
      java.compile(new File("../next/target/classes"), source);
    } finally {
      reader.close();
    }
  }

  /**
   * @throws IOException
   */
  @Test
  public void testGenerateJpegParser() throws IOException {
    final InputStreamReader reader = new InputStreamReader(
        JPEGTest.class.getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"),
        "UTF-8");
    try {
      final Java java = new Java("de.matrixweb.jpeg.JPEGParser");
      final String source = JPEG.createParser2(reader, java);
      System.out.println(source);
      final File target = new File("../next/src/main/java");
      target.mkdirs();
      final File subtarget = new File(target, "de/matrixweb/jpeg");
      FileUtils.deleteDirectory(subtarget);
      subtarget.mkdirs();
      IOUtils.write(source, new FileOutputStream(new File(target,
          "de/matrixweb/jpeg/JPEGParser.java")));
      java.compile(new File("../next/target/classes"), source);
    } finally {
      reader.close();
    }
  }

}
