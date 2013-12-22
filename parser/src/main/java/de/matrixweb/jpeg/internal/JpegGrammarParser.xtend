package de.matrixweb.jpeg.internal

import de.matrixweb.jpeg.internal.CharacterRange
import java.util.List
import org.eclipse.xtext.xbase.lib.Pair

import static extension de.matrixweb.jpeg.internal.CharacterRange.*
import static extension de.matrixweb.jpeg.internal.Extensions.*

/**
 * @author markusw
 */
class JpegGrammarParser {

  /**
   * (rules+=Rule | Comment WS*)+ EOI
   */
  static def Pair<Jpeg, String> jpeg(String input) {
    val result = new Jpeg
    var tail = input
    
    var once0 = false
    try {
      while (true) {
        try {
          // rules+=Rule
          var result0 = rule(tail)
          result.rules += result0.key
          tail = result0.value
        } catch (ParseException e1) {
          // Comment
          var result0 = comment(tail)
          tail = result0.value
          
          // WS*
          try {
            while (true) {
              var result1 = WS(tail)
              tail = result1.value
            }
          } catch (ParseException e2) {
          }
        }
        once0 = true
      }
    } catch (ParseException e0) {
      if (!once0) throw e0
    }
    
    // EOI
    var result2 = eoi(tail)
    tail = result2.value
    
    return result -> tail
  }

  /**
   * (rules+=Rule | Comment WS*)+ EOI
   */
  static def Pair<Jpeg, String> jpeg0(String input) {
    val r0 = new Jpeg -> input

    // (rules+=Rule | Comment WS*)+
    val r1 = r0.oneOrMore [
      val r6 = it
      val r7 = r6.oneOf(
        [
          val r10 = it
          // rules+=Rule
          val r11 = rule(r10.value)
          val r12 = (r10.key.add(r11.key)) -> r11.value
          return r12
        ],
        [
          val r14 = it
          // Comment
          val r15 = comment(r14.value)
          val r16 = r14.key -> r15.value
          // WS*
          val r17 = r16.zeroOrMore [
            val r20 = it
            val r21 = WS(r20.value)
            val r22 = r20.key -> r21.value
            return r22
          ]
          val r18 = r16.key -> r17.value
          return r18
        ])
      return r7 as Pair<Jpeg, String>
    ]

    // EOI
    val r2 = eoi(r1.value)
    val r4 = r1.key -> r2.value

    return r4
  }

  /**
   * name=ID WS* returns=RuleReturns? WS* ':' WS* body=Body WS* ';' WS*
   */
  static def Pair<Rule, String> rule(String input) {
    val r0 = new Rule -> input

    // name=ID
    val r1 = ID(r0.value)
    val r2 = (r0.key.name = r1.key) -> r1.value

    // WS*
    val r3 = r2.zeroOrMore [
      val r4 = it
      val r5 = WS(r4.value)
      val r6 = r4.key -> r5.value
      return r6
    ]
    val r4 = r2.key -> r3.value

    // returns=RuleReturns?
    val r5 = r4.optional [
      val r8 = it
      val r9 = ruleReturns(r8.value)
      val r10 = (r8.key.returns = r9.key) -> r9.value
      return r10
    ] as Pair<Rule, String>
    val r6 = r5

    // WS*
    val r7 = r6.zeroOrMore [
      val r10 = it
      val r11 = WS(r10.value)
      val r12 = r10.key -> r11.value
      return r12
    ]
    val r8 = r6.key -> r7.value

    // ':'
    val r9 = r8.terminal(':')
    val r10 = r8.key -> r9.value

    // WS*
    val r11 = r10.zeroOrMore [
      val r12 = it
      val r13 = WS(r12.value)
      val r14 = r12.key -> r13.value
      return r14
    ]
    val r16 = r10.key -> r11.value

    // body=Body
    val r17 = body(r16.value)
    val r18 = (r16.key.body = r17.key) -> r17.value

    // WS*
    val r19 = r18.zeroOrMore [
      val r20 = it
      val r21 = WS(r20.value)
      val r22 = r20.key -> r21.value
      return r22
    ]
    val r24 = r18.key -> r19.value

    // ';'
    val r25 = r24.terminal(';')
    val r26 = r24.key -> r25.value

    // WS*
    val r27 = r26.zeroOrMore [
      val r28 = it
      val r29 = WS(r28.value)
      val r30 = r28.key -> r29.value
      return r30
    ]
    val r32 = r26.key -> r27.value

    return r32
  }

