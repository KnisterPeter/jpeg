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
    val nl = '\n'.charAt(0)
    
    var line = 1
    var column = 0
    if (idx > 0) 
      for (n : 0..(idx - 1))
        if (chars.get(n) === nl) { line = line + 1; column = 0 }
        else column = column + 1
    return line -> column
  }
  
  package static def Result<Terminal> __terminal(Derivation derivation, String str) {
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
  
  package static def Result<Terminal> __oneOfThese(Derivation derivation, CharacterRange range) {
    val r = derivation.dvChar
    return 
      if (r.node != null && range.contains(r.node)) new Result<Terminal>(new Terminal(r.node), r.derivation, new ParseInfo(r.derivation.index))
      else new Result<Terminal>(null, derivation, new ParseInfo(r.derivation.index, "'" + range + "'"))
  }

  package static def Result<Terminal> __oneOfThese(Derivation derivation, String range) {
    derivation.__oneOfThese(new CharacterRange(range))
  }

  package static def Result<Terminal> __any(Derivation derivation) {
    val r = derivation.dvChar
    return
      if (r.node != null) new Result<Terminal>(new Terminal(r.node), r.derivation, new ParseInfo(r.derivation.index))
      else  new Result<Terminal>(null, derivation, new ParseInfo(r.derivation.index, 'end of input'))
  }

  def Rule Rule(String in) {
    this.chars = in.toCharArray()
    val result = parse(0).dvRule
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expr Expr(String in) {
    this.chars = in.toCharArray()
    val result = parse(0).dvExpr
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expr ExprA(String in) {
    this.chars = in.toCharArray()
    val result = parse(0).dvExprA
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expr ExprB(String in) {
    this.chars = in.toCharArray()
    val result = parse(0).dvExprB
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  
}

package class RuleRule {

  /**
   * Rule <- expr+=(ExprA / ExprB); 
   */
  package static def Result<? extends Rule> matchRule(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Rule node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // expr+=(ExprA / ExprB)
    val result2 = d.sub0MatchRule(parser)
    d = result2.derivation
    result = result2
    info.join(result2, false)
    if (result.node != null) {
      if (node == null) {
        node = new Rule
      }
      node.add(result2.node)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new Rule()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Rule>(node, d, result.info)
    }
    return new Result<Rule>(null, derivation, result.info)
  }
  
  private static def Result<? extends Expr> sub0MatchRule(Derivation derivation, Parser parser) {
      var Result<? extends Expr> result = null
      var Expr node = new Expr
      var d = derivation
      val ParseInfo info = new ParseInfo(derivation.index)
      
      // ExprA / ExprB
      val backup0 = node?.copy()
      val backup1 = d
      
      val result0 = d.dvExprA
      d = result0.derivation
      result = result0
      info.join(result0, false)
      if (result.node == null) {
        node = backup0
        d = backup1
        val backup2 = node?.copy()
        val backup3 = d
        
        val result1 = d.dvExprB
        d = result1.derivation
        result = result1
        info.join(result1, false)
        if (result.node == null) {
          node = backup2
          d = backup3
        }
      }
      
      result.info = info
      return result
  }
  
}
package class ExprRule {

  /**
   * Expr <- ExprA / ExprB; 
   */
  package static def Result<? extends Expr> matchExpr(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Expr node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // ExprA / ExprB
    val backup0 = node?.copy()
    val backup1 = d
    
    val result0 = d.dvExprA
    d = result0.derivation
    if (node == null) {
      node = result0.node
    }
    result = result0
    info.join(result0, false)
    if (result.node == null) {
      node = backup0
      d = backup1
      val backup2 = node?.copy()
      val backup3 = d
      
      val result1 = d.dvExprB
      d = result1.derivation
      if (node == null) {
        node = result1.node
      }
      result = result1
      info.join(result1, false)
      if (result.node == null) {
        node = backup2
        d = backup3
      }
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new Expr()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Expr>(node, d, result.info)
    }
    return new Result<Expr>(null, derivation, result.info)
  }
  
  
}
package class ExprARule {

  /**
   * ExprA[Expr] <- 'a'; 
   */
  package static def Result<? extends Expr> matchExprA(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Expr node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val result0 =  d.__terminal('a')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new ExprA()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Expr>(node, d, result.info)
    }
    return new Result<Expr>(null, derivation, result.info)
  }
  
  
}
package class ExprBRule {

  /**
   * ExprB[Expr] <- 'b'; 
   */
  package static def Result<? extends Expr> matchExprB(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Expr node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val result0 =  d.__terminal('b')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new ExprB()
      }
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
  Result<? extends Expr> dvExpr
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
      val lr = new Result<Rule>(false, this, new ParseInfo(index, "Detected non-terminating left-recursion in 'Rule'"))
      dvRule = lr
      dvRule = RuleRule.matchRule(parser, this)
      if (lr.leftRecursive && dvRule.node != null) {
        growDvRule()
      }
    } if (dvRule.leftRecursive != null) {
      dvRule.setLeftRecursive()
    }
    return dvRule
  }
  
  private def growDvRule() {
    while(true) {
      val temp = RuleRule.matchRule(parser, this)
      if (temp.node == null || temp.derivation.idx <= dvRule.derivation.idx) return
      else dvRule = temp
    }
  }
  
  def getDvExpr() {
    if (dvExpr == null) {
      val lr = new Result<Expr>(false, this, new ParseInfo(index, "Detected non-terminating left-recursion in 'Expr'"))
      dvExpr = lr
      dvExpr = ExprRule.matchExpr(parser, this)
      if (lr.leftRecursive && dvExpr.node != null) {
        growDvExpr()
      }
    } if (dvExpr.leftRecursive != null) {
      dvExpr.setLeftRecursive()
    }
    return dvExpr
  }
  
  private def growDvExpr() {
    while(true) {
      val temp = ExprRule.matchExpr(parser, this)
      if (temp.node == null || temp.derivation.idx <= dvExpr.derivation.idx) return
      else dvExpr = temp
    }
  }
  
  def getDvExprA() {
    if (dvExprA == null) {
      val lr = new Result<ExprA>(false, this, new ParseInfo(index, "Detected non-terminating left-recursion in 'ExprA'"))
      dvExprA = lr
      dvExprA = ExprARule.matchExprA(parser, this)
      if (lr.leftRecursive && dvExprA.node != null) {
        growDvExprA()
      }
    } if (dvExprA.leftRecursive != null) {
      dvExprA.setLeftRecursive()
    }
    return dvExprA
  }
  
  private def growDvExprA() {
    while(true) {
      val temp = ExprARule.matchExprA(parser, this)
      if (temp.node == null || temp.derivation.idx <= dvExprA.derivation.idx) return
      else dvExprA = temp
    }
  }
  
  def getDvExprB() {
    if (dvExprB == null) {
      val lr = new Result<ExprB>(false, this, new ParseInfo(index, "Detected non-terminating left-recursion in 'ExprB'"))
      dvExprB = lr
      dvExprB = ExprBRule.matchExprB(parser, this)
      if (lr.leftRecursive && dvExprB.node != null) {
        growDvExprB()
      }
    } if (dvExprB.leftRecursive != null) {
      dvExprB.setLeftRecursive()
    }
    return dvExprB
  }
  
  private def growDvExprB() {
    while(true) {
      val temp = ExprBRule.matchExprB(parser, this)
      if (temp.node == null || temp.derivation.idx <= dvExprB.derivation.idx) return
      else dvExprB = temp
    }
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

    val sb = new StringBuilder(upper - lower)
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
  
  Boolean leftRecursion = null
  
  Derivation derivation
  
  ParseInfo info
  
  new(T node, Derivation derivation, ParseInfo info) {
    this.node = node
    this.derivation = derivation
    this.info = info
  }
  
  new(boolean leftRecursion, Derivation derivation, ParseInfo info) {
    this(null, derivation, info)
    this.leftRecursion = leftRecursion
  }
  
  def getNode() { node }
  def getDerivation() { derivation }
  def getInfo() { info }
  def setInfo(ParseInfo info) { this.info = info }
  def isLeftRecursive() { leftRecursion }
  def setLeftRecursive() { leftRecursion = true }
  
  override toString() {
    'Result[' + (if (node != null) 'MATCH' else 'NO MATCH') + ']'
  }
  
}

package class SpecialResult extends Result<Object> {
  new(Object o) { super(o, null, null) }
}

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
    this.position = position
    this.messages = messages?.toSet
  }
  
  def getPosition() { position }
  def getMessages() { messages }
  
  def join(Result<?> r, boolean inPredicate) {
    if (!inPredicate && r != null && r.info != null) {
      if (position > r.info.position || r.info.messages == null) {
        // Do nothing
      } else if (position < r.info.position || messages == null) {
        position = r.info.position
        messages = r.info.messages
      } else {
        messages += r.info.messages
      }
    }
  }
  
}

