package de.matrixweb.jpeg;

import java.io.IOException;
import java.io.Reader;
import java.util.Stack;

/**
 * @author markusw
 */
public class JPEG {

  private final InputReader reader;

  /**
   * @param reader
   * @throws IOException
   */
  public static boolean create(final Reader reader) throws IOException {
    return new JPEG(reader).read();
  }

  private JPEG(final Reader reader) {
    this.reader = new InputReader(reader);
    this.reader.mark();
  }

  private boolean read() throws IOException {
    return Comment();
  }

  private boolean Comment() throws IOException {
    try {
      this.reader.mark();
      _(T("//"), ZeroOrMore(Not(Opt(T("\r")), T("\n")), Any())).exec(
          this.reader);
      return true;
    } catch (final RuleMismatchException e) {
      this.reader.reset();
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  //
  // Shortcuts
  //
  // ---------------------------------------------------------------------------

  static AnyChar Any() {
    return new AnyChar();
  }

  static Terminal T(final String sequence) {
    return new Terminal(sequence);
  }

  static CharRange Chars(final String range) {
    return new CharRange(range);
  }

  static Sequence _(final Rule... rules) {
    return new Sequence(rules);
  }

  static AndPredicate And(final Rule... rules) {
    return new AndPredicate(rules);
  }

  static NotPredicate Not(final Rule... rules) {
    return new NotPredicate(rules);
  }

  static Optional Opt(final Rule... rules) {
    return new Optional(rules);
  }

  static OneOrMore OneOrMore(final Rule... rules) {
    return new OneOrMore(rules);
  }

  static ZeroOrMore ZeroOrMore(final Rule... rules) {
    return new ZeroOrMore(rules);
  }

  /**
   * @author markusw
   */
  static class JPEGParserException extends RuntimeException {

    private static final long serialVersionUID = 643518539969475932L;

    /**
     * @param message
     */
    public JPEGParserException(final String message) {
      super(message);
    }

    /**
     * @param message
     * @param cause
     */
    public JPEGParserException(final String message, final Throwable cause) {
      super(message, cause);
    }

  }

  static class UnexpectedEndOfInputException extends JPEGParserException {

    private static final long serialVersionUID = -9209564372753698493L;

    /**
     * @param message
     */
    public UnexpectedEndOfInputException(final String message) {
      super(message);
    }

    /**
     * @param message
     * @param cause
     */
    public UnexpectedEndOfInputException(final String message,
        final Throwable cause) {
      super(message, cause);
    }

  }

}

class InputReader {

  private final char[] data;

  private int next = 0;

  private final Stack<Integer> marks = new Stack<Integer>();

  InputReader(final Reader reader) {
    try {
      final StringBuilder sb = new StringBuilder();
      final char[] buf = new char[1024];
      int len = reader.read(buf);
      while (len != -1) {
        sb.append(buf);
        len = reader.read(buf);
      }
      this.data = sb.toString().toCharArray();
    } catch (final IOException e) {
      throw new JPEG.JPEGParserException("Failed to read input", e);
    }
  }

  boolean hasNext() {
    return this.next < this.data.length;
  }

  char read() {
    if (!hasNext()) {
      throw new JPEG.UnexpectedEndOfInputException(
          "Unexpected end of input at pos " + this.next);
    }
    return this.data[this.next++];
  }

  void mark() {
    this.marks.push(this.next);
  }

  void reset() {
    if (this.marks.isEmpty()) {
      throw new JPEG.JPEGParserException("Reset without mark");
    }
    this.next = this.marks.pop();
  }

}

class RuleMismatchException extends Exception {

  private static final long serialVersionUID = 2613836771515322358L;

  RuleMismatchException() {
    super();
  }

}

interface Rule {

  void exec(InputReader reader) throws RuleMismatchException;

}

class AnyChar implements Rule {

  @Override
  public void exec(final InputReader reader) {
    reader.read();
  }

}

class Terminal implements Rule {

  private final String sequence;

  Terminal(final String sequence) {
    this.sequence = sequence;
  }

  @Override
  public void exec(final InputReader reader) throws RuleMismatchException {
    for (int i = 0, n = this.sequence.length(); i < n; i++) {
      final char s = this.sequence.charAt(i);
      final char c = reader.read();
      if (c != s) {
        throw new RuleMismatchException();
      }
    }
  }

}

class CharRange implements Rule {

  private final char min;

  private final char max;

  CharRange(final String range) {
    this.min = range.charAt(1);
    this.max = range.charAt(3);
  }

  @Override
  public void exec(final InputReader reader) throws RuleMismatchException {
    final char c = reader.read();
    if (this.min < c && c < this.max) {
      throw new RuleMismatchException();
    }
  }

}

class Sequence implements Rule {

  private final Rule[] rules;

  Sequence(final Rule... rules) {
    this.rules = rules;
  }

  @Override
  public void exec(final InputReader reader) throws RuleMismatchException {
    for (final Rule rule : this.rules) {
      rule.exec(reader);
    }
  }

}

class OneOrMore implements Rule {

  private final Rule[] rules;

  OneOrMore(final Rule... rules) {
    this.rules = rules;
  }

  @Override
  public void exec(final InputReader reader) throws RuleMismatchException {
    for (final Rule rule : this.rules) {
      rule.exec(reader);
    }
    try {
      while (true) {
        for (final Rule rule : this.rules) {
          rule.exec(reader);
        }
      }
    } catch (final RuleMismatchException e) {
      // Does not match anymore => just continue
    }
  }

}

class ZeroOrMore implements Rule {

  private final Rule[] rules;

  ZeroOrMore(final Rule... rules) {
    this.rules = rules;
  }

  @Override
  public void exec(final InputReader reader) {
    try {
      while (true) {
        for (final Rule rule : this.rules) {
          rule.exec(reader);
        }
      }
    } catch (final RuleMismatchException e) {
      // Does not match anymore => just continue
    } catch (final JPEG.UnexpectedEndOfInputException e) {
      // Does not match anymore => just continue
    }
  }

}

class Optional implements Rule {

  private final Rule[] rules;

  Optional(final Rule... rules) {
    this.rules = rules;
  }

  @Override
  public void exec(final InputReader reader) {
    try {
      for (final Rule rule : this.rules) {
        rule.exec(reader);
      }
    } catch (final RuleMismatchException e) {
      // If not match ok => expected
    }
  }

}

class AndPredicate implements Rule {

  private final Rule[] rules;

  AndPredicate(final Rule... rules) {
    this.rules = rules;
  }

  @Override
  public void exec(final InputReader reader) throws RuleMismatchException {
    boolean caught = false;
    reader.mark();
    try {
      for (final Rule rule : this.rules) {
        rule.exec(reader);
      }
    } catch (final RuleMismatchException e) {
      // This does not match => unexpected
      caught = true;
    } catch (final JPEG.UnexpectedEndOfInputException e) {
      // This does not match => unexpected
      caught = true;
    } finally {
      reader.reset();
    }
    if (caught) {
      throw new RuleMismatchException();
    }
  }

}

class NotPredicate implements Rule {

  private final Rule[] rules;

  NotPredicate(final Rule... rules) {
    this.rules = rules;
  }

  @Override
  public void exec(final InputReader reader) throws RuleMismatchException {
    boolean caught = false;
    reader.mark();
    try {
      for (final Rule rule : this.rules) {
        rule.exec(reader);
      }
    } catch (final RuleMismatchException e) {
      // This does not match => expected
      caught = true;
    } catch (final JPEG.UnexpectedEndOfInputException e) {
      // This does not match => expected
      caught = true;
    } finally {
      reader.reset();
    }
    if (!caught) {
      throw new RuleMismatchException();
    }
  }

}
