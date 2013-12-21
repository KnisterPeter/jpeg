package de.matrixweb.jpeg;

import java.io.File;
import java.io.IOException;

import jpeg.Jpeg;

import org.junit.Test;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
@SuppressWarnings("javadoc")
public class JPEG2Test {

  @Test
  public void testParse() {
    final Jpeg r = jpeg.Parser.Jpeg("Rule:'a';");
    assertThat(r, is(notNullValue()));
  }

  @Test
  public void testParse2() {
    final Jpeg r = jpeg.Parser.Jpeg("Rule:Rule2|'a';\nRule2:'b';");
    assertThat(r, is(notNullValue()));
  }

  @Test
  public void testJpegGrammar() throws IOException {
    final Jpeg r = jpeg.Parser.Jpeg(Files.toString(new File(
        "src/main/resources/de/matrixweb/jpeg/jpeg.jpeg"), Charsets.UTF_8));
    assertThat(r, is(notNullValue()));
  }

}