  /**
   * 'returns' WS* name=FQTN
   */
  static def Pair<RuleReturns, String> ruleReturns(String input) {
    val r0 = new RuleReturns -> input

    val r1 = r0.terminal('returns')
    val r2 = r0.key -> r1.value
    
    val r3 = r2.zeroOrMore[
      val r3 = WS(value)
      return key -> r3.value
    ]
    val r4 = r2.key -> r3.value
    
    val r5 = FQTN(r4.value)
    val r6 = (r4.key.name = r5.key) -> r5.value

    return r6
  }

  /**
   * (expressions+=ChoiceExpression WS*)+
   */
  static def Pair<Body, String> body(String input) {
    val r0 = new Body -> input

    val r1 = r0.oneOrMore [
      val r1 = it
      val r2 = choiceExpression(r1.value)
      val r3 = r1.key.add(r2.key) -> r2.value
      
      val r4 = r3.zeroOrMore[
        val r4 = WS(value)
        return it.key -> r4.value
      ]
      val r5 = r3.key -> r4.value
      
      return r5
    ]
    
    return r1
  }

  /**
   * choices+=SequenceExpression ('|' WS* choices+=SequenceExpression)*
   */
  static def Pair<ChoiceExpression, String> choiceExpression(String input) {
    val r0 = new ChoiceExpression -> input

    val r1 = sequenceExpression(r0.value)
    val r2 = r0.key.add(r1.key) -> r1.value

    val r3 = r2.zeroOrMore [
      val r3 = it
      val r4 = r3.terminal('|')
      val r5 = r3.key -> r4.value
      val r6 = r5.zeroOrMore [
        val r6 = it
        val r7 = WS(r6.value)
        return r6.key -> r7.value
      ]
      val r7 = sequenceExpression(r6.value)
      val r8 = r6.key.add(r7.key) -> r7.value
      return r8
    ]

    return r3
  }

  /**
      (
        expressions+=
        (
            ActionExpression
          | AndPredicateExpression
          | NotPredicateExpression
          | OneOrMoreExpression
          | ZeroOrMoreExpression
          | OptionalExpression
          | AtomicExpression
        )
        WS*
      )+
   */
  static def Pair<SequenceExpression, String> sequenceExpression(String input) {
    val r0 = new SequenceExpression -> input

    val r6 = r0.oneOrMore[
      val r1 = it
      
      val r2 = r1.oneOf([
        return actionExpression(value)
      ], [
        return andPredicateExpression(value)
      ], [
        return notPredicateExpression(value)
      ], [
        return oneOrMoreExpression(value)
      ], [
        return zeroOrMoreExpression(value)
      ], [
        return optionalExpression(value)
      ], [
        return atomicExpression(value)
      ])
      val r3 = r1.key.add(r2.key) -> r2.value
      
      val r6 = r3.zeroOrMore[
        val r4 = it
        val r5 = WS(r4.value)
        return r4.key -> r5.value
      ]
      return r3.key -> r6.value
    ]

    return r6
  }
  
  /**
      '{' WS* 
      ( property=ID WS* op=AssignmentOperator WS* 'current' WS*
      | name=FQTN
      ) 
      WS* '}'
   */
  static def Pair<ActionExpression, String> actionExpression(String input) {
    val r0 = new ActionExpression -> input

    val r1 = r0.terminal('{')
    val r2 = r0.key -> r1.value
    
    val r3 = r2.zeroOrMore[
      val r3 = WS(it.value)
      return it.key -> r3.value
    ]

    println('TODO: actionExpression')

    return r0
  }

