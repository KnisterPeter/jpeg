package jpeg

import java.util.Set

import static extension jpeg.CharacterRange.*

class Parser {
  
  static Result<Object> CONTINUE = new SpecialResult(new Object)
  static Result<Object> BREAK = new SpecialResult(null)
  
  char[] chars
  
  package def Derivation parse(int idx) {
    new Derivation(idx, [jpeg()],[rule()],[ruleReturns()],[body()],[choiceExpression()],[sequenceExpression()],[actionExpression()],[andPredicateExpression()],[notPredicateExpression()],[oneOrMoreExpression()],[zeroOrMoreExpression()],[optionalExpression()],[assignableExpression()],[assignmentOperator()],[subExpression()],[rangeExpression()],[minMaxRange()],[charRange()],[anyCharExpression()],[ruleReferenceExpression()],[terminalExpression()],[inTerminalChar()],[comment()],[eOI()],[iD()],[wS()],
      [
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
  
  static def <T> __terminal(Derivation derivation, String str, Parser parser) {
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
  
  static def <T> __oneOfThese(Derivation derivation, CharacterRange range, Parser parser) {
    val r = derivation.dvChar
    return 
      if (r.node != null && range.contains(r.node)) new Result<Terminal>(new Terminal(r.node), r.derivation, new ParseInfo(r.derivation.index))
      else new Result<Terminal>(null, derivation, new ParseInfo(r.derivation.index, "'" + range + "'"))
  }

  static def <T> __any(Derivation derivation, Parser parser) {
    val r = derivation.dvChar
    return
      if (r.node != null) new Result<Terminal>(new Terminal(r.node), r.derivation, new ParseInfo(r.derivation.index))
      else  new Result<Terminal>(null, derivation, new ParseInfo(r.derivation.index, 'end of input'))
  }

  //--------------------------------------------------------------------------
  
  def Jpeg Jpeg(String in) {
    this.chars = in.toCharArray()
    val result = jpeg(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * Jpeg : (rules+=Rule | Comment)+ EOI ; 
   */
  package def Result<? extends Jpeg> jpeg(Derivation derivation) {
    var Result<?> result = null
    var node = new Jpeg
    var d = derivation
    
    // (rules+=Rule | Comment)+ 
    var backup0 = node.copy()
    var backup1 = d
    var loop0 = false
    
    do {
      // (rules+=Rule | Comment)
      // rules+=Rule | Comment
      val backup2 = node.copy()
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
        val backup4 = node.copy()
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
        backup0 = node.copy()
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
      // EOI 
      val result2 = d.dvEOI
      d = result2.derivation
      result = result2.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Jpeg>(node, d, result.info)
    }
    return new Result<Jpeg>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Rule Rule(String in) {
    this.chars = in.toCharArray()
    val result = rule(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * Rule : name=ID WS* returns=RuleReturns? ':' WS* body=Body ';' WS* ; 
   */
  package def Result<? extends Rule> rule(Derivation derivation) {
    var Result<?> result = null
    var node = new Rule
    var d = derivation
    
    // name=ID 
    val result0 = d.dvID
    d = result0.derivation
    result = result0.joinErrors(result, false)
    if (result.node != null) {
      node.name = result0.node
    }
    
    if (result.node != null) {
      // WS* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // returns=RuleReturns? 
      val backup2 = node.copy()
      val backup3 = d
      
      // returns=RuleReturns
      val result2 = d.dvRuleReturns
      d = result2.derivation
      result = result2.joinErrors(result, false)
      if (result.node != null) {
        node.returns = result2.node
      }
      if (result.node == null) {
        node = backup2
        d = backup3
        result = CONTINUE.joinErrors(result, false)
      }
    }
    
    if (result.node != null) {
      // ':' 
      val result3 =  d.__terminal(':', this)
      d = result3.derivation
      result = result3.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // WS* 
      var backup4 = node.copy()
      var backup5 = d
      
      do {
        // WS
        val result4 = d.dvWS
        d = result4.derivation
        result = result4.joinErrors(result, false)
        if (result.node != null) {
          backup4 = node.copy()
          backup5 = d
        }
      } while (result.node != null)
      node = backup4
      d = backup5
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // body=Body 
      val result5 = d.dvBody
      d = result5.derivation
      result = result5.joinErrors(result, false)
      if (result.node != null) {
        node.body = result5.node
      }
    }
    
    if (result.node != null) {
      // ';' 
      val result6 =  d.__terminal(';', this)
      d = result6.derivation
      result = result6.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // WS* 
      var backup6 = node.copy()
      var backup7 = d
      
      do {
        // WS
        val result7 = d.dvWS
        d = result7.derivation
        result = result7.joinErrors(result, false)
        if (result.node != null) {
          backup6 = node.copy()
          backup7 = d
        }
      } while (result.node != null)
      node = backup6
      d = backup7
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Rule>(node, d, result.info)
    }
    return new Result<Rule>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def RuleReturns RuleReturns(String in) {
    this.chars = in.toCharArray()
    val result = ruleReturns(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * RuleReturns : 'returns' WS* name=ID WS* ; 
   */
  package def Result<? extends RuleReturns> ruleReturns(Derivation derivation) {
    var Result<?> result = null
    var node = new RuleReturns
    var d = derivation
    
    // 'returns' 
    val result0 =  d.__terminal('returns', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    
    if (result.node != null) {
      // WS* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // name=ID 
      val result2 = d.dvID
      d = result2.derivation
      result = result2.joinErrors(result, false)
      if (result.node != null) {
        node.name = result2.node
      }
    }
    
    if (result.node != null) {
      // WS* 
      var backup2 = node.copy()
      var backup3 = d
      
      do {
        // WS
        val result3 = d.dvWS
        d = result3.derivation
        result = result3.joinErrors(result, false)
        if (result.node != null) {
          backup2 = node.copy()
          backup3 = d
        }
      } while (result.node != null)
      node = backup2
      d = backup3
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<RuleReturns>(node, d, result.info)
    }
    return new Result<RuleReturns>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Body Body(String in) {
    this.chars = in.toCharArray()
    val result = body(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * Body : (expressions+=ChoiceExpression WS*)+ ; 
   */
  package def Result<? extends Body> body(Derivation derivation) {
    var Result<?> result = null
    var node = new Body
    var d = derivation
    
    // (expressions+=ChoiceExpression WS*)+ 
    var backup0 = node.copy()
    var backup1 = d
    var loop0 = false
    
    do {
      // (expressions+=ChoiceExpression WS*)
      // expressions+=ChoiceExpression 
      val result0 = d.dvChoiceExpression
      d = result0.derivation
      result = result0.joinErrors(result, false)
      if (result.node != null) {
        node.add(result0.node)
      }
      
      if (result.node != null) {
        // WS*
        var backup2 = node.copy()
        var backup3 = d
        
        do {
          // WS
          val result1 = d.dvWS
          d = result1.derivation
          result = result1.joinErrors(result, false)
          if (result.node != null) {
            backup2 = node.copy()
            backup3 = d
          }
        } while (result.node != null)
        node = backup2
        d = backup3
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        loop0 = true
        backup0 = node.copy()
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
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Body>(node, d, result.info)
    }
    return new Result<Body>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression ChoiceExpression(String in) {
    this.chars = in.toCharArray()
    val result = choiceExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * ChoiceExpression returns Expression : choices+=SequenceExpression ('|' WS* choices+=SequenceExpression)* ; 
   */
  package def Result<? extends Expression> choiceExpression(Derivation derivation) {
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
      // ('|' WS* choices+=SequenceExpression)* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // ('|' WS* choices+=SequenceExpression)
        // '|' 
        val result1 =  d.__terminal('|', this)
        d = result1.derivation
        result = result1.joinErrors(result, false)
        
        if (result.node != null) {
          // WS* 
          var backup2 = node.copy()
          var backup3 = d
          
          do {
            // WS
            val result2 = d.dvWS
            d = result2.derivation
            result = result2.joinErrors(result, false)
            if (result.node != null) {
              backup2 = node.copy()
              backup3 = d
            }
          } while (result.node != null)
          node = backup2
          d = backup3
          result = CONTINUE.joinErrors(result, false)
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
          backup0 = node.copy()
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
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression SequenceExpression(String in) {
    this.chars = in.toCharArray()
    val result = sequenceExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * SequenceExpression returns Expression : ( Comment* expressions+=( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression ) WS* )+ ; 
   */
  package def Result<? extends Expression> sequenceExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new SequenceExpression
    var d = derivation
    
    // ( Comment* expressions+=( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression ) WS* )+ 
    var backup0 = node.copy()
    var backup1 = d
    var loop0 = false
    
    do {
      // ( Comment* expressions+=( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression ) WS* )
      // Comment* 
      var backup2 = node.copy()
      var backup3 = d
      
      do {
        // Comment
        val result0 = d.dvComment
        d = result0.derivation
        result = result0.joinErrors(result, false)
        if (result.node != null) {
          backup2 = node.copy()
          backup3 = d
        }
      } while (result.node != null)
      node = backup2
      d = backup3
      result = CONTINUE.joinErrors(result, false)
      
      if (result.node != null) {
        // expressions+=( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression ) 
        val result1 = d.sequenceExpression_sub0()
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          node.add(result1.node)
        }
      }
      
      if (result.node != null) {
        // WS* 
        var backup4 = node.copy()
        var backup5 = d
        
        do {
          // WS
          val result2 = d.dvWS
          d = result2.derivation
          result = result2.joinErrors(result, false)
          if (result.node != null) {
            backup4 = node.copy()
            backup5 = d
          }
        } while (result.node != null)
        node = backup4
        d = backup5
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        loop0 = true
        backup0 = node.copy()
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
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  private def Result<? extends Expression> sequenceExpression_sub0(Derivation derivation) {
    var Result<?> result = null
    val d = derivation
    // ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression 
    result = d.dvActionExpression
    .joinErrors(result, false)
    if (result.node == null) {
      result = d.dvAndPredicateExpression
      .joinErrors(result, false)
      if (result.node == null) {
        result = d.dvNotPredicateExpression
        .joinErrors(result, false)
        if (result.node == null) {
          result = d.dvOneOrMoreExpression
          .joinErrors(result, false)
          if (result.node == null) {
            result = d.dvZeroOrMoreExpression
            .joinErrors(result, false)
            if (result.node == null) {
              result = d.dvOptionalExpression
              .joinErrors(result, false)
              if (result.node == null) {
                result = d.dvAssignableExpression
                .joinErrors(result, false)
              }
            }
          }
        }
      }
    }
    return result as Result<? extends Expression>
  }
  //--------------------------------------------------------------------------
  
  def Expression ActionExpression(String in) {
    this.chars = in.toCharArray()
    val result = actionExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * ActionExpression returns Expression : '{' WS* (property=ID WS* op=AssignmentOperator 'current' WS* | name=ID WS*) '}' ; 
   */
  package def Result<? extends Expression> actionExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new ActionExpression
    var d = derivation
    
    // '{' 
    val result0 =  d.__terminal('{', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    
    if (result.node != null) {
      // WS* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // (property=ID WS* op=AssignmentOperator 'current' WS* | name=ID WS*) 
      // property=ID WS* op=AssignmentOperator 'current' WS* | name=ID WS*
      val backup2 = node.copy()
      val backup3 = d
      
      // property=ID 
      val result2 = d.dvID
      d = result2.derivation
      result = result2.joinErrors(result, false)
      if (result.node != null) {
        node.property = result2.node
      }
      
      if (result.node != null) {
        // WS* 
        var backup4 = node.copy()
        var backup5 = d
        
        do {
          // WS
          val result3 = d.dvWS
          d = result3.derivation
          result = result3.joinErrors(result, false)
          if (result.node != null) {
            backup4 = node.copy()
            backup5 = d
          }
        } while (result.node != null)
        node = backup4
        d = backup5
        result = CONTINUE.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // op=AssignmentOperator 
        val result4 = d.dvAssignmentOperator
        d = result4.derivation
        result = result4.joinErrors(result, false)
        if (result.node != null) {
          node.op = result4.node
        }
      }
      
      if (result.node != null) {
        // 'current' 
        val result5 =  d.__terminal('current', this)
        d = result5.derivation
        result = result5.joinErrors(result, false)
      }
      
      if (result.node != null) {
        // WS* 
        var backup6 = node.copy()
        var backup7 = d
        
        do {
          // WS
          val result6 = d.dvWS
          d = result6.derivation
          result = result6.joinErrors(result, false)
          if (result.node != null) {
            backup6 = node.copy()
            backup7 = d
          }
        } while (result.node != null)
        node = backup6
        d = backup7
        result = CONTINUE.joinErrors(result, false)
      }
      if (result.node == null) {
        node = backup2
        d = backup3
        val backup8 = node.copy()
        val backup9 = d
        
        // name=ID 
        val result7 = d.dvID
        d = result7.derivation
        result = result7.joinErrors(result, false)
        if (result.node != null) {
          node.name = result7.node
        }
        
        if (result.node != null) {
          // WS*
          var backup10 = node.copy()
          var backup11 = d
          
          do {
            // WS
            val result8 = d.dvWS
            d = result8.derivation
            result = result8.joinErrors(result, false)
            if (result.node != null) {
              backup10 = node.copy()
              backup11 = d
            }
          } while (result.node != null)
          node = backup10
          d = backup11
          result = CONTINUE.joinErrors(result, false)
        }
        if (result.node == null) {
          node = backup8
          d = backup9
        }
      }
    }
    
    if (result.node != null) {
      // '}' 
      val result9 =  d.__terminal('}', this)
      d = result9.derivation
      result = result9.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression AndPredicateExpression(String in) {
    this.chars = in.toCharArray()
    val result = andPredicateExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * AndPredicateExpression returns Expression : '&' WS* expr=AssignableExpression ; 
   */
  package def Result<? extends Expression> andPredicateExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new AndPredicateExpression
    var d = derivation
    
    // '&' 
    val result0 =  d.__terminal('&', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    
    if (result.node != null) {
      // WS* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // expr=AssignableExpression 
      val result2 = d.dvAssignableExpression
      d = result2.derivation
      result = result2.joinErrors(result, false)
      if (result.node != null) {
        node.expr = result2.node
      }
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression NotPredicateExpression(String in) {
    this.chars = in.toCharArray()
    val result = notPredicateExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * NotPredicateExpression returns Expression : '!' WS* expr=AssignableExpression ; 
   */
  package def Result<? extends Expression> notPredicateExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new NotPredicateExpression
    var d = derivation
    
    // '!' 
    val result0 =  d.__terminal('!', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    
    if (result.node != null) {
      // WS* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // expr=AssignableExpression 
      val result2 = d.dvAssignableExpression
      d = result2.derivation
      result = result2.joinErrors(result, false)
      if (result.node != null) {
        node.expr = result2.node
      }
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression OneOrMoreExpression(String in) {
    this.chars = in.toCharArray()
    val result = oneOrMoreExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * OneOrMoreExpression returns Expression : expr=AssignableExpression '+' WS* ; 
   */
  package def Result<? extends Expression> oneOrMoreExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new OneOrMoreExpression
    var d = derivation
    
    // expr=AssignableExpression 
    val result0 = d.dvAssignableExpression
    d = result0.derivation
    result = result0.joinErrors(result, false)
    if (result.node != null) {
      node.expr = result0.node
    }
    
    if (result.node != null) {
      // '+' 
      val result1 =  d.__terminal('+', this)
      d = result1.derivation
      result = result1.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // WS* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // WS
        val result2 = d.dvWS
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression ZeroOrMoreExpression(String in) {
    this.chars = in.toCharArray()
    val result = zeroOrMoreExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * ZeroOrMoreExpression returns Expression : expr=AssignableExpression '*' WS* ; 
   */
  package def Result<? extends Expression> zeroOrMoreExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new ZeroOrMoreExpression
    var d = derivation
    
    // expr=AssignableExpression 
    val result0 = d.dvAssignableExpression
    d = result0.derivation
    result = result0.joinErrors(result, false)
    if (result.node != null) {
      node.expr = result0.node
    }
    
    if (result.node != null) {
      // '*' 
      val result1 =  d.__terminal('*', this)
      d = result1.derivation
      result = result1.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // WS* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // WS
        val result2 = d.dvWS
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression OptionalExpression(String in) {
    this.chars = in.toCharArray()
    val result = optionalExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * OptionalExpression returns Expression : expr=AssignableExpression '?' WS* ; 
   */
  package def Result<? extends Expression> optionalExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new OptionalExpression
    var d = derivation
    
    // expr=AssignableExpression 
    val result0 = d.dvAssignableExpression
    d = result0.derivation
    result = result0.joinErrors(result, false)
    if (result.node != null) {
      node.expr = result0.node
    }
    
    if (result.node != null) {
      // '?' 
      val result1 =  d.__terminal('?', this)
      d = result1.derivation
      result = result1.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // WS* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // WS
        val result2 = d.dvWS
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression AssignableExpression(String in) {
    this.chars = in.toCharArray()
    val result = assignableExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * AssignableExpression returns Expression : (property=ID WS* op=AssignmentOperator)? expr= ( SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression ) WS* ; 
   */
  package def Result<? extends Expression> assignableExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new AssignableExpression
    var d = derivation
    
    // (property=ID WS* op=AssignmentOperator)? 
    val backup0 = node.copy()
    val backup1 = d
    
    // (property=ID WS* op=AssignmentOperator)
    // property=ID 
    val result0 = d.dvID
    d = result0.derivation
    result = result0.joinErrors(result, false)
    if (result.node != null) {
      node.property = result0.node
    }
    
    if (result.node != null) {
      // WS* 
      var backup2 = node.copy()
      var backup3 = d
      
      do {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          backup2 = node.copy()
          backup3 = d
        }
      } while (result.node != null)
      node = backup2
      d = backup3
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // op=AssignmentOperator
      val result2 = d.dvAssignmentOperator
      d = result2.derivation
      result = result2.joinErrors(result, false)
      if (result.node != null) {
        node.op = result2.node
      }
    }
    if (result.node == null) {
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // expr= ( SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression ) 
      val result3 = d.assignableExpression_sub0()
      d = result3.derivation
      result = result3.joinErrors(result, false)
      if (result.node != null) {
        node.expr = result3.node
      }
    }
    
    if (result.node != null) {
      // WS* 
      var backup4 = node.copy()
      var backup5 = d
      
      do {
        // WS
        val result4 = d.dvWS
        d = result4.derivation
        result = result4.joinErrors(result, false)
        if (result.node != null) {
          backup4 = node.copy()
          backup5 = d
        }
      } while (result.node != null)
      node = backup4
      d = backup5
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  private def Result<? extends Expression> assignableExpression_sub0(Derivation derivation) {
    var Result<?> result = null
    val d = derivation
    // SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression 
    result = d.dvSubExpression
    .joinErrors(result, false)
    if (result.node == null) {
      result = d.dvRangeExpression
      .joinErrors(result, false)
      if (result.node == null) {
        result = d.dvTerminalExpression
        .joinErrors(result, false)
        if (result.node == null) {
          result = d.dvAnyCharExpression
          .joinErrors(result, false)
          if (result.node == null) {
            result = d.dvRuleReferenceExpression
            .joinErrors(result, false)
          }
        }
      }
    }
    return result as Result<? extends Expression>
  }
  //--------------------------------------------------------------------------
  
  def AssignmentOperator AssignmentOperator(String in) {
    this.chars = in.toCharArray()
    val result = assignmentOperator(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * AssignmentOperator : (single='=' | multi='+=') WS* ; 
   */
  package def Result<? extends AssignmentOperator> assignmentOperator(Derivation derivation) {
    var Result<?> result = null
    var node = new AssignmentOperator
    var d = derivation
    
    // (single='=' | multi='+=') 
    // single='=' | multi='+='
    val backup0 = node.copy()
    val backup1 = d
    
    // single='=' 
    val result0 =  d.__terminal('=', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    if (result.node != null) {
      node.single = result0.node
    }
    if (result.node == null) {
      node = backup0
      d = backup1
      val backup2 = node.copy()
      val backup3 = d
      
      // multi='+='
      val result1 =  d.__terminal('+=', this)
      d = result1.derivation
      result = result1.joinErrors(result, false)
      if (result.node != null) {
        node.multi = result1.node
      }
      if (result.node == null) {
        node = backup2
        d = backup3
      }
    }
    
    if (result.node != null) {
      // WS* 
      var backup4 = node.copy()
      var backup5 = d
      
      do {
        // WS
        val result2 = d.dvWS
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node != null) {
          backup4 = node.copy()
          backup5 = d
        }
      } while (result.node != null)
      node = backup4
      d = backup5
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<AssignmentOperator>(node, d, result.info)
    }
    return new Result<AssignmentOperator>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression SubExpression(String in) {
    this.chars = in.toCharArray()
    val result = subExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * SubExpression returns Expression : '(' WS* expr=ChoiceExpression ')' WS* ; 
   */
  package def Result<? extends Expression> subExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new SubExpression
    var d = derivation
    
    // '(' 
    val result0 =  d.__terminal('(', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    
    if (result.node != null) {
      // WS* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // expr=ChoiceExpression 
      val result2 = d.dvChoiceExpression
      d = result2.derivation
      result = result2.joinErrors(result, false)
      if (result.node != null) {
        node.expr = result2.node
      }
    }
    
    if (result.node != null) {
      // ')' 
      val result3 =  d.__terminal(')', this)
      d = result3.derivation
      result = result3.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // WS* 
      var backup2 = node.copy()
      var backup3 = d
      
      do {
        // WS
        val result4 = d.dvWS
        d = result4.derivation
        result = result4.joinErrors(result, false)
        if (result.node != null) {
          backup2 = node.copy()
          backup3 = d
        }
      } while (result.node != null)
      node = backup2
      d = backup3
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression RangeExpression(String in) {
    this.chars = in.toCharArray()
    val result = rangeExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * RangeExpression returns Expression : '[' dash='-'? (!']' ranges+=(MinMaxRange | CharRange))* ']' WS* ; 
   */
  package def Result<? extends Expression> rangeExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new RangeExpression
    var d = derivation
    
    // '[' 
    val result0 =  d.__terminal('[', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    
    if (result.node != null) {
      // dash='-'? 
      val backup0 = node.copy()
      val backup1 = d
      
      // dash='-'
      val result1 =  d.__terminal('-', this)
      d = result1.derivation
      result = result1.joinErrors(result, false)
      if (result.node != null) {
        node.dash = result1.node
      }
      if (result.node == null) {
        node = backup0
        d = backup1
        result = CONTINUE.joinErrors(result, false)
      }
    }
    
    if (result.node != null) {
      // (!']' ranges+=(MinMaxRange | CharRange))* 
      var backup2 = node.copy()
      var backup3 = d
      
      do {
        // (!']' ranges+=(MinMaxRange | CharRange))
        val backup4 = node.copy()
        val backup5 = d
        // ']' 
        val result2 =  d.__terminal(']', this)
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
          val result3 = d.rangeExpression_sub0()
          d = result3.derivation
          result = result3.joinErrors(result, false)
          if (result.node != null) {
            node.add(result3.node)
          }
        }
        if (result.node != null) {
          backup2 = node.copy()
          backup3 = d
        }
      } while (result.node != null)
      node = backup2
      d = backup3
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // ']' 
      val result4 =  d.__terminal(']', this)
      d = result4.derivation
      result = result4.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // WS* 
      var backup6 = node.copy()
      var backup7 = d
      
      do {
        // WS
        val result5 = d.dvWS
        d = result5.derivation
        result = result5.joinErrors(result, false)
        if (result.node != null) {
          backup6 = node.copy()
          backup7 = d
        }
      } while (result.node != null)
      node = backup6
      d = backup7
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  private def Result<? extends Node> rangeExpression_sub0(Derivation derivation) {
    var Result<?> result = null
    val d = derivation
    // MinMaxRange | CharRange
    result = d.dvMinMaxRange
    .joinErrors(result, false)
    if (result.node == null) {
      result = d.dvCharRange
      .joinErrors(result, false)
    }
    return result as Result<? extends Node>
  }
  //--------------------------------------------------------------------------
  
  def MinMaxRange MinMaxRange(String in) {
    this.chars = in.toCharArray()
    val result = minMaxRange(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * MinMaxRange: !'-' min=. '-' !'-' max=. ; 
   */
  package def Result<? extends MinMaxRange> minMaxRange(Derivation derivation) {
    var Result<?> result = null
    var node = new MinMaxRange
    var d = derivation
    
    val backup0 = node.copy()
    val backup1 = d
    // '-' 
    val result0 =  d.__terminal('-', this)
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
      val result1 =  d.__any(this)
      d = result1.derivation
      result = result1.joinErrors(result, false)
      if (result.node != null) {
        node.min = result1.node
      }
    }
    
    if (result.node != null) {
      // '-' 
      val result2 =  d.__terminal('-', this)
      d = result2.derivation
      result = result2.joinErrors(result, false)
    }
    
    if (result.node != null) {
      val backup2 = node.copy()
      val backup3 = d
      // '-' 
      val result3 =  d.__terminal('-', this)
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
      // max=. 
      // .
      val result4 =  d.__any(this)
      d = result4.derivation
      result = result4.joinErrors(result, false)
      if (result.node != null) {
        node.max = result4.node
      }
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<MinMaxRange>(node, d, result.info)
    }
    return new Result<MinMaxRange>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def CharRange CharRange(String in) {
    this.chars = in.toCharArray()
    val result = charRange(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * CharRange: char='\\]' | char='\\\\' | !'-' char=. ; 
   */
  package def Result<? extends CharRange> charRange(Derivation derivation) {
    var Result<?> result = null
    var node = new CharRange
    var d = derivation
    
    // char='\\]' | char='\\\\' | !'-' char=. 
    val backup0 = node.copy()
    val backup1 = d
    
    // char='\\]' 
    val result0 =  d.__terminal('\\]', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    if (result.node != null) {
      node._char = result0.node
    }
    if (result.node == null) {
      node = backup0
      d = backup1
      val backup2 = node.copy()
      val backup3 = d
      
      // char='\\\\' 
      val result1 =  d.__terminal('\\\\', this)
      d = result1.derivation
      result = result1.joinErrors(result, false)
      if (result.node != null) {
        node._char = result1.node
      }
      if (result.node == null) {
        node = backup2
        d = backup3
        val backup4 = node.copy()
        val backup5 = d
        
        val backup6 = node.copy()
        val backup7 = d
        // '-' 
        val result2 =  d.__terminal('-', this)
        d = result2.derivation
        result = result2.joinErrors(result, true)
        node = backup6
        d = backup7
        if (result.node != null) {
          result = BREAK.joinErrors(result, true)
        } else {
          result = CONTINUE.joinErrors(result, true)
        }
        
        if (result.node != null) {
          // char=. 
          // .
          val result3 =  d.__any(this)
          d = result3.derivation
          result = result3.joinErrors(result, false)
          if (result.node != null) {
            node._char = result3.node
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
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<CharRange>(node, d, result.info)
    }
    return new Result<CharRange>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression AnyCharExpression(String in) {
    this.chars = in.toCharArray()
    val result = anyCharExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * AnyCharExpression returns Expression : char='.' ; 
   */
  package def Result<? extends Expression> anyCharExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new AnyCharExpression
    var d = derivation
    
    // char='.' 
    val result0 =  d.__terminal('.', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    if (result.node != null) {
      node._char = result0.node
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression RuleReferenceExpression(String in) {
    this.chars = in.toCharArray()
    val result = ruleReferenceExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * RuleReferenceExpression returns Expression : name=ID WS* ; 
   */
  package def Result<? extends Expression> ruleReferenceExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new RuleReferenceExpression
    var d = derivation
    
    // name=ID 
    val result0 = d.dvID
    d = result0.derivation
    result = result0.joinErrors(result, false)
    if (result.node != null) {
      node.name = result0.node
    }
    
    if (result.node != null) {
      // WS* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression TerminalExpression(String in) {
    this.chars = in.toCharArray()
    val result = terminalExpression(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * TerminalExpression returns Expression : '\'' value=InTerminalChar? '\'' WS* ; 
   */
  package def Result<? extends Expression> terminalExpression(Derivation derivation) {
    var Result<?> result = null
    var node = new TerminalExpression
    var d = derivation
    
    // '\'' 
    val result0 =  d.__terminal('\'', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    
    if (result.node != null) {
      // value=InTerminalChar? 
      val backup0 = node.copy()
      val backup1 = d
      
      // value=InTerminalChar
      val result1 = d.dvInTerminalChar
      d = result1.derivation
      result = result1.joinErrors(result, false)
      if (result.node != null) {
        node.value = result1.node
      }
      if (result.node == null) {
        node = backup0
        d = backup1
        result = CONTINUE.joinErrors(result, false)
      }
    }
    
    if (result.node != null) {
      // '\'' 
      val result2 =  d.__terminal('\'', this)
      d = result2.derivation
      result = result2.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // WS* 
      var backup2 = node.copy()
      var backup3 = d
      
      do {
        // WS
        val result3 = d.dvWS
        d = result3.derivation
        result = result3.joinErrors(result, false)
        if (result.node != null) {
          backup2 = node.copy()
          backup3 = d
        }
      } while (result.node != null)
      node = backup2
      d = backup3
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Expression>(node, d, result.info)
    }
    return new Result<Expression>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def InTerminalChar InTerminalChar(String in) {
    this.chars = in.toCharArray()
    val result = inTerminalChar(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * InTerminalChar: ('\\' '\'' | '\\' '\\' | !'\'' .)+ ; 
   */
  package def Result<? extends InTerminalChar> inTerminalChar(Derivation derivation) {
    var Result<?> result = null
    var node = new InTerminalChar
    var d = derivation
    
    // ('\\' '\'' | '\\' '\\' | !'\'' .)+ 
    var backup0 = node.copy()
    var backup1 = d
    var loop0 = false
    
    do {
      // ('\\' '\'' | '\\' '\\' | !'\'' .)
      // '\\' '\'' | '\\' '\\' | !'\'' .
      val backup2 = node.copy()
      val backup3 = d
      
      // '\\' 
      val result0 =  d.__terminal('\\', this)
      d = result0.derivation
      result = result0.joinErrors(result, false)
      
      if (result.node != null) {
        // '\'' 
        val result1 =  d.__terminal('\'', this)
        d = result1.derivation
        result = result1.joinErrors(result, false)
      }
      if (result.node == null) {
        node = backup2
        d = backup3
        val backup4 = node.copy()
        val backup5 = d
        
        // '\\' 
        val result2 =  d.__terminal('\\', this)
        d = result2.derivation
        result = result2.joinErrors(result, false)
        
        if (result.node != null) {
          // '\\' 
          val result3 =  d.__terminal('\\', this)
          d = result3.derivation
          result = result3.joinErrors(result, false)
        }
        if (result.node == null) {
          node = backup4
          d = backup5
          val backup6 = node.copy()
          val backup7 = d
          
          val backup8 = node.copy()
          val backup9 = d
          // '\'' 
          val result4 =  d.__terminal('\'', this)
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
            val result5 =  d.__any(this)
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
        backup0 = node.copy()
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
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<InTerminalChar>(node, d, result.info)
    }
    return new Result<InTerminalChar>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def Comment Comment(String in) {
    this.chars = in.toCharArray()
    val result = comment(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * Comment : '//' (!('\r'? '\n') .)* WS* ; 
   */
  package def Result<? extends Comment> comment(Derivation derivation) {
    var Result<?> result = null
    var node = new Comment
    var d = derivation
    
    // '//' 
    val result0 =  d.__terminal('//', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    
    if (result.node != null) {
      // (!('\r'? '\n') .)* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // (!('\r'? '\n') .)
        val backup2 = node.copy()
        val backup3 = d
        // ('\r'? '\n') 
        // '\r'? 
        val backup4 = node.copy()
        val backup5 = d
        
        // '\r'
        val result1 =  d.__terminal('\r', this)
        d = result1.derivation
        result = result1.joinErrors(result, true)
        if (result.node == null) {
          node = backup4
          d = backup5
          result = CONTINUE.joinErrors(result, true)
        }
        
        if (result.node != null) {
          // '\n'
          val result2 =  d.__terminal('\n', this)
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
          val result3 =  d.__any(this)
          d = result3.derivation
          result = result3.joinErrors(result, false)
        }
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      // WS* 
      var backup6 = node.copy()
      var backup7 = d
      
      do {
        // WS
        val result4 = d.dvWS
        d = result4.derivation
        result = result4.joinErrors(result, false)
        if (result.node != null) {
          backup6 = node.copy()
          backup7 = d
        }
      } while (result.node != null)
      node = backup6
      d = backup7
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<Comment>(node, d, result.info)
    }
    return new Result<Comment>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def EOI EOI(String in) {
    this.chars = in.toCharArray()
    val result = eOI(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * EOI: !(.) ; 
   */
  package def Result<? extends EOI> eOI(Derivation derivation) {
    var Result<?> result = null
    var node = new EOI
    var d = derivation
    
    val backup0 = node.copy()
    val backup1 = d
    // (.) 
    // .
    // .
    val result0 =  d.__any(this)
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
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<EOI>(node, d, result.info)
    }
    return new Result<EOI>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def ID ID(String in) {
    this.chars = in.toCharArray()
    val result = iD(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * ID: [a-zA-Z_] [a-zA-Z0-9_]* ; 
   */
  package def Result<? extends ID> iD(Derivation derivation) {
    var Result<?> result = null
    var node = new ID
    var d = derivation
    
    // [a-zA-Z_] 
    // [a-zA-Z_] 
    val result0 = d.__oneOfThese(
      ('a'..'z') + 
      ('A'..'Z') + 
      '_'
      , this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    
    if (result.node != null) {
      // [a-zA-Z0-9_]* 
      var backup0 = node.copy()
      var backup1 = d
      
      do {
        // [a-zA-Z0-9_]
        // [a-zA-Z0-9_]
        val result1 = d.__oneOfThese(
          ('a'..'z') + 
          ('A'..'Z') + 
          ('0'..'9') + 
          '_'
          , this)
        d = result1.derivation
        result = result1.joinErrors(result, false)
        if (result.node != null) {
          backup0 = node.copy()
          backup1 = d
        }
      } while (result.node != null)
      node = backup0
      d = backup1
      result = CONTINUE.joinErrors(result, false)
    }
    
    if (result.node != null) {
      node.index = derivation.index
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<ID>(node, d, result.info)
    }
    return new Result<ID>(null, derivation, result.info)
  }
  
  //--------------------------------------------------------------------------
  
  def WS WS(String in) {
    this.chars = in.toCharArray()
    val result = wS(parse(0))
    return
      if (result.derivation.dvChar.node == null) result.node
      else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
  }
  
  /**
   * WS : ' ' | '\n' | '\t' | '\r' ; 
   */
  package def Result<? extends WS> wS(Derivation derivation) {
    var Result<?> result = null
    var node = new WS
    var d = derivation
    
    // ' ' | '\n' | '\t' | '\r' 
    val backup0 = node.copy()
    val backup1 = d
    
    // ' ' 
    val result0 =  d.__terminal(' ', this)
    d = result0.derivation
    result = result0.joinErrors(result, false)
    if (result.node == null) {
      node = backup0
      d = backup1
      val backup2 = node.copy()
      val backup3 = d
      
      // '\n' 
      val result1 =  d.__terminal('\n', this)
      d = result1.derivation
      result = result1.joinErrors(result, false)
      if (result.node == null) {
        node = backup2
        d = backup3
        val backup4 = node.copy()
        val backup5 = d
        
        // '\t' 
        val result2 =  d.__terminal('\t', this)
        d = result2.derivation
        result = result2.joinErrors(result, false)
        if (result.node == null) {
          node = backup4
          d = backup5
          val backup6 = node.copy()
          val backup7 = d
          
          // '\r' 
          val result3 =  d.__terminal('\r', this)
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
      node.parsed = new String(chars, derivation.index, d.index - derivation.index);
      return new Result<WS>(node, d, result.info)
    }
    return new Result<WS>(null, derivation, result.info)
  }
  
  
}

package class Derivation {
  
  int idx
  
  val (Derivation)=>Result<? extends Jpeg> dvfJpeg
  val (Derivation)=>Result<? extends Rule> dvfRule
  val (Derivation)=>Result<? extends RuleReturns> dvfRuleReturns
  val (Derivation)=>Result<? extends Body> dvfBody
  val (Derivation)=>Result<? extends Expression> dvfChoiceExpression
  val (Derivation)=>Result<? extends Expression> dvfSequenceExpression
  val (Derivation)=>Result<? extends Expression> dvfActionExpression
  val (Derivation)=>Result<? extends Expression> dvfAndPredicateExpression
  val (Derivation)=>Result<? extends Expression> dvfNotPredicateExpression
  val (Derivation)=>Result<? extends Expression> dvfOneOrMoreExpression
  val (Derivation)=>Result<? extends Expression> dvfZeroOrMoreExpression
  val (Derivation)=>Result<? extends Expression> dvfOptionalExpression
  val (Derivation)=>Result<? extends Expression> dvfAssignableExpression
  val (Derivation)=>Result<? extends AssignmentOperator> dvfAssignmentOperator
  val (Derivation)=>Result<? extends Expression> dvfSubExpression
  val (Derivation)=>Result<? extends Expression> dvfRangeExpression
  val (Derivation)=>Result<? extends MinMaxRange> dvfMinMaxRange
  val (Derivation)=>Result<? extends CharRange> dvfCharRange
  val (Derivation)=>Result<? extends Expression> dvfAnyCharExpression
  val (Derivation)=>Result<? extends Expression> dvfRuleReferenceExpression
  val (Derivation)=>Result<? extends Expression> dvfTerminalExpression
  val (Derivation)=>Result<? extends InTerminalChar> dvfInTerminalChar
  val (Derivation)=>Result<? extends Comment> dvfComment
  val (Derivation)=>Result<? extends EOI> dvfEOI
  val (Derivation)=>Result<? extends ID> dvfID
  val (Derivation)=>Result<? extends WS> dvfWS
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
  Result<Character> dvChar
  
  new(int idx, (Derivation)=>Result<? extends Jpeg> dvfJpeg, (Derivation)=>Result<? extends Rule> dvfRule, (Derivation)=>Result<? extends RuleReturns> dvfRuleReturns, (Derivation)=>Result<? extends Body> dvfBody, (Derivation)=>Result<? extends Expression> dvfChoiceExpression, (Derivation)=>Result<? extends Expression> dvfSequenceExpression, (Derivation)=>Result<? extends Expression> dvfActionExpression, (Derivation)=>Result<? extends Expression> dvfAndPredicateExpression, (Derivation)=>Result<? extends Expression> dvfNotPredicateExpression, (Derivation)=>Result<? extends Expression> dvfOneOrMoreExpression, (Derivation)=>Result<? extends Expression> dvfZeroOrMoreExpression, (Derivation)=>Result<? extends Expression> dvfOptionalExpression, (Derivation)=>Result<? extends Expression> dvfAssignableExpression, (Derivation)=>Result<? extends AssignmentOperator> dvfAssignmentOperator, (Derivation)=>Result<? extends Expression> dvfSubExpression, (Derivation)=>Result<? extends Expression> dvfRangeExpression, (Derivation)=>Result<? extends MinMaxRange> dvfMinMaxRange, (Derivation)=>Result<? extends CharRange> dvfCharRange, (Derivation)=>Result<? extends Expression> dvfAnyCharExpression, (Derivation)=>Result<? extends Expression> dvfRuleReferenceExpression, (Derivation)=>Result<? extends Expression> dvfTerminalExpression, (Derivation)=>Result<? extends InTerminalChar> dvfInTerminalChar, (Derivation)=>Result<? extends Comment> dvfComment, (Derivation)=>Result<? extends EOI> dvfEOI, (Derivation)=>Result<? extends ID> dvfID, (Derivation)=>Result<? extends WS> dvfWS, (Derivation)=>Result<Character> dvfChar) {
    this.idx = idx
    this.dvfJpeg = dvfJpeg
    this.dvfRule = dvfRule
    this.dvfRuleReturns = dvfRuleReturns
    this.dvfBody = dvfBody
    this.dvfChoiceExpression = dvfChoiceExpression
    this.dvfSequenceExpression = dvfSequenceExpression
    this.dvfActionExpression = dvfActionExpression
    this.dvfAndPredicateExpression = dvfAndPredicateExpression
    this.dvfNotPredicateExpression = dvfNotPredicateExpression
    this.dvfOneOrMoreExpression = dvfOneOrMoreExpression
    this.dvfZeroOrMoreExpression = dvfZeroOrMoreExpression
    this.dvfOptionalExpression = dvfOptionalExpression
    this.dvfAssignableExpression = dvfAssignableExpression
    this.dvfAssignmentOperator = dvfAssignmentOperator
    this.dvfSubExpression = dvfSubExpression
    this.dvfRangeExpression = dvfRangeExpression
    this.dvfMinMaxRange = dvfMinMaxRange
    this.dvfCharRange = dvfCharRange
    this.dvfAnyCharExpression = dvfAnyCharExpression
    this.dvfRuleReferenceExpression = dvfRuleReferenceExpression
    this.dvfTerminalExpression = dvfTerminalExpression
    this.dvfInTerminalChar = dvfInTerminalChar
    this.dvfComment = dvfComment
    this.dvfEOI = dvfEOI
    this.dvfID = dvfID
    this.dvfWS = dvfWS
    this.dvfChar = dvfChar
  }
  
  def getIndex() {
    idx
  }
  
  def getDvJpeg() {
    if (dvJpeg == null) {
      dvJpeg = dvfJpeg.apply(this)
    }
    return dvJpeg
  }
  
  def getDvRule() {
    if (dvRule == null) {
      dvRule = dvfRule.apply(this)
    }
    return dvRule
  }
  
  def getDvRuleReturns() {
    if (dvRuleReturns == null) {
      dvRuleReturns = dvfRuleReturns.apply(this)
    }
    return dvRuleReturns
  }
  
  def getDvBody() {
    if (dvBody == null) {
      dvBody = dvfBody.apply(this)
    }
    return dvBody
  }
  
  def getDvChoiceExpression() {
    if (dvChoiceExpression == null) {
      dvChoiceExpression = dvfChoiceExpression.apply(this)
    }
    return dvChoiceExpression
  }
  
  def getDvSequenceExpression() {
    if (dvSequenceExpression == null) {
      dvSequenceExpression = dvfSequenceExpression.apply(this)
    }
    return dvSequenceExpression
  }
  
  def getDvActionExpression() {
    if (dvActionExpression == null) {
      dvActionExpression = dvfActionExpression.apply(this)
    }
    return dvActionExpression
  }
  
  def getDvAndPredicateExpression() {
    if (dvAndPredicateExpression == null) {
      dvAndPredicateExpression = dvfAndPredicateExpression.apply(this)
    }
    return dvAndPredicateExpression
  }
  
  def getDvNotPredicateExpression() {
    if (dvNotPredicateExpression == null) {
      dvNotPredicateExpression = dvfNotPredicateExpression.apply(this)
    }
    return dvNotPredicateExpression
  }
  
  def getDvOneOrMoreExpression() {
    if (dvOneOrMoreExpression == null) {
      dvOneOrMoreExpression = dvfOneOrMoreExpression.apply(this)
    }
    return dvOneOrMoreExpression
  }
  
  def getDvZeroOrMoreExpression() {
    if (dvZeroOrMoreExpression == null) {
      dvZeroOrMoreExpression = dvfZeroOrMoreExpression.apply(this)
    }
    return dvZeroOrMoreExpression
  }
  
  def getDvOptionalExpression() {
    if (dvOptionalExpression == null) {
      dvOptionalExpression = dvfOptionalExpression.apply(this)
    }
    return dvOptionalExpression
  }
  
  def getDvAssignableExpression() {
    if (dvAssignableExpression == null) {
      dvAssignableExpression = dvfAssignableExpression.apply(this)
    }
    return dvAssignableExpression
  }
  
  def getDvAssignmentOperator() {
    if (dvAssignmentOperator == null) {
      dvAssignmentOperator = dvfAssignmentOperator.apply(this)
    }
    return dvAssignmentOperator
  }
  
  def getDvSubExpression() {
    if (dvSubExpression == null) {
      dvSubExpression = dvfSubExpression.apply(this)
    }
    return dvSubExpression
  }
  
  def getDvRangeExpression() {
    if (dvRangeExpression == null) {
      dvRangeExpression = dvfRangeExpression.apply(this)
    }
    return dvRangeExpression
  }
  
  def getDvMinMaxRange() {
    if (dvMinMaxRange == null) {
      dvMinMaxRange = dvfMinMaxRange.apply(this)
    }
    return dvMinMaxRange
  }
  
  def getDvCharRange() {
    if (dvCharRange == null) {
      dvCharRange = dvfCharRange.apply(this)
    }
    return dvCharRange
  }
  
  def getDvAnyCharExpression() {
    if (dvAnyCharExpression == null) {
      dvAnyCharExpression = dvfAnyCharExpression.apply(this)
    }
    return dvAnyCharExpression
  }
  
  def getDvRuleReferenceExpression() {
    if (dvRuleReferenceExpression == null) {
      dvRuleReferenceExpression = dvfRuleReferenceExpression.apply(this)
    }
    return dvRuleReferenceExpression
  }
  
  def getDvTerminalExpression() {
    if (dvTerminalExpression == null) {
      dvTerminalExpression = dvfTerminalExpression.apply(this)
    }
    return dvTerminalExpression
  }
  
  def getDvInTerminalChar() {
    if (dvInTerminalChar == null) {
      dvInTerminalChar = dvfInTerminalChar.apply(this)
    }
    return dvInTerminalChar
  }
  
  def getDvComment() {
    if (dvComment == null) {
      dvComment = dvfComment.apply(this)
    }
    return dvComment
  }
  
  def getDvEOI() {
    if (dvEOI == null) {
      dvEOI = dvfEOI.apply(this)
    }
    return dvEOI
  }
  
  def getDvID() {
    if (dvID == null) {
      dvID = dvfID.apply(this)
    }
    return dvID
  }
  
  def getDvWS() {
    if (dvWS == null) {
      dvWS = dvfWS.apply(this)
    }
    return dvWS
  }
  
  
  def getDvChar() {
    if (dvChar == null) {
      dvChar = dvfChar.apply(this)
    }
    return dvChar
  }

}

class ParseException extends RuntimeException {
  
  new(String message) {
    super(message)
  }
  
  new(Pair<Integer, Integer> location, String... message) {
    super("[" + location.key + "," + location.value + "] Expected " + message.join(' or ').replaceAll('\n', '\\\\n').replaceAll('\r', '\\\\r'))
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

package class Node {
  
  @Property
  int index
  
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

class OptionalExpression extends Expression {
  
  @Property
  Expression expr
  
  override OptionalExpression copy() {
    val r = new OptionalExpression
    r._expr = _expr
    return r
  }
  
}

class ActionExpression extends Expression {
  
  @Property
  ID property
  
  @Property
  AssignmentOperator op
  
  @Property
  ID name
  
  override ActionExpression copy() {
    val r = new ActionExpression
    r._property = _property
    r._op = _op
    r._name = _name
    return r
  }
  
}

class SequenceExpression extends Expression {
  
  @Property
  java.util.List<Expression> expressions
  
  def dispatch void add(Expression __expression) {
    _expressions = _expressions ?: newArrayList
    _expressions += __expression
  }
  
  override SequenceExpression copy() {
    val r = new SequenceExpression
    r._expressions = _expressions
    return r
  }
  
}

class AssignableExpression extends Expression {
  
  @Property
  ID property
  
  @Property
  AssignmentOperator op
  
  @Property
  Expression expr
  
  override AssignableExpression copy() {
    val r = new AssignableExpression
    r._property = _property
    r._op = _op
    r._expr = _expr
    return r
  }
  
}

class RangeExpression extends Expression {
  
  @Property
  Terminal dash
  
  @Property
  java.util.List<Node> ranges
  
  def dispatch void add(Node __node) {
    _ranges = _ranges ?: newArrayList
    _ranges += __node
  }
  
  override RangeExpression copy() {
    val r = new RangeExpression
    r._dash = _dash
    r._ranges = _ranges
    return r
  }
  
}

class AnyCharExpression extends Expression {
  
  @Property
  Terminal _char
  
  override AnyCharExpression copy() {
    val r = new AnyCharExpression
    r.__char = __char
    return r
  }
  
}

class ID extends Node {
  
  override ID copy() {
    val r = new ID
    return r
  }
  
}

class EOI extends Node {
  
  override EOI copy() {
    val r = new EOI
    return r
  }
  
}

class Expression extends Node {
  
  
}

class TerminalExpression extends Expression {
  
  @Property
  InTerminalChar value
  
  override TerminalExpression copy() {
    val r = new TerminalExpression
    r._value = _value
    return r
  }
  
}

class AndPredicateExpression extends Expression {
  
  @Property
  Expression expr
  
  override AndPredicateExpression copy() {
    val r = new AndPredicateExpression
    r._expr = _expr
    return r
  }
  
}

class ZeroOrMoreExpression extends Expression {
  
  @Property
  Expression expr
  
  override ZeroOrMoreExpression copy() {
    val r = new ZeroOrMoreExpression
    r._expr = _expr
    return r
  }
  
}

class Body extends Node {
  
  @Property
  java.util.List<Expression> expressions
  
  def dispatch void add(Expression __expression) {
    _expressions = _expressions ?: newArrayList
    _expressions += __expression
  }
  
  override Body copy() {
    val r = new Body
    r._expressions = _expressions
    return r
  }
  
}

class AssignmentOperator extends Node {
  
  @Property
  Terminal single
  
  @Property
  Terminal multi
  
  override AssignmentOperator copy() {
    val r = new AssignmentOperator
    r._single = _single
    r._multi = _multi
    return r
  }
  
}

class WS extends Node {
  
  override WS copy() {
    val r = new WS
    return r
  }
  
}

class CharRange extends Node {
  
  @Property
  Terminal _char
  
  override CharRange copy() {
    val r = new CharRange
    r.__char = __char
    return r
  }
  
}

class Comment extends Node {
  
  override Comment copy() {
    val r = new Comment
    return r
  }
  
}

class SubExpression extends Expression {
  
  @Property
  Expression expr
  
  override SubExpression copy() {
    val r = new SubExpression
    r._expr = _expr
    return r
  }
  
}

class Rule extends Node {
  
  @Property
  ID name
  
  @Property
  RuleReturns returns
  
  @Property
  Body body
  
  override Rule copy() {
    val r = new Rule
    r._name = _name
    r._returns = _returns
    r._body = _body
    return r
  }
  
}

class RuleReturns extends Node {
  
  @Property
  ID name
  
  override RuleReturns copy() {
    val r = new RuleReturns
    r._name = _name
    return r
  }
  
}

class MinMaxRange extends Node {
  
  @Property
  Terminal min
  
  @Property
  Terminal max
  
  override MinMaxRange copy() {
    val r = new MinMaxRange
    r._min = _min
    r._max = _max
    return r
  }
  
}

class NotPredicateExpression extends Expression {
  
  @Property
  Expression expr
  
  override NotPredicateExpression copy() {
    val r = new NotPredicateExpression
    r._expr = _expr
    return r
  }
  
}

class RuleReferenceExpression extends Expression {
  
  @Property
  ID name
  
  override RuleReferenceExpression copy() {
    val r = new RuleReferenceExpression
    r._name = _name
    return r
  }
  
}

class Jpeg extends Node {
  
  @Property
  java.util.List<Rule> rules
  
  def dispatch void add(Rule __rule) {
    _rules = _rules ?: newArrayList
    _rules += __rule
  }
  
  override Jpeg copy() {
    val r = new Jpeg
    r._rules = _rules
    return r
  }
  
}

class OneOrMoreExpression extends Expression {
  
  @Property
  Expression expr
  
  override OneOrMoreExpression copy() {
    val r = new OneOrMoreExpression
    r._expr = _expr
    return r
  }
  
}

class InTerminalChar extends Node {
  
  override InTerminalChar copy() {
    val r = new InTerminalChar
    return r
  }
  
}

class ChoiceExpression extends Expression {
  
  @Property
  java.util.List<Expression> choices
  
  def dispatch void add(Expression __expression) {
    _choices = _choices ?: newArrayList
    _choices += __expression
  }
  
  override ChoiceExpression copy() {
    val r = new ChoiceExpression
    r._choices = _choices
    return r
  }
  
}

