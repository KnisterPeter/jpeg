package jpeg

import java.util.List

import static extension jpeg.CharacterRange.*
import static extension jpeg.Extensions.*

class Parser {
  
  //--------------------------------------------------------------------------
  
  static def Jpeg Jpeg(String in) {
    val result = jpeg(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * Jpeg : (rules+=Rule | Comment WS*)+ EOI ; 
   */
  package static def Pair<? extends Jpeg, String> jpeg(String in) {
    var result = new Jpeg
    var tail = in
    
    // (rules+=Rule | Comment WS*)+
    var backup0 = result
    var backup1 = tail
    var loop0 = false
    try {
      while (true) {
        // (rules+=Rule | Comment WS*)
        // rules+=Rule | Comment WS*
        val backup2 = result.copy()
        val backup3 = tail
        try {
          // rules+=Rule
          val result0 = tail.rule()
          tail = result0.value
          result.add(result0.key)
        } catch (ParseException e0) {
          result = backup2
          tail = backup3
          val backup4 = result.copy()
          val backup5 = tail
          try {
            // Comment
            val result1 = tail.comment()
            tail = result1.value
            
            // WS*
            var backup6 = result
            var backup7 = tail
            try {
              while (true) {
                // WS
                val result2 = tail.wS()
                tail = result2.value
                backup6 = result
                backup7 = tail
              }
            } catch (ParseException e1) {
              result = backup6
              tail = backup7
            }
          } catch (ParseException e2) {
            result = backup4
            tail = backup5
            throw e2
          }
        }
        
        loop0 = true
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e3) {
      if (!loop0) {
        result = backup0
        tail = backup1
        throw e3
      }
    }
    
    // EOI
    val result3 = tail.eoi()
    tail = result3.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
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
   * Rule : name=ID WS* returns=RuleReturns? WS* ':' WS* body=Body WS* ';' WS* ; 
   */
  package static def Pair<? extends Rule, String> rule(String in) {
    var result = new Rule
    var tail = in
    
    // name=ID
    val result0 = tail.iD()
    tail = result0.value
    result.name = result0.key
    
    // WS*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // WS
        val result1 = tail.wS()
        tail = result1.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    // returns=RuleReturns?
    val backup2 = result.copy()
    val backup3 = tail
    try {
      // returns=RuleReturns
      val result2 = tail.ruleReturns()
      tail = result2.value
      result.returns = result2.key
    } catch (ParseException e1) {
      result = backup2
      tail = backup3
    }
    
    // WS*
    var backup4 = result
    var backup5 = tail
    try {
      while (true) {
        // WS
        val result3 = tail.wS()
        tail = result3.value
        backup4 = result
        backup5 = tail
      }
    } catch (ParseException e2) {
      result = backup4
      tail = backup5
    }
    
    // ':'
    // ':'
    val result4 =  tail.terminal(':')
    tail = result4.value
    
    // WS*
    var backup6 = result
    var backup7 = tail
    try {
      while (true) {
        // WS
        val result5 = tail.wS()
        tail = result5.value
        backup6 = result
        backup7 = tail
      }
    } catch (ParseException e3) {
      result = backup6
      tail = backup7
    }
    
    // body=Body
    val result6 = tail.body()
    tail = result6.value
    result.body = result6.key
    
    // WS*
    var backup8 = result
    var backup9 = tail
    try {
      while (true) {
        // WS
        val result7 = tail.wS()
        tail = result7.value
        backup8 = result
        backup9 = tail
      }
    } catch (ParseException e4) {
      result = backup8
      tail = backup9
    }
    
    // ';'
    // ';'
    val result8 =  tail.terminal(';')
    tail = result8.value
    
    // WS*
    var backup10 = result
    var backup11 = tail
    try {
      while (true) {
        // WS
        val result9 = tail.wS()
        tail = result9.value
        backup10 = result
        backup11 = tail
      }
    } catch (ParseException e5) {
      result = backup10
      tail = backup11
    }
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def RuleReturns RuleReturns(String in) {
    val result = ruleReturns(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * RuleReturns : 'returns' WS* name=FQTN ; 
   */
  package static def Pair<? extends RuleReturns, String> ruleReturns(String in) {
    var result = new RuleReturns
    var tail = in
    
    // 'returns'
    // 'returns'
    val result0 =  tail.terminal('returns')
    tail = result0.value
    
    // WS*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // WS
        val result1 = tail.wS()
        tail = result1.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    // name=FQTN
    val result2 = tail.fQTN()
    tail = result2.value
    result.name = result2.key
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Body Body(String in) {
    val result = body(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * Body : (expressions+=ChoiceExpression WS*)+ ; 
   */
  package static def Pair<? extends Body, String> body(String in) {
    var result = new Body
    var tail = in
    
    // (expressions+=ChoiceExpression WS*)+
    var backup0 = result
    var backup1 = tail
    var loop0 = false
    try {
      while (true) {
        // (expressions+=ChoiceExpression WS*)
        // expressions+=ChoiceExpression
        val result0 = tail.choiceExpression()
        tail = result0.value
        result.add(result0.key)
        
        // WS*
        var backup2 = result
        var backup3 = tail
        try {
          while (true) {
            // WS
            val result1 = tail.wS()
            tail = result1.value
            backup2 = result
            backup3 = tail
          }
        } catch (ParseException e0) {
          result = backup2
          tail = backup3
        }
        
        loop0 = true
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e1) {
      if (!loop0) {
        result = backup0
        tail = backup1
        throw e1
      }
    }
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression Expression(String in) {
    val result = expression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * Expression : ActionExpression | AndPredicateExpression | AnyCharExpression | AtomicExpression | ChoiceExpression | NotPredicateExpression | OneOrMoreExpression | OptionalExpression | RangeExpression | RuleReferenceExpression | SequenceExpression | SubExpression | TerminalExpression | ZeroOrMoreExpression ; 
   */
  package static def Pair<? extends Expression, String> expression(String in) {
    val tail = in
    // ActionExpression | AndPredicateExpression | AnyCharExpression | AtomicExpression | ChoiceExpression | NotPredicateExpression | OneOrMoreExpression | OptionalExpression | RangeExpression | RuleReferenceExpression | SequenceExpression | SubExpression | TerminalExpression | ZeroOrMoreExpression 
    try {
      return tail.actionExpression()
    } catch (ParseException e0) {
      try {
        return tail.andPredicateExpression()
      } catch (ParseException e1) {
        try {
          return tail.anyCharExpression()
        } catch (ParseException e2) {
          try {
            return tail.atomicExpression()
          } catch (ParseException e3) {
            try {
              return tail.choiceExpression()
            } catch (ParseException e4) {
              try {
                return tail.notPredicateExpression()
              } catch (ParseException e5) {
                try {
                  return tail.oneOrMoreExpression()
                } catch (ParseException e6) {
                  try {
                    return tail.optionalExpression()
                  } catch (ParseException e7) {
                    try {
                      return tail.rangeExpression()
                    } catch (ParseException e8) {
                      try {
                        return tail.ruleReferenceExpression()
                      } catch (ParseException e9) {
                        try {
                          return tail.sequenceExpression()
                        } catch (ParseException e10) {
                          try {
                            return tail.subExpression()
                          } catch (ParseException e11) {
                            try {
                              return tail.terminalExpression()
                            } catch (ParseException e12) {
                              try {
                                return tail.zeroOrMoreExpression()
                              } catch (ParseException e13) {
                                throw e13
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
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression ChoiceExpression(String in) {
    val result = choiceExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ChoiceExpression returns Expression : choices+=SequenceExpression ('|' WS* choices+=SequenceExpression)* ; 
   */
  package static def Pair<? extends Expression, String> choiceExpression(String in) {
    var result = new ChoiceExpression
    var tail = in
    
    // choices+=SequenceExpression
    val result0 = tail.sequenceExpression()
    tail = result0.value
    result.add(result0.key)
    
    // ('|' WS* choices+=SequenceExpression)*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // ('|' WS* choices+=SequenceExpression)
        // '|'
        // '|'
        val result1 =  tail.terminal('|')
        tail = result1.value
        
        // WS*
        var backup2 = result
        var backup3 = tail
        try {
          while (true) {
            // WS
            val result2 = tail.wS()
            tail = result2.value
            backup2 = result
            backup3 = tail
          }
        } catch (ParseException e0) {
          result = backup2
          tail = backup3
        }
        
        // choices+=SequenceExpression
        val result3 = tail.sequenceExpression()
        tail = result3.value
        result.add(result3.key)
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e1) {
      result = backup0
      tail = backup1
    }
    
    if (result.choices.size() == 1) {
      return result.choices.get(0) -> tail
    }
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression SequenceExpression(String in) {
    val result = sequenceExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * SequenceExpression returns Expression : ( expressions+= ( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AtomicExpression ) WS* )+ ; 
   */
  package static def Pair<? extends Expression, String> sequenceExpression(String in) {
    var result = new SequenceExpression
    var tail = in
    
    // ( expressions+= ( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AtomicExpression ) WS* )+
    var backup0 = result
    var backup1 = tail
    var loop0 = false
    try {
      while (true) {
        // ( expressions+= ( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AtomicExpression ) WS* )
        // expressions+= ( ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AtomicExpression )
        val result0 = tail.sequenceExpression_sub0()
        tail = result0.value
        result.add(result0.key)
        
        // WS*
        var backup2 = result
        var backup3 = tail
        try {
          while (true) {
            // WS
            val result1 = tail.wS()
            tail = result1.value
            backup2 = result
            backup3 = tail
          }
        } catch (ParseException e7) {
          result = backup2
          tail = backup3
        }
        
        loop0 = true
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e8) {
      if (!loop0) {
        result = backup0
        tail = backup1
        throw e8
      }
    }
    
    if (result.expressions.size() == 1) {
      return result.expressions.get(0) -> tail
    }
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  private static  def Pair<? extends Expression, String> sequenceExpression_sub0(String in) {
    val tail = in
    // ActionExpression | AndPredicateExpression | NotPredicateExpression | OneOrMoreExpression | ZeroOrMoreExpression | OptionalExpression | AtomicExpression 
    try {
      return tail.actionExpression()
    } catch (ParseException e0) {
      try {
        return tail.andPredicateExpression()
      } catch (ParseException e1) {
        try {
          return tail.notPredicateExpression()
        } catch (ParseException e2) {
          try {
            return tail.oneOrMoreExpression()
          } catch (ParseException e3) {
            try {
              return tail.zeroOrMoreExpression()
            } catch (ParseException e4) {
              try {
                return tail.optionalExpression()
              } catch (ParseException e5) {
                try {
                  return tail.atomicExpression()
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
  
  static def Expression ActionExpression(String in) {
    val result = actionExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ActionExpression returns Expression : '{' WS* ( property=ID WS* op=AssignmentOperator WS* 'current' WS* | name=FQTN ) WS* '}' ; 
   */
  package static def Pair<? extends Expression, String> actionExpression(String in) {
    var result = new ActionExpression
    var tail = in
    
    // '{'
    // '{'
    val result0 =  tail.terminal('{')
    tail = result0.value
    
    // WS*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // WS
        val result1 = tail.wS()
        tail = result1.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    // ( property=ID WS* op=AssignmentOperator WS* 'current' WS* | name=FQTN )
    // property=ID WS* op=AssignmentOperator WS* 'current' WS* | name=FQTN 
    val backup2 = result.copy()
    val backup3 = tail
    try {
      // property=ID
      val result2 = tail.iD()
      tail = result2.value
      result.property = result2.key
      
      // WS*
      var backup4 = result
      var backup5 = tail
      try {
        while (true) {
          // WS
          val result3 = tail.wS()
          tail = result3.value
          backup4 = result
          backup5 = tail
        }
      } catch (ParseException e1) {
        result = backup4
        tail = backup5
      }
      
      // op=AssignmentOperator
      val result4 = tail.assignmentOperator()
      tail = result4.value
      result.op = result4.key
      
      // WS*
      var backup6 = result
      var backup7 = tail
      try {
        while (true) {
          // WS
          val result5 = tail.wS()
          tail = result5.value
          backup6 = result
          backup7 = tail
        }
      } catch (ParseException e2) {
        result = backup6
        tail = backup7
      }
      
      // 'current'
      // 'current'
      val result6 =  tail.terminal('current')
      tail = result6.value
      
      // WS*
      var backup8 = result
      var backup9 = tail
      try {
        while (true) {
          // WS
          val result7 = tail.wS()
          tail = result7.value
          backup8 = result
          backup9 = tail
        }
      } catch (ParseException e3) {
        result = backup8
        tail = backup9
      }
    } catch (ParseException e4) {
      result = backup2
      tail = backup3
      val backup10 = result.copy()
      val backup11 = tail
      try {
        // name=FQTN
        val result8 = tail.fQTN()
        tail = result8.value
        result.name = result8.key
      } catch (ParseException e5) {
        result = backup10
        tail = backup11
        throw e5
      }
    }
    
    // WS*
    var backup12 = result
    var backup13 = tail
    try {
      while (true) {
        // WS
        val result9 = tail.wS()
        tail = result9.value
        backup12 = result
        backup13 = tail
      }
    } catch (ParseException e6) {
      result = backup12
      tail = backup13
    }
    
    // '}'
    // '}'
    val result10 =  tail.terminal('}')
    tail = result10.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression AndPredicateExpression(String in) {
    val result = andPredicateExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * AndPredicateExpression returns Expression : '&' WS* expr=AtomicExpression ; 
   */
  package static def Pair<? extends Expression, String> andPredicateExpression(String in) {
    var result = new AndPredicateExpression
    var tail = in
    
    // '&'
    // '&'
    val result0 =  tail.terminal('&')
    tail = result0.value
    
    // WS*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // WS
        val result1 = tail.wS()
        tail = result1.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    // expr=AtomicExpression
    val result2 = tail.atomicExpression()
    tail = result2.value
    result.expr = result2.key
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression NotPredicateExpression(String in) {
    val result = notPredicateExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * NotPredicateExpression returns Expression : '!' WS* expr=AtomicExpression ; 
   */
  package static def Pair<? extends Expression, String> notPredicateExpression(String in) {
    var result = new NotPredicateExpression
    var tail = in
    
    // '!'
    // '!'
    val result0 =  tail.terminal('!')
    tail = result0.value
    
    // WS*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // WS
        val result1 = tail.wS()
        tail = result1.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    // expr=AtomicExpression
    val result2 = tail.atomicExpression()
    tail = result2.value
    result.expr = result2.key
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression OneOrMoreExpression(String in) {
    val result = oneOrMoreExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * OneOrMoreExpression returns Expression : expr=AtomicExpression WS* '+' ; 
   */
  package static def Pair<? extends Expression, String> oneOrMoreExpression(String in) {
    var result = new OneOrMoreExpression
    var tail = in
    
    // expr=AtomicExpression
    val result0 = tail.atomicExpression()
    tail = result0.value
    result.expr = result0.key
    
    // WS*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // WS
        val result1 = tail.wS()
        tail = result1.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    // '+'
    // '+'
    val result2 =  tail.terminal('+')
    tail = result2.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression ZeroOrMoreExpression(String in) {
    val result = zeroOrMoreExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ZeroOrMoreExpression returns Expression : expr=AtomicExpression WS* '*' ; 
   */
  package static def Pair<? extends Expression, String> zeroOrMoreExpression(String in) {
    var result = new ZeroOrMoreExpression
    var tail = in
    
    // expr=AtomicExpression
    val result0 = tail.atomicExpression()
    tail = result0.value
    result.expr = result0.key
    
    // WS*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // WS
        val result1 = tail.wS()
        tail = result1.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    // '*'
    // '*'
    val result2 =  tail.terminal('*')
    tail = result2.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression OptionalExpression(String in) {
    val result = optionalExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * OptionalExpression returns Expression : expr=AtomicExpression WS* '?' ; 
   */
  package static def Pair<? extends Expression, String> optionalExpression(String in) {
    var result = new OptionalExpression
    var tail = in
    
    // expr=AtomicExpression
    val result0 = tail.atomicExpression()
    tail = result0.value
    result.expr = result0.key
    
    // WS*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // WS
        val result1 = tail.wS()
        tail = result1.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    // '?'
    // '?'
    val result2 =  tail.terminal('?')
    tail = result2.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression AtomicExpression(String in) {
    val result = atomicExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * AtomicExpression returns Expression : EndOfInputExpression | AssignableExpression ; 
   */
  package static def Pair<? extends Expression, String> atomicExpression(String in) {
    val tail = in
    // EndOfInputExpression | AssignableExpression 
    try {
      return tail.endOfInputExpression()
    } catch (ParseException e0) {
      try {
        return tail.assignableExpression()
      } catch (ParseException e1) {
        throw e1
      }
    }
  }
  
  //--------------------------------------------------------------------------
  
  static def AtomicExpression AssignableExpression(String in) {
    val result = assignableExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * AssignableExpression returns AtomicExpression : (property=ID WS* op=AssignmentOperator WS*)? expr= ( SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression ) ; 
   */
  package static def Pair<? extends AtomicExpression, String> assignableExpression(String in) {
    var result = new AssignableExpression
    var tail = in
    
    // (property=ID WS* op=AssignmentOperator WS*)?
    val backup0 = result.copy()
    val backup1 = tail
    try {
      // (property=ID WS* op=AssignmentOperator WS*)
      // property=ID
      val result0 = tail.iD()
      tail = result0.value
      result.property = result0.key
      
      // WS*
      var backup2 = result
      var backup3 = tail
      try {
        while (true) {
          // WS
          val result1 = tail.wS()
          tail = result1.value
          backup2 = result
          backup3 = tail
        }
      } catch (ParseException e0) {
        result = backup2
        tail = backup3
      }
      
      // op=AssignmentOperator
      val result2 = tail.assignmentOperator()
      tail = result2.value
      result.op = result2.key
      
      // WS*
      var backup4 = result
      var backup5 = tail
      try {
        while (true) {
          // WS
          val result3 = tail.wS()
          tail = result3.value
          backup4 = result
          backup5 = tail
        }
      } catch (ParseException e1) {
        result = backup4
        tail = backup5
      }
    } catch (ParseException e2) {
      result = backup0
      tail = backup1
    }
    
    // expr= ( SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression )
    val result4 = tail.assignableExpression_sub0()
    tail = result4.value
    result.expr = result4.key
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  private static  def Pair<? extends Expression, String> assignableExpression_sub0(String in) {
    val tail = in
    // SubExpression | RangeExpression | TerminalExpression | AnyCharExpression | RuleReferenceExpression 
    try {
      return tail.subExpression()
    } catch (ParseException e3) {
      try {
        return tail.rangeExpression()
      } catch (ParseException e4) {
        try {
          return tail.terminalExpression()
        } catch (ParseException e5) {
          try {
            return tail.anyCharExpression()
          } catch (ParseException e6) {
            try {
              return tail.ruleReferenceExpression()
            } catch (ParseException e7) {
              throw e7
            }
          }
        }
      }
    }
  }
  //--------------------------------------------------------------------------
  
  static def AssignmentOperator AssignmentOperator(String in) {
    val result = assignmentOperator(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * AssignmentOperator : single='=' | multi='+=' ; 
   */
  package static def Pair<? extends AssignmentOperator, String> assignmentOperator(String in) {
    var result = new AssignmentOperator
    var tail = in
    
    // single='=' | multi='+=' 
    val backup0 = result.copy()
    val backup1 = tail
    try {
      // single='='
      // '='
      val result0 =  tail.terminal('=')
      tail = result0.value
      result.single = result0.key
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
      val backup2 = result.copy()
      val backup3 = tail
      try {
        // multi='+='
        // '+='
        val result1 =  tail.terminal('+=')
        tail = result1.value
        result.multi = result1.key
      } catch (ParseException e1) {
        result = backup2
        tail = backup3
        throw e1
      }
    }
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression SubExpression(String in) {
    val result = subExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * SubExpression returns Expression : '(' WS* expr=ChoiceExpression WS* ')' ; 
   */
  package static def Pair<? extends Expression, String> subExpression(String in) {
    var result = new SubExpression
    var tail = in
    
    // '('
    // '('
    val result0 =  tail.terminal('(')
    tail = result0.value
    
    // WS*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // WS
        val result1 = tail.wS()
        tail = result1.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    // expr=ChoiceExpression
    val result2 = tail.choiceExpression()
    tail = result2.value
    result.expr = result2.key
    
    // WS*
    var backup2 = result
    var backup3 = tail
    try {
      while (true) {
        // WS
        val result3 = tail.wS()
        tail = result3.value
        backup2 = result
        backup3 = tail
      }
    } catch (ParseException e1) {
      result = backup2
      tail = backup3
    }
    
    // ')'
    // ')'
    val result4 =  tail.terminal(')')
    tail = result4.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression RangeExpression(String in) {
    val result = rangeExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * RangeExpression returns Expression : '[' dash='-'? (!']' ranges+=(MinMaxRange | CharRange))* ']' ; 
   */
  package static def Pair<? extends Expression, String> rangeExpression(String in) {
    var result = new RangeExpression
    var tail = in
    
    // '['
    // '['
    val result0 =  tail.terminal('[')
    tail = result0.value
    
    // dash='-'?
    val backup0 = result.copy()
    val backup1 = tail
    try {
      // dash='-'
      // '-'
      val result1 =  tail.terminal('-')
      tail = result1.value
      result.dash = result1.key
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    // (!']' ranges+=(MinMaxRange | CharRange))*
    var backup2 = result
    var backup3 = tail
    try {
      while (true) {
        // (!']' ranges+=(MinMaxRange | CharRange))
        val backup4 = result.copy()
        val backup5 = tail
        var loop0 = true
        try {
          // ']'
          // ']'
          val result2 =  tail.terminal(']')
          tail = result2.value
          loop0 = false
          throw new ParseException('Expected...')
        } catch (ParseException e1) {
          if (!loop0) throw e1
        } finally {
          result = backup4
          tail = backup5
        }
        
        // ranges+=(MinMaxRange | CharRange)
        val result3 = tail.rangeExpression_sub0()
        tail = result3.value
        result.add(result3.key)
        backup2 = result
        backup3 = tail
      }
    } catch (ParseException e4) {
      result = backup2
      tail = backup3
    }
    
    // ']'
    // ']'
    val result4 =  tail.terminal(']')
    tail = result4.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  private static  def Pair<? extends Result, String> rangeExpression_sub0(String in) {
    val tail = in
    // MinMaxRange | CharRange
    try {
      return tail.minMaxRange()
    } catch (ParseException e2) {
      try {
        return tail.charRange()
      } catch (ParseException e3) {
        throw e3
      }
    }
  }
  //--------------------------------------------------------------------------
  
  static def MinMaxRange MinMaxRange(String in) {
    val result = minMaxRange(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * MinMaxRange: !'-' min=. '-' !'-' max=. ; 
   */
  package static def Pair<? extends MinMaxRange, String> minMaxRange(String in) {
    var result = new MinMaxRange
    var tail = in
    
    val backup0 = result.copy()
    val backup1 = tail
    var loop0 = true
    try {
      // '-'
      // '-'
      val result0 =  tail.terminal('-')
      tail = result0.value
      loop0 = false
      throw new ParseException('Expected...')
    } catch (ParseException e0) {
      if (!loop0) throw e0
    } finally {
      result = backup0
      tail = backup1
    }
    
    // min=.
    // .
    val result1 =  tail.any()
    tail = result1.value
    result.min = result1.key
    
    // '-'
    // '-'
    val result2 =  tail.terminal('-')
    tail = result2.value
    
    val backup2 = result.copy()
    val backup3 = tail
    var loop1 = true
    try {
      // '-'
      // '-'
      val result3 =  tail.terminal('-')
      tail = result3.value
      loop1 = false
      throw new ParseException('Expected...')
    } catch (ParseException e1) {
      if (!loop1) throw e1
    } finally {
      result = backup2
      tail = backup3
    }
    
    // max=.
    // .
    val result4 =  tail.any()
    tail = result4.value
    result.max = result4.key
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def CharRange CharRange(String in) {
    val result = charRange(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * CharRange: !'-' char=. ; 
   */
  package static def Pair<? extends CharRange, String> charRange(String in) {
    var result = new CharRange
    var tail = in
    
    val backup0 = result.copy()
    val backup1 = tail
    var loop0 = true
    try {
      // '-'
      // '-'
      val result0 =  tail.terminal('-')
      tail = result0.value
      loop0 = false
      throw new ParseException('Expected...')
    } catch (ParseException e0) {
      if (!loop0) throw e0
    } finally {
      result = backup0
      tail = backup1
    }
    
    // char=.
    // .
    val result1 =  tail.any()
    tail = result1.value
    result._char = result1.key
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression AnyCharExpression(String in) {
    val result = anyCharExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * AnyCharExpression returns Expression : char='.' ; 
   */
  package static def Pair<? extends Expression, String> anyCharExpression(String in) {
    var result = new AnyCharExpression
    var tail = in
    
    // char='.'
    // '.'
    val result0 =  tail.terminal('.')
    tail = result0.value
    result._char = result0.key
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression RuleReferenceExpression(String in) {
    val result = ruleReferenceExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * RuleReferenceExpression returns Expression : name=ID ; 
   */
  package static def Pair<? extends Expression, String> ruleReferenceExpression(String in) {
    var result = new RuleReferenceExpression
    var tail = in
    
    // name=ID
    val result0 = tail.iD()
    tail = result0.value
    result.name = result0.key
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def AtomicExpression EndOfInputExpression(String in) {
    val result = endOfInputExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * EndOfInputExpression returns AtomicExpression : 'EOI' ; 
   */
  package static def Pair<? extends AtomicExpression, String> endOfInputExpression(String in) {
    var result = new EndOfInputExpression
    var tail = in
    
    // 'EOI'
    // 'EOI'
    val result0 =  tail.terminal('EOI')
    tail = result0.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Expression TerminalExpression(String in) {
    val result = terminalExpression(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * TerminalExpression returns Expression : '\'' value=InTerminalChar? '\'' ; 
   */
  package static def Pair<? extends Expression, String> terminalExpression(String in) {
    var result = new TerminalExpression
    var tail = in
    
    // '\''
    // '\''
    val result0 =  tail.terminal('\'')
    tail = result0.value
    
    // value=InTerminalChar?
    val backup0 = result.copy()
    val backup1 = tail
    try {
      // value=InTerminalChar
      val result1 = tail.inTerminalChar()
      tail = result1.value
      result.value = result1.key
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    // '\''
    // '\''
    val result2 =  tail.terminal('\'')
    tail = result2.value
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def InTerminalChar InTerminalChar(String in) {
    val result = inTerminalChar(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * InTerminalChar: ('\\' '\'' | '\\' '\\' | !'\'' .)+ ; 
   */
  package static def Pair<? extends InTerminalChar, String> inTerminalChar(String in) {
    var result = new InTerminalChar
    var tail = in
    
    // ('\\' '\'' | '\\' '\\' | !'\'' .)+
    var backup0 = result
    var backup1 = tail
    var loop0 = false
    try {
      while (true) {
        // ('\\' '\'' | '\\' '\\' | !'\'' .)
        // '\\' '\'' | '\\' '\\' | !'\'' .
        val backup2 = result.copy()
        val backup3 = tail
        try {
          // '\\'
          // '\\'
          val result0 =  tail.terminal('\\')
          tail = result0.value
          
          // '\''
          // '\''
          val result1 =  tail.terminal('\'')
          tail = result1.value
        } catch (ParseException e0) {
          result = backup2
          tail = backup3
          val backup4 = result.copy()
          val backup5 = tail
          try {
            // '\\'
            // '\\'
            val result2 =  tail.terminal('\\')
            tail = result2.value
            
            // '\\'
            // '\\'
            val result3 =  tail.terminal('\\')
            tail = result3.value
          } catch (ParseException e1) {
            result = backup4
            tail = backup5
            val backup6 = result.copy()
            val backup7 = tail
            try {
              val backup8 = result.copy()
              val backup9 = tail
              var loop1 = true
              try {
                // '\''
                // '\''
                val result4 =  tail.terminal('\'')
                tail = result4.value
                loop1 = false
                throw new ParseException('Expected...')
              } catch (ParseException e2) {
                if (!loop1) throw e2
              } finally {
                result = backup8
                tail = backup9
              }
              
              // .
              // .
              val result5 =  tail.any()
              tail = result5.value
            } catch (ParseException e3) {
              result = backup6
              tail = backup7
              throw e3
            }
          }
        }
        
        loop0 = true
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e4) {
      if (!loop0) {
        result = backup0
        tail = backup1
        throw e4
      }
    }
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def Comment Comment(String in) {
    val result = comment(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * Comment : '//' (!('\r'? '\n') .)* ; 
   */
  package static def Pair<? extends Comment, String> comment(String in) {
    var result = new Comment
    var tail = in
    
    // '//'
    // '//'
    val result0 =  tail.terminal('//')
    tail = result0.value
    
    // (!('\r'? '\n') .)*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // (!('\r'? '\n') .)
        val backup2 = result.copy()
        val backup3 = tail
        var loop0 = true
        try {
          // ('\r'? '\n')
          // '\r'?
          val backup4 = result.copy()
          val backup5 = tail
          try {
            // '\r'
            // '\r'
            val result1 =  tail.terminal('\r')
            tail = result1.value
          } catch (ParseException e0) {
            result = backup4
            tail = backup5
          }
          
          // '\n'
          // '\n'
          val result2 =  tail.terminal('\n')
          tail = result2.value
          loop0 = false
          throw new ParseException('Expected...')
        } catch (ParseException e1) {
          if (!loop0) throw e1
        } finally {
          result = backup2
          tail = backup3
        }
        
        // .
        // .
        val result3 =  tail.any()
        tail = result3.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e2) {
      result = backup0
      tail = backup1
    }
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def FQTN FQTN(String in) {
    val result = fQTN(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * FQTN: ID ('.' ID)* ; 
   */
  package static def Pair<? extends FQTN, String> fQTN(String in) {
    var result = new FQTN
    var tail = in
    
    // ID
    val result0 = tail.iD()
    tail = result0.value
    
    // ('.' ID)*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // ('.' ID)
        // '.'
        // '.'
        val result1 =  tail.terminal('.')
        tail = result1.value
        
        // ID
        val result2 = tail.iD()
        tail = result2.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def ID ID(String in) {
    val result = iD(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * ID: [a-zA-Z_] [a-zA-Z0-9_]* ; 
   */
  package static def Pair<? extends ID, String> iD(String in) {
    var result = new ID
    var tail = in
    
    // [a-zA-Z_]
    // [a-zA-Z_]
    val result0 = tail.terminal(
      ('a'..'z') + 
      ('A'..'Z') + 
      '_'
      )
    tail = result0.value
    
    // [a-zA-Z0-9_]*
    var backup0 = result
    var backup1 = tail
    try {
      while (true) {
        // [a-zA-Z0-9_]
        // [a-zA-Z0-9_]
        val result1 = tail.terminal(
          ('a'..'z') + 
          ('A'..'Z') + 
          ('0'..'9') + 
          '_'
          )
        tail = result1.value
        backup0 = result
        backup1 = tail
      }
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
    }
    
    result.parsed = in.substring(0, in.length - tail.length)
    return result -> tail
  }
  
  //--------------------------------------------------------------------------
  
  static def WS WS(String in) {
    val result = wS(in)
    return 
      if (result.value.length == 0) 
        result.key 
      else 
        throw new ParseException("Unexpected end of input")
  }
  
  /**
   * WS : ' ' | '\n' | '\t' | '\r' ; 
   */
  package static def Pair<? extends WS, String> wS(String in) {
    var result = new WS
    var tail = in
    
    // ' ' | '\n' | '\t' | '\r' 
    val backup0 = result.copy()
    val backup1 = tail
    try {
      // ' '
      // ' '
      val result0 =  tail.terminal(' ')
      tail = result0.value
    } catch (ParseException e0) {
      result = backup0
      tail = backup1
      val backup2 = result.copy()
      val backup3 = tail
      try {
        // '\n'
        // '\n'
        val result1 =  tail.terminal('\n')
        tail = result1.value
      } catch (ParseException e1) {
        result = backup2
        tail = backup3
        val backup4 = result.copy()
        val backup5 = tail
        try {
          // '\t'
          // '\t'
          val result2 =  tail.terminal('\t')
          tail = result2.value
        } catch (ParseException e2) {
          result = backup4
          tail = backup5
          val backup6 = result.copy()
          val backup7 = tail
          try {
            // '\r'
            // '\r'
            val result3 =  tail.terminal('\r')
            tail = result3.value
          } catch (ParseException e3) {
            result = backup6
            tail = backup7
            throw e3
          }
        }
      }
    }
    
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
  
  class EndOfInputExpression extends AtomicExpression {
    
    override EndOfInputExpression copy() {
      val r = new EndOfInputExpression
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
    FQTN name
    
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
  
  class AtomicExpression extends Expression {
    
    override AtomicExpression copy() {
      val r = new AtomicExpression
      return r
    }
    
  }
  
  class AssignableExpression extends AtomicExpression {
    
    
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
    java.util.List<Result> ranges
    
    def dispatch void add(Result __result) {
      _ranges = _ranges ?: newArrayList
      _ranges += __result
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
  
  class ID extends Terminal {
    
    override ID copy() {
      val r = new ID
      return r
    }
    
  }
  
  class Expression extends Result {
    
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
  
  class Body extends Result {
    
    
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
  
  class AssignmentOperator extends Result {
    
    
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
  
  class FQTN extends Terminal {
    
    override FQTN copy() {
      val r = new FQTN
      return r
    }
    
  }
  
  class WS extends Terminal {
    
    override WS copy() {
      val r = new WS
      return r
    }
    
  }
  
  class CharRange extends Result {
    
    
    @Property
    Object _char
    
    override CharRange copy() {
      val r = new CharRange
      r.__char = __char
      return r
    }
    
  }
  
  class Comment extends Result {
    
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
  
  class Rule extends Result {
    
    
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
  
  class RuleReturns extends Result {
    
    
    @Property
    FQTN name
    
    override RuleReturns copy() {
      val r = new RuleReturns
      r._name = _name
      return r
    }
    
  }
  
  class MinMaxRange extends Result {
    
    
    @Property
    Object min
    
    
    @Property
    Object max
    
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
  
  class Jpeg extends Result {
    
    
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
  
  class InTerminalChar extends Result {
    
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
  
