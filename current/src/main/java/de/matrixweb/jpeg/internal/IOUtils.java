package de.matrixweb.jpeg.internal;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.UnsupportedEncodingException;

import de.matrixweb.jpeg.JPEGParserException;

/**
 * @author markusw
 */
public class IOUtils {

  /**
   * @param location
   *          The classpath resource to load
   * @param charset
   *          The charset to use
   * @return Returns the resouce content as {@link String}
   */
  public static String readResourceAsString(final String location,
      final String charset) {
    final InputStream stream = IOUtils.class.getResourceAsStream(location);
    if (stream == null) {
      throw new JPEGParserException("Unknown resource " + location);
    }
    try {
      return readStreamAsString(new InputStreamReader(stream, charset));
    } catch (final UnsupportedEncodingException e) {
      throw new JPEGParserException("Unknown charset " + charset, e);
    } finally {
      if (stream != null) {
        try {
          stream.close();
        } catch (final IOException e) {
          throw new JPEGParserException("Failed to close stream", e);
        }
      }
    }

  }

  /**
   * @param location
   *          The classpath resource to load
   * @param charset
   *          The charset to use
   * @return Returns the resouce content as array of char
   */
  public static char[] readResourceAsCharArray(final String location,
      final String charset) {
    return readResourceAsString(location, charset).toCharArray();
  }

  /**
   * @param reader
   *          The {@link Reader} to read
   * @return Returns the whole reader content as {@link String}
   */
  public static String readStreamAsString(final Reader reader) {
    try {
      final StringBuilder sb = new StringBuilder();
      final char[] buf = new char[512];
      int len = reader.read(buf);
      while (len > -1) {
        sb.append(buf, 0, len);
        len = reader.read(buf);
      }
      return sb.toString();
    } catch (final IOException e) {
      throw new JPEGParserException("Failed to read stream", e);
    }
  }

  /**
   * @param reader
   *          The {@link Reader} to read
   * @return Returns the whole reader content as array of char
   */
  public static char[] readStreamAsCharArray(final Reader reader) {
    return readStreamAsString(reader).toCharArray();
  }

}
