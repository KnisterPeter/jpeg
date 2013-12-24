package jpeg

import java.util.Set

import static extension jpeg.CharacterRange.*
import static extension jpeg.Parser.*

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

  def Jpeg Jpeg(String in) {
    this.chars = in.toCharArray()
    val result = JpegRule.matchJpeg(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Rule Rule(String in) {
    this.chars = in.toCharArray()
    val result = RuleRule.matchRule(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def RuleReturns RuleReturns(String in) {
    this.chars = in.toCharArray()
    val result = RuleReturnsRule.matchRuleReturns(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Body Body(String in) {
    this.chars = in.toCharArray()
    val result = BodyRule.matchBody(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression ChoiceExpression(String in) {
    this.chars = in.toCharArray()
    val result = ChoiceExpressionRule.matchChoiceExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression SequenceExpression(String in) {
    this.chars = in.toCharArray()
    val result = SequenceExpressionRule.matchSequenceExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression ActionExpression(String in) {
    this.chars = in.toCharArray()
    val result = ActionExpressionRule.matchActionExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression AndPredicateExpression(String in) {
    this.chars = in.toCharArray()
    val result = AndPredicateExpressionRule.matchAndPredicateExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression NotPredicateExpression(String in) {
    this.chars = in.toCharArray()
    val result = NotPredicateExpressionRule.matchNotPredicateExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression OneOrMoreExpression(String in) {
    this.chars = in.toCharArray()
    val result = OneOrMoreExpressionRule.matchOneOrMoreExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression ZeroOrMoreExpression(String in) {
    this.chars = in.toCharArray()
    val result = ZeroOrMoreExpressionRule.matchZeroOrMoreExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression OptionalExpression(String in) {
    this.chars = in.toCharArray()
    val result = OptionalExpressionRule.matchOptionalExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression AssignableExpression(String in) {
    this.chars = in.toCharArray()
    val result = AssignableExpressionRule.matchAssignableExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def AssignmentOperator AssignmentOperator(String in) {
    this.chars = in.toCharArray()
    val result = AssignmentOperatorRule.matchAssignmentOperator(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression SubExpression(String in) {
    this.chars = in.toCharArray()
    val result = SubExpressionRule.matchSubExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression RangeExpression(String in) {
    this.chars = in.toCharArray()
    val result = RangeExpressionRule.matchRangeExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def MinMaxRange MinMaxRange(String in) {
    this.chars = in.toCharArray()
    val result = MinMaxRangeRule.matchMinMaxRange(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def CharRange CharRange(String in) {
    this.chars = in.toCharArray()
    val result = CharRangeRule.matchCharRange(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression AnyCharExpression(String in) {
    this.chars = in.toCharArray()
    val result = AnyCharExpressionRule.matchAnyCharExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression RuleReferenceExpression(String in) {
    this.chars = in.toCharArray()
    val result = RuleReferenceExpressionRule.matchRuleReferenceExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Expression TerminalExpression(String in) {
    this.chars = in.toCharArray()
    val result = TerminalExpressionRule.matchTerminalExpression(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def InTerminalChar InTerminalChar(String in) {
    this.chars = in.toCharArray()
    val result = InTerminalCharRule.matchInTerminalChar(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def Comment Comment(String in) {
    this.chars = in.toCharArray()
    val result = CommentRule.matchComment(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def EOI EOI(String in) {
    this.chars = in.toCharArray()
    val result = EOIRule.matchEOI(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def ID ID(String in) {
    this.chars = in.toCharArray()
    val result = IDRule.matchID(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def WS WS(String in) {
    this.chars = in.toCharArray()
    val result = WSRule.matchWS(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  def _ _(String in) {
    this.chars = in.toCharArray()
    val result = _Rule.match_(this, parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  
}

package class JpegRule {

  /**
   * Jpeg : (rules+=Rule | Comment)+ EOI ; 
   */
  package static def Result<? extends Jpeg> matchJpeg(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new Jpeg
      var d = derivation
      
      // (rules+=Rule | Comment)+ 
      var backup0 = node?.copy()
      var backup1 = d
      var loop0 = false
      
      do {
        // (rules+=Rule | Comment)
        // rules+=Rule | Comment
        val backup2 = node?.copy()
        val backup3 = d
        
        // rules+=Rule 
        val result0 = d.dvRule
        d = result0.derivation
        result = result0.joinErrors(result, false)
        if (result.node != null) {
          node.add(result0.node)
        }
        if (result.node == null) {
          node = backup2
          d = backup3
          val backup4 = node?.copy()
          val backup5 = d
          
          // Comment
          val result1 = d.dvComment
          d = result1.derivation
          result = result1.joinErrors(result, false)
          if (result.node == null) {
            node = backup4
            d = backup5
          }
        }
        
        if (result.node != null) {
          loop0 = true
          backup0 = node?.copy()
          backup1 = d
        }
      } while(result.node != null)
      if (!loop0) {
        node = backup0
        d = backup1
      } else {
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // EOI\u000a
        val result2 = d.dvEOI
        d = result2.derivation
        result = result2.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Jpeg>(node, d, result.info)
      }
      return new Result<Jpeg>(null, derivation, result.info)
  }
  
  
}
package class RuleRule {

  /**
   * Rule : name=ID _ returns=RuleReturns? ':' _ body=Body ';' _ ; 
   */
  package static def Result<? extends Rule> matchRule(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new Rule
      var d = derivation
      
      // name=ID 
      val result0 = d.dvID
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node != null) {
        node.setName(result0.node)
      }
      
      if (result.node != null) {
        // _ 
        val result1 = d.dv_
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // returns=RuleReturns? 
        val backup0 = node?.copy()
        val backup1 = d
        
        // returns=RuleReturns
        val result2 = d.dvRuleReturns
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node != null) {
          node.setReturns(result2.node)
        }
        if (result.node == null) {
          node = backup0
          d = backup1
          result = CONTINUE.joinErrors(result, false)
        }
      }
      
      if (result.node != null) {
        // ':' 
        val result3 =  d.__terminal(':')
        d = result3.derivation
        result = result3.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // _ 
        val result4 = d.dv_
        d = result4.derivation
        result = result4.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // body=Body 
        val result5 = d.dvBody
        d = result5.derivation
        result = result5.joinErrors(result, false)
        if (result.node != null) {
          node.setBody(result5.node)
        }
      }
      
      if (result.node != null) {
        // ';' 
        val result6 =  d.__terminal(';')
        d = result6.derivation
        result = result6.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // _\u000a
        val result7 = d.dv_
        d = result7.derivation
        result = result7.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Rule>(node, d, result.info)
      }
      return new Result<Rule>(null, derivation, result.info)
  }
  
  
}
package class RuleReturnsRule {

  /**
   * RuleReturns : 'returns' _ name=ID _ ; 
   */
  package static def Result<? extends RuleReturns> matchRuleReturns(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new RuleReturns
      var d = derivation
      
      // 'returns' 
      val result0 =  d.__terminal('returns')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        // _ 
        val result1 = d.dv_
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // name=ID 
        val result2 = d.dvID
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node != null) {
          node.setName(result2.node)
        }
      }
      
      if (result.node != null) {
        // _\u000a
        val result3 = d.dv_
        d = result3.derivation
        result = result3.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<RuleReturns>(node, d, result.info)
      }
      return new Result<RuleReturns>(null, derivation, result.info)
  }
  
  
}
package class BodyRule {

  /**
   * Body : (expressions+=ChoiceExpression _)+ ; 
   */
  package static def Result<? extends Body> matchBody(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new Body
      var d = derivation
      
      // (expressions+=ChoiceExpression _)+\u000a
      var backup0 = node?.copy()
      var backup1 = d
      var loop0 = false
      
      do {
        // (expressions+=ChoiceExpression _)
        // expressions+=ChoiceExpression 
        val result0 = d.dvChoiceExpression
        d = result0.derivation
        result = result0.joinErrors(result, false)
        if (result.node != null) {
          node.add(result0.node)
        }
        
        if (result.node != null) {
          // _
          val result1 = d.dv_
          d = result1.derivation
          result = result1.joinErrors(result, false)
        }
        
        if (result.node != null) {
          loop0 = true
          backup0 = node?.copy()
          backup1 = d
        }
      } while(result.node != null)
      if (!loop0) {
        node = backup0
        d = backup1
      } else {
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Body>(node, d, result.info)
      }
      return new Result<Body>(null, derivation, result.info)
  }
  
  
}
package class ChoiceExpressionRule {

  /**
   * ChoiceExpression returns Expression : choices+=SequenceExpression ('|' _ choices+=SequenceExpression)* ; 
   */
  package static def Result<? extends Expression> matchChoiceExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new ChoiceExpression
      var d = derivation
      
      // choices+=SequenceExpression 
      val result0 = d.dvSequenceExpression
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node != null) {
        node.add(result0.node)
      }
      
      if (result.node != null) {
        // ('|' _ choices+=SequenceExpression)*\u000a
        var backup0 = node?.copy()
        var backup1 = d
        
        do {
          // ('|' _ choices+=SequenceExpression)
          // '|' 
          val result1 =  d.__terminal('|')
          d = result1.derivation
          result = result1.joinErrors(result, false)
          
          if (result.node != null) {
            // _ 
            val result2 = d.dv_
            d = result2.derivation
            result = result2.joinErrors(result, false)
          }
          
          if (result.node != null) {
            // choices+=SequenceExpression
            val result3 = d.dvSequenceExpression
            d = result3.derivation
            result = result3.joinErrors(result, false)
            if (result.node != null) {
              node.add(result3.node)
            }
          }
          if (result.node != null) {
            backup0 = node?.copy()
            backup1 = d
          }
        } while (result.node != null)
        node = backup0
        d = backup1
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        if (node.choices.size() == 1) {
          return new Result<Expression>(node.choices.get(0), d, result.info)
        }
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class SequenceExpressionRule {

  /**
   * SequenceExpression returns Expression : ( Comment* expressions+=( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression ) _ )+ ; 
   */
  package static def Result<? extends Expression> matchSequenceExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new SequenceExpression
      var d = derivation
      
      // (\u000a    Comment*\u000a    expressions+=( ActionExpression\u000a                 | AndPredicateExpression\u000a                 | NotPredicateExpression\u000a                 | OneOrMoreExpression\u000a                 | ZeroOrMoreExpression\u000a                 | OptionalExpression\u000a                 | AssignableExpression\u000a                 )\u000a    _\u000a  )+\u000a
      var backup0 = node?.copy()
      var backup1 = d
      var loop0 = false
      
      do {
        // (\u000a    Comment*\u000a    expressions+=( ActionExpression\u000a                 | AndPredicateExpression\u000a                 | NotPredicateExpression\u000a                 | OneOrMoreExpression\u000a                 | ZeroOrMoreExpression\u000a                 | OptionalExpression\u000a                 | AssignableExpression\u000a                 )\u000a    _\u000a  )
        // Comment*\u000a    
        var backup2 = node?.copy()
        var backup3 = d
        
        do {
          // Comment
          val result0 = d.dvComment
          d = result0.derivation
          result = result0.joinErrors(result, false)
          if (result.node != null) {
            backup2 = node?.copy()
            backup3 = d
          }
        } while (result.node != null)
        node = backup2
        d = backup3
        result = CONTINUE.joinErrors(result, false)
        
        if (result.node != null) {
          // expressions+=( ActionExpression\u000a                 | AndPredicateExpression\u000a                 | NotPredicateExpression\u000a                 | OneOrMoreExpression\u000a                 | ZeroOrMoreExpression\u000a                 | OptionalExpression\u000a                 | AssignableExpression\u000a                 )\u000a    
          val result8 = d.sub0MatchSequenceExpression(parser)
          d = result8.derivation
          result = result8.joinErrors(result, false)
          if (result.node != null) {
            node.add(result8.node)
          }
        }
        
        if (result.node != null) {
          // _\u000a  
          val result9 = d.dv_
          d = result9.derivation
          result = result9.joinErrors(result, false)
        }
        
        if (result.node != null) {
          loop0 = true
          backup0 = node?.copy()
          backup1 = d
        }
      } while(result.node != null)
      if (!loop0) {
        node = backup0
        d = backup1
      } else {
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        if (node.expressions.size() == 1) {
          return new Result<Expression>(node.expressions.get(0), d, result.info)
        }
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  private static def Result<? extends Expression> sub0MatchSequenceExpression(Derivation derivation, Parser parser) {
      var Result<?> result = null
      var Expression node = null
      var d = derivation
      
      // ActionExpression\u000a                 | AndPredicateExpression\u000a                 | NotPredicateExpression\u000a                 | OneOrMoreExpression\u000a                 | ZeroOrMoreExpression\u000a                 | OptionalExpression\u000a                 | AssignableExpression\u000a                 
      val backup4 = node?.copy()
      val backup5 = d
      
      // ActionExpression\u000a                 
      val result1 = d.dvActionExpression
      d = result1.derivation
      result = result1.joinErrors(result, false)
      if (result.node == null) {
        node = backup4
        d = backup5
        val backup6 = node?.copy()
        val backup7 = d
        
        // AndPredicateExpression\u000a                 
        val result2 = d.dvAndPredicateExpression
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node == null) {
          node = backup6
          d = backup7
          val backup8 = node?.copy()
          val backup9 = d
          
          // NotPredicateExpression\u000a                 
          val result3 = d.dvNotPredicateExpression
          d = result3.derivation
          result = result3.joinErrors(result, false)
          if (result.node == null) {
            node = backup8
            d = backup9
            val backup10 = node?.copy()
            val backup11 = d
            
            // OneOrMoreExpression\u000a                 
            val result4 = d.dvOneOrMoreExpression
            d = result4.derivation
            result = result4.joinErrors(result, false)
            if (result.node == null) {
              node = backup10
              d = backup11
              val backup12 = node?.copy()
              val backup13 = d
              
              // ZeroOrMoreExpression\u000a                 
              val result5 = d.dvZeroOrMoreExpression
              d = result5.derivation
              result = result5.joinErrors(result, false)
              if (result.node == null) {
                node = backup12
                d = backup13
                val backup14 = node?.copy()
                val backup15 = d
                
                // OptionalExpression\u000a                 
                val result6 = d.dvOptionalExpression
                d = result6.derivation
                result = result6.joinErrors(result, false)
                if (result.node == null) {
                  node = backup14
                  d = backup15
                  val backup16 = node?.copy()
                  val backup17 = d
                  
                  // AssignableExpression\u000a                 
                  val result7 = d.dvAssignableExpression
                  d = result7.derivation
                  result = result7.joinErrors(result, false)
                  if (result.node == null) {
                    node = backup16
                    d = backup17
                  }
                }
              }
            }
          }
        }
      }
      
      return result as Result<? extends Expression>
  }
  
}
package class ActionExpressionRule {

  /**
   * ActionExpression returns Expression : '{' _ (property=ID _ op=AssignmentOperator ('current' | name=ID) _) '}' ; 
   */
  package static def Result<? extends Expression> matchActionExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new ActionExpression
      var d = derivation
      
      // '{' 
      val result0 =  d.__terminal('{')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        // _ 
        val result1 = d.dv_
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // (property=ID _ op=AssignmentOperator ('current' | name=ID) _) 
        // property=ID 
        val result2 = d.dvID
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node != null) {
          node.setProperty(result2.node)
        }
        
        if (result.node != null) {
          // _ 
          val result3 = d.dv_
          d = result3.derivation
          result = result3.joinErrors(result, false)
        }
        
        if (result.node != null) {
          // op=AssignmentOperator 
          val result4 = d.dvAssignmentOperator
          d = result4.derivation
          result = result4.joinErrors(result, false)
          if (result.node != null) {
            node.setOp(result4.node)
          }
        }
        
        if (result.node != null) {
          // ('current' | name=ID) 
          // 'current' | name=ID
          val backup0 = node?.copy()
          val backup1 = d
          
          // 'current' 
          val result5 =  d.__terminal('current')
          d = result5.derivation
          result = result5.joinErrors(result, false)
          if (result.node == null) {
            node = backup0
            d = backup1
            val backup2 = node?.copy()
            val backup3 = d
            
            // name=ID
            val result6 = d.dvID
            d = result6.derivation
            result = result6.joinErrors(result, false)
            if (result.node != null) {
              node.setName(result6.node)
            }
            if (result.node == null) {
              node = backup2
              d = backup3
            }
          }
        }
        
        if (result.node != null) {
          // _
          val result7 = d.dv_
          d = result7.derivation
          result = result7.joinErrors(result, false)
        }
      }
      
      if (result.node != null) {
        // '}'\u000a
        val result8 =  d.__terminal('}')
        d = result8.derivation
        result = result8.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class AndPredicateExpressionRule {

  /**
   * AndPredicateExpression returns Expression : '&' _ expr=AssignableExpression ; 
   */
  package static def Result<? extends Expression> matchAndPredicateExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new AndPredicateExpression
      var d = derivation
      
      // '&' 
      val result0 =  d.__terminal('&')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        // _ 
        val result1 = d.dv_
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // expr=AssignableExpression\u000a
        val result2 = d.dvAssignableExpression
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node != null) {
          node.setExpr(result2.node)
        }
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class NotPredicateExpressionRule {

  /**
   * NotPredicateExpression returns Expression : '!' _ expr=AssignableExpression ; 
   */
  package static def Result<? extends Expression> matchNotPredicateExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new NotPredicateExpression
      var d = derivation
      
      // '!' 
      val result0 =  d.__terminal('!')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        // _ 
        val result1 = d.dv_
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // expr=AssignableExpression\u000a
        val result2 = d.dvAssignableExpression
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node != null) {
          node.setExpr(result2.node)
        }
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class OneOrMoreExpressionRule {

  /**
   * OneOrMoreExpression returns Expression : expr=AssignableExpression '+' _ ; 
   */
  package static def Result<? extends Expression> matchOneOrMoreExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new OneOrMoreExpression
      var d = derivation
      
      // expr=AssignableExpression 
      val result0 = d.dvAssignableExpression
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node != null) {
        node.setExpr(result0.node)
      }
      
      if (result.node != null) {
        // '+' 
        val result1 =  d.__terminal('+')
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // _\u000a
        val result2 = d.dv_
        d = result2.derivation
        result = result2.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class ZeroOrMoreExpressionRule {

  /**
   * ZeroOrMoreExpression returns Expression : expr=AssignableExpression '*' _ ; 
   */
  package static def Result<? extends Expression> matchZeroOrMoreExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new ZeroOrMoreExpression
      var d = derivation
      
      // expr=AssignableExpression 
      val result0 = d.dvAssignableExpression
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node != null) {
        node.setExpr(result0.node)
      }
      
      if (result.node != null) {
        // '*' 
        val result1 =  d.__terminal('*')
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // _\u000a
        val result2 = d.dv_
        d = result2.derivation
        result = result2.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class OptionalExpressionRule {

  /**
   * OptionalExpression returns Expression : expr=AssignableExpression '?' _ ; 
   */
  package static def Result<? extends Expression> matchOptionalExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new OptionalExpression
      var d = derivation
      
      // expr=AssignableExpression 
      val result0 = d.dvAssignableExpression
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node != null) {
        node.setExpr(result0.node)
      }
      
      if (result.node != null) {
        // '?' 
        val result1 =  d.__terminal('?')
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // _\u000a
        val result2 = d.dv_
        d = result2.derivation
        result = result2.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class AssignableExpressionRule {

  /**
   * AssignableExpression returns Expression : (property=ID _ op=AssignmentOperator)? expr= ( SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression ) _ ; 
   */
  package static def Result<? extends Expression> matchAssignableExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new AssignableExpression
      var d = derivation
      
      // (property=ID _ op=AssignmentOperator)?\u000a  
      val backup0 = node?.copy()
      val backup1 = d
      
      // (property=ID _ op=AssignmentOperator)
      // property=ID 
      val result0 = d.dvID
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node != null) {
        node.setProperty(result0.node)
      }
      
      if (result.node != null) {
        // _ 
        val result1 = d.dv_
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // op=AssignmentOperator
        val result2 = d.dvAssignmentOperator
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node != null) {
          node.setOp(result2.node)
        }
      }
      if (result.node == null) {
        node = backup0
        d = backup1
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // expr=\u000a  ( SubExpression\u000a  | RangeExpression\u000a  | TerminalExpression\u000a  | AnyCharExpression\u000a  | RuleReferenceExpression\u000a  )\u000a  
        val result8 = d.sub0MatchAssignableExpression(parser)
        d = result8.derivation
        result = result8.joinErrors(result, false)
        if (result.node != null) {
          node.setExpr(result8.node)
        }
      }
      
      if (result.node != null) {
        // _\u000a
        val result9 = d.dv_
        d = result9.derivation
        result = result9.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  private static def Result<? extends Expression> sub0MatchAssignableExpression(Derivation derivation, Parser parser) {
      var Result<?> result = null
      var Expression node = null
      var d = derivation
      
      // SubExpression\u000a  | RangeExpression\u000a  | TerminalExpression\u000a  | AnyCharExpression\u000a  | RuleReferenceExpression\u000a  
      val backup2 = node?.copy()
      val backup3 = d
      
      // SubExpression\u000a  
      val result3 = d.dvSubExpression
      d = result3.derivation
      result = result3.joinErrors(result, false)
      if (result.node == null) {
        node = backup2
        d = backup3
        val backup4 = node?.copy()
        val backup5 = d
        
        // RangeExpression\u000a  
        val result4 = d.dvRangeExpression
        d = result4.derivation
        result = result4.joinErrors(result, false)
        if (result.node == null) {
          node = backup4
          d = backup5
          val backup6 = node?.copy()
          val backup7 = d
          
          // TerminalExpression\u000a  
          val result5 = d.dvTerminalExpression
          d = result5.derivation
          result = result5.joinErrors(result, false)
          if (result.node == null) {
            node = backup6
            d = backup7
            val backup8 = node?.copy()
            val backup9 = d
            
            // AnyCharExpression\u000a  
            val result6 = d.dvAnyCharExpression
            d = result6.derivation
            result = result6.joinErrors(result, false)
            if (result.node == null) {
              node = backup8
              d = backup9
              val backup10 = node?.copy()
              val backup11 = d
              
              // RuleReferenceExpression\u000a  
              val result7 = d.dvRuleReferenceExpression
              d = result7.derivation
              result = result7.joinErrors(result, false)
              if (result.node == null) {
                node = backup10
                d = backup11
              }
            }
          }
        }
      }
      
      return result as Result<? extends Expression>
  }
  
}
package class AssignmentOperatorRule {

  /**
   * AssignmentOperator : (single?='=' | multi?='+=' | bool?='?=') _ ; 
   */
  package static def Result<? extends AssignmentOperator> matchAssignmentOperator(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new AssignmentOperator
      var d = derivation
      
      // (single?='=' | multi?='+=' | bool?='?=')\u000a  
      // single?='=' | multi?='+=' | bool?='?='
      val backup0 = node?.copy()
      val backup1 = d
      
      // single?='=' 
      val result0 =  d.__terminal('=')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node != null) {
        node.setSingle(result0.node != null)
      }
      if (result.node == null) {
        node = backup0
        d = backup1
        val backup2 = node?.copy()
        val backup3 = d
        
        // multi?='+=' 
        val result1 =  d.__terminal('+=')
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          node.setMulti(result1.node != null)
        }
        if (result.node == null) {
          node = backup2
          d = backup3
          val backup4 = node?.copy()
          val backup5 = d
          
          // bool?='?='
          val result2 =  d.__terminal('?=')
          d = result2.derivation
          result = result2.joinErrors(result, false)
          if (result.node != null) {
            node.setBool(result2.node != null)
          }
          if (result.node == null) {
            node = backup4
            d = backup5
          }
        }
      }
      
      if (result.node != null) {
        // _\u000a
        val result3 = d.dv_
        d = result3.derivation
        result = result3.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<AssignmentOperator>(node, d, result.info)
      }
      return new Result<AssignmentOperator>(null, derivation, result.info)
  }
  
  
}
package class SubExpressionRule {

  /**
   * SubExpression returns Expression : '(' _ expr=ChoiceExpression ')' _ ; 
   */
  package static def Result<? extends Expression> matchSubExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new SubExpression
      var d = derivation
      
      // '(' 
      val result0 =  d.__terminal('(')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        // _ 
        val result1 = d.dv_
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // expr=ChoiceExpression 
        val result2 = d.dvChoiceExpression
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node != null) {
          node.setExpr(result2.node)
        }
      }
      
      if (result.node != null) {
        // ')' 
        val result3 =  d.__terminal(')')
        d = result3.derivation
        result = result3.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // _\u000a
        val result4 = d.dv_
        d = result4.derivation
        result = result4.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class RangeExpressionRule {

  /**
   * RangeExpression returns Expression : '[' dash='-'? (!']' ranges+=(MinMaxRange | CharRange))* ']' _ ; 
   */
  package static def Result<? extends Expression> matchRangeExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new RangeExpression
      var d = derivation
      
      // '[' 
      val result0 =  d.__terminal('[')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        // dash='-'? 
        val backup0 = node?.copy()
        val backup1 = d
        
        // dash='-'
        val result1 =  d.__terminal('-')
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          node.setDash(result1.node)
        }
        if (result.node == null) {
          node = backup0
          d = backup1
          result = CONTINUE.joinErrors(result, false)
        }
      }
      
      if (result.node != null) {
        // (!']' ranges+=(MinMaxRange | CharRange))* 
        var backup2 = node?.copy()
        var backup3 = d
        
        do {
          // (!']' ranges+=(MinMaxRange | CharRange))
          val backup4 = node?.copy()
          val backup5 = d
          // ']' 
          val result2 =  d.__terminal(']')
          d = result2.derivation
          result = result2.joinErrors(result, true)
          node = backup4
          d = backup5
          if (result.node != null) {
            result = BREAK.joinErrors(result, true)
          } else {
            result = CONTINUE.joinErrors(result, true)
          }
          
          if (result.node != null) {
            // ranges+=(MinMaxRange | CharRange)
            val result5 = d.sub0MatchRangeExpression(parser)
            d = result5.derivation
            result = result5.joinErrors(result, false)
            if (result.node != null) {
              node.add(result5.node)
            }
          }
          if (result.node != null) {
            backup2 = node?.copy()
            backup3 = d
          }
        } while (result.node != null)
        node = backup2
        d = backup3
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // ']' 
        val result6 =  d.__terminal(']')
        d = result6.derivation
        result = result6.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // _\u000a
        val result7 = d.dv_
        d = result7.derivation
        result = result7.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  private static def Result<? extends Node> sub0MatchRangeExpression(Derivation derivation, Parser parser) {
      var Result<?> result = null
      var Node node = null
      var d = derivation
      
      // MinMaxRange | CharRange
      val backup6 = node?.copy()
      val backup7 = d
      
      // MinMaxRange 
      val result3 = d.dvMinMaxRange
      d = result3.derivation
      result = result3.joinErrors(result, false)
      if (result.node == null) {
        node = backup6
        d = backup7
        val backup8 = node?.copy()
        val backup9 = d
        
        // CharRange
        val result4 = d.dvCharRange
        d = result4.derivation
        result = result4.joinErrors(result, false)
        if (result.node == null) {
          node = backup8
          d = backup9
        }
      }
      
      return result as Result<? extends Node>
  }
  
}
package class MinMaxRangeRule {

  /**
   * MinMaxRange: !'-' min=. '-' !'-' max=. ; 
   */
  package static def Result<? extends MinMaxRange> matchMinMaxRange(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new MinMaxRange
      var d = derivation
      
      val backup0 = node?.copy()
      val backup1 = d
      // '-' 
      val result0 =  d.__terminal('-')
      d = result0.derivation
      result = result0.joinErrors(result, true)
      node = backup0
      d = backup1
      if (result.node != null) {
        result = BREAK.joinErrors(result, true)
      } else {
        result = CONTINUE.joinErrors(result, true)
      }
      
      if (result.node != null) {
        // min=. 
        // .
        val result1 =  d.__any()
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          node.setMin(result1.node)
        }
      }
      
      if (result.node != null) {
        // '-' 
        val result2 =  d.__terminal('-')
        d = result2.derivation
        result = result2.joinErrors(result, false)
      }
      
      if (result.node != null) {
        val backup2 = node?.copy()
        val backup3 = d
        // '-' 
        val result3 =  d.__terminal('-')
        d = result3.derivation
        result = result3.joinErrors(result, true)
        node = backup2
        d = backup3
        if (result.node != null) {
          result = BREAK.joinErrors(result, true)
        } else {
          result = CONTINUE.joinErrors(result, true)
        }
      }
      
      if (result.node != null) {
        // max=.\u000a
        // .
        val result4 =  d.__any()
        d = result4.derivation
        result = result4.joinErrors(result, false)
        if (result.node != null) {
          node.setMax(result4.node)
        }
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<MinMaxRange>(node, d, result.info)
      }
      return new Result<MinMaxRange>(null, derivation, result.info)
  }
  
  
}
package class CharRangeRule {

  /**
   * CharRange: '\\\\' char=']' | '\\\\' char='\\\\' | !'-' char=. ; 
   */
  package static def Result<? extends CharRange> matchCharRange(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new CharRange
      var d = derivation
      
      // '\\\\' char=']'\u000a  | '\\\\' char='\\\\'\u000a  | !'-' char=.\u000a
      val backup0 = node?.copy()
      val backup1 = d
      
      // '\\\\' 
      val result0 =  d.__terminal('\\')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        // char=']'\u000a  
        val result1 =  d.__terminal(']')
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          node.setChar(result1.node)
        }
      }
      if (result.node == null) {
        node = backup0
        d = backup1
        val backup2 = node?.copy()
        val backup3 = d
        
        // '\\\\' 
        val result2 =  d.__terminal('\\')
        d = result2.derivation
        result = result2.joinErrors(result, false)
        
        if (result.node != null) {
          // char='\\\\'\u000a  
          val result3 =  d.__terminal('\\')
          d = result3.derivation
          result = result3.joinErrors(result, false)
          if (result.node != null) {
            node.setChar(result3.node)
          }
        }
        if (result.node == null) {
          node = backup2
          d = backup3
          val backup4 = node?.copy()
          val backup5 = d
          
          val backup6 = node?.copy()
          val backup7 = d
          // '-' 
          val result4 =  d.__terminal('-')
          d = result4.derivation
          result = result4.joinErrors(result, true)
          node = backup6
          d = backup7
          if (result.node != null) {
            result = BREAK.joinErrors(result, true)
          } else {
            result = CONTINUE.joinErrors(result, true)
          }
          
          if (result.node != null) {
            // char=.\u000a
            // .
            val result5 =  d.__any()
            d = result5.derivation
            result = result5.joinErrors(result, false)
            if (result.node != null) {
              node.setChar(result5.node)
            }
          }
          if (result.node == null) {
            node = backup4
            d = backup5
          }
        }
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<CharRange>(node, d, result.info)
      }
      return new Result<CharRange>(null, derivation, result.info)
  }
  
  
}
package class AnyCharExpressionRule {

  /**
   * AnyCharExpression returns Expression : char='.' ; 
   */
  package static def Result<? extends Expression> matchAnyCharExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new AnyCharExpression
      var d = derivation
      
      // char='.'\u000a
      val result0 =  d.__terminal('.')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node != null) {
        node.setChar(result0.node)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class RuleReferenceExpressionRule {

  /**
   * RuleReferenceExpression returns Expression : name=ID _ ; 
   */
  package static def Result<? extends Expression> matchRuleReferenceExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new RuleReferenceExpression
      var d = derivation
      
      // name=ID 
      val result0 = d.dvID
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node != null) {
        node.setName(result0.node)
      }
      
      if (result.node != null) {
        // _\u000a
        val result1 = d.dv_
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class TerminalExpressionRule {

  /**
   * TerminalExpression returns Expression : '\\'' value=InTerminalChar? '\\'' _ ; 
   */
  package static def Result<? extends Expression> matchTerminalExpression(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new TerminalExpression
      var d = derivation
      
      // '\\'' 
      val result0 =  d.__terminal('\'')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        // value=InTerminalChar? 
        val backup0 = node?.copy()
        val backup1 = d
        
        // value=InTerminalChar
        val result1 = d.dvInTerminalChar
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          node.setValue(result1.node)
        }
        if (result.node == null) {
          node = backup0
          d = backup1
          result = CONTINUE.joinErrors(result, false)
        }
      }
      
      if (result.node != null) {
        // '\\'' 
        val result2 =  d.__terminal('\'')
        d = result2.derivation
        result = result2.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // _\u000a
        val result3 = d.dv_
        d = result3.derivation
        result = result3.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Expression>(node, d, result.info)
      }
      return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class InTerminalCharRule {

  /**
   * InTerminalChar: ('\\\\' '\\'' | '\\\\' '\\\\' | !'\\'' .)+ ; 
   */
  package static def Result<? extends InTerminalChar> matchInTerminalChar(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new InTerminalChar
      var d = derivation
      
      // ('\\\\' '\\'' | '\\\\' '\\\\' | !'\\'' .)+\u000a
      var backup0 = node?.copy()
      var backup1 = d
      var loop0 = false
      
      do {
        // ('\\\\' '\\'' | '\\\\' '\\\\' | !'\\'' .)
        // '\\\\' '\\'' | '\\\\' '\\\\' | !'\\'' .
        val backup2 = node?.copy()
        val backup3 = d
        
        // '\\\\' 
        val result0 =  d.__terminal('\\')
        d = result0.derivation
        result = result0.joinErrors(result, false)
        
        if (result.node != null) {
          // '\\'' 
          val result1 =  d.__terminal('\'')
          d = result1.derivation
          result = result1.joinErrors(result, false)
        }
        if (result.node == null) {
          node = backup2
          d = backup3
          val backup4 = node?.copy()
          val backup5 = d
          
          // '\\\\' 
          val result2 =  d.__terminal('\\')
          d = result2.derivation
          result = result2.joinErrors(result, false)
          
          if (result.node != null) {
            // '\\\\' 
            val result3 =  d.__terminal('\\')
            d = result3.derivation
            result = result3.joinErrors(result, false)
          }
          if (result.node == null) {
            node = backup4
            d = backup5
            val backup6 = node?.copy()
            val backup7 = d
            
            val backup8 = node?.copy()
            val backup9 = d
            // '\\'' 
            val result4 =  d.__terminal('\'')
            d = result4.derivation
            result = result4.joinErrors(result, true)
            node = backup8
            d = backup9
            if (result.node != null) {
              result = BREAK.joinErrors(result, true)
            } else {
              result = CONTINUE.joinErrors(result, true)
            }
            
            if (result.node != null) {
              // .
              // .
              val result5 =  d.__any()
              d = result5.derivation
              result = result5.joinErrors(result, false)
            }
            if (result.node == null) {
              node = backup6
              d = backup7
            }
          }
        }
        
        if (result.node != null) {
          loop0 = true
          backup0 = node?.copy()
          backup1 = d
        }
      } while(result.node != null)
      if (!loop0) {
        node = backup0
        d = backup1
      } else {
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<InTerminalChar>(node, d, result.info)
      }
      return new Result<InTerminalChar>(null, derivation, result.info)
  }
  
  
}
package class CommentRule {

  /**
   * Comment : '//' (!('\\r'? '\\n') .)* _ ; 
   */
  package static def Result<? extends Comment> matchComment(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new Comment
      var d = derivation
      
      // '//' 
      val result0 =  d.__terminal('//')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        // (!('\\r'? '\\n') .)* 
        var backup0 = node?.copy()
        var backup1 = d
        
        do {
          // (!('\\r'? '\\n') .)
          val backup2 = node?.copy()
          val backup3 = d
          // ('\\r'? '\\n') 
          // '\\r'? 
          val backup4 = node?.copy()
          val backup5 = d
          
          // '\\r'
          val result1 =  d.__terminal('\r')
          d = result1.derivation
          result = result1.joinErrors(result, true)
          if (result.node == null) {
            node = backup4
            d = backup5
            result = CONTINUE.joinErrors(result, true)
          }
          
          if (result.node != null) {
            // '\\n'
            val result2 =  d.__terminal('\n')
            d = result2.derivation
            result = result2.joinErrors(result, true)
          }
          node = backup2
          d = backup3
          if (result.node != null) {
            result = BREAK.joinErrors(result, true)
          } else {
            result = CONTINUE.joinErrors(result, true)
          }
          
          if (result.node != null) {
            // .
            // .
            val result3 =  d.__any()
            d = result3.derivation
            result = result3.joinErrors(result, false)
          }
          if (result.node != null) {
            backup0 = node?.copy()
            backup1 = d
          }
        } while (result.node != null)
        node = backup0
        d = backup1
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // _\u000a
        val result4 = d.dv_
        d = result4.derivation
        result = result4.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<Comment>(node, d, result.info)
      }
      return new Result<Comment>(null, derivation, result.info)
  }
  
  
}
package class EOIRule {

  /**
   * EOI: !(.) ; 
   */
  package static def Result<? extends EOI> matchEOI(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new EOI
      var d = derivation
      
      val backup0 = node?.copy()
      val backup1 = d
      // (.)\u000a
      // .
      // .
      val result0 =  d.__any()
      d = result0.derivation
      result = result0.joinErrors(result, true)
      node = backup0
      d = backup1
      if (result.node != null) {
        result = BREAK.joinErrors(result, true)
      } else {
        result = CONTINUE.joinErrors(result, true)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<EOI>(node, d, result.info)
      }
      return new Result<EOI>(null, derivation, result.info)
  }
  
  
}
package class IDRule {

  /**
   * ID: [a-zA-Z_] [a-zA-Z0-9_]* ; 
   */
  package static def Result<? extends ID> matchID(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new ID
      var d = derivation
      
      // [a-zA-Z_] 
      // [a-zA-Z_] 
      val result0 = d.__oneOfThese(
        ('a'..'z') + ('A'..'Z') + '_'
        )
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        // [a-zA-Z0-9_]*\u000a
        var backup0 = node?.copy()
        var backup1 = d
        
        do {
          // [a-zA-Z0-9_]
          // [a-zA-Z0-9_]
          val result1 = d.__oneOfThese(
            ('a'..'z') + ('A'..'Z') + ('0'..'9') + '_'
            )
          d = result1.derivation
          result = result1.joinErrors(result, false)
          if (result.node != null) {
            backup0 = node?.copy()
            backup1 = d
          }
        } while (result.node != null)
        node = backup0
        d = backup1
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<ID>(node, d, result.info)
      }
      return new Result<ID>(null, derivation, result.info)
  }
  
  
}
package class WSRule {

  /**
   * WS : ' ' | '\\n' | '\\t' | '\\r' ; 
   */
  package static def Result<? extends WS> matchWS(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new WS
      var d = derivation
      
      // ' ' | '\\n' | '\\t' | '\\r'\u000a
      val backup0 = node?.copy()
      val backup1 = d
      
      // ' ' 
      val result0 =  d.__terminal(' ')
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node == null) {
        node = backup0
        d = backup1
        val backup2 = node?.copy()
        val backup3 = d
        
        // '\\n' 
        val result1 =  d.__terminal('\n')
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node == null) {
          node = backup2
          d = backup3
          val backup4 = node?.copy()
          val backup5 = d
          
          // '\\t' 
          val result2 =  d.__terminal('\t')
          d = result2.derivation
          result = result2.joinErrors(result, false)
          if (result.node == null) {
            node = backup4
            d = backup5
            val backup6 = node?.copy()
            val backup7 = d
            
            // '\\r'\u000a
            val result3 =  d.__terminal('\r')
            d = result3.derivation
            result = result3.joinErrors(result, false)
            if (result.node == null) {
              node = backup6
              d = backup7
            }
          }
        }
      }
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<WS>(node, d, result.info)
      }
      return new Result<WS>(null, derivation, result.info)
  }
  
  
}
package class _Rule {

  /**
   * _ : WS* ; 
   */
  package static def Result<? extends _> match_(Parser parser, Derivation derivation) {
      var Result<?> result = null
      var node = new _
      var d = derivation
      
      // WS* \u000a
      var backup0 = node?.copy()
      var backup1 = d
      
      do {
        // WS
        val result0 = d.dvWS
        d = result0.derivation
        result = result0.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node?.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
      
      if (result.node != null) {
        node.index = derivation.index
        node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
        return new Result<_>(node, d, result.info)
      }
      return new Result<_>(null, derivation, result.info)
  }
  
  
}
  
package class Derivation {
  
  Parser parser
  
  int idx
  
  val (Derivation)=>Result<Character> dvfChar
  
  Result<? extends Jpeg> dvJpeg
  Result<? extends Rule> dvRule
  Result<? extends RuleReturns> dvRuleReturns
  Result<? extends Body> dvBody
  Result<? extends Expression> dvChoiceExpression
  Result<? extends Expression> dvSequenceExpression
  Result<? extends Expression> dvActionExpression
  Result<? extends Expression> dvAndPredicateExpression
  Result<? extends Expression> dvNotPredicateExpression
  Result<? extends Expression> dvOneOrMoreExpression
  Result<? extends Expression> dvZeroOrMoreExpression
  Result<? extends Expression> dvOptionalExpression
  Result<? extends Expression> dvAssignableExpression
  Result<? extends AssignmentOperator> dvAssignmentOperator
  Result<? extends Expression> dvSubExpression
  Result<? extends Expression> dvRangeExpression
  Result<? extends MinMaxRange> dvMinMaxRange
  Result<? extends CharRange> dvCharRange
  Result<? extends Expression> dvAnyCharExpression
  Result<? extends Expression> dvRuleReferenceExpression
  Result<? extends Expression> dvTerminalExpression
  Result<? extends InTerminalChar> dvInTerminalChar
  Result<? extends Comment> dvComment
  Result<? extends EOI> dvEOI
  Result<? extends ID> dvID
  Result<? extends WS> dvWS
  Result<? extends _> dv_
  Result<Character> dvChar
  
  new(Parser parser, int idx, (Derivation)=>Result<Character> dvfChar) {
    this.parser = parser
    this.idx = idx
    this.dvfChar = dvfChar
  }
  
  def getIndex() {
    idx
  }
  
  def getDvJpeg() {
    if (dvJpeg == null) {
      // Fail LR upfront
      dvJpeg = new Result<Jpeg>(null, this, new ParseInfo(index, 'Detected left-recursion in Jpeg'))
      dvJpeg = JpegRule.matchJpeg(parser, this)
    }
    return dvJpeg
  }
  
  def getDvRule() {
    if (dvRule == null) {
      // Fail LR upfront
      dvRule = new Result<Rule>(null, this, new ParseInfo(index, 'Detected left-recursion in Rule'))
      dvRule = RuleRule.matchRule(parser, this)
    }
    return dvRule
  }
  
  def getDvRuleReturns() {
    if (dvRuleReturns == null) {
      // Fail LR upfront
      dvRuleReturns = new Result<RuleReturns>(null, this, new ParseInfo(index, 'Detected left-recursion in RuleReturns'))
      dvRuleReturns = RuleReturnsRule.matchRuleReturns(parser, this)
    }
    return dvRuleReturns
  }
  
  def getDvBody() {
    if (dvBody == null) {
      // Fail LR upfront
      dvBody = new Result<Body>(null, this, new ParseInfo(index, 'Detected left-recursion in Body'))
      dvBody = BodyRule.matchBody(parser, this)
    }
    return dvBody
  }
  
  def getDvChoiceExpression() {
    if (dvChoiceExpression == null) {
      // Fail LR upfront
      dvChoiceExpression = new Result<ChoiceExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in ChoiceExpression'))
      dvChoiceExpression = ChoiceExpressionRule.matchChoiceExpression(parser, this)
    }
    return dvChoiceExpression
  }
  
  def getDvSequenceExpression() {
    if (dvSequenceExpression == null) {
      // Fail LR upfront
      dvSequenceExpression = new Result<SequenceExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in SequenceExpression'))
      dvSequenceExpression = SequenceExpressionRule.matchSequenceExpression(parser, this)
    }
    return dvSequenceExpression
  }
  
  def getDvActionExpression() {
    if (dvActionExpression == null) {
      // Fail LR upfront
      dvActionExpression = new Result<ActionExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in ActionExpression'))
      dvActionExpression = ActionExpressionRule.matchActionExpression(parser, this)
    }
    return dvActionExpression
  }
  
  def getDvAndPredicateExpression() {
    if (dvAndPredicateExpression == null) {
      // Fail LR upfront
      dvAndPredicateExpression = new Result<AndPredicateExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in AndPredicateExpression'))
      dvAndPredicateExpression = AndPredicateExpressionRule.matchAndPredicateExpression(parser, this)
    }
    return dvAndPredicateExpression
  }
  
  def getDvNotPredicateExpression() {
    if (dvNotPredicateExpression == null) {
      // Fail LR upfront
      dvNotPredicateExpression = new Result<NotPredicateExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in NotPredicateExpression'))
      dvNotPredicateExpression = NotPredicateExpressionRule.matchNotPredicateExpression(parser, this)
    }
    return dvNotPredicateExpression
  }
  
  def getDvOneOrMoreExpression() {
    if (dvOneOrMoreExpression == null) {
      // Fail LR upfront
      dvOneOrMoreExpression = new Result<OneOrMoreExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in OneOrMoreExpression'))
      dvOneOrMoreExpression = OneOrMoreExpressionRule.matchOneOrMoreExpression(parser, this)
    }
    return dvOneOrMoreExpression
  }
  
  def getDvZeroOrMoreExpression() {
    if (dvZeroOrMoreExpression == null) {
      // Fail LR upfront
      dvZeroOrMoreExpression = new Result<ZeroOrMoreExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in ZeroOrMoreExpression'))
      dvZeroOrMoreExpression = ZeroOrMoreExpressionRule.matchZeroOrMoreExpression(parser, this)
    }
    return dvZeroOrMoreExpression
  }
  
  def getDvOptionalExpression() {
    if (dvOptionalExpression == null) {
      // Fail LR upfront
      dvOptionalExpression = new Result<OptionalExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in OptionalExpression'))
      dvOptionalExpression = OptionalExpressionRule.matchOptionalExpression(parser, this)
    }
    return dvOptionalExpression
  }
  
  def getDvAssignableExpression() {
    if (dvAssignableExpression == null) {
      // Fail LR upfront
      dvAssignableExpression = new Result<AssignableExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in AssignableExpression'))
      dvAssignableExpression = AssignableExpressionRule.matchAssignableExpression(parser, this)
    }
    return dvAssignableExpression
  }
  
  def getDvAssignmentOperator() {
    if (dvAssignmentOperator == null) {
      // Fail LR upfront
      dvAssignmentOperator = new Result<AssignmentOperator>(null, this, new ParseInfo(index, 'Detected left-recursion in AssignmentOperator'))
      dvAssignmentOperator = AssignmentOperatorRule.matchAssignmentOperator(parser, this)
    }
    return dvAssignmentOperator
  }
  
  def getDvSubExpression() {
    if (dvSubExpression == null) {
      // Fail LR upfront
      dvSubExpression = new Result<SubExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in SubExpression'))
      dvSubExpression = SubExpressionRule.matchSubExpression(parser, this)
    }
    return dvSubExpression
  }
  
  def getDvRangeExpression() {
    if (dvRangeExpression == null) {
      // Fail LR upfront
      dvRangeExpression = new Result<RangeExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in RangeExpression'))
      dvRangeExpression = RangeExpressionRule.matchRangeExpression(parser, this)
    }
    return dvRangeExpression
  }
  
  def getDvMinMaxRange() {
    if (dvMinMaxRange == null) {
      // Fail LR upfront
      dvMinMaxRange = new Result<MinMaxRange>(null, this, new ParseInfo(index, 'Detected left-recursion in MinMaxRange'))
      dvMinMaxRange = MinMaxRangeRule.matchMinMaxRange(parser, this)
    }
    return dvMinMaxRange
  }
  
  def getDvCharRange() {
    if (dvCharRange == null) {
      // Fail LR upfront
      dvCharRange = new Result<CharRange>(null, this, new ParseInfo(index, 'Detected left-recursion in CharRange'))
      dvCharRange = CharRangeRule.matchCharRange(parser, this)
    }
    return dvCharRange
  }
  
  def getDvAnyCharExpression() {
    if (dvAnyCharExpression == null) {
      // Fail LR upfront
      dvAnyCharExpression = new Result<AnyCharExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in AnyCharExpression'))
      dvAnyCharExpression = AnyCharExpressionRule.matchAnyCharExpression(parser, this)
    }
    return dvAnyCharExpression
  }
  
  def getDvRuleReferenceExpression() {
    if (dvRuleReferenceExpression == null) {
      // Fail LR upfront
      dvRuleReferenceExpression = new Result<RuleReferenceExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in RuleReferenceExpression'))
      dvRuleReferenceExpression = RuleReferenceExpressionRule.matchRuleReferenceExpression(parser, this)
    }
    return dvRuleReferenceExpression
  }
  
  def getDvTerminalExpression() {
    if (dvTerminalExpression == null) {
      // Fail LR upfront
      dvTerminalExpression = new Result<TerminalExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in TerminalExpression'))
      dvTerminalExpression = TerminalExpressionRule.matchTerminalExpression(parser, this)
    }
    return dvTerminalExpression
  }
  
  def getDvInTerminalChar() {
    if (dvInTerminalChar == null) {
      // Fail LR upfront
      dvInTerminalChar = new Result<InTerminalChar>(null, this, new ParseInfo(index, 'Detected left-recursion in InTerminalChar'))
      dvInTerminalChar = InTerminalCharRule.matchInTerminalChar(parser, this)
    }
    return dvInTerminalChar
  }
  
  def getDvComment() {
    if (dvComment == null) {
      // Fail LR upfront
      dvComment = new Result<Comment>(null, this, new ParseInfo(index, 'Detected left-recursion in Comment'))
      dvComment = CommentRule.matchComment(parser, this)
    }
    return dvComment
  }
  
  def getDvEOI() {
    if (dvEOI == null) {
      // Fail LR upfront
      dvEOI = new Result<EOI>(null, this, new ParseInfo(index, 'Detected left-recursion in EOI'))
      dvEOI = EOIRule.matchEOI(parser, this)
    }
    return dvEOI
  }
  
  def getDvID() {
    if (dvID == null) {
      // Fail LR upfront
      dvID = new Result<ID>(null, this, new ParseInfo(index, 'Detected left-recursion in ID'))
      dvID = IDRule.matchID(parser, this)
    }
    return dvID
  }
  
  def getDvWS() {
    if (dvWS == null) {
      // Fail LR upfront
      dvWS = new Result<WS>(null, this, new ParseInfo(index, 'Detected left-recursion in WS'))
      dvWS = WSRule.matchWS(parser, this)
    }
    return dvWS
  }
  
  def getDv_() {
    if (dv_ == null) {
      // Fail LR upfront
      dv_ = new Result<_>(null, this, new ParseInfo(index, 'Detected left-recursion in _'))
      dv_ = _Rule.match_(parser, this)
    }
    return dv_
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