  /**
   * '&' WS* expr=AtomicExpression
   */
  static def Pair<AndPredicateExpression, String> andPredicateExpression(String input) {
    val r0 = new AndPredicateExpression -> input

    val r1 = r0.terminal('&')
    val r2 = r0.key -> r1.value
    
    val r3 = r2.zeroOrMore[
      val r = WS(it.value)
      return it.key -> r.value
    ]
    
    val r4 = atomicExpression(r3.value)
    val r5 = (r0.key.expr = r4.key) -> r4.value

    return r5
  }

  /**
   * '!' WS* expr=AtomicExpression
   */
  static def Pair<NotPredicateExpression, String> notPredicateExpression(String input) {
    val r0 = new NotPredicateExpression -> input

    val r1 = r0.terminal('!')
    val r2 = r0.key -> r1.value
    
    val r3 = r2.zeroOrMore[
      val r = WS(it.value)
      return it.key -> r.value
    ]
    
    val r4 = atomicExpression(r3.value)
    val r5 = (r0.key.expr = r4.key) -> r4.value

    return r5
  }

  /**
   * expr=AtomicExpression WS* '+'
   */
  static def Pair<OneOrMoreExpression, String> oneOrMoreExpression(String input) {
    val r0 = new OneOrMoreExpression -> input

    val r1 = atomicExpression(r0.value)
    val r2 = (r0.key.expr = r1.key) -> r1.value
    
    val r3 = r2.zeroOrMore[
      val r = WS(it.value)
      return it.key -> r.value
    ]
    
    val r4 = r3.terminal('+')
    val r5 = r3.key -> r4.value

    return r5
  }

  /**
   * expr=AtomicExpression WS* '*'
   */
  static def Pair<ZeroOrMoreExpression, String> zeroOrMoreExpression(String input) {
    val r0 = new ZeroOrMoreExpression -> input

    val r1 = atomicExpression(r0.value)
    val r2 = (r0.key.expr = r1.key) -> r1.value
    
    val r3 = r2.zeroOrMore[
      val r = WS(it.value)
      return it.key -> r.value
    ]
    
    val r4 = r3.terminal('*')
    val r5 = r3.key -> r4.value

    return r5
  }

  /**
   * expr=AtomicExpression WS* '?'
   */
  static def Pair<OptionalExpression, String> optionalExpression(String input) {
    val r0 = new OptionalExpression -> input

    val r1 = atomicExpression(r0.value)
    val r2 = (r0.key.expr = r1.key) -> r1.value
    
    val r3 = r2.zeroOrMore[
      val r = WS(it.value)
      return it.key -> r.value
    ]
    
    val r4 = r3.terminal('?')
    val r5 = r3.key -> r4.value

    return r5
  }

  /**
   * EndOfInputExpression | AssignableExpression
   */
  static def Pair<AtomicExpression, String> atomicExpression(String input) {
    val r0 = new AtomicExpression -> input

    val r1 = r0.oneOf([
      return endOfInputExpression(value)
    ], [
      return assignableExpression(value)
    ])

    return r1 as Pair<AtomicExpression, String>
  }
  
  /**
      (property=ID WS* op=AssignmentOperator WS*)?
      expr=
      ( SubExpression
      | RangeExpression
      | TerminalExpression
      | AnyCharExpression
      | RuleReferenceExpression
      )
   */
  static def Pair<AssignableExpression, String> assignableExpression(String input) {
    val r0 = new AssignableExpression -> input

    // (property=ID WS* op=AssignmentOperator WS*)?
    val r1 = r0.optional[
      val r1 = it
      val r2 = ID(r1.value)
      val r3 = (r1.key.property = r2.key) -> r2.value
      
      val r4 = r3.zeroOrMore[
        val r = WS(it.value)
        return it.key -> r.value
      ]
      
      val r5 = assignmentOperator(r4.value)
      val r6 = (r4.key.op = r5.key) -> r5.value
      
      val r7 = r6.zeroOrMore[
        val r = WS(it.value)
        return it.key -> r.value
      ]
      return r7
    ] as Pair<AssignableExpression, String>

    val r2 = r1.oneOf([
      val r2 = it
      return subExpression(r2.value)
    ], [
      val r2 = it
      return rangeExpression(r2.value)
    ], [
      val r2 = it
      return terminalExpression(r2.value)
    ], [
      val r2 = it
      return anyCharExpression(r2.value)
    ], [
      val r2 = it
      return ruleReferenceExpression(r2.value)
    ])
    val r3 = (r1.key.expr = r2.key) -> r2.value

    return r3
  }
  
