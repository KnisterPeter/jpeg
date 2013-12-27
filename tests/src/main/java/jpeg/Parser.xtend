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
  
  def Expression Expression(String in) {
    this.chars = in.toCharArray()
    val result = ExpressionRule.matchExpression(this, parse(0))
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
  
  def Expression SequenceExpressionExpressions(String in) {
    this.chars = in.toCharArray()
    val result = SequenceExpressionExpressionsRule.matchSequenceExpressionExpressions(this, parse(0))
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
  
  def ActionOperator ActionOperator(String in) {
    this.chars = in.toCharArray()
    val result = ActionOperatorRule.matchActionOperator(this, parse(0))
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
  
  def Expression AssignableExpressionExpressions(String in) {
    this.chars = in.toCharArray()
    val result = AssignableExpressionExpressionsRule.matchAssignableExpressionExpressions(this, parse(0))
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
    var Jpeg node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // (rules+=Rule | Comment)+ 
    var backup0 = node?.copy()
    var backup1 = d
    var loop0 = false
    
    do {
      // rules+=Rule | Comment
      val backup2 = node?.copy()
      val backup3 = d
      
      // rules+=Rule 
      val result0 = d.dvRule
      d = result0.derivation
      result = result0
      info.join(result0, false)
      if (result.node != null) {
        if (node == null) {
          node = new Jpeg
        }
        node.add(result0.node)
      }
      if (result.node == null) {
        node = backup2
        d = backup3
        val backup4 = node?.copy()
        val backup5 = d
        
        val result1 = d.dvComment
        d = result1.derivation
        result = result1
        info.join(result1, false)
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
      result = CONTINUE
      info.join(result, false)
    }
    
    if (result.node != null) {
      val result2 = d.dvEOI
      d = result2.derivation
      result = result2
      info.join(result2, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new Jpeg()
      }
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
    var Rule node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // name=ID 
    val result0 = d.dvID
    d = result0.derivation
    result = result0
    info.join(result0, false)
    if (result.node != null) {
      if (node == null) {
        node = new Rule
      }
      node.setName(result0.node)
    }
    
    if (result.node != null) {
      val result1 = d.dv_
      d = result1.derivation
      result = result1
      info.join(result1, false)
    }
    
    if (result.node != null) {
      // returns=RuleReturns? 
      val backup0 = node?.copy()
      val backup1 = d
      
      // returns=RuleReturns
      val result2 = d.dvRuleReturns
      d = result2.derivation
      result = result2
      info.join(result2, false)
      if (result.node != null) {
        if (node == null) {
          node = new Rule
        }
        node.setReturns(result2.node)
      }
      if (result.node == null) {
        node = backup0
        d = backup1
        result = CONTINUE
        info.join(result, false)
      }
    }
    
    if (result.node != null) {
      val result3 =  d.__terminal(':')
      d = result3.derivation
      result = result3
      info.join(result3, false)
    }
    
    if (result.node != null) {
      val result4 = d.dv_
      d = result4.derivation
      result = result4
      info.join(result4, false)
    }
    
    if (result.node != null) {
      // body=Body 
      val result5 = d.dvBody
      d = result5.derivation
      result = result5
      info.join(result5, false)
      if (result.node != null) {
        if (node == null) {
          node = new Rule
        }
        node.setBody(result5.node)
      }
    }
    
    if (result.node != null) {
      val result6 =  d.__terminal(';')
      d = result6.derivation
      result = result6
      info.join(result6, false)
    }
    
    if (result.node != null) {
      val result7 = d.dv_
      d = result7.derivation
      result = result7
      info.join(result7, false)
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
  
  
}
package class RuleReturnsRule {

  /**
   * RuleReturns : 'returns' _ name=ID _ ; 
   */
  package static def Result<? extends RuleReturns> matchRuleReturns(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var RuleReturns node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val result0 =  d.__terminal('returns')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    if (result.node != null) {
      val result1 = d.dv_
      d = result1.derivation
      result = result1
      info.join(result1, false)
    }
    
    if (result.node != null) {
      // name=ID 
      val result2 = d.dvID
      d = result2.derivation
      result = result2
      info.join(result2, false)
      if (result.node != null) {
        if (node == null) {
          node = new RuleReturns
        }
        node.setName(result2.node)
      }
    }
    
    if (result.node != null) {
      val result3 = d.dv_
      d = result3.derivation
      result = result3
      info.join(result3, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new RuleReturns()
      }
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
    var Body node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // (expressions+=ChoiceExpression _)+\u000a
    var backup0 = node?.copy()
    var backup1 = d
    var loop0 = false
    
    do {
      // expressions+=ChoiceExpression 
      val result0 = d.dvChoiceExpression
      d = result0.derivation
      result = result0
      info.join(result0, false)
      if (result.node != null) {
        if (node == null) {
          node = new Body
        }
        node.add(result0.node)
      }
      
      if (result.node != null) {
        val result1 = d.dv_
        d = result1.derivation
        result = result1
        info.join(result1, false)
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
      result = CONTINUE
      info.join(result, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new Body()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Body>(node, d, result.info)
    }
    return new Result<Body>(null, derivation, result.info)
  }
  
  
}
package class ExpressionRule {

  /**
   * Expression : ActionExpression | AndPredicateExpression | AnyCharExpression | AssignableExpression | ChoiceExpression | NotPredicateExpression | OneOrMoreExpression | OptionalExpression | RangeExpression | RuleReferenceExpression | SequenceExpression | SubExpression | TerminalExpression | ZeroOrMoreExpression ; 
   */
  package static def Result<? extends Expression> matchExpression(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // ActionExpression\u000a  | AndPredicateExpression\u000a  | AnyCharExpression\u000a  | AssignableExpression\u000a  | ChoiceExpression\u000a  | NotPredicateExpression\u000a  | OneOrMoreExpression\u000a  | OptionalExpression\u000a  | RangeExpression\u000a  | RuleReferenceExpression\u000a  | SequenceExpression\u000a  | SubExpression\u000a  | TerminalExpression\u000a  | ZeroOrMoreExpression\u000a
    val backup0 = node?.copy()
    val backup1 = d
    
    val result0 = d.dvActionExpression
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
      
      val result1 = d.dvAndPredicateExpression
      d = result1.derivation
      if (node == null) {
        node = result1.node
      }
      result = result1
      info.join(result1, false)
      if (result.node == null) {
        node = backup2
        d = backup3
        val backup4 = node?.copy()
        val backup5 = d
        
        val result2 = d.dvAnyCharExpression
        d = result2.derivation
        if (node == null) {
          node = result2.node
        }
        result = result2
        info.join(result2, false)
        if (result.node == null) {
          node = backup4
          d = backup5
          val backup6 = node?.copy()
          val backup7 = d
          
          val result3 = d.dvAssignableExpression
          d = result3.derivation
          if (node == null) {
            node = result3.node
          }
          result = result3
          info.join(result3, false)
          if (result.node == null) {
            node = backup6
            d = backup7
            val backup8 = node?.copy()
            val backup9 = d
            
            val result4 = d.dvChoiceExpression
            d = result4.derivation
            if (node == null) {
              node = result4.node
            }
            result = result4
            info.join(result4, false)
            if (result.node == null) {
              node = backup8
              d = backup9
              val backup10 = node?.copy()
              val backup11 = d
              
              val result5 = d.dvNotPredicateExpression
              d = result5.derivation
              if (node == null) {
                node = result5.node
              }
              result = result5
              info.join(result5, false)
              if (result.node == null) {
                node = backup10
                d = backup11
                val backup12 = node?.copy()
                val backup13 = d
                
                val result6 = d.dvOneOrMoreExpression
                d = result6.derivation
                if (node == null) {
                  node = result6.node
                }
                result = result6
                info.join(result6, false)
                if (result.node == null) {
                  node = backup12
                  d = backup13
                  val backup14 = node?.copy()
                  val backup15 = d
                  
                  val result7 = d.dvOptionalExpression
                  d = result7.derivation
                  if (node == null) {
                    node = result7.node
                  }
                  result = result7
                  info.join(result7, false)
                  if (result.node == null) {
                    node = backup14
                    d = backup15
                    val backup16 = node?.copy()
                    val backup17 = d
                    
                    val result8 = d.dvRangeExpression
                    d = result8.derivation
                    if (node == null) {
                      node = result8.node
                    }
                    result = result8
                    info.join(result8, false)
                    if (result.node == null) {
                      node = backup16
                      d = backup17
                      val backup18 = node?.copy()
                      val backup19 = d
                      
                      val result9 = d.dvRuleReferenceExpression
                      d = result9.derivation
                      if (node == null) {
                        node = result9.node
                      }
                      result = result9
                      info.join(result9, false)
                      if (result.node == null) {
                        node = backup18
                        d = backup19
                        val backup20 = node?.copy()
                        val backup21 = d
                        
                        val result10 = d.dvSequenceExpression
                        d = result10.derivation
                        if (node == null) {
                          node = result10.node
                        }
                        result = result10
                        info.join(result10, false)
                        if (result.node == null) {
                          node = backup20
                          d = backup21
                          val backup22 = node?.copy()
                          val backup23 = d
                          
                          val result11 = d.dvSubExpression
                          d = result11.derivation
                          if (node == null) {
                            node = result11.node
                          }
                          result = result11
                          info.join(result11, false)
                          if (result.node == null) {
                            node = backup22
                            d = backup23
                            val backup24 = node?.copy()
                            val backup25 = d
                            
                            val result12 = d.dvTerminalExpression
                            d = result12.derivation
                            if (node == null) {
                              node = result12.node
                            }
                            result = result12
                            info.join(result12, false)
                            if (result.node == null) {
                              node = backup24
                              d = backup25
                              val backup26 = node?.copy()
                              val backup27 = d
                              
                              val result13 = d.dvZeroOrMoreExpression
                              d = result13.derivation
                              if (node == null) {
                                node = result13.node
                              }
                              result = result13
                              info.join(result13, false)
                              if (result.node == null) {
                                node = backup26
                                d = backup27
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new Expression()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class ChoiceExpressionRule {

  /**
   * ChoiceExpression returns Expression : SequenceExpression ( &'|' {ChoiceExpression.choices+=current} ('|' _ choices+=SequenceExpression)* )? ; 
   */
  package static def Result<? extends Expression> matchChoiceExpression(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val result0 = d.dvSequenceExpression
    d = result0.derivation
    if (node == null) {
      node = result0.node
    }
    result = result0
    info.join(result0, false)
    
    if (result.node != null) {
      // ( &'|' {ChoiceExpression.choices+=current} ('|' _ choices+=SequenceExpression)* )?\u000a
      val backup0 = node?.copy()
      val backup1 = d
      
      val backup2 = node?.copy()
      val backup3 = d
      val result1 =  d.__terminal('|')
      d = result1.derivation
      result = result1
      info.join(result1, true)
      node = backup2
      d = backup3
      if (result.node != null) {
        result = CONTINUE
        info.join(result, true)
      } else {
        result = BREAK
        info.join(result, true)
      }
      
      if (result.node != null) {
        val current = node
        node = new ChoiceExpression()
        (node as ChoiceExpression).add(current)
        result = CONTINUE
      }
      
      if (result.node != null) {
        // ('|' _ choices+=SequenceExpression)* 
        var backup4 = node?.copy()
        var backup5 = d
        
        do {
          val result2 =  d.__terminal('|')
          d = result2.derivation
          result = result2
          info.join(result2, false)
          
          if (result.node != null) {
            val result3 = d.dv_
            d = result3.derivation
            result = result3
            info.join(result3, false)
          }
          
          if (result.node != null) {
            // choices+=SequenceExpression
            val result4 = d.dvSequenceExpression
            d = result4.derivation
            result = result4
            info.join(result4, false)
            if (result.node != null) {
              if (node == null) {
                node = new ChoiceExpression
              }
              (node as ChoiceExpression).add(result4.node)
            }
          }
          if (result.node != null) {
            backup4 = node?.copy()
            backup5 = d
          }
        } while (result.node != null)
        node = backup4
        d = backup5
        result = CONTINUE
        info.join(result, false)
      }
      if (result.node == null) {
        node = backup0
        d = backup1
        result = CONTINUE
        info.join(result, false)
      }
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new ChoiceExpression()
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
   * SequenceExpression returns Expression : Comment* SequenceExpressionExpressions ( &SequenceExpressionExpressions {SequenceExpression.expressions+=current} Comment* expressions+=SequenceExpressionExpressions _ )* ; 
   */
  package static def Result<? extends Expression> matchSequenceExpression(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // Comment*\u000a  
    var backup0 = node?.copy()
    var backup1 = d
    
    do {
      val result0 = d.dvComment
      d = result0.derivation
      result = result0
      info.join(result0, false)
      if (result.node != null) {
        backup0 = node?.copy()
        backup1 = d
      }
    } while (result.node != null)
    node = backup0
    d = backup1
    result = CONTINUE
    info.join(result, false)
    
    if (result.node != null) {
      val result1 = d.dvSequenceExpressionExpressions
      d = result1.derivation
      if (node == null) {
        node = result1.node
      }
      result = result1
      info.join(result1, false)
    }
    
    if (result.node != null) {
      // (\u000a    &SequenceExpressionExpressions\u000a    {SequenceExpression.expressions+=current}\u000a    Comment*\u000a    expressions+=SequenceExpressionExpressions\u000a    _\u000a  )*\u000a
      var backup2 = node?.copy()
      var backup3 = d
      
      do {
        val backup4 = node?.copy()
        val backup5 = d
        val result2 = d.dvSequenceExpressionExpressions
        d = result2.derivation
        if (node == null) {
          node = result2.node
        }
        result = result2
        info.join(result2, true)
        node = backup4
        d = backup5
        if (result.node != null) {
          result = CONTINUE
          info.join(result, true)
        } else {
          result = BREAK
          info.join(result, true)
        }
        
        if (result.node != null) {
          val current = node
          node = new SequenceExpression()
          (node as SequenceExpression).add(current)
          result = CONTINUE
        }
        
        if (result.node != null) {
          // Comment*\u000a    
          var backup6 = node?.copy()
          var backup7 = d
          
          do {
            val result3 = d.dvComment
            d = result3.derivation
            result = result3
            info.join(result3, false)
            if (result.node != null) {
              backup6 = node?.copy()
              backup7 = d
            }
          } while (result.node != null)
          node = backup6
          d = backup7
          result = CONTINUE
          info.join(result, false)
        }
        
        if (result.node != null) {
          // expressions+=SequenceExpressionExpressions\u000a    
          val result4 = d.dvSequenceExpressionExpressions
          d = result4.derivation
          result = result4
          info.join(result4, false)
          if (result.node != null) {
            if (node == null) {
              node = new SequenceExpression
            }
            (node as SequenceExpression).add(result4.node)
          }
        }
        
        if (result.node != null) {
          val result5 = d.dv_
          d = result5.derivation
          result = result5
          info.join(result5, false)
        }
        if (result.node != null) {
          backup2 = node?.copy()
          backup3 = d
        }
      } while (result.node != null)
      node = backup2
      d = backup3
      result = CONTINUE
      info.join(result, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new SequenceExpression()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class SequenceExpressionExpressionsRule {

  /**
   * SequenceExpressionExpressions returns Expression : ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression ; 
   */
  package static def Result<? extends Expression> matchSequenceExpressionExpressions(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // ActionExpression\u000a  | AndPredicateExpression\u000a  | NotPredicateExpression\u000a  | OneOrMoreExpression\u000a  | ZeroOrMoreExpression\u000a  | OptionalExpression\u000a  | AssignableExpression\u000a
    val backup0 = node?.copy()
    val backup1 = d
    
    val result0 = d.dvActionExpression
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
      
      val result1 = d.dvAndPredicateExpression
      d = result1.derivation
      if (node == null) {
        node = result1.node
      }
      result = result1
      info.join(result1, false)
      if (result.node == null) {
        node = backup2
        d = backup3
        val backup4 = node?.copy()
        val backup5 = d
        
        val result2 = d.dvNotPredicateExpression
        d = result2.derivation
        if (node == null) {
          node = result2.node
        }
        result = result2
        info.join(result2, false)
        if (result.node == null) {
          node = backup4
          d = backup5
          val backup6 = node?.copy()
          val backup7 = d
          
          val result3 = d.dvOneOrMoreExpression
          d = result3.derivation
          if (node == null) {
            node = result3.node
          }
          result = result3
          info.join(result3, false)
          if (result.node == null) {
            node = backup6
            d = backup7
            val backup8 = node?.copy()
            val backup9 = d
            
            val result4 = d.dvZeroOrMoreExpression
            d = result4.derivation
            if (node == null) {
              node = result4.node
            }
            result = result4
            info.join(result4, false)
            if (result.node == null) {
              node = backup8
              d = backup9
              val backup10 = node?.copy()
              val backup11 = d
              
              val result5 = d.dvOptionalExpression
              d = result5.derivation
              if (node == null) {
                node = result5.node
              }
              result = result5
              info.join(result5, false)
              if (result.node == null) {
                node = backup10
                d = backup11
                val backup12 = node?.copy()
                val backup13 = d
                
                val result6 = d.dvAssignableExpression
                d = result6.derivation
                if (node == null) {
                  node = result6.node
                }
                result = result6
                info.join(result6, false)
                if (result.node == null) {
                  node = backup12
                  d = backup13
                }
              }
            }
          }
        }
      }
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new SequenceExpressionExpressions()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class ActionExpressionRule {

  /**
   * ActionExpression returns Expression : '{' _ ( type=ID _ ('.' property=ID _ op=ActionOperator _ 'current' _)? ) '}' _ ; 
   */
  package static def Result<? extends Expression> matchActionExpression(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val result0 =  d.__terminal('{')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    if (result.node != null) {
      val result1 = d.dv_
      d = result1.derivation
      result = result1
      info.join(result1, false)
    }
    
    if (result.node != null) {
      // type=ID 
      val result2 = d.dvID
      d = result2.derivation
      result = result2
      info.join(result2, false)
      if (result.node != null) {
        if (node == null) {
          node = new ActionExpression
        }
        (node as ActionExpression).setType(result2.node)
      }
      
      if (result.node != null) {
        val result3 = d.dv_
        d = result3.derivation
        result = result3
        info.join(result3, false)
      }
      
      if (result.node != null) {
        // ('.' property=ID _ op=ActionOperator _ 'current' _)? 
        val backup0 = node?.copy()
        val backup1 = d
        
        val result4 =  d.__terminal('.')
        d = result4.derivation
        result = result4
        info.join(result4, false)
        
        if (result.node != null) {
          // property=ID 
          val result5 = d.dvID
          d = result5.derivation
          result = result5
          info.join(result5, false)
          if (result.node != null) {
            if (node == null) {
              node = new ActionExpression
            }
            (node as ActionExpression).setProperty(result5.node)
          }
        }
        
        if (result.node != null) {
          val result6 = d.dv_
          d = result6.derivation
          result = result6
          info.join(result6, false)
        }
        
        if (result.node != null) {
          // op=ActionOperator 
          val result7 = d.dvActionOperator
          d = result7.derivation
          result = result7
          info.join(result7, false)
          if (result.node != null) {
            if (node == null) {
              node = new ActionExpression
            }
            (node as ActionExpression).setOp(result7.node)
          }
        }
        
        if (result.node != null) {
          val result8 = d.dv_
          d = result8.derivation
          result = result8
          info.join(result8, false)
        }
        
        if (result.node != null) {
          val result9 =  d.__terminal('current')
          d = result9.derivation
          result = result9
          info.join(result9, false)
        }
        
        if (result.node != null) {
          val result10 = d.dv_
          d = result10.derivation
          result = result10
          info.join(result10, false)
        }
        if (result.node == null) {
          node = backup0
          d = backup1
          result = CONTINUE
          info.join(result, false)
        }
      }
    }
    
    if (result.node != null) {
      val result11 =  d.__terminal('}')
      d = result11.derivation
      result = result11
      info.join(result11, false)
    }
    
    if (result.node != null) {
      val result12 = d.dv_
      d = result12.derivation
      result = result12
      info.join(result12, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new ActionExpression()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class ActionOperatorRule {

  /**
   * ActionOperator: multi?='+=' | single?='=' ; 
   */
  package static def Result<? extends ActionOperator> matchActionOperator(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var ActionOperator node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // multi?='+=' | single?='='\u000a
    val backup0 = node?.copy()
    val backup1 = d
    
    // multi?='+=' 
    val result0 =  d.__terminal('+=')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    if (result.node != null) {
      if (node == null) {
        node = new ActionOperator
      }
      node.setMulti(result0.node != null)
    }
    if (result.node == null) {
      node = backup0
      d = backup1
      val backup2 = node?.copy()
      val backup3 = d
      
      // single?='='\u000a
      val result1 =  d.__terminal('=')
      d = result1.derivation
      result = result1
      info.join(result1, false)
      if (result.node != null) {
        if (node == null) {
          node = new ActionOperator
        }
        node.setSingle(result1.node != null)
      }
      if (result.node == null) {
        node = backup2
        d = backup3
      }
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new ActionOperator()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<ActionOperator>(node, d, result.info)
    }
    return new Result<ActionOperator>(null, derivation, result.info)
  }
  
  
}
package class AndPredicateExpressionRule {

  /**
   * AndPredicateExpression returns Expression : '&' _ expr=AssignableExpression ; 
   */
  package static def Result<? extends Expression> matchAndPredicateExpression(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val result0 =  d.__terminal('&')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    if (result.node != null) {
      val result1 = d.dv_
      d = result1.derivation
      result = result1
      info.join(result1, false)
    }
    
    if (result.node != null) {
      // expr=AssignableExpression\u000a
      val result2 = d.dvAssignableExpression
      d = result2.derivation
      result = result2
      info.join(result2, false)
      if (result.node != null) {
        if (node == null) {
          node = new AndPredicateExpression
        }
        (node as AndPredicateExpression).setExpr(result2.node)
      }
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new AndPredicateExpression()
      }
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
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val result0 =  d.__terminal('!')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    if (result.node != null) {
      val result1 = d.dv_
      d = result1.derivation
      result = result1
      info.join(result1, false)
    }
    
    if (result.node != null) {
      // expr=AssignableExpression\u000a
      val result2 = d.dvAssignableExpression
      d = result2.derivation
      result = result2
      info.join(result2, false)
      if (result.node != null) {
        if (node == null) {
          node = new NotPredicateExpression
        }
        (node as NotPredicateExpression).setExpr(result2.node)
      }
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new NotPredicateExpression()
      }
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
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // expr=AssignableExpression 
    val result0 = d.dvAssignableExpression
    d = result0.derivation
    result = result0
    info.join(result0, false)
    if (result.node != null) {
      if (node == null) {
        node = new OneOrMoreExpression
      }
      (node as OneOrMoreExpression).setExpr(result0.node)
    }
    
    if (result.node != null) {
      val result1 =  d.__terminal('+')
      d = result1.derivation
      result = result1
      info.join(result1, false)
    }
    
    if (result.node != null) {
      val result2 = d.dv_
      d = result2.derivation
      result = result2
      info.join(result2, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new OneOrMoreExpression()
      }
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
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // expr=AssignableExpression 
    val result0 = d.dvAssignableExpression
    d = result0.derivation
    result = result0
    info.join(result0, false)
    if (result.node != null) {
      if (node == null) {
        node = new ZeroOrMoreExpression
      }
      (node as ZeroOrMoreExpression).setExpr(result0.node)
    }
    
    if (result.node != null) {
      val result1 =  d.__terminal('*')
      d = result1.derivation
      result = result1
      info.join(result1, false)
    }
    
    if (result.node != null) {
      val result2 = d.dv_
      d = result2.derivation
      result = result2
      info.join(result2, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new ZeroOrMoreExpression()
      }
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
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // expr=AssignableExpression 
    val result0 = d.dvAssignableExpression
    d = result0.derivation
    result = result0
    info.join(result0, false)
    if (result.node != null) {
      if (node == null) {
        node = new OptionalExpression
      }
      (node as OptionalExpression).setExpr(result0.node)
    }
    
    if (result.node != null) {
      val result1 =  d.__terminal('?')
      d = result1.derivation
      result = result1
      info.join(result1, false)
    }
    
    if (result.node != null) {
      val result2 = d.dv_
      d = result2.derivation
      result = result2
      info.join(result2, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new OptionalExpression()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class AssignableExpressionRule {

  /**
   * AssignableExpression returns Expression : ( property=ID _ op=AssignmentOperator _ expr=AssignableExpressionExpressions | AssignableExpressionExpressions ) _ ; 
   */
  package static def Result<? extends Expression> matchAssignableExpression(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // property=ID _ op=AssignmentOperator _ expr=AssignableExpressionExpressions\u000a  | AssignableExpressionExpressions\u000a  
    val backup0 = node?.copy()
    val backup1 = d
    
    // property=ID 
    val result0 = d.dvID
    d = result0.derivation
    result = result0
    info.join(result0, false)
    if (result.node != null) {
      if (node == null) {
        node = new AssignableExpression
      }
      (node as AssignableExpression).setProperty(result0.node)
    }
    
    if (result.node != null) {
      val result1 = d.dv_
      d = result1.derivation
      result = result1
      info.join(result1, false)
    }
    
    if (result.node != null) {
      // op=AssignmentOperator 
      val result2 = d.dvAssignmentOperator
      d = result2.derivation
      result = result2
      info.join(result2, false)
      if (result.node != null) {
        if (node == null) {
          node = new AssignableExpression
        }
        (node as AssignableExpression).setOp(result2.node)
      }
    }
    
    if (result.node != null) {
      val result3 = d.dv_
      d = result3.derivation
      result = result3
      info.join(result3, false)
    }
    
    if (result.node != null) {
      // expr=AssignableExpressionExpressions\u000a  
      val result4 = d.dvAssignableExpressionExpressions
      d = result4.derivation
      result = result4
      info.join(result4, false)
      if (result.node != null) {
        if (node == null) {
          node = new AssignableExpression
        }
        (node as AssignableExpression).setExpr(result4.node)
      }
    }
    if (result.node == null) {
      node = backup0
      d = backup1
      val backup2 = node?.copy()
      val backup3 = d
      
      val result5 = d.dvAssignableExpressionExpressions
      d = result5.derivation
      if (node == null) {
        node = result5.node
      }
      result = result5
      info.join(result5, false)
      if (result.node == null) {
        node = backup2
        d = backup3
      }
    }
    
    if (result.node != null) {
      val result6 = d.dv_
      d = result6.derivation
      result = result6
      info.join(result6, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new AssignableExpression()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class AssignableExpressionExpressionsRule {

  /**
   * AssignableExpressionExpressions returns Expression : SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression ; 
   */
  package static def Result<? extends Expression> matchAssignableExpressionExpressions(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // SubExpression\u000a  | RangeExpression\u000a  | TerminalExpression\u000a  | AnyCharExpression\u000a  | RuleReferenceExpression\u000a
    val backup0 = node?.copy()
    val backup1 = d
    
    val result0 = d.dvSubExpression
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
      
      val result1 = d.dvRangeExpression
      d = result1.derivation
      if (node == null) {
        node = result1.node
      }
      result = result1
      info.join(result1, false)
      if (result.node == null) {
        node = backup2
        d = backup3
        val backup4 = node?.copy()
        val backup5 = d
        
        val result2 = d.dvTerminalExpression
        d = result2.derivation
        if (node == null) {
          node = result2.node
        }
        result = result2
        info.join(result2, false)
        if (result.node == null) {
          node = backup4
          d = backup5
          val backup6 = node?.copy()
          val backup7 = d
          
          val result3 = d.dvAnyCharExpression
          d = result3.derivation
          if (node == null) {
            node = result3.node
          }
          result = result3
          info.join(result3, false)
          if (result.node == null) {
            node = backup6
            d = backup7
            val backup8 = node?.copy()
            val backup9 = d
            
            val result4 = d.dvRuleReferenceExpression
            d = result4.derivation
            if (node == null) {
              node = result4.node
            }
            result = result4
            info.join(result4, false)
            if (result.node == null) {
              node = backup8
              d = backup9
            }
          }
        }
      }
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new AssignableExpressionExpressions()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  
}
package class AssignmentOperatorRule {

  /**
   * AssignmentOperator : (single?='=' | multi?='+=' | bool?='?=') _ ; 
   */
  package static def Result<? extends AssignmentOperator> matchAssignmentOperator(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var AssignmentOperator node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // single?='=' | multi?='+=' | bool?='?='
    val backup0 = node?.copy()
    val backup1 = d
    
    // single?='=' 
    val result0 =  d.__terminal('=')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    if (result.node != null) {
      if (node == null) {
        node = new AssignmentOperator
      }
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
      result = result1
      info.join(result1, false)
      if (result.node != null) {
        if (node == null) {
          node = new AssignmentOperator
        }
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
        result = result2
        info.join(result2, false)
        if (result.node != null) {
          if (node == null) {
            node = new AssignmentOperator
          }
          node.setBool(result2.node != null)
        }
        if (result.node == null) {
          node = backup4
          d = backup5
        }
      }
    }
    
    if (result.node != null) {
      val result3 = d.dv_
      d = result3.derivation
      result = result3
      info.join(result3, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new AssignmentOperator()
      }
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
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val result0 =  d.__terminal('(')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    if (result.node != null) {
      val result1 = d.dv_
      d = result1.derivation
      result = result1
      info.join(result1, false)
    }
    
    if (result.node != null) {
      // expr=ChoiceExpression 
      val result2 = d.dvChoiceExpression
      d = result2.derivation
      result = result2
      info.join(result2, false)
      if (result.node != null) {
        if (node == null) {
          node = new SubExpression
        }
        (node as SubExpression).setExpr(result2.node)
      }
    }
    
    if (result.node != null) {
      val result3 =  d.__terminal(')')
      d = result3.derivation
      result = result3
      info.join(result3, false)
    }
    
    if (result.node != null) {
      val result4 = d.dv_
      d = result4.derivation
      result = result4
      info.join(result4, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new SubExpression()
      }
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
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val result0 =  d.__terminal('[')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    if (result.node != null) {
      // dash='-'? 
      val backup0 = node?.copy()
      val backup1 = d
      
      // dash='-'
      val result1 =  d.__terminal('-')
      d = result1.derivation
      result = result1
      info.join(result1, false)
      if (result.node != null) {
        if (node == null) {
          node = new RangeExpression
        }
        (node as RangeExpression).setDash(result1.node)
      }
      if (result.node == null) {
        node = backup0
        d = backup1
        result = CONTINUE
        info.join(result, false)
      }
    }
    
    if (result.node != null) {
      // (!']' ranges+=(MinMaxRange | CharRange))* 
      var backup2 = node?.copy()
      var backup3 = d
      
      do {
        val backup4 = node?.copy()
        val backup5 = d
        val result2 =  d.__terminal(']')
        d = result2.derivation
        result = result2
        info.join(result2, true)
        node = backup4
        d = backup5
        if (result.node != null) {
          result = BREAK
          info.join(result, true)
        } else {
          result = CONTINUE
          info.join(result, true)
        }
        
        if (result.node != null) {
          // ranges+=(MinMaxRange | CharRange)
          val result5 = d.sub0MatchRangeExpression(parser)
          d = result5.derivation
          result = result5
          info.join(result5, false)
          if (result.node != null) {
            if (node == null) {
              node = new RangeExpression
            }
            (node as RangeExpression).add(result5.node)
          }
        }
        if (result.node != null) {
          backup2 = node?.copy()
          backup3 = d
        }
      } while (result.node != null)
      node = backup2
      d = backup3
      result = CONTINUE
      info.join(result, false)
    }
    
    if (result.node != null) {
      val result6 =  d.__terminal(']')
      d = result6.derivation
      result = result6
      info.join(result6, false)
    }
    
    if (result.node != null) {
      val result7 = d.dv_
      d = result7.derivation
      result = result7
      info.join(result7, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new RangeExpression()
      }
      node.index = derivation.index
      node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  private static def Result<? extends Node> sub0MatchRangeExpression(Derivation derivation, Parser parser) {
      var Result<? extends Node> result = null
      var Node node = null
      var d = derivation
      val ParseInfo info = new ParseInfo(derivation.index)
      
      // MinMaxRange | CharRange
      val backup6 = node?.copy()
      val backup7 = d
      
      val result3 = d.dvMinMaxRange
      d = result3.derivation
      result = result3
      info.join(result3, false)
      if (result.node == null) {
        node = backup6
        d = backup7
        val backup8 = node?.copy()
        val backup9 = d
        
        val result4 = d.dvCharRange
        d = result4.derivation
        result = result4
        info.join(result4, false)
        if (result.node == null) {
          node = backup8
          d = backup9
        }
      }
      
      result.info = info
      return result
  }
  
}
package class MinMaxRangeRule {

  /**
   * MinMaxRange: !'-' min=. '-' !'-' max=. ; 
   */
  package static def Result<? extends MinMaxRange> matchMinMaxRange(Parser parser, Derivation derivation) {
    var Result<?> result = null
    var MinMaxRange node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val backup0 = node?.copy()
    val backup1 = d
    val result0 =  d.__terminal('-')
    d = result0.derivation
    result = result0
    info.join(result0, true)
    node = backup0
    d = backup1
    if (result.node != null) {
      result = BREAK
      info.join(result, true)
    } else {
      result = CONTINUE
      info.join(result, true)
    }
    
    if (result.node != null) {
      // min=. 
      // .
      val result1 =  d.__any()
      d = result1.derivation
      result = result1
      info.join(result1, false)
      if (result.node != null) {
        if (node == null) {
          node = new MinMaxRange
        }
        node.setMin(result1.node)
      }
    }
    
    if (result.node != null) {
      val result2 =  d.__terminal('-')
      d = result2.derivation
      result = result2
      info.join(result2, false)
    }
    
    if (result.node != null) {
      val backup2 = node?.copy()
      val backup3 = d
      val result3 =  d.__terminal('-')
      d = result3.derivation
      result = result3
      info.join(result3, true)
      node = backup2
      d = backup3
      if (result.node != null) {
        result = BREAK
        info.join(result, true)
      } else {
        result = CONTINUE
        info.join(result, true)
      }
    }
    
    if (result.node != null) {
      // max=.\u000a
      // .
      val result4 =  d.__any()
      d = result4.derivation
      result = result4
      info.join(result4, false)
      if (result.node != null) {
        if (node == null) {
          node = new MinMaxRange
        }
        node.setMax(result4.node)
      }
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new MinMaxRange()
      }
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
    var CharRange node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // '\\\\' char=']'\u000a  | '\\\\' char='\\\\'\u000a  | !'-' char=.\u000a
    val backup0 = node?.copy()
    val backup1 = d
    
    val result0 =  d.__terminal('\\')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    if (result.node != null) {
      // char=']'\u000a  
      val result1 =  d.__terminal(']')
      d = result1.derivation
      result = result1
      info.join(result1, false)
      if (result.node != null) {
        if (node == null) {
          node = new CharRange
        }
        node.setChar(result1.node)
      }
    }
    if (result.node == null) {
      node = backup0
      d = backup1
      val backup2 = node?.copy()
      val backup3 = d
      
      val result2 =  d.__terminal('\\')
      d = result2.derivation
      result = result2
      info.join(result2, false)
      
      if (result.node != null) {
        // char='\\\\'\u000a  
        val result3 =  d.__terminal('\\')
        d = result3.derivation
        result = result3
        info.join(result3, false)
        if (result.node != null) {
          if (node == null) {
            node = new CharRange
          }
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
        val result4 =  d.__terminal('-')
        d = result4.derivation
        result = result4
        info.join(result4, true)
        node = backup6
        d = backup7
        if (result.node != null) {
          result = BREAK
          info.join(result, true)
        } else {
          result = CONTINUE
          info.join(result, true)
        }
        
        if (result.node != null) {
          // char=.\u000a
          // .
          val result5 =  d.__any()
          d = result5.derivation
          result = result5
          info.join(result5, false)
          if (result.node != null) {
            if (node == null) {
              node = new CharRange
            }
            node.setChar(result5.node)
          }
        }
        if (result.node == null) {
          node = backup4
          d = backup5
        }
      }
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new CharRange()
      }
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
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // char='.'\u000a
    val result0 =  d.__terminal('.')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    if (result.node != null) {
      if (node == null) {
        node = new AnyCharExpression
      }
      (node as AnyCharExpression).setChar(result0.node)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new AnyCharExpression()
      }
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
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // name=ID 
    val result0 = d.dvID
    d = result0.derivation
    result = result0
    info.join(result0, false)
    if (result.node != null) {
      if (node == null) {
        node = new RuleReferenceExpression
      }
      (node as RuleReferenceExpression).setName(result0.node)
    }
    
    if (result.node != null) {
      val result1 = d.dv_
      d = result1.derivation
      result = result1
      info.join(result1, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new RuleReferenceExpression()
      }
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
    var Expression node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val result0 =  d.__terminal('\'')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    if (result.node != null) {
      // value=InTerminalChar? 
      val backup0 = node?.copy()
      val backup1 = d
      
      // value=InTerminalChar
      val result1 = d.dvInTerminalChar
      d = result1.derivation
      result = result1
      info.join(result1, false)
      if (result.node != null) {
        if (node == null) {
          node = new TerminalExpression
        }
        (node as TerminalExpression).setValue(result1.node)
      }
      if (result.node == null) {
        node = backup0
        d = backup1
        result = CONTINUE
        info.join(result, false)
      }
    }
    
    if (result.node != null) {
      val result2 =  d.__terminal('\'')
      d = result2.derivation
      result = result2
      info.join(result2, false)
    }
    
    if (result.node != null) {
      val result3 = d.dv_
      d = result3.derivation
      result = result3
      info.join(result3, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new TerminalExpression()
      }
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
    var InTerminalChar node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // ('\\\\' '\\'' | '\\\\' '\\\\' | !'\\'' .)+\u000a
    var backup0 = node?.copy()
    var backup1 = d
    var loop0 = false
    
    do {
      // '\\\\' '\\'' | '\\\\' '\\\\' | !'\\'' .
      val backup2 = node?.copy()
      val backup3 = d
      
      val result0 =  d.__terminal('\\')
      d = result0.derivation
      result = result0
      info.join(result0, false)
      
      if (result.node != null) {
        val result1 =  d.__terminal('\'')
        d = result1.derivation
        result = result1
        info.join(result1, false)
      }
      if (result.node == null) {
        node = backup2
        d = backup3
        val backup4 = node?.copy()
        val backup5 = d
        
        val result2 =  d.__terminal('\\')
        d = result2.derivation
        result = result2
        info.join(result2, false)
        
        if (result.node != null) {
          val result3 =  d.__terminal('\\')
          d = result3.derivation
          result = result3
          info.join(result3, false)
        }
        if (result.node == null) {
          node = backup4
          d = backup5
          val backup6 = node?.copy()
          val backup7 = d
          
          val backup8 = node?.copy()
          val backup9 = d
          val result4 =  d.__terminal('\'')
          d = result4.derivation
          result = result4
          info.join(result4, true)
          node = backup8
          d = backup9
          if (result.node != null) {
            result = BREAK
            info.join(result, true)
          } else {
            result = CONTINUE
            info.join(result, true)
          }
          
          if (result.node != null) {
            // .
            val result5 =  d.__any()
            d = result5.derivation
            result = result5
            info.join(result5, false)
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
      result = CONTINUE
      info.join(result, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new InTerminalChar()
      }
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
    var Comment node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val result0 =  d.__terminal('//')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    if (result.node != null) {
      // (!('\\r'? '\\n') .)* 
      var backup0 = node?.copy()
      var backup1 = d
      
      do {
        val backup2 = node?.copy()
        val backup3 = d
        // '\\r'? 
        val backup4 = node?.copy()
        val backup5 = d
        
        val result1 =  d.__terminal('\r')
        d = result1.derivation
        result = result1
        info.join(result1, true)
        if (result.node == null) {
          node = backup4
          d = backup5
          result = CONTINUE
          info.join(result, true)
        }
        
        if (result.node != null) {
          val result2 =  d.__terminal('\n')
          d = result2.derivation
          result = result2
          info.join(result2, true)
        }
        node = backup2
        d = backup3
        if (result.node != null) {
          result = BREAK
          info.join(result, true)
        } else {
          result = CONTINUE
          info.join(result, true)
        }
        
        if (result.node != null) {
          // .
          val result3 =  d.__any()
          d = result3.derivation
          result = result3
          info.join(result3, false)
        }
        if (result.node != null) {
          backup0 = node?.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE
      info.join(result, false)
    }
    
    if (result.node != null) {
      val result4 = d.dv_
      d = result4.derivation
      result = result4
      info.join(result4, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new Comment()
      }
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
    var EOI node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    val backup0 = node?.copy()
    val backup1 = d
    // .
    val result0 =  d.__any()
    d = result0.derivation
    result = result0
    info.join(result0, true)
    node = backup0
    d = backup1
    if (result.node != null) {
      result = BREAK
      info.join(result, true)
    } else {
      result = CONTINUE
      info.join(result, true)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new EOI()
      }
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
    var ID node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // [a-zA-Z_] 
    val result0 = d.__oneOfThese(
      ('a'..'z') + ('A'..'Z') + '_'
      )
    d = result0.derivation
    result = result0
    info.join(result0, false)
    
    if (result.node != null) {
      // [a-zA-Z0-9_]*\u000a
      var backup0 = node?.copy()
      var backup1 = d
      
      do {
        // [a-zA-Z0-9_]
        val result1 = d.__oneOfThese(
          ('a'..'z') + ('A'..'Z') + ('0'..'9') + '_'
          )
        d = result1.derivation
        result = result1
        info.join(result1, false)
        if (result.node != null) {
          backup0 = node?.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE
      info.join(result, false)
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new ID()
      }
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
    var WS node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // ' ' | '\\n' | '\\t' | '\\r'\u000a
    val backup0 = node?.copy()
    val backup1 = d
    
    val result0 =  d.__terminal(' ')
    d = result0.derivation
    result = result0
    info.join(result0, false)
    if (result.node == null) {
      node = backup0
      d = backup1
      val backup2 = node?.copy()
      val backup3 = d
      
      val result1 =  d.__terminal('\n')
      d = result1.derivation
      result = result1
      info.join(result1, false)
      if (result.node == null) {
        node = backup2
        d = backup3
        val backup4 = node?.copy()
        val backup5 = d
        
        val result2 =  d.__terminal('\t')
        d = result2.derivation
        result = result2
        info.join(result2, false)
        if (result.node == null) {
          node = backup4
          d = backup5
          val backup6 = node?.copy()
          val backup7 = d
          
          val result3 =  d.__terminal('\r')
          d = result3.derivation
          result = result3
          info.join(result3, false)
          if (result.node == null) {
            node = backup6
            d = backup7
          }
        }
      }
    }
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new WS()
      }
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
    var _ node = null
    var d = derivation
    val ParseInfo info = new ParseInfo(derivation.index)
    
    // WS* \u000a
    var backup0 = node?.copy()
    var backup1 = d
    
    do {
      val result0 = d.dvWS
      d = result0.derivation
      result = result0
      info.join(result0, false)
      if (result.node != null) {
        backup0 = node?.copy()
        backup1 = d
      }
    } while (result.node != null)
    node = backup0
    d = backup1
    result = CONTINUE
    info.join(result, false)
    
    result.info = info
    if (result.node != null) {
      if (node == null) {
        node = new _()
      }
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
  Result<? extends Expression> dvExpression
  Result<? extends Expression> dvChoiceExpression
  Result<? extends Expression> dvSequenceExpression
  Result<? extends Expression> dvSequenceExpressionExpressions
  Result<? extends Expression> dvActionExpression
  Result<? extends ActionOperator> dvActionOperator
  Result<? extends Expression> dvAndPredicateExpression
  Result<? extends Expression> dvNotPredicateExpression
  Result<? extends Expression> dvOneOrMoreExpression
  Result<? extends Expression> dvZeroOrMoreExpression
  Result<? extends Expression> dvOptionalExpression
  Result<? extends Expression> dvAssignableExpression
  Result<? extends Expression> dvAssignableExpressionExpressions
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
  
  def getDvExpression() {
    if (dvExpression == null) {
      // Fail LR upfront
      dvExpression = new Result<Expression>(null, this, new ParseInfo(index, 'Detected left-recursion in Expression'))
      dvExpression = ExpressionRule.matchExpression(parser, this)
    }
    return dvExpression
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
  
  def getDvSequenceExpressionExpressions() {
    if (dvSequenceExpressionExpressions == null) {
      // Fail LR upfront
      dvSequenceExpressionExpressions = new Result<SequenceExpressionExpressions>(null, this, new ParseInfo(index, 'Detected left-recursion in SequenceExpressionExpressions'))
      dvSequenceExpressionExpressions = SequenceExpressionExpressionsRule.matchSequenceExpressionExpressions(parser, this)
    }
    return dvSequenceExpressionExpressions
  }
  
  def getDvActionExpression() {
    if (dvActionExpression == null) {
      // Fail LR upfront
      dvActionExpression = new Result<ActionExpression>(null, this, new ParseInfo(index, 'Detected left-recursion in ActionExpression'))
      dvActionExpression = ActionExpressionRule.matchActionExpression(parser, this)
    }
    return dvActionExpression
  }
  
  def getDvActionOperator() {
    if (dvActionOperator == null) {
      // Fail LR upfront
      dvActionOperator = new Result<ActionOperator>(null, this, new ParseInfo(index, 'Detected left-recursion in ActionOperator'))
      dvActionOperator = ActionOperatorRule.matchActionOperator(parser, this)
    }
    return dvActionOperator
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
  
  def getDvAssignableExpressionExpressions() {
    if (dvAssignableExpressionExpressions == null) {
      // Fail LR upfront
      dvAssignableExpressionExpressions = new Result<AssignableExpressionExpressions>(null, this, new ParseInfo(index, 'Detected left-recursion in AssignableExpressionExpressions'))
      dvAssignableExpressionExpressions = AssignableExpressionExpressionsRule.matchAssignableExpressionExpressions(parser, this)
    }
    return dvAssignableExpressionExpressions
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

