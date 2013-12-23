package jpeg

import java.util.List

import static extension jpeg.CharacterConsumer.*
import static extension jpeg.CharacterRange.*

class Parser {
  
  char[] chars
  
  package def Derivation parse(int idx) {
    new Derivation(idx, [jpeg()],[rule()],[ruleReturns()],[body()],[choiceExpression()],[sequenceExpression()],[actionExpression()],[andPredicateExpression()],[notPredicateExpression()],[oneOrMoreExpression()],[zeroOrMoreExpression()],[optionalExpression()],[assignableExpression()],[assignmentOperator()],[subExpression()],[rangeExpression()],[minMaxRange()],[charRange()],[anyCharExpression()],[ruleReferenceExpression()],[terminalExpression()],[inTerminalChar()],[comment()],[eOI()],[iD()],[wS()],
      [
        if (chars.length == idx) {
          throw new ParseException('Unexpected end of input')
        }
        new Result<Character>(chars.get(idx), parse(idx + 1))
      ])
  }
  
  //--------------------------------------------------------------------------
  
  def Jpeg Jpeg(String in) {
    this.chars = in.toCharArray()
    val result = jpeg(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * Jpeg : (rules+=Rule | Comment WS*)+ EOI ; 
   */
  package def Result<? extends Jpeg> jpeg(Derivation derivation) {
    var node = new Jpeg
    var d = derivation
    
    // (rules+=Rule | Comment WS*)+
    var backup0 = node.copy()
    var backup1 = d
    var loop0 = false
    try {
      while (true) {
        // (rules+=Rule | Comment WS*)
        // rules+=Rule | Comment WS*
        val backup2 = node.copy()
        val backup3 = d
        try {
          // rules+=Rule
          val result0 = d.dvRule
          d = result0.derivation
          node.add(result0.node)
        } catch (ParseException e0) {
          node = backup2
          d = backup3
          val backup4 = node.copy()
          val backup5 = d
          try {
            // Comment
            val result1 = d.dvComment
            d = result1.derivation
            
            // WS*
            var backup6 = node.copy()
            var backup7 = d
            try {
              while (true) {
                // WS
                val result2 = d.dvWS
                d = result2.derivation
                backup6 = node.copy()
                backup7 = d
              }
            } catch (ParseException e1) {
              node = backup6
              d = backup7
            }
          } catch (ParseException e2) {
            node = backup4
            d = backup5
            throw e2
          }
        }
        
        loop0 = true
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e3) {
      if (!loop0) {
        node = backup0
        d = backup1
        throw e3
      }
    }
    
    // EOI
    val result3 = d.dvEOI
    d = result3.derivation
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Jpeg>(node, d)
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
   * Rule : name=ID WS* returns=RuleReturns? WS* ':' WS* body=Body WS* ';' WS* ; 
   */
  package def Result<? extends Rule> rule(Derivation derivation) {
    var node = new Rule
    var d = derivation
    
    // name=ID
    val result0 = d.dvID
    d = result0.derivation
    node.name = result0.node
    
    // WS*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    // returns=RuleReturns?
    val backup2 = node.copy()
    val backup3 = d
    try {
      // returns=RuleReturns
      val result2 = d.dvRuleReturns
      d = result2.derivation
      node.returns = result2.node
    } catch (ParseException e1) {
      node = backup2
      d = backup3
    }
    
    // WS*
    var backup4 = node.copy()
    var backup5 = d
    try {
      while (true) {
        // WS
        val result3 = d.dvWS
        d = result3.derivation
        backup4 = node.copy()
        backup5 = d
      }
    } catch (ParseException e2) {
      node = backup4
      d = backup5
    }
    
    // ':'
    // ':'
    val result4 =  d.terminal(':', this)
    d = result4.derivation
    
    // WS*
    var backup6 = node.copy()
    var backup7 = d
    try {
      while (true) {
        // WS
        val result5 = d.dvWS
        d = result5.derivation
        backup6 = node.copy()
        backup7 = d
      }
    } catch (ParseException e3) {
      node = backup6
      d = backup7
    }
    
    // body=Body
    val result6 = d.dvBody
    d = result6.derivation
    node.body = result6.node
    
    // WS*
    var backup8 = node.copy()
    var backup9 = d
    try {
      while (true) {
        // WS
        val result7 = d.dvWS
        d = result7.derivation
        backup8 = node.copy()
        backup9 = d
      }
    } catch (ParseException e4) {
      node = backup8
      d = backup9
    }
    
    // ';'
    // ';'
    val result8 =  d.terminal(';', this)
    d = result8.derivation
    
    // WS*
    var backup10 = node.copy()
    var backup11 = d
    try {
      while (true) {
        // WS
        val result9 = d.dvWS
        d = result9.derivation
        backup10 = node.copy()
        backup11 = d
      }
    } catch (ParseException e5) {
      node = backup10
      d = backup11
    }
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Rule>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def RuleReturns RuleReturns(String in) {
    this.chars = in.toCharArray()
    val result = ruleReturns(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * RuleReturns : 'returns' WS* name=ID ; 
   */
  package def Result<? extends RuleReturns> ruleReturns(Derivation derivation) {
    var node = new RuleReturns
    var d = derivation
    
    // 'returns'
    // 'returns'
    val result0 =  d.terminal('returns', this)
    d = result0.derivation
    
    // WS*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    // name=ID
    val result2 = d.dvID
    d = result2.derivation
    node.name = result2.node
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<RuleReturns>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Body Body(String in) {
    this.chars = in.toCharArray()
    val result = body(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * Body : (expressions+=ChoiceExpression WS*)+ ; 
   */
  package def Result<? extends Body> body(Derivation derivation) {
    var node = new Body
    var d = derivation
    
    // (expressions+=ChoiceExpression WS*)+
    var backup0 = node.copy()
    var backup1 = d
    var loop0 = false
    try {
      while (true) {
        // (expressions+=ChoiceExpression WS*)
        // expressions+=ChoiceExpression
        val result0 = d.dvChoiceExpression
        d = result0.derivation
        node.add(result0.node)
        
        // WS*
        var backup2 = node.copy()
        var backup3 = d
        try {
          while (true) {
            // WS
            val result1 = d.dvWS
            d = result1.derivation
            backup2 = node.copy()
            backup3 = d
          }
        } catch (ParseException e0) {
          node = backup2
          d = backup3
        }
        
        loop0 = true
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e1) {
      if (!loop0) {
        node = backup0
        d = backup1
        throw e1
      }
    }
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Body>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression ChoiceExpression(String in) {
    this.chars = in.toCharArray()
    val result = choiceExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ChoiceExpression returns Expression : choices+=SequenceExpression ('|' WS* choices+=SequenceExpression)* ; 
   */
  package def Result<? extends Expression> choiceExpression(Derivation derivation) {
    var node = new ChoiceExpression
    var d = derivation
    
    // choices+=SequenceExpression
    val result0 = d.dvSequenceExpression
    d = result0.derivation
    node.add(result0.node)
    
    // ('|' WS* choices+=SequenceExpression)*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // ('|' WS* choices+=SequenceExpression)
        // '|'
        // '|'
        val result1 =  d.terminal('|', this)
        d = result1.derivation
        
        // WS*
        var backup2 = node.copy()
        var backup3 = d
        try {
          while (true) {
            // WS
            val result2 = d.dvWS
            d = result2.derivation
            backup2 = node.copy()
            backup3 = d
          }
        } catch (ParseException e0) {
          node = backup2
          d = backup3
        }
        
        // choices+=SequenceExpression
        val result3 = d.dvSequenceExpression
        d = result3.derivation
        node.add(result3.node)
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e1) {
      node = backup0
      d = backup1
    }
    
    if (node.choices.size() == 1) {
      return new Result<Expression>(node.choices.get(0), d)
    }
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression SequenceExpression(String in) {
    this.chars = in.toCharArray()
    val result = sequenceExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * SequenceExpression returns Expression : ( expressions+= ( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression ) WS* )+ ; 
   */
  package def Result<? extends Expression> sequenceExpression(Derivation derivation) {
    var node = new SequenceExpression
    var d = derivation
    
    // ( expressions+= ( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression ) WS* )+
    var backup0 = node.copy()
    var backup1 = d
    var loop0 = false
    try {
      while (true) {
        // ( expressions+= ( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression ) WS* )
        // expressions+= ( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression )
        val result0 = d.sequenceExpression_sub0()
        d = result0.derivation
        node.add(result0.node)
        
        // WS*
        var backup2 = node.copy()
        var backup3 = d
        try {
          while (true) {
            // WS
            val result1 = d.dvWS
            d = result1.derivation
            backup2 = node.copy()
            backup3 = d
          }
        } catch (ParseException e7) {
          node = backup2
          d = backup3
        }
        
        loop0 = true
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e8) {
      if (!loop0) {
        node = backup0
        d = backup1
        throw e8
      }
    }
    
    if (node.expressions.size() == 1) {
      return new Result<Expression>(node.expressions.get(0), d)
    }
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  private def Result<? extends Expression> sequenceExpression_sub0(Derivation derivation) {
    val d = derivation
    // ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AssignableExpression 
    try {
      return d.dvActionExpression
    } catch (ParseException e0) {
      try {
        return d.dvAndPredicateExpression
      } catch (ParseException e1) {
        try {
          return d.dvNotPredicateExpression
        } catch (ParseException e2) {
          try {
            return d.dvOneOrMoreExpression
          } catch (ParseException e3) {
            try {
              return d.dvZeroOrMoreExpression
            } catch (ParseException e4) {
              try {
                return d.dvOptionalExpression
              } catch (ParseException e5) {
                try {
                  return d.dvAssignableExpression
                } catch (ParseException e6) {
                  throw e6
                }
              }
            }
          }
        }
      }
    }
  }
  //--------------------------------------------------------------------------
  
  def Expression ActionExpression(String in) {
    this.chars = in.toCharArray()
    val result = actionExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ActionExpression returns Expression : '{' WS* ( property=ID WS* op=AssignmentOperator WS* 'current' WS* | name=ID ) WS* '}' ; 
   */
  package def Result<? extends Expression> actionExpression(Derivation derivation) {
    var node = new ActionExpression
    var d = derivation
    
    // '{'
    // '{'
    val result0 =  d.terminal('{', this)
    d = result0.derivation
    
    // WS*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    // ( property=ID WS* op=AssignmentOperator WS* 'current' WS* | name=ID )
    // property=ID WS* op=AssignmentOperator WS* 'current' WS* | name=ID 
    val backup2 = node.copy()
    val backup3 = d
    try {
      // property=ID
      val result2 = d.dvID
      d = result2.derivation
      node.property = result2.node
      
      // WS*
      var backup4 = node.copy()
      var backup5 = d
      try {
        while (true) {
          // WS
          val result3 = d.dvWS
          d = result3.derivation
          backup4 = node.copy()
          backup5 = d
        }
      } catch (ParseException e1) {
        node = backup4
        d = backup5
      }
      
      // op=AssignmentOperator
      val result4 = d.dvAssignmentOperator
      d = result4.derivation
      node.op = result4.node
      
      // WS*
      var backup6 = node.copy()
      var backup7 = d
      try {
        while (true) {
          // WS
          val result5 = d.dvWS
          d = result5.derivation
          backup6 = node.copy()
          backup7 = d
        }
      } catch (ParseException e2) {
        node = backup6
        d = backup7
      }
      
      // 'current'
      // 'current'
      val result6 =  d.terminal('current', this)
      d = result6.derivation
      
      // WS*
      var backup8 = node.copy()
      var backup9 = d
      try {
        while (true) {
          // WS
          val result7 = d.dvWS
          d = result7.derivation
          backup8 = node.copy()
          backup9 = d
        }
      } catch (ParseException e3) {
        node = backup8
        d = backup9
      }
    } catch (ParseException e4) {
      node = backup2
      d = backup3
      val backup10 = node.copy()
      val backup11 = d
      try {
        // name=ID
        val result8 = d.dvID
        d = result8.derivation
        node.name = result8.node
      } catch (ParseException e5) {
        node = backup10
        d = backup11
        throw e5
      }
    }
    
    // WS*
    var backup12 = node.copy()
    var backup13 = d
    try {
      while (true) {
        // WS
        val result9 = d.dvWS
        d = result9.derivation
        backup12 = node.copy()
        backup13 = d
      }
    } catch (ParseException e6) {
      node = backup12
      d = backup13
    }
    
    // '}'
    // '}'
    val result10 =  d.terminal('}', this)
    d = result10.derivation
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression AndPredicateExpression(String in) {
    this.chars = in.toCharArray()
    val result = andPredicateExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * AndPredicateExpression returns Expression : '&' WS* expr=AssignableExpression ; 
   */
  package def Result<? extends Expression> andPredicateExpression(Derivation derivation) {
    var node = new AndPredicateExpression
    var d = derivation
    
    // '&'
    // '&'
    val result0 =  d.terminal('&', this)
    d = result0.derivation
    
    // WS*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    // expr=AssignableExpression
    val result2 = d.dvAssignableExpression
    d = result2.derivation
    node.expr = result2.node
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression NotPredicateExpression(String in) {
    this.chars = in.toCharArray()
    val result = notPredicateExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * NotPredicateExpression returns Expression : '!' WS* expr=AssignableExpression ; 
   */
  package def Result<? extends Expression> notPredicateExpression(Derivation derivation) {
    var node = new NotPredicateExpression
    var d = derivation
    
    // '!'
    // '!'
    val result0 =  d.terminal('!', this)
    d = result0.derivation
    
    // WS*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    // expr=AssignableExpression
    val result2 = d.dvAssignableExpression
    d = result2.derivation
    node.expr = result2.node
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression OneOrMoreExpression(String in) {
    this.chars = in.toCharArray()
    val result = oneOrMoreExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * OneOrMoreExpression returns Expression : expr=AssignableExpression WS* '+' ; 
   */
  package def Result<? extends Expression> oneOrMoreExpression(Derivation derivation) {
    var node = new OneOrMoreExpression
    var d = derivation
    
    // expr=AssignableExpression
    val result0 = d.dvAssignableExpression
    d = result0.derivation
    node.expr = result0.node
    
    // WS*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    // '+'
    // '+'
    val result2 =  d.terminal('+', this)
    d = result2.derivation
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression ZeroOrMoreExpression(String in) {
    this.chars = in.toCharArray()
    val result = zeroOrMoreExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ZeroOrMoreExpression returns Expression : expr=AssignableExpression WS* '*' ; 
   */
  package def Result<? extends Expression> zeroOrMoreExpression(Derivation derivation) {
    var node = new ZeroOrMoreExpression
    var d = derivation
    
    // expr=AssignableExpression
    val result0 = d.dvAssignableExpression
    d = result0.derivation
    node.expr = result0.node
    
    // WS*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    // '*'
    // '*'
    val result2 =  d.terminal('*', this)
    d = result2.derivation
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression OptionalExpression(String in) {
    this.chars = in.toCharArray()
    val result = optionalExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * OptionalExpression returns Expression : expr=AssignableExpression WS* '?' ; 
   */
  package def Result<? extends Expression> optionalExpression(Derivation derivation) {
    var node = new OptionalExpression
    var d = derivation
    
    // expr=AssignableExpression
    val result0 = d.dvAssignableExpression
    d = result0.derivation
    node.expr = result0.node
    
    // WS*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    // '?'
    // '?'
    val result2 =  d.terminal('?', this)
    d = result2.derivation
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression AssignableExpression(String in) {
    this.chars = in.toCharArray()
    val result = assignableExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * AssignableExpression returns Expression : (property=ID WS* op=AssignmentOperator WS*)? expr= ( SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression ) ; 
   */
  package def Result<? extends Expression> assignableExpression(Derivation derivation) {
    var node = new AssignableExpression
    var d = derivation
    
    // (property=ID WS* op=AssignmentOperator WS*)?
    val backup0 = node.copy()
    val backup1 = d
    try {
      // (property=ID WS* op=AssignmentOperator WS*)
      // property=ID
      val result0 = d.dvID
      d = result0.derivation
      node.property = result0.node
      
      // WS*
      var backup2 = node.copy()
      var backup3 = d
      try {
        while (true) {
          // WS
          val result1 = d.dvWS
          d = result1.derivation
          backup2 = node.copy()
          backup3 = d
        }
      } catch (ParseException e0) {
        node = backup2
        d = backup3
      }
      
      // op=AssignmentOperator
      val result2 = d.dvAssignmentOperator
      d = result2.derivation
      node.op = result2.node
      
      // WS*
      var backup4 = node.copy()
      var backup5 = d
      try {
        while (true) {
          // WS
          val result3 = d.dvWS
          d = result3.derivation
          backup4 = node.copy()
          backup5 = d
        }
      } catch (ParseException e1) {
        node = backup4
        d = backup5
      }
    } catch (ParseException e2) {
      node = backup0
      d = backup1
    }
    
    // expr= ( SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression )
    val result4 = d.assignableExpression_sub0()
    d = result4.derivation
    node.expr = result4.node
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  private def Result<? extends Expression> assignableExpression_sub0(Derivation derivation) {
    val d = derivation
    // SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression 
    try {
      return d.dvSubExpression
    } catch (ParseException e3) {
      try {
        return d.dvRangeExpression
      } catch (ParseException e4) {
        try {
          return d.dvTerminalExpression
        } catch (ParseException e5) {
          try {
            return d.dvAnyCharExpression
          } catch (ParseException e6) {
            try {
              return d.dvRuleReferenceExpression
            } catch (ParseException e7) {
              throw e7
            }
          }
        }
      }
    }
  }
  //--------------------------------------------------------------------------
  
  def AssignmentOperator AssignmentOperator(String in) {
    this.chars = in.toCharArray()
    val result = assignmentOperator(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * AssignmentOperator : single='=' | multi='+=' ; 
   */
  package def Result<? extends AssignmentOperator> assignmentOperator(Derivation derivation) {
    var node = new AssignmentOperator
    var d = derivation
    
    // single='=' | multi='+=' 
    val backup0 = node.copy()
    val backup1 = d
    try {
      // single='='
      // '='
      val result0 =  d.terminal('=', this)
      d = result0.derivation
      node.single = result0.node
    } catch (ParseException e0) {
      node = backup0
      d = backup1
      val backup2 = node.copy()
      val backup3 = d
      try {
        // multi='+='
        // '+='
        val result1 =  d.terminal('+=', this)
        d = result1.derivation
        node.multi = result1.node
      } catch (ParseException e1) {
        node = backup2
        d = backup3
        throw e1
      }
    }
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<AssignmentOperator>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression SubExpression(String in) {
    this.chars = in.toCharArray()
    val result = subExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * SubExpression returns Expression : '(' WS* expr=ChoiceExpression WS* ')' ; 
   */
  package def Result<? extends Expression> subExpression(Derivation derivation) {
    var node = new SubExpression
    var d = derivation
    
    // '('
    // '('
    val result0 =  d.terminal('(', this)
    d = result0.derivation
    
    // WS*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // WS
        val result1 = d.dvWS
        d = result1.derivation
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    // expr=ChoiceExpression
    val result2 = d.dvChoiceExpression
    d = result2.derivation
    node.expr = result2.node
    
    // WS*
    var backup2 = node.copy()
    var backup3 = d
    try {
      while (true) {
        // WS
        val result3 = d.dvWS
        d = result3.derivation
        backup2 = node.copy()
        backup3 = d
      }
    } catch (ParseException e1) {
      node = backup2
      d = backup3
    }
    
    // ')'
    // ')'
    val result4 =  d.terminal(')', this)
    d = result4.derivation
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression RangeExpression(String in) {
    this.chars = in.toCharArray()
    val result = rangeExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * RangeExpression returns Expression : '[' dash='-'? (!']' ranges+=(MinMaxRange | CharRange))* ']' ; 
   */
  package def Result<? extends Expression> rangeExpression(Derivation derivation) {
    var node = new RangeExpression
    var d = derivation
    
    // '['
    // '['
    val result0 =  d.terminal('[', this)
    d = result0.derivation
    
    // dash='-'?
    val backup0 = node.copy()
    val backup1 = d
    try {
      // dash='-'
      // '-'
      val result1 =  d.terminal('-', this)
      d = result1.derivation
      node.dash = result1.node
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    // (!']' ranges+=(MinMaxRange | CharRange))*
    var backup2 = node.copy()
    var backup3 = d
    try {
      while (true) {
        // (!']' ranges+=(MinMaxRange | CharRange))
        val backup4 = node.copy()
        val backup5 = d
        var loop0 = true
        try {
          // ']'
          // ']'
          val result2 =  d.terminal(']', this)
          d = result2.derivation
          loop0 = false
          throw new ParseException('Expected...')
        } catch (ParseException e1) {
          if (!loop0) throw e1
        } finally {
          node = backup4
          d = backup5
        }
        
        // ranges+=(MinMaxRange | CharRange)
        val result3 = d.rangeExpression_sub0()
        d = result3.derivation
        node.add(result3.node)
        backup2 = node.copy()
        backup3 = d
      }
    } catch (ParseException e4) {
      node = backup2
      d = backup3
    }
    
    // ']'
    // ']'
    val result4 =  d.terminal(']', this)
    d = result4.derivation
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  private def Result<? extends Node> rangeExpression_sub0(Derivation derivation) {
    val d = derivation
    // MinMaxRange | CharRange
    try {
      return d.dvMinMaxRange
    } catch (ParseException e2) {
      try {
        return d.dvCharRange
      } catch (ParseException e3) {
        throw e3
      }
    }
  }
  //--------------------------------------------------------------------------
  
  def MinMaxRange MinMaxRange(String in) {
    this.chars = in.toCharArray()
    val result = minMaxRange(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * MinMaxRange: !'-' min=. '-' !'-' max=. ; 
   */
  package def Result<? extends MinMaxRange> minMaxRange(Derivation derivation) {
    var node = new MinMaxRange
    var d = derivation
    
    val backup0 = node.copy()
    val backup1 = d
    var loop0 = true
    try {
      // '-'
      // '-'
      val result0 =  d.terminal('-', this)
      d = result0.derivation
      loop0 = false
      throw new ParseException('Expected...')
    } catch (ParseException e0) {
      if (!loop0) throw e0
    } finally {
      node = backup0
      d = backup1
    }
    
    // min=.
    // .
    val result1 =  d.any(this)
    d = result1.derivation
    node.min = result1.node
    
    // '-'
    // '-'
    val result2 =  d.terminal('-', this)
    d = result2.derivation
    
    val backup2 = node.copy()
    val backup3 = d
    var loop1 = true
    try {
      // '-'
      // '-'
      val result3 =  d.terminal('-', this)
      d = result3.derivation
      loop1 = false
      throw new ParseException('Expected...')
    } catch (ParseException e1) {
      if (!loop1) throw e1
    } finally {
      node = backup2
      d = backup3
    }
    
    // max=.
    // .
    val result4 =  d.any(this)
    d = result4.derivation
    node.max = result4.node
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<MinMaxRange>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def CharRange CharRange(String in) {
    this.chars = in.toCharArray()
    val result = charRange(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * CharRange: char='\\]' | char='\\\\' | !'-' char=. ; 
   */
  package def Result<? extends CharRange> charRange(Derivation derivation) {
    var node = new CharRange
    var d = derivation
    
    // char='\\]' | char='\\\\' | !'-' char=. 
    val backup0 = node.copy()
    val backup1 = d
    try {
      // char='\\]'
      // '\\]'
      val result0 =  d.terminal('\\]', this)
      d = result0.derivation
      node._char = result0.node
    } catch (ParseException e0) {
      node = backup0
      d = backup1
      val backup2 = node.copy()
      val backup3 = d
      try {
        // char='\\\\'
        // '\\\\'
        val result1 =  d.terminal('\\\\', this)
        d = result1.derivation
        node._char = result1.node
      } catch (ParseException e1) {
        node = backup2
        d = backup3
        val backup4 = node.copy()
        val backup5 = d
        try {
          val backup6 = node.copy()
          val backup7 = d
          var loop0 = true
          try {
            // '-'
            // '-'
            val result2 =  d.terminal('-', this)
            d = result2.derivation
            loop0 = false
            throw new ParseException('Expected...')
          } catch (ParseException e2) {
            if (!loop0) throw e2
          } finally {
            node = backup6
            d = backup7
          }
          
          // char=.
          // .
          val result3 =  d.any(this)
          d = result3.derivation
          node._char = result3.node
        } catch (ParseException e3) {
          node = backup4
          d = backup5
          throw e3
        }
      }
    }
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<CharRange>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression AnyCharExpression(String in) {
    this.chars = in.toCharArray()
    val result = anyCharExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * AnyCharExpression returns Expression : char='.' ; 
   */
  package def Result<? extends Expression> anyCharExpression(Derivation derivation) {
    var node = new AnyCharExpression
    var d = derivation
    
    // char='.'
    // '.'
    val result0 =  d.terminal('.', this)
    d = result0.derivation
    node._char = result0.node
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression RuleReferenceExpression(String in) {
    this.chars = in.toCharArray()
    val result = ruleReferenceExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * RuleReferenceExpression returns Expression : name=ID ; 
   */
  package def Result<? extends Expression> ruleReferenceExpression(Derivation derivation) {
    var node = new RuleReferenceExpression
    var d = derivation
    
    // name=ID
    val result0 = d.dvID
    d = result0.derivation
    node.name = result0.node
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Expression TerminalExpression(String in) {
    this.chars = in.toCharArray()
    val result = terminalExpression(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * TerminalExpression returns Expression : '\'' value=InTerminalChar? '\'' ; 
   */
  package def Result<? extends Expression> terminalExpression(Derivation derivation) {
    var node = new TerminalExpression
    var d = derivation
    
    // '\''
    // '\''
    val result0 =  d.terminal('\'', this)
    d = result0.derivation
    
    // value=InTerminalChar?
    val backup0 = node.copy()
    val backup1 = d
    try {
      // value=InTerminalChar
      val result1 = d.dvInTerminalChar
      d = result1.derivation
      node.value = result1.node
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    // '\''
    // '\''
    val result2 =  d.terminal('\'', this)
    d = result2.derivation
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Expression>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def InTerminalChar InTerminalChar(String in) {
    this.chars = in.toCharArray()
    val result = inTerminalChar(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * InTerminalChar: ('\\' '\'' | '\\' '\\' | !'\'' .)+ ; 
   */
  package def Result<? extends InTerminalChar> inTerminalChar(Derivation derivation) {
    var node = new InTerminalChar
    var d = derivation
    
    // ('\\' '\'' | '\\' '\\' | !'\'' .)+
    var backup0 = node.copy()
    var backup1 = d
    var loop0 = false
    try {
      while (true) {
        // ('\\' '\'' | '\\' '\\' | !'\'' .)
        // '\\' '\'' | '\\' '\\' | !'\'' .
        val backup2 = node.copy()
        val backup3 = d
        try {
          // '\\'
          // '\\'
          val result0 =  d.terminal('\\', this)
          d = result0.derivation
          
          // '\''
          // '\''
          val result1 =  d.terminal('\'', this)
          d = result1.derivation
        } catch (ParseException e0) {
          node = backup2
          d = backup3
          val backup4 = node.copy()
          val backup5 = d
          try {
            // '\\'
            // '\\'
            val result2 =  d.terminal('\\', this)
            d = result2.derivation
            
            // '\\'
            // '\\'
            val result3 =  d.terminal('\\', this)
            d = result3.derivation
          } catch (ParseException e1) {
            node = backup4
            d = backup5
            val backup6 = node.copy()
            val backup7 = d
            try {
              val backup8 = node.copy()
              val backup9 = d
              var loop1 = true
              try {
                // '\''
                // '\''
                val result4 =  d.terminal('\'', this)
                d = result4.derivation
                loop1 = false
                throw new ParseException('Expected...')
              } catch (ParseException e2) {
                if (!loop1) throw e2
              } finally {
                node = backup8
                d = backup9
              }
              
              // .
              // .
              val result5 =  d.any(this)
              d = result5.derivation
            } catch (ParseException e3) {
              node = backup6
              d = backup7
              throw e3
            }
          }
        }
        
        loop0 = true
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e4) {
      if (!loop0) {
        node = backup0
        d = backup1
        throw e4
      }
    }
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<InTerminalChar>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def Comment Comment(String in) {
    this.chars = in.toCharArray()
    val result = comment(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * Comment : '//' (!('\r'? '\n') .)* ; 
   */
  package def Result<? extends Comment> comment(Derivation derivation) {
    var node = new Comment
    var d = derivation
    
    // '//'
    // '//'
    val result0 =  d.terminal('//', this)
    d = result0.derivation
    
    // (!('\r'? '\n') .)*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // (!('\r'? '\n') .)
        val backup2 = node.copy()
        val backup3 = d
        var loop0 = true
        try {
          // ('\r'? '\n')
          // '\r'?
          val backup4 = node.copy()
          val backup5 = d
          try {
            // '\r'
            // '\r'
            val result1 =  d.terminal('\r', this)
            d = result1.derivation
          } catch (ParseException e0) {
            node = backup4
            d = backup5
          }
          
          // '\n'
          // '\n'
          val result2 =  d.terminal('\n', this)
          d = result2.derivation
          loop0 = false
          throw new ParseException('Expected...')
        } catch (ParseException e1) {
          if (!loop0) throw e1
        } finally {
          node = backup2
          d = backup3
        }
        
        // .
        // .
        val result3 =  d.any(this)
        d = result3.derivation
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e2) {
      node = backup0
      d = backup1
    }
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<Comment>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def EOI EOI(String in) {
    this.chars = in.toCharArray()
    val result = eOI(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * EOI: !(.) ; 
   */
  package def Result<? extends EOI> eOI(Derivation derivation) {
    var node = new EOI
    var d = derivation
    
    val backup0 = node.copy()
    val backup1 = d
    var loop0 = true
    try {
      // (.)
      // .
      // .
      val result0 =  d.any(this)
      d = result0.derivation
      loop0 = false
      throw new ParseException('Expected...')
    } catch (ParseException e0) {
      if (!loop0) throw e0
    } finally {
      node = backup0
      d = backup1
    }
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<EOI>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def ID ID(String in) {
    this.chars = in.toCharArray()
    val result = iD(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ID: [a-zA-Z_] [a-zA-Z0-9_]* ; 
   */
  package def Result<? extends ID> iD(Derivation derivation) {
    var node = new ID
    var d = derivation
    
    // [a-zA-Z_]
    // [a-zA-Z_]
    val result0 = d.terminal(
      ('a'..'z') + 
      ('A'..'Z') + 
      '_'
      , this)
    d = result0.derivation
    
    // [a-zA-Z0-9_]*
    var backup0 = node.copy()
    var backup1 = d
    try {
      while (true) {
        // [a-zA-Z0-9_]
        // [a-zA-Z0-9_]
        val result1 = d.terminal(
          ('a'..'z') + 
          ('A'..'Z') + 
          ('0'..'9') + 
          '_'
          , this)
        d = result1.derivation
        backup0 = node.copy()
        backup1 = d
      }
    } catch (ParseException e0) {
      node = backup0
      d = backup1
    }
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<ID>(node, d)
  }
  
  //--------------------------------------------------------------------------
  
  def WS WS(String in) {
    this.chars = in.toCharArray()
    val result = wS(parse(0))
    try {
      result.derivation.dvChar
    } catch (ParseException e) {
      return result.node
    }
    throw new ParseException("Unexpected end of input")
  }
  
  /**
   * WS : ' ' | '\n' | '\t' | '\r' ; 
   */
  package def Result<? extends WS> wS(Derivation derivation) {
    var node = new WS
    var d = derivation
    
    // ' ' | '\n' | '\t' | '\r' 
    val backup0 = node.copy()
    val backup1 = d
    try {
      // ' '
      // ' '
      val result0 =  d.terminal(' ', this)
      d = result0.derivation
    } catch (ParseException e0) {
      node = backup0
      d = backup1
      val backup2 = node.copy()
      val backup3 = d
      try {
        // '\n'
        // '\n'
        val result1 =  d.terminal('\n', this)
        d = result1.derivation
      } catch (ParseException e1) {
        node = backup2
        d = backup3
        val backup4 = node.copy()
        val backup5 = d
        try {
          // '\t'
          // '\t'
          val result2 =  d.terminal('\t', this)
          d = result2.derivation
        } catch (ParseException e2) {
          node = backup4
          d = backup5
          val backup6 = node.copy()
          val backup7 = d
          try {
            // '\r'
            // '\r'
            val result3 =  d.terminal('\r', this)
            d = result3.derivation
          } catch (ParseException e3) {
            node = backup6
            d = backup7
            throw e3
          }
        }
      }
    }
    
    node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
    return new Result<WS>(node, d)
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
    
    override Expression copy() {
      val r = new Expression
      return r
    }
    
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
  
