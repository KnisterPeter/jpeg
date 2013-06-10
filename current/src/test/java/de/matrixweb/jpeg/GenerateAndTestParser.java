package de.matrixweb.jpeg;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import jpeg.TestParser;

import org.apache.commons.io.IOUtils;
import org.junit.Test;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

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
      new File("target/gen-parser/jpeg").mkdirs();
      IOUtils.write(source, new FileOutputStream(
          "target/gen-parser/jpeg/TestParser.java"));
      java.compile(new File("target/gen-parser"), source);
    } finally {
      reader.close();
    }
  }

  @Test
  public void testTest() {
    final TestParser parser = new TestParser();
    final jpeg.TestParser.ParsingResult res = parser.Start("Hallo Welt!");
    assertThat(res.matches(), is(true));
    System.out.println(TestParser.Utils.formatParsingTree(res));
  }

}
