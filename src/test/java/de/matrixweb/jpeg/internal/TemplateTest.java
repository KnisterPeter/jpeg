package de.matrixweb.jpeg.internal;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public class TemplateTest {

  private final Template tmpl = new Template();

  /** */
  @Test
  public void testRender() {
    final Map<String, Object> params = new HashMap<String, Object>();
    params.put("abc", "def");
    params.put("list",
        Arrays.asList(new ValueHolder("1"), new ValueHolder("2")));
    assertThat(
        this.tmpl.render("de/matrixweb/jpeg/internal", "test.template", params),
        is("start\ndef\nmiddle\n  output 1\n  output 2\nend\n"
            + "// reference include.template\njust some included output\n"));
  }

  @SuppressWarnings("javadoc")
  public class ValueHolder {

    private final String value;

    public ValueHolder(final String value) {
      this.value = value;
    }

    public String getValue() {
      return this.value;
    }

  }

}
