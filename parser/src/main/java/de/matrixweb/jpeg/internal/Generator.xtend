package de.matrixweb.jpeg.internal

import java.util.Collection
import java.util.List
import java.util.Map

import static extension de.matrixweb.jpeg.internal.AstOptimizer.*
import static extension de.matrixweb.jpeg.internal.ExpressionTypeEvaluator.*
import static extension de.matrixweb.jpeg.internal.GeneratorHelper.*

/**
 * @author markusw
 */
class Generator {
  
  static def generateParser(Jpeg jpeg, Map<String, JType> types, String packageName) '''
    «val rules = jpeg.rules.filter[!types.get(name.parsed).internal]»
    package «packageName»
    
    import java.util.List
    
    import static extension «packageName».CharacterRange.*

    class Parser {
      
      static Result<Object> CONTINUE = new Result<Object>(new Object, null)
      static Result<Object> BREAK = new Result<Object>(null, null)
      
      char[] chars
      
      package def Derivation parse(int idx) {
        new Derivation(idx, «FOR rule : rules SEPARATOR ','»[«rule.name.parsed.toFirstLower»()]«ENDFOR»,
          [
            return 
              if (chars.length == idx) new Result<Character>(null, parse(idx))
              else new Result<Character>(chars.get(idx), parse(idx + 1))
          ])
      }
      
      static def <T> __terminal(Derivation derivation, String str, Parser parser) {
        var n = 0
        var d = derivation
        while (n < str.length) {
          val r = d.dvChar
          if (r.node == null || r.node != str.charAt(n)) {
            return new Result<Terminal>(null, derivation)
          }
          n = n + 1
          d = r.derivation
        }
        new Result<Terminal>(new Terminal(str), d)
      }
      
      static def <T> __oneOfThese(Derivation derivation, CharacterRange range, Parser parser) {
        val r = derivation.dvChar
        return 
          if (r.node != null && range.contains(r.node)) new Result<Terminal>(new Terminal(r.node), r.derivation)
          else new Result<Terminal>(null, derivation)
      }
    
      static def <T> __any(Derivation derivation, Parser parser) {
        val r = derivation.dvChar
        return
          if (r.node != null) new Result<Terminal>(new Terminal(r.node), r.derivation)
          else  new Result<Terminal>(null, derivation)
      }

      «FOR rule : rules»
        «new RuleGenerator(rule, jpeg, types).generate()»
      «ENDFOR»
      
    }
    
    package class Derivation {
      
      int idx
      
      «FOR rule : rules»
        val (Derivation)=>Result<? extends «rule.getResultType(types).name»> dvf«rule.name.parsed.toFirstUpper»
      «ENDFOR»
      val (Derivation)=>Result<Character> dvfChar
      
      «FOR rule : rules»
        Result<? extends «rule.getResultType(types).name»> dv«rule.name.parsed.toFirstUpper»
      «ENDFOR»
      Result<Character> dvChar
      
      new(int idx, «FOR rule : rules SEPARATOR ', '»(Derivation)=>Result<? extends «rule.getResultType(types).name»> dvf«rule.name.parsed.toFirstUpper»«ENDFOR», (Derivation)=>Result<Character> dvfChar) {
        this.idx = idx
        «FOR rule : rules»
          this.dvf«rule.name.parsed.toFirstUpper» = dvf«rule.name.parsed.toFirstUpper»
        «ENDFOR»
        this.dvfChar = dvfChar
      }
      
      def getIndex() {
        idx
      }
      
      «FOR rule : rules»
        «val uname = rule.name.parsed.toFirstUpper»
        def getDv«uname»() {
          if (dv«uname» == null) {
            dv«uname» = dvf«uname».apply(this)
          }
          return dv«uname»
        }
        
      «ENDFOR»
      
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

  '''
  
  static def generateTypes(Collection<JType> types) '''
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
    
    «FOR type : types»
      «type.generateType()»
    «ENDFOR»
  '''
  
  private static def generateType(JType type) '''
    «IF type.generate»
      class «type.name»«IF type.supertype != null» extends «type.supertype.name»«ENDIF» {
        
        «FOR attribute : type.attributes»
          «attribute.generateAttribute(type)»
        «ENDFOR»
        «type.attributes.generateAttributeMethods(type)»
        
      }
      
    «ENDIF»
  '''
  
  private static def generateAttribute(JAttribute attribute, JType type) '''
    «val name = attribute.name»
    @Property
    «attribute.type.name»«IF attribute.typeParameter != null»<«attribute.typeParameter.name»>«ENDIF» «name»
    
    «val typeParameter = attribute.typeParameter»
    «IF typeParameter != null»
      def dispatch void add(«typeParameter.name» __«typeParameter.name.toFirstLower») {
        _«name» = _«name» ?: newArrayList
        _«name» += __«typeParameter.name.toFirstLower»
      }
      
    «ENDIF»
  '''
  
