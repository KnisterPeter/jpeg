package de.matrixweb.jpeg;

import java.io.IOException;

import org.junit.Test;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public class SimpleTest {

  /**
   * @throws IOException
   */
  @Test
  public void testSimpleRules() throws IOException {
    final Parser parser = JPEG.create("A:B;B:'a';");

    ParsingResult result = parser.parse("A", "a");
    assertThat(result.isSuccess(), is(true));

    result = parser.parse("A", "b");
    assertThat(result.isSuccess(), is(false));
  }

}