  /**
   * single='=' | multi='+='
   */
  static def Pair<AssignmentOperator, String> assignmentOperator(String input) {
    val r0 = new AssignmentOperator -> input
    
    val r4 = r0.oneOf([
      val r1 = it
      val r2 = r1.terminal('=')
      val r3 = (r1.key.single = r2.key) -> r2.value
      return r3
    ], [
      val r1 = it
      val r2 = r1.terminal('+=')
      val r3 = (r1.key.multi = r2.key) -> r2.value
      return r3
    ])
    
    return r4 as Pair<AssignmentOperator, String>
  }
  
  /**
   * '(' WS* expr=ChoiceExpression WS* ')'
   */
  static def Pair<SubExpression, String> subExpression(String input) {
    val r0 = new SubExpression -> input
    
    val r1 = r0.terminal('(')
    val r2 = r0.key -> r1.value
    
    val r3 = r2.zeroOrMore[
      val r = WS(it.value)
      return it.key -> r.value
    ]
    
    val r4 = choiceExpression(r3.value)
    val r5 = (r3.key.expr = r4.key) -> r4.value

    val r6 = r5.zeroOrMore[
      val r = WS(it.value)
      return it.key -> r.value
    ]
    
    val r7 = r6.terminal(')')
    val r8 = r6.key -> r7.value
    
    return r8
  }
  
  /**
   * '[' dash='-'? (!']' ranges+=(MinMaxRange | CharRange))* ']'
   */
  static def Pair<RangeExpression, String> rangeExpression(String input) {
    val r0 = new RangeExpression -> input
    
    val r1 = r0.terminal('[')
    val r2 = r0.key -> r1.value
    
    val r3 = r2.optional[
      val r3 = it
      val r4 = r3.terminal('-')
      return (r3.key.dash = r4.key) -> r4.value
    ] as Pair<RangeExpression, String>
    
    val r4 = r3.zeroOrMore[
      val r4 = it
      
      // !']' ranges+=(MinMaxRange | CharRange)
      val r5 = r4.not([ terminal(']') ]) [
        val r5 = it
        val r6 = r5.oneOf([
          return minMaxRange(value)
        ], [
          return charRange(value)
        ])
        val r7 = r5.key.add(r6.key) -> r6.value
        return r7
      ]
      
      return r5
    ]
    
    val r5 = r4.terminal(']')
    val r6 = r4.key -> r5.value
    
    return r6
  }
  
  /**
   * !'-' min=. '-' !'-' max=.
   */
  static def Pair<MinMaxRange, String> minMaxRange(String input) {
    val r0 = new MinMaxRange -> input
    
    val r1 = r0.not([terminal('-')]) [
      val r1 = it
      val r2 = r1.any()
      val r3 = (r1.key.min = r2.key) -> r2.value
      
      val r4 = r3.terminal('-')
      val r5 = r3.key -> r4.value
      
      val r6 = r5.not([terminal('-')]) [
        val r6 = it
        val r7 = r6.any()
        val r8 = (r6.key.max = r7.key) -> r7.value
        return r8
      ]
      
      return r6
    ]
    
    return r1
  }
  
  /**
   * !'-' char=.
   */
  static def Pair<CharRange, String> charRange(String input) {
    val r0 = new CharRange -> input
    
    val r1 = r0.not([terminal('-')]) [
      val r1 = it
      val r2 = r1.any()
      val r3 = (r1.key._char = r2.key) -> r2.value
      return r3
    ]
    
    return r1
  }
  
  /**
   * '\'' value=InTerminalChar? '\''
   */
  static def Pair<TerminalExpression, String> terminalExpression(String input) {
    val r0 = new TerminalExpression -> input
    
    val r1 = r0.terminal("'")
    val r2 = r0.key -> r1.value
    
    val r3 = r2.optional[
      var r = inTerminalChar(it.value)
      return (it.key.value = r.key) -> r.value
    ]
    val r4 = r3.key as TerminalExpression -> r3.value
    
    val r5 = r4.terminal("'")
    val r6 = r4.key -> r5.value
    
    return r6
  }
  