  private static def generateAttributeMethods(List<JAttribute> attributes, JType type) '''
    override «type.name» copy() {
      val r = new «type.name»
      «FOR attribute : attributes»
        r._«attribute.name» = _«attribute.name»
      «ENDFOR»
      return r
    }
  '''

}

class RuleGenerator {
  
  Rule rule
  
  JType type
  
  JType resultType
  
  Jpeg jpeg
  
  Map<String, JType> types
  
  List<String> subFunctions = newArrayList
  
  int exceptionCounter = -1
  
  int resultCounter = -1
  
  int loopCounter = -1
  
  int backupCounter = -1
  
  int subCounter = -1
  
  boolean inSimpleChoice = false
  
  new(Rule rule, Jpeg jpeg, Map<String, JType> types) {
    this.rule = rule
    this.type = rule.getType(types)
    this.resultType = rule.getResultType(types)
    this.jpeg = jpeg
    this.types = types
  }
  
  def generate() '''
    //--------------------------------------------------------------------------
    
    def «resultType.name» «name.toFirstUpper»(String in) {
      this.chars = in.toCharArray()
      val result = «name.toFirstLower»(parse(0))
      return
        if (result.derivation.dvChar.node == null) result.node
        else throw new ParseException("Unexpected end of input")
    }
    
    /**
     * «rule»
     */
    package def Result<? extends «resultType.name»> «name.toFirstLower()»(Derivation derivation) {
      «IF rule.simpleRule»
        «if(true) { inSimpleChoice = true; ''}»
        val d = derivation
        «rule.body.create()»
        «if(true) { inSimpleChoice = false; ''}»
      «ELSE»
        var Result<?> result = null
        var node = new «name»
        var d = derivation
        
        «rule.body.create()»
        
        if (result.node != null) {
          «optimize()»
          node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
          return new Result<«resultType.name»>(node, d)
        }
        return new Result<«resultType.name»>(null, derivation)
      «ENDIF»
    }
    
    «subFunctions.join('\n')»
  '''
  
  private def optimize() '''
    «IF type.isResultOptimizable(resultType, types)»
      «val attr = type.attributes.head.name»
      if (node.«attr».size() == 1) {
        return new Result<«resultType.name»>(node.«attr».get(0), d)
      }
    «ENDIF»
  '''
  
  def dispatch CharSequence create(Object o) '''
    // TODO: «o.class»
  '''
  
  def dispatch CharSequence create(Body body) '''
    «FOR expr : body.expressions»
      «expr.create()»
    «ENDFOR»
  '''
  
  def dispatch CharSequence create(ChoiceExpression expr) '''
    // «expr»
    «IF inSimpleChoice»
      «expr.choices.generateSimpleChoices()»
    «ELSE»
      «expr.choices.generateChoices()»
    «ENDIF»
  '''
  
  def CharSequence generateSimpleChoices(Iterable<Expression> exprs) '''
    result = «exprs.head.create()»
    if (result.node == null) {
      «IF !exprs.tail.empty»
        «exprs.tail.generateSimpleChoices()»
      «ENDIF»
    }
  '''
  
  def CharSequence generateChoices(Iterable<Expression> exprs) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    val «currentBackup» = node.copy()
    val «tailBackup» = d
    
    «exprs.head.create()»
    if (result.node == null) {
      node = «currentBackup»
      d = «tailBackup»
      «IF !exprs.tail.empty»
        «exprs.tail.generateChoices()»
      «ENDIF»
    }
  '''

  def dispatch CharSequence create(SequenceExpression expr) '''
    «var first = true»
    «FOR e : expr.expressions SEPARATOR '\n'»
      «IF first»
        «e.create()»
        «if (first = false) '' else ''»
      «ELSE»
        if (result.node != null) {
          «e.create()»
        }
      «ENDIF»
    «ENDFOR»
  '''
  
  def dispatch CharSequence create(AndPredicateExpression expr) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    val «currentBackup» = node.copy()
    val «tailBackup» = d
    «expr.expr.create()»
    node = «currentBackup»
    d = «tailBackup»
  '''
  
  def dispatch CharSequence create(NotPredicateExpression expr) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    val «currentBackup» = node.copy()
    val «tailBackup» = d
    «expr.expr.create()»
    node = «currentBackup»
    d = «tailBackup»
    if (result.node != null) {
      result = BREAK
    } else {
      result = CONTINUE
    }
  '''
  
  def dispatch CharSequence create(OneOrMoreExpression expr) '''
    «val currentLoop = nextLoop»
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    // «expr»
    var «currentBackup» = node.copy()
    var «tailBackup» = d
    var «currentLoop» = false
    
    do {
      «expr.expr.create()»
      
      if (result.node != null) {
        «currentLoop» = true
        «currentBackup» = node.copy()
        «tailBackup» = d
      }
    } while(result.node != null)
    if (!«currentLoop») {
      node = «currentBackup»
      d = «tailBackup»
    } else {
      result = CONTINUE
    }
  '''
  
  def dispatch CharSequence create(ZeroOrMoreExpression expr) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    // «expr»
    var «currentBackup» = node.copy()
    var «tailBackup» = d
    
    do {
      «expr.expr.create()»
      if (result.node != null) {
        «currentBackup» = node.copy()
        «tailBackup» = d
      }
    } while (result.node != null)
    node = «currentBackup»
    d = «tailBackup»
    result = CONTINUE
  '''
  
