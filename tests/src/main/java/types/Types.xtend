package types

import java.util.List

import static extension types.CharacterConsumer.*
import static extension types.CharacterRange.*

class Parser {
  
  int line = 1
  int column = 1
  
  package def addMatch(String match) {
    var s = match
    var idx = s.indexOf('\n')
    while (idx != -1) {
      column = 1
      line = line + 1
      s = s.substring(idx + 1)
    }
    column = column + s.length
  }
  
  package def getLocation() {
    line -> column
  }
  
  //--------------------------------------------------------------------------
  
  def Rule Rule(String in) {
    val result = rule(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input", location)
  }
  
  /**
   * Rule: expr+=(ExprA | ExprB) ; 
   */
  package def Pair<? extends Rule, String> rule(String in) {
    var result = new Rule
    var tail = in
    
    // expr+=(ExprA | ExprB)
    val result0 = tail.rule_sub0()
    tail = result0.value
    result.add(result0.key)
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  private def Pair<? extends Expr, String> rule_sub0(String in) {
    val tail = in
    // ExprA | ExprB
    try {
      return tail.exprA()
    } catch (ParseException e0) {
      try {
        return tail.exprB()
      } catch (ParseException e1) {
        throw e1
      }
    }
  }
  //--------------------------------------------------------------------------
  
  def Expr ExprA(String in) {
    val result = exprA(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input", location)
  }
  
  /**
   * ExprA returns Expr: 'a' ; 
   */
  package def Pair<? extends Expr, String> exprA(String in) {
    var result = new ExprA
    var tail = in
    
    // 'a'
    // 'a'
    val result0 =  tail.terminal('a', this)
    tail = result0.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  def Expr ExprB(String in) {
    val result = exprB(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input", location)
  }
  
  /**
   * ExprB returns Expr: 'b' ; 
   */
  package def Pair<? extends Expr, String> exprB(String in) {
    var result = new ExprB
    var tail = in
    
    // 'b'
    // 'b'
    val result0 =  tail.terminal('b', this)
    tail = result0.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  
}

class ParseException extends RuntimeException {
  
  @Property
  List<ParseException> causes
  
  @Property
  Pair<Integer, Integer> location
  
  new(String message, Pair<Integer, Integer> location) {
    super(message)
    this.location = location
  }
  
  def add(ParseException e) {
    causes = causes ?: newArrayList
    causes += e
  }
  
  override toString() {
    'ParseException [' + location.key + ',' + location.value + '] ' + super.toString() + if (causes != null) ':\n' + causes.join('\n') else ''
  }
  
}

package class CharacterRange {

  String chars

  static def operator_upTo(String lower, String upper) {
    return new CharacterRange(lower.charAt(0), upper.charAt(0))
  }
  
  static def operator_plus(CharacterRange r1, CharacterRange r2) {
    new CharacterRange(r1.chars + r2.chars)
  }

  static def operator_plus(CharacterRange r, String s) {
    new CharacterRange(r.chars  + s)
  }

  private new(char lower, char upper) {
    if (lower > upper) {
      throw new IllegalArgumentException('lower is great than upper bound')
    }

    val sb = new StringBuilder
    var c = lower
    while (c <= upper) {
      sb.append(c)
      c = ((c as int) + 1) as char
    }
    chars = sb.toString()
  }
  
  private new(String chars) {
    this.chars = chars
  }

  def contains(String s) {
    s.length > 0 && chars.contains(s.substring(0, 1))
  }
  
  override toString() {
    chars
  }

}

package class CharacterConsumer {

  static def Pair<Eoi, String> eoi(String input, Parser parser) {
    val r0 = new Eoi -> input

    if (input.length > 0) {
      throw new ParseException('Expected EOI', parser.location)
    }

    return r0
  }

  static def <T> terminal(String in, String str, Parser parser) {
    if (in.startsWith(str)) {
      parser.addMatch(str)
      new Terminal(str) -> in.substring(str.length)
    } else {
      throw new ParseException("Expected '" + str + "'", parser.location)
    }
  }
  
  static def <T> terminal(String in, CharacterRange range, Parser parser) {
    if (range.contains(in)) {
      val match = in.charAt(0).toString()
      parser.addMatch(match)
      new Terminal(match) -> in.substring(1)
    } else {
      throw new ParseException('Expected [' + range + ']', parser.location)
    }
  }

  static def <T> any(String in, Parser parser) {
    if (in.length > 0) {
      val match = in.substring(0, 1)
      parser.addMatch(match)
      new Terminal(match) -> in.substring(1)
    } else {
      throw new ParseException('Unexpected EOI', parser.location)
    }
  }

}

  package class Result {
    
    @Property
    String parsed
    
    def Result copy() {
      val r = new Result
      r._parsed = _parsed
      return r
    }
    
    def <T extends Result> T add(Result in) {
      val out = class.newInstance as T
      out.parsed = (this._parsed ?: '') + in._parsed
      return out
    }
    
    override toString() {
      parsed.replace('\n', ' ').replaceAll('\\s+', ' ')
    }
  
  }

  class Terminal extends Result {
  
    new() {
    }
  
    new(String parsed) {
      this.parsed = parsed
    }
  
    override Terminal copy() {
      val r = new Terminal
      r.parsed = parsed
      return r
    }
    
  
  }
  
  class Eoi extends Terminal {
  }
  
  class ExprA extends Expr {
    
    override ExprA copy() {
      val r = new ExprA
      return r
    }
    
  }
  
  class ExprB extends Expr {
    
    override ExprB copy() {
      val r = new ExprB
      return r
    }
    
  }
  
  class Rule extends Result {
    
    @Property
    java.util.List<Expr> expr
    
    def dispatch void add(Expr __expr) {
      _expr = _expr ?: newArrayList
      _expr += __expr
    }
    
    override Rule copy() {
      val r = new Rule
      r._expr = _expr
      return r
    }
    
  }
  
  class Expr extends Result {
    
    override Expr copy() {
      val r = new Expr
      return r
    }
    
  }
  
