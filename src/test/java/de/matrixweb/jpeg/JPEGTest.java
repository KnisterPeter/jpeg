package de.matrixweb.jpeg;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;

import org.junit.Test;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public class JPEGTest {

  /**
   * @throws IOException
   */
  @Test
  public void testCreate() throws IOException {
    assertThat(JPEG.create(new StringReader("// some comment")), is(true));
    assertThat(JPEG.create(new StringReader(
        "// some comment\n// Another comment line")), is(true));
    assertThat(JPEG.create(new StringReader(
        "// some comment\r\n// Another comment line")), is(true));
    assertThat(JPEG.create(new StringReader("Comment without slashes")),
        is(false));
  }

  /**
   * @throws IOException
   */
  @Test
  public void testCreateFromFile() throws IOException {
    final InputStreamReader reader = new InputStreamReader(getClass()
        .getResourceAsStream("/de/matrixweb/jpeg/jpeg.jpeg"));
    assertThat(JPEG.create(reader), is(true));
    assertThat(reader.read(), is(-1));
  }

}
