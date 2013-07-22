package de.matrixweb.jpeg.internal.io;

import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.JPEGParserException;
import de.matrixweb.jpeg.UnexpectedEndOfInputException;

/**
 * @author markusw
 */
public class InputReader {

  private final char[] data;

  private int next = 0;

  private int line = 1;

  private int position = 0;

  private List<Position> marks = new ArrayList<Position>();

  /**
   * @param reader
   */
  public InputReader(final Reader reader) {
    this(toString(reader));
  }

  /**
   * @param input
   */
  public InputReader(final String input) {
    this.data = input.toCharArray();
  }

  private static String toString(final Reader reader) {
    try {
      final StringBuilder sb = new StringBuilder();
      final char[] buf = new char[1024];
      int len = reader.read(buf);
      while (len != -1) {
        sb.append(buf, 0, len);
        len = reader.read(buf);
      }
      return sb.toString();
    } catch (final IOException e) {
      throw new JPEGParserException("Failed to read input", e);
    }
  }

  /**
   * @return Returns true if there is more input available, false otherwise
   */
  public boolean hasNext() {
    return this.next < this.data.length;
  }

  /**
   * @return Returns the next available char
   * @throws UnexpectedEndOfInputException
   */
  public char read() {
    if (!hasNext()) {
      throw new UnexpectedEndOfInputException("Unexpected end of input at pos "
          + this.next);
    }
    final char c = this.data[this.next++];
    if (c == '\n') {
      this.line++;
      this.position = 0;
    } else {
      this.position++;
    }
    return c;
  }

  /**
   * @return Returns the mark position
   */
  public int mark() {
    final int mark = this.marks.size();
    this.marks.add(new Position(this.next, this.line, this.position));
    return mark;
  }

  /**
   * @param mark
   * @return Returns the matched input {@link String} from mark position
   */
  public String get(final int mark) {
    final Position position = this.marks.get(mark);
    return new String(this.data, position.next, this.next - position.next);
  }

  /**
   * @param mark
   */
  public void reset(final int mark) {
    if (this.marks.isEmpty()) {
      throw new JPEGParserException("Reset without mark");
    }
    final Position position = this.marks.get(mark);
    this.next = position.next;
    this.line = position.line;
    this.position = position.position;
    this.marks = new ArrayList<Position>(this.marks.subList(0, mark));
  }

  /**
   * @return Returns the current input position in line and char
   */
  public String getPosition() {
    return "[" + this.line + "," + this.position + "]";
  }

  /**
   * @see java.lang.Object#toString()
   */
  @Override
  public String toString() {
    return new String(this.data)
        .substring(Math.max(0, this.next),
            Math.min(this.next + 80, this.data.length)).replace("\n", "\\n")
        .replace("\r", "\\r").replace("\t", "\\t");
  }

  private static class Position {

    int next;

    int line;

    int position;

    Position(final int next, final int line, final int position) {
      this.next = next;
      this.line = line;
      this.position = position;
    }

  }

}
