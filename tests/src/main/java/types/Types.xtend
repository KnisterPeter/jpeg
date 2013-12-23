package types

import java.util.List

import static extension types.CharacterConsumer.*
import static extension types.CharacterRange.*

class Parser {
  
  char[] chars
  
  package def Derivation parse(int idx) {
    new Derivation(idx, [rule()],[exprA()],[exprB()],
      [
        if (chars.length == idx) {
          throw new ParseException('Unexpected end of input')
        }
        new Result<Character>(chars.get(idx), parse(idx + 1))
      ])
  }
  
  //--------------------------------------------------------------------------
  
  def Rule Rule(String in) {
    this.chars = in.toCharArray()
    val result = rule(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * Rule: expr+=(ExprA | ExprB) ; 
   */
  package def Result<? extends Rule> rule(Derivation derivation) {
    var node = new Rule
    var d = derivation
    
    // expr+=(ExprA | ExprB)
    val result0 = d.rule_sub0()
    d = result0.derivation
    node.add(result0.node)
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Rule>(node, d)
  }
  
  private def Result<? extends Expr> rule_sub0(Derivation derivation) {
    val d = derivation
    // ExprA | ExprB
    try {
      return d.dvExprA
    } catch (ParseException e0) {
      try {
        return d.dvExprB
      } catch (ParseException e1) {
        throw e1
      }
    }
  }
  //--------------------------------------------------------------------------
  
  def Expr ExprA(String in) {
    this.chars = in.toCharArray()
    val result = exprA(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ExprA returns Expr: 'a' ; 
   */
  package def Result<? extends Expr> exprA(Derivation derivation) {
    var node = new ExprA
    var d = derivation
    
    // 'a'
    // 'a'
    val result0 =  d.terminal('a', this)
    d = result0.derivation
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expr>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expr ExprB(String in) {
    this.chars = in.toCharArray()
    val result = exprB(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ExprB returns Expr: 'b' ; 
   */
  package def Result<? extends Expr> exprB(Derivation derivation) {
    var node = new ExprB
    var d = derivation
    
    // 'b'
    // 'b'
    val result0 =  d.terminal('b', this)
    d = result0.derivation
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expr>(node, d)
  }
  
  
}

package class Derivation {
  
  int idx
  
  val (Derivation)=>Result<? extends Rule> dvfRule
  val (Derivation)=>Result<? extends Expr> dvfExprA
  val (Derivation)=>Result<? extends Expr> dvfExprB
  val (Derivation)=>Result<Character> dvfChar
  
  Result<? extends Rule> dvRule
  Result<? extends Expr> dvExprA
  Result<? extends Expr> dvExprB
  Result<Character> dvChar
  
  new(int idx, (Derivation)=>Result<? extends Rule> dvfRule, (Derivation)=>Result<? extends Expr> dvfExprA, (Derivation)=>Result<? extends Expr> dvfExprB, (Derivation)=>Result<Character> dvfChar) {
    this.idx = idx
    this.dvfRule = dvfRule
    this.dvfExprA = dvfExprA
    this.dvfExprB = dvfExprB
    this.dvfChar = dvfChar
  }
  
  def getIndex() {
    idx
  }
  
  def getDvRule() {
    if (dvRule == null) {
      dvRule = dvfRule.apply(this)
    }
    return dvRule
  }
  
  def getDvExprA() {
    if (dvExprA == null) {
      dvExprA = dvfExprA.apply(this)
    }
    return dvExprA
  }
  
  def getDvExprB() {
    if (dvExprB == null) {
      dvExprB = dvfExprB.apply(this)
    }
    return dvExprB
  }
  
  
  def getDvChar() {
    if (dvChar == null) {
      dvChar = dvfChar.apply(this)
    }
    return dvChar
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
    'ParseException ' + super.localizedMessage + if (causes != null) ':\n' + causes.join('\n') else ''
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

  def contains(Character c) {
    chars.indexOf(c) != -1
  }
  
  override toString() {
    chars
  }

}

package class CharacterConsumer {

  static def Result<Eoi> eoi(Derivation derivation, Parser parser) {
    var exception = false
    try {
      derivation.dvChar
    } catch (ParseException e) {
      exception = true
    }
    return 
      if (exception) new Result<Eoi>(new Eoi, derivation) 
      else throw new ParseException('Expected EOI')
  }

  static def <T> terminal(Derivation derivation, String str, Parser parser) {
    var n = 0
    var d = derivation
    while (n < str.length) {
      val r = d.dvChar
      if (r.node != str.charAt(n)) {
        throw new ParseException("Expected '" + str + "'")
      }
      n = n + 1
      d = r.derivation
    }
    new Result<Terminal>(new Terminal(str), d)
  }
  
  static def <T> terminal(Derivation derivation, CharacterRange range, Parser parser) {
    val r = derivation.dvChar
    return 
      if (range.contains(r.node)) new Result<Terminal>(new Terminal(r.node), r.derivation)
      else throw new ParseException('Expected [' + range + ']')
  }

  static def <T> any(Derivation derivation, Parser parser) {
    val r = derivation.dvChar
    new Result<Terminal>(new Terminal(r.node), r.derivation)
  }

}

  @Data
  package class Result<T> {
    
    T node
    
    Derivation derivation
    
  }

  package class Node {
    
    @Property
    String parsed
    
    def Node copy() {
      val r = new Node
      r._parsed = _parsed
      return r
    }
    
    def <T extends Node> T add(Node in) {
      val out = class.newInstance as T
      out.parsed = (this._parsed ?: '') + in._parsed
      return out
    }
    
    override toString() {
      parsed.replace('\n', ' ').replaceAll('\\s+', ' ')
    }
  
  }

  class Terminal extends Node {
  
    new() {
    }
  
    new(Character parsed) {
      this.parsed = parsed.toString()
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
  
  class Rule extends Node {
    
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
  
  class Expr extends Node {
    
    override Expr copy() {
      val r = new Expr
      return r
    }
    
  }
  