  def dispatch CharSequence create(OptionalExpression expr) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    // «expr»
    val «currentBackup» = node.copy()
    val «tailBackup» = d
    
    «expr.expr.create()»
    if (result.node == null) {
      node = «currentBackup»
      d = «tailBackup»
      result = CONTINUE
    }
  '''
  
  def dispatch CharSequence create(AssignableExpression expr) '''
    «IF !inSimpleChoice»
      // «expr»
    «ENDIF»
    «IF expr.property != null»
      «IF expr.expr instanceof SubExpression»
        «val currentSubFunction = name.toFirstLower() + '_' + nextSubFunction»
        «if(subFunctions += (expr.expr as SubExpression).createSubFunction(currentSubFunction)) '' else ''»
        val «nextResult» = d.«currentSubFunction»()
        d = «result».derivation
        result = «result»
      «ELSE»
        «expr.expr.create()»
      «ENDIF»
      if (result.node != null) {
        «IF expr.op.multi != null»
          node.add(«result».node)
        «ELSE»
          node.«expr.propertyName» = «result».node
        «ENDIF»
      }
    «ELSE»
      «expr.expr.create()»
    «ENDIF»
  '''
  
  def private getPropertyName(AssignableExpression expr) {
    if (#['char'].contains(expr.property.parsed)) {
      return '_' + expr.property.parsed
    }
    return expr.property.parsed
  }
  
  private def String createSubFunction(SubExpression expr, String subFunction) '''
    «val resultType = expr.evaluateType(jpeg, types)»
    private def Result<? extends «resultType.name»> «subFunction»(Derivation derivation) {
      «IF expr.expr.simpleChoiceExpression»
        «if(true) { inSimpleChoice = true; ''}»
        var Result<?> result = null
        val d = derivation
        «expr.expr.create()»
        return result as Result<? extends «resultType.name»>
        «if(true) { inSimpleChoice = false; ''}»
      «ELSE»
        var Result<?> result = null
        var «resultType.name» node = new «resultType.name»
        val d = derivation
        
        «expr.expr.create()»
        
        if (result.node != null) {
          node.parsed = new String(chars, derivation.getIndex(), d.getIndex() - derivation.getIndex());
          return new Result<«resultType.name»>(node, d)
        }
        return new Result<«resultType.name»>(null, derivation)
      «ENDIF»
    }
  '''
  
  def dispatch CharSequence create(SubExpression expr) '''
    «expr.expr.create()»
  '''
  
  def dispatch CharSequence create(RuleReferenceExpression expr) '''
    «IF inSimpleChoice»
      d.dv«expr.name.parsed.toFirstUpper»
    «ELSE»
      val «nextResult» = d.dv«expr.name.parsed.toFirstUpper»
      d = «result».derivation
      result = «result»
    «ENDIF»
  '''
  
  def dispatch CharSequence create(RangeExpression expr) '''
    // «expr»
    val «nextResult» = d.__oneOfThese(
      «FOR range : expr.ranges SEPARATOR ' + '»
        «range.create()»
      «ENDFOR»
      «IF expr.dash != null»«IF !expr.ranges.empty» + «ENDIF»'-'«ENDIF»
      , this)
    d = «result».derivation
    result = «result»
  '''
  
  def dispatch CharSequence create(MinMaxRange range) '''
    ('«range.min»'..'«range.max»')
  '''
  
  def dispatch CharSequence create(CharRange range) '''
    '«range._char»'
  '''
  
  def dispatch CharSequence create(AnyCharExpression expr) '''
    // «expr»
    val «nextResult» =  d.__any(this)
    d = «result».derivation
    result = «result»
  '''
  
  def dispatch CharSequence create(TerminalExpression expr) '''
    val «nextResult» =  d.__terminal('«expr.value.parsed»', this)
    d = «result».derivation
    result = «result»
  '''
  
  private def getName() {
    rule.name.parsed
  }
  
  private def getException() {
    return 'e' + exceptionCounter
  }
  
  private def nextException() {
    exceptionCounter = exceptionCounter + 1
    return getException()
  }
  
  private def getResult() {
    return 'result' + resultCounter
  }
  
  private def nextResult() {
    resultCounter = resultCounter + 1
    return getResult()
  }
  
  private def getLoop() {
    return 'loop' + loopCounter
  }
  
  private def nextLoop() {
    loopCounter = loopCounter + 1
    return getLoop()
  }
  
  private def getBackup() {
    return 'backup' + backupCounter
  }
  
  private def nextBackup() {
    backupCounter = backupCounter + 1
    return getBackup()
  }
  
  private def getSubFunction() {
    return 'sub' + subCounter
  }
  
  private def nextSubFunction() {
    subCounter = subCounter + 1
    return getSubFunction()
  }
  
}
