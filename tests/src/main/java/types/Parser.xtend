package types

import java.util.Set

import static extension types.CharacterRange.*
import static extension types.Parser.*

class Parser {
  
  package static Result<Object> CONTINUE = new SpecialResult(new Object)
  package static Result<Object> BREAK = new SpecialResult(null)
  
  package char[] chars
  
  package def Derivation parse(int idx) {
    new Derivation(this, idx, [
        return 
          if (idx < chars.length) new Result<Character>(chars.get(idx), parse(idx + 1), new ParseInfo(idx))
          else new Result<Character>(null, parse(idx), new ParseInfo(idx, 'Unexpected end of input'))
      ])
  }
  
  package def getLineAndColumn(int idx) {
    var line = 1
    var column = 0
    var n = 0
    val nl = '\n'.charAt(0)
    while (n < idx) {
      if (chars.get(n) === nl) { line = line + 1; column = 0 }
      else column = column + 1
      n = n + 1
    }
    return line -> column
  }
  
  static def Result<Terminal> __terminal(Derivation derivation, String str) {
    var n = 0
    var d = derivation
    while (n < str.length) {
      val r = d.dvChar
      d = r.derivation
      if (r.node == null || r.node != str.charAt(n)) {
        return new Result<Terminal>(null, derivation, new ParseInfo(d.index, "'" + str + "'"))
      }
      n = n + 1
    }
    new Result<Terminal>(new Terminal(str), d, new ParseInfo(d.index))
  }
  
  static def Result<Terminal> __oneOfThese(Derivation derivation, CharacterRange range) {
    val r = derivation.dvChar
    return 
      if (r.node != null && range.contains(r.node)) new Result<Terminal>(new Terminal(r.node), r.derivation, new ParseInfo(r.derivation.index))
      else new Result<Terminal>(null, derivation, new ParseInfo(r.derivation.index, "'" + range + "'"))
  }

  static def Result<Terminal> __oneOfThese(Derivation derivation, String range) {
    derivation.__oneOfThese(new CharacterRange(range))
  }

  static def Result<Terminal> __any(Derivation derivation) {
    val r = derivation.dvChar
    return
      if (r.node != null) new Result<Terminal>(new Terminal(r.node), r.derivation, new ParseInfo(r.derivation.index))
      else  new Result<Terminal>(null, derivation, new ParseInfo(r.derivation.index, 'end of input'))
  }