  /**
   * ('\\' '\'' | '\\' '\\' | !'\'' .)+
   */
  static def Pair<InTerminalChar, String> inTerminalChar(String input) {
    val r0 = new InTerminalChar -> input
    
    val r1 = r0.oneOrMore[
      val r1 = it
      val r2 = r1.oneOf([
        val r = it.terminal("\\'")
        return it.key.add(r.key.parsed) -> r.value
      ], [
        val r = it.terminal("\\\\")
        return it.key.add(r.key.parsed) -> r.value
      ], [
        return it.not([ terminal("'") ]) [
          return it.key.add(value.substring(0, 1)) -> value.substring(1)
        ]
      ]) as Pair<InTerminalChar, String>
      r1.key.parsed = r2.key.parsed
      return r1.key -> r2.value
    ]
    
    return r1
  }

  /**
   * char='.'
   */
  static def Pair<AnyCharExpression, String> anyCharExpression(String input) {
    val r0 = new AnyCharExpression -> input
    
    val r1 = r0.terminal('.')
    val r2 = (r0.key._char = r1.key.parsed) -> r1.value
    
    return r2
  }
  
  /**
   * name=ID
   */
  static def Pair<RuleReferenceExpression, String> ruleReferenceExpression(String input) {
    val r0 = new RuleReferenceExpression -> input
    
    val r1 = ID(r0.value)
    val r2 = (r0.key.name = r1.key) -> r1.value
    
    return r2
  }
  
  /**
   * 'EOI'
   */
  static def Pair<EndOfInputExpression, String> endOfInputExpression(String input) {
    val r0 = new EndOfInputExpression -> input

    val r1 = r0.terminal('EOI')
    val r2 = r0.key -> r1.value

    return r2
  }

  /**
   * '//' (!('\r'? '\n') .)*
   */
  static def Pair<Comment, String> comment(String input) {
    val r0 = new Comment -> input

    val r1 = r0.terminal('//')
    val r2 = r0.key -> r1.value
    
    val r3 = r2.zeroOrMore[
      val r3 = it
      // !('\r'? '\n') .
      val r4 = r3.not([
        val r4 = it
        val r5 = r4.optional[
          terminal('\r')
        ]
        r5.terminal('\n')
      ])[
        val r4 = it
        val r5 = r4.any()
        return r4.key -> r5.value
      ]
      return r3.key -> r4.value
    ]

    return r3
  }

  /**
   * ID ('.' ID)*
   */
  static def Pair<Fqtn, String> FQTN(String input) {
    val r0 = new Fqtn -> input
    
    val r1 = ID(r0.value)
    val r2 = r0.key.add(r1.key) as Fqtn -> r1.value
    
    val r3 = r2.zeroOrMore[
      val r3 = it
      val r4 = r3.terminal('.')
      val r5 = r3.key.add(r4.key) as Fqtn -> r4.value
      val r6 = ID(r5.value)
      val r7 = r5.key.add(r6.key) as Fqtn -> r6.value
      return r7
    ]
    
    return r3
  }

  /**
   * [a-zA-Z_] [a-zA-Z0-9_]*
   */
  static def Pair<Id, String> ID(String input) {
    val r0 = new Id -> input

    // [a-zA-Z_]
    val r1 = r0.terminal(('a' .. 'z') + ('A' .. 'Z') + '_')
    val r2 = r0.key.add(r1.key) as Id -> r1.value

    // [a-zA-Z0-9_]*
    val r4 = r2.zeroOrMore [
      val r3 = it
      val r4 = r3.terminal(('a' .. 'z') + ('A' .. 'Z') + ('0' .. '9') + '_')
      return r3.key.add(r4.key) as Id -> r4.value
    ]

    return r4
  }

