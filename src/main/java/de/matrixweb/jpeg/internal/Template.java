package de.matrixweb.jpeg.internal;

import java.io.StringReader;
import java.io.StringWriter;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;

import de.matrixweb.jpeg.JPEGParserException;

/**
 * @author markusw
 */
public class Template {

  public String render(final String base, final String name,
      final Map<String, Object> parameters) {
    final StringWriter writer = new StringWriter();

    String source = IOUtils.readResourceAsString('/' + base + '/' + name,
        "UTF-8");

    // Rewrite outputs
    final Pattern pattern = Pattern.compile("\\{\\{\\$([^}]+)\\}\\}");
    final Matcher matcher = pattern.matcher(source);
    final StringBuffer sb = new StringBuffer();
    while (matcher.find()) {
      final String match = matcher.group(1);
      final String[] parts = match.split("\\.");
      final StringBuilder isb = new StringBuilder(parts[0]);
      for (int i = 1; i < parts.length; i++) {
        isb.append('.')
            .append(String.valueOf(parts[i].charAt(0)).toUpperCase())
            .append(parts[i].substring(1));
      }
      matcher.appendReplacement(sb, "\\${" + isb.toString() + "}");
    }
    matcher.appendTail(sb);
    source = sb.toString();

    // Rewrite for-loops
    source = source.replaceAll("\\{\\{for ([^ ]+) in ([^}]+)\\}\\}",
        "#foreach(\\$$1 in \\$$2)").replaceAll("\\{\\{/for\\}\\}", "#end");
    // Rewrite references
    source = source.replaceAll("\\{\\{reference ([^}]+)\\}\\}",
        "reference $1\n#include(\"/" + base + "/$1\")");

    final VelocityContext context = new VelocityContext(parameters);
    final VelocityEngine ve = new VelocityEngine();
    ve.setProperty("resource.loader", "class");
    ve.setProperty("class.resource.loader.class",
        "org.apache.velocity.runtime.resource.loader.ClasspathResourceLoader");
    ve.evaluate(context, writer, name, new StringReader(source));
    return writer.toString();
  }

  /**
   * TODO: Finish when we have parser-actions
   * 
   * @param base
   *          The base to resolve includes against
   * @param name
   *          The resource name to render
   * @param parameters
   *          The parameters to use for rendering
   * @return Returns the rendered template
   */
  public String render0(final String base, final String name,
      final Map<String, Object> parameters) {
    final StringBuilder sb = new StringBuilder();

    final char[] source = IOUtils.readResourceAsCharArray('/' + base + '/'
        + name, "UTF-8");
    int pos = 0;
    while (pos != -1) {
      pos = readUntil("{{", source, pos, sb);
      if (pos != -1) {
        pos = resolveExpression(source, pos, sb, parameters);
      }
    }
    return sb.toString();
  }

  private int resolveExpression(final char[] source, final int startPos,
      final StringBuilder sb, final Map<String, Object> parameters) {
    final StringBuilder expression = new StringBuilder();
    final int pos = readUntil("}}", source, startPos, expression);
    if (pos == -1) {
      throw new JPEGParserException("Unclosed template expression '"
          + expression.toString() + "'");
    }
    if (expression.charAt(0) == '$') {
      final Object value = parameters.get(expression.substring(1));
      if (value != null) {
        sb.append(value);
      } else {
        sb.append("{{").append(expression).append("}}");
      }
    } else if (expression.substring(0, 4).equals("for ")) {
      // TODO: For expression
    } else if (expression.substring(0, 10).equals("reference ")) {
      // TODO: Reference expression
    } else {
      throw new JPEGParserException("Unknown expression '"
          + expression.toString() + "'");
    }
    return pos;
  }

  private int readUntil(final String str, final char[] source,
      final int startPos, final StringBuilder sb) {
    final char[] chars = str.toCharArray();
    int pos = startPos;
    boolean charsFound = false;
    while (pos != -1 && !charsFound) {
      if (pos < source.length) {
        final char c = source[pos];
        if (pos + 1 < source.length) {
          final char la = source[pos + 1];
          if (c == chars[0] && la == chars[1]) {
            pos++;
            charsFound = true;
          } else {
            sb.append(c);
          }
        } else {
          sb.append(c);
        }
        pos++;
      } else {
        pos = -1;
      }
    }
    return pos;
  }

}