  def Rule Rule(String in) {
    this.chars = in.toCharArray()
    val result = RuleRule.matchRule(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expr ExprA(String in) {
    this.chars = in.toCharArray()
    val result = ExprARule.matchExprA(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expr ExprB(String in) {
    this.chars = in.toCharArray()
    val result = ExprBRule.matchExprB(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  
}

package class RuleRule {

  /**
   * Rule: expr+=(ExprA | ExprB) ; 
   */
  package static def Result<? extends Rule> matchRule(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new Rule
      var d = derivation
      
      // expr+=(ExprA | ExprB)\u000a
      val result2 = d.sub0MatchRule(parser)
      d = result2.derivation
      result = result2.joinErrors(result, false)
      if (result.node != null) {
        node.add(result2.node)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Rule>(node, d, result.info)
      }
      return new Result<Rule>(null, derivation, result.info)
  }
  
  private static def Result<? extends Expr> sub0MatchRule(Derivation derivation, Parser parser) {
      var Result<?> result = null
      var Expr node = null
      var d = derivation
      
      // ExprA | ExprB
      val backup0 = node?.copy()
      val backup1 = d
      
      // ExprA 
      val result0 = d.dvExprA
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node == null) {
        node = backup0
        d = backup1
        val backup2 = node?.copy()
        val backup3 = d
        
        // ExprB
        val result1 = d.dvExprB
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node == null) {
          node = backup2
          d = backup3
        }
      }
      
      return result as Result<? extends Expr>
  }
  
}
package class ExprARule {

  /**
   * ExprA returns Expr: 'a' ; 
   */
  package static def Result<? extends Expr> matchExprA(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new ExprA
      var d = derivation
      
      // 'a'\u000a
      val result0 =  d.__terminal('a')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expr>(node, d, result.info)
      }
      return new Result<Expr>(null, derivation, result.info)
  }
  
  
}
package class ExprBRule {

  /**
   * ExprB returns Expr: 'b' ; 
   */
  package static def Result<? extends Expr> matchExprB(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new ExprB
      var d = derivation
      
      // 'b'\u000a
      val result0 =  d.__terminal('b')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expr>(node, d, result.info)
      }
      return new Result<Expr>(null, derivation, result.info)
  }
  
  
}
  
package class Derivation {
  
  Parser parser
  
  int idx
  
  val (Derivation)=>Result<Character> dvfChar
  
  Result<? extends Rule> dvRule
  Result<? extends Expr> dvExprA
  Result<? extends Expr> dvExprB
  Result<Character> dvChar
  
  new(Parser parser, int idx, (Derivation)=>Result<Character> dvfChar) {
    this.parser = parser
    this.idx = idx
    this.dvfChar = dvfChar
  }
  
  def getIndex() {
    idx
  }
  
  def getDvRule() {
    if (dvRule == null) {
      // Fail LR upfront
      dvRule = new Result<Rule>(null, this, new ParseInfo(index, 'Detected left-recursion in Rule'))
      dvRule = RuleRule.matchRule(parser, this)
    }
    return dvRule
  }
  
  def getDvExprA() {
    if (dvExprA == null) {
      // Fail LR upfront
      dvExprA = new Result<ExprA>(null, this, new ParseInfo(index, 'Detected left-recursion in ExprA'))
      dvExprA = ExprARule.matchExprA(parser, this)
    }
    return dvExprA
  }
  
  def getDvExprB() {
    if (dvExprB == null) {
      // Fail LR upfront
      dvExprB = new Result<ExprB>(null, this, new ParseInfo(index, 'Detected left-recursion in ExprB'))
      dvExprB = ExprBRule.matchExprB(parser, this)
    }
    return dvExprB
  }
  
  
  def getDvChar() {
    if (dvChar == null) {
      dvChar = dvfChar.apply(this)
    }
    return dvChar
  }
  
  override toString() {
    new String(parser.chars, index, Math.min(100, parser.chars.length - index))
  }

}

class ParseException extends RuntimeException {
  
  new(String message) {
    super(message)
  }
  
  new(Pair<Integer, Integer> location, String... message) {
    super("[" + location.key + "," + location.value + "] Expected " 
      + if (message != null) message.join(' or ').replaceAll('\n', '\\\\n').replaceAll('\r', '\\\\r') else '')
  }
  
  override getMessage() { 'ParseException' + super.message }
  override toString() { message }
  
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
  
  package new(String chars) {
    this.chars = chars
  }

  def contains(Character c) {
    chars.indexOf(c) != -1
  }
  
  override toString() {
    chars
  }

}

package class Result<T> {
  
  T node
  
  Derivation derivation
  
  ParseInfo info
  
  new(T node, Derivation derivation, ParseInfo info) {
    this.node = node
    this.derivation = derivation
    this.info = info
  }
  
  def getNode() { node }
  def getDerivation() { derivation }
  def getInfo() { info }
  def setInfo(ParseInfo info) { this.info = info }
  
  def Result<?> joinErrors(Result<?> r2, boolean inPredicate) {
    if (r2 != null) {
      if (inPredicate) {
        info = r2.info
      } else {
        info = 
          if (info.position > r2.info.position || r2.info.messages == null) info
          else if (info.position < r2.info.position || info.messages == null) r2.info
          else new ParseInfo(info.position, info.messages + r2.info.messages)
      }
    }
    return this
  }
  
  override toString() {
    'Result[' + (if (node != null) 'MATCH' else 'NO MATCH') + ']'
  }
  
}

package class SpecialResult extends Result<Object> {
  new(Object o) { super(o, null, null) }
  override joinErrors(Result<?> r2, boolean inPredicate) { 
    info = r2.info
    return this
  }
}

@Data
package class ParseInfo {
  
  int position
  
  Set<String> messages
  
  new(int position) {
    this(position, null as Iterable<String>) 
  }
  
  new(int position, String message) {
    this(position, newHashSet(message)) 
  }
  
  new(int position, Iterable<String> messages) {
    this._position = position
    this._messages = messages?.toSet
  }
  
}