  /**
   * ' ' | '\n' | '\t' | '\r'
   */
  static def Pair<Ws, String> WS(String input) {
    val r0 = new Ws -> input

    val r1 = r0.oneOf(
      [
        val r1 = it
        val r2 = r1.terminal(' ')
        return r1.key.add(r2.key) as Ws -> r2.value
      ],
      [
        val r1 = it
        val r2 = r1.terminal('\n')
        return r1.key.add(r2.key) as Ws -> r2.value
      ],
      [
        val r1 = it
        val r2 = r1.terminal('\t')
        return r1.key.add(r2.key) as Ws -> r2.value
      ],
      [
        val r1 = it
        val r2 = r1.terminal('\r')
        return r1.key.add(r2.key) as Ws -> r2.value
      ])

    return r1 as Pair<Ws, String>
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

  static def <T> terminal(Pair<T, String> in, CharacterRange range) {
    if (range.contains(in.value)) {
      new Terminal(in.value.charAt(0).toString()) -> in.value.substring(1)
    } else {
      throw new ParseException('Expected ' + range)
    }
  }

  static def <T> terminal(Pair<T, String> in, String str) {
    if (in.value.startsWith(str)) {
      new Terminal(str) -> in.value.substring(str.length)
    } else {
      throw new ParseException('Expected ' + str)
    }
  }
  
  static def <T> terminal(String in, String str) {
    if (in.startsWith(str)) {
      new Terminal(str) -> in.substring(str.length)
    } else {
      throw new ParseException('Expected ' + str)
    }
  }
  
  static def <T> any(Pair<T, String> in) {
    if (in.value.length > 0) {
      new Terminal(in.value.substring(0, 1)) -> in.value.substring(1)
    } else {
      throw new ParseException('Unexpected EOI')
    }
  }

  static def <T> any(String in) {
    if (in.length > 0) {
      new Terminal(in.substring(0, 1)) -> in.substring(1)
    } else {
      throw new ParseException('Unexpected EOI')
    }
  }

  static def <T> oneOf(Pair<T, String> in, (Pair<T, String>)=>Pair<? extends Object, String>... fns) {
    val pe = new ParseException('Expected one of ' + fns)
    for (fn : fns) {
      try {
        return fn.apply(in)
      } catch (ParseException e) {
        pe.add(e)
        // Ignore for now
      }
    }
    throw pe
  }

  static def <T> optional(Pair<T, String> in, (Pair<T, String>)=>Pair<? extends Object, String> fn) {
    try {
      return fn.apply(in)
    } catch (ParseException e) {
      // TODO: remember exception
      return in
    }
  }

  static def <T> oneOrMore(Pair<T, String> in, (Pair<T, String>)=>Pair<T, String> fn) {
    var r = in
    var once = false
    try {
      var t0 = r.key -> r.value
      while (true) {
        r = fn.apply(r)
        t0 = r
        once = true
      }
    } catch (ParseException e) {
      if (!once) {
        throw e
      }
    }
    return r
  }

  static def <T> zeroOrMore(Pair<T, String> in, (Pair<T, String>)=>Pair<T, String> fn) {
    var r = in
    var t1 = r
    try {
      while (true) {
        r = fn.apply(r)
        t1 = r
      }
    } catch (ParseException e1) {
      // TODO: remember exception
      r = t1
    }
    return r
  }
  
  static def <T> not(Pair<T, String> in, (Pair<T, String>)=>void test, (Pair<T, String>)=>Pair<T, String> fn) {
    try {
      test.apply(in)
    } catch (ParseException e) {
      return fn.apply(in)
    }
    throw new ParseException('TODO: not...')
  }

  static def <T> operator_plus(List<T> list, T item) {
    var result = newArrayList
    result += list
    result.add(item)
    return result
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

class Terminal {

  @Property
  String parsed

  new() {
  }

  new(String parsed) {
    this._parsed = parsed
  }

  def <T extends Terminal> T add(Terminal in) {
    val out = class.newInstance as T
    out.parsed = (this._parsed ?: '') + in._parsed
    return out
  }
  
  override toString() {
    parsed
  }

}

class Jpeg {

  @Property
  List<Rule> rules = newArrayList()

  def dispatch Jpeg add(Rule rule) {
    var _result = new Jpeg
    _result.rules = rules + rule
    return _result
  }

}

class Rule {

  @Property
  Id name

  @Property
  RuleReturns returns

  @Property
  Body body

  private def Rule copy() {
    val r = new Rule
    r._name = _name
    r._returns = _returns
    r._body = _body
    return r
  }

  def Rule setName(Id name) {
    val c = copy
    c._name = name
    return c
  }

  def Rule setReturns(RuleReturns returns) {
    val c = copy
    c._returns = returns
    return c
  }

  def Rule setBody(Body body) {
    val c = copy
    c._body = body
    return c
  }
  
  override toString() {
    body.toString()
  }

}

class RuleReturns {
  
  @Property
  Fqtn name
  
  private def RuleReturns copy() {
    val c = new RuleReturns
    c._name = _name
    return c
  }
  
  def RuleReturns setName(Fqtn name) {
    val c = copy
    c._name = name
    return c
  }
  
}

class Body {

  @Property
  List<Expression> expressions = newArrayList()

  def dispatch Body add(Expression expr) {
    var _result = new Body
    _result.expressions = expressions + expr
    return _result
  }
  
  override toString() {
    expressions.join(' ')
  }

}

class Expression {
}

class ChoiceExpression extends Expression {

  @Property
  List<SequenceExpression> choices = newArrayList()

  def dispatch ChoiceExpression add(SequenceExpression expr) {
    var _result = new ChoiceExpression
    _result.choices = choices + expr
    return _result
  }
  
  override toString() {
    choices.join(' | ')
  }

}

class SequenceExpression extends Expression {
  
  @Property
  List<Object> expressions = newArrayList
  
  def dispatch add(Object o) {
    val _r = new SequenceExpression
    _r.expressions = expressions + o
    return _r
  }
  
  override toString() {
    expressions.join(' ')
  }
  
}

class ActionExpression {
}

class AndPredicateExpression {
  
  @Property
  AtomicExpression expr
  
  private def AndPredicateExpression copy() {
    val r = new AndPredicateExpression
    r._expr = _expr
    return r
  }

  def AndPredicateExpression setExpr(AtomicExpression expr) {
    val c = copy
    c._expr = expr
    return c
  }

  override toString() {
    '&' + expr
  }
  
}

class NotPredicateExpression {

  @Property
  AtomicExpression expr
  
  private def NotPredicateExpression copy() {
    val r = new NotPredicateExpression
    r._expr = _expr
    return r
  }

  def NotPredicateExpression setExpr(AtomicExpression expr) {
    val c = copy
    c._expr = expr
    return c
  }
  
  override toString() {
    '!' + expr
  }

}

class OneOrMoreExpression {

  @Property
  AtomicExpression expr
  
  private def OneOrMoreExpression copy() {
    val r = new OneOrMoreExpression
    r._expr = _expr
    return r
  }

  def OneOrMoreExpression setExpr(AtomicExpression expr) {
    val c = copy
    c._expr = expr
    return c
  }
  
  override toString() {
    expr + '+'
  }

}

class ZeroOrMoreExpression {

  @Property
  AtomicExpression expr
  
  private def ZeroOrMoreExpression copy() {
    val r = new ZeroOrMoreExpression
    r._expr = _expr
    return r
  }

  def ZeroOrMoreExpression setExpr(AtomicExpression expr) {
    val c = copy
    c._expr = expr
    return c
  }
  
  override toString() {
    expr + '*'
  }

}

class OptionalExpression {

  @Property
  AtomicExpression expr
  
  private def OptionalExpression copy() {
    val r = new OptionalExpression
    r._expr = _expr
    return r
  }

  def OptionalExpression setExpr(AtomicExpression expr) {
    val c = copy
    c._expr = expr
    return c
  }
  
  override toString() {
    expr + '?'
  }

}

class AtomicExpression {
}

class AssignableExpression extends AtomicExpression {
  
  @Property
  Id property
  
  @Property
  AssignmentOperator op
  
  @Property
  Object expr
  
  private def AssignableExpression copy() {
    val r = new AssignableExpression
    r._property = _property
    r._op = _op
    r._expr = _expr
    return r
  }

  def AssignableExpression setProperty(Id property) {
    val c = copy
    c._property = property
    return c
  }
  
  def AssignableExpression setOp(AssignmentOperator op) {
    val c = copy
    c._op = op
    return c
  }

  def AssignableExpression setExpr(Object expr) {
    val c = copy
    c._expr = expr
    return c
  }
  
  override toString() {
    (if (property != null) property + '' + op else '') + expr
  }

}

class AssignmentOperator {
  
  @Property
  Terminal single
  
  @Property
  Terminal multi
  
  private def AssignmentOperator copy() {
    val r = new AssignmentOperator
    r._single = _single
    r._multi = _multi
    return r
  }
  
  def AssignmentOperator setSingle(Terminal single) {
    val c = copy
    c._single = single
    return c
  }

  def AssignmentOperator setMulti(Terminal multi) {
    val c = copy
    c._multi = multi
    return c
  }
  
  override toString() {
    if (single != null) single.toString() else multi.toString()
  }

}

class SubExpression {

  @Property
  ChoiceExpression expr
  
  private def SubExpression copy() {
    val r = new SubExpression
    r._expr = _expr
    return r
  }

  def SubExpression setExpr(ChoiceExpression expr) {
    val c = copy
    c._expr = expr
    return c
  }
  
  override toString() {
    '(' + expr + ')'
  }

}

class RangeExpression {
  
  @Property
  Terminal dash
  
  @Property
  List<Object> ranges = newArrayList
  
  private def RangeExpression copy() {
    val r = new RangeExpression
    r._dash = _dash
    r._ranges = _ranges
    return r
  }
  
  def RangeExpression setDash(Terminal dash) {
    val c = copy
    c._dash = dash
    return c
  }
  
  def dispatch add(Object o) {
    val _r = new RangeExpression
    _r._ranges = _ranges + o
    return _r
  }
  
  override toString() {
    '[' + (if (dash != null) dash else '') + ranges.join() + ']'
  }

}

class MinMaxRange {
  
  @Property
  Terminal min
  
  @Property
  Terminal max
  
  private def MinMaxRange copy() {
    val r = new MinMaxRange
    r._min = _min
    r._max = _max
    return r
  }
  
  public def MinMaxRange setMin(Terminal min) {
    val c = copy
    c._min = min
    return c
  }

  public def MinMaxRange setMax(Terminal max) {
    val c = copy
    c._max = max
    return c
  }
  
  override toString() {
    min + '-' + max
  }

}

class CharRange {

  @Property
  Terminal _char
  
  private def CharRange copy() {
    val r = new CharRange
    r.__char = __char
    return r
  }
  
  public def CharRange set_char(Terminal _char) {
    val c = copy
    c.__char = _char
    return c
  }
  
  override toString() {
    _char.toString()
  }

}

class TerminalExpression {
  
  @Property
  InTerminalChar value
  
  private def TerminalExpression copy() {
    val r = new TerminalExpression
    r._value = _value
    return r
  }

  def TerminalExpression setValue(InTerminalChar value) {
    val c = copy
    c._value = value
    return c
  }
  
  override toString() {
    "'" + value + "'"
  }

}

class InTerminalChar {
  
  @Property
  String parsed

  def InTerminalChar add(String in) {
    val out = new InTerminalChar
    out._parsed = (this._parsed ?: '') + in
    return out
  }
  
  override toString() {
    parsed
  }

}

class AnyCharExpression {
  
  @Property
  String _char
  
  private def AnyCharExpression copy() {
    val r = new AnyCharExpression
    r.__char = __char
    return r
  }

  def AnyCharExpression set_char(String _char) {
    val c = copy
    c.__char = _char
    return c
  }
  
  override toString() {
    _char
  }

}

class RuleReferenceExpression {

  @Property
  Id name
  
  private def RuleReferenceExpression copy() {
    val r = new RuleReferenceExpression
    r._name = _name
    return r
  }

  def RuleReferenceExpression setName(Id name) {
    val c = copy
    c._name = name
    return c
  }
  
  override toString() {
    name.toString()
  }

}

class EndOfInputExpression extends AtomicExpression {
  
  override toString() {
    'EOI'
  }
  
}

class Comment {
}

class Fqtn extends Terminal {
}

class Id extends Terminal {
}

class Ws extends Terminal {
}

class Eoi extends Terminal {
}
