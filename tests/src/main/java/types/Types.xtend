package types

import java.util.List

import static extension types.CharacterRange.*
import static extension types.Extensions.*

class Parser {
  
  //--------------------------------------------------------------------------
  
  static def Rule Rule(String in) {
    val result = rule(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * Rule: expr+=(ExprA | ExprB) ; 
   */
  package static def Pair<? extends Rule, String> rule(String in) {
    var result = new Rule
    var tail = in
    
    // expr+=(ExprA | ExprB)
    val result0 = tail.rule_sub0()
    tail = result0.value
    result.add(result0.key)
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  private static  def Pair<? extends Expr, String> rule_sub0(String in) {
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
  
  static def Expr ExprA(String in) {
    val result = exprA(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ExprA returns Expr: 'a' ; 
   */
  package static def Pair<? extends Expr, String> exprA(String in) {
    var result = new ExprA
    var tail = in
    
    // 'a'
    // 'a'
    val result0 =  tail.terminal('a')
    tail = result0.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expr ExprB(String in) {
    val result = exprB(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ExprB returns Expr: 'b' ; 
   */
  package static def Pair<? extends Expr, String> exprB(String in) {
    var result = new ExprB
    var tail = in
    
    // 'b'
    // 'b'
    val result0 =  tail.terminal('b')
    tail = result0.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  
}

class ParseException extends RuntimeException {
  
  @Property
  List<ParseException> causes
  
  new(String message) {
    super(message)
  }
  
  def add(ParseException e) {
    causes = causes ?: newArrayList
    causes += e
  }
  
  override toString() {
    super.toString() + if (causes != null) ':\n' + causes.join('\n') else ''
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

  new(char lower, char upper) {
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

package class Extensions {

  static def Pair<Eoi, String> eoi(String input) {
    val r0 = new Eoi -> input

    if (input.length > 0) {
      throw new ParseException("Expected EOI")
    }

    return r0
  }

  static def <T> terminal(String in, String str) {
    if (in.startsWith(str)) {
      new Terminal(str) -> in.substring(str.length)
    } else {
      throw new ParseException('Expected ' + str)
    }
  }
  
  static def <T> terminal(String in, CharacterRange range) {
    if (range.contains(in)) {
      new Terminal(in.charAt(0).toString()) -> in.substring(1)
    } else {
      throw new ParseException('Expected ' + range)
    }
  }

  static def <T> any(String in) {
    if (in.length > 0) {
      new Terminal(in.substring(0, 1)) -> in.substring(1)
    } else {
      throw new ParseException('Unexpected EOI')
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

  package class Terminal extends Result {
  
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
  
