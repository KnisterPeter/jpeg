package de.matrixweb.jpeg.internal;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Writer;

import de.matrixweb.jpeg.JPEG;
import de.matrixweb.jpeg.Java;

/**
 * @author markusw
 */
public class GenerateTestParser {

  /**
   * @param args
   * @throws Exception
   */
  public static void main(final String[] args) throws Exception {
    if (args.length > 0 && "release".equals(args[0])) {
      generate("src/main/java", "de.matrixweb.jpeg.internal.JPEGParser");
    } else {
      generate("target/test-parser", "de.matrixweb.jpeg.test.JPEGTestParser");
    }
  }

  private static void generate(final String target, final String name)
      throws Exception {
    final Java java = new Java(name);
    final String source = JPEG.createParser(
        new InputStreamReader(GenerateTestParser.class
            .getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"), "UTF-8"),
        java);

    File file = new File(target + "/" + name.replace('.', '/') + ".java");
    file.getParentFile().mkdirs();
    final Writer writer = new FileWriter(file);
    writer.write(source);
    writer.close();

    file = new File("target/gen-parser-classes");
    deleteDirectory(file);
    file.mkdirs();
    java.compile(file, source);
    deleteDirectory(file);
  }

  static void deleteDirectory(final File directory) throws IOException {
    if (directory.exists()) {
      for (final File file : directory.listFiles()) {
        if (file.isDirectory()) {
          deleteDirectory(file);
        } else {
          file.delete();
        }
      }
      directory.delete();
    }
  }

}
