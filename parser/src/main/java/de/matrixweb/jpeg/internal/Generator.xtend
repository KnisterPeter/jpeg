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
    package «packageName»
    
    import java.util.List
    
    import static extension «packageName».CharacterConsumer.*
    import static extension «packageName».CharacterRange.*

    class Parser {
      
      int line = 1
      int column = 1
      
      package def addMatch(String match) {
        var s = match
        var idx = s.indexOf('\n')
        while (idx != -1) {
          column = 1
          line = line + 1
          s = s.substring(idx + 1)
        }
        column = column + s.length
      }
      
      package def getLocation() {
        line -> column
      }
      
      «FOR rule : jpeg.rules.filter[!types.get(name.parsed).internal]»
        «new RuleGenerator(rule, jpeg, types).generate()»
      «ENDFOR»
      
    }
    
    class ParseException extends RuntimeException {
      
      @Property
      List<ParseException> causes
      
      @Property
      Pair<Integer, Integer> location
      
      new(String message, Pair<Integer, Integer> location) {
        super(message)
        this.location = location
      }
      
      def add(ParseException e) {
        causes = causes ?: newArrayList
        causes += e
      }
      
      override toString() {
        'ParseException [' + location.key + ',' + location.value + '] ' + super.toString() + if (causes != null) ':\n' + causes.join('\n') else ''
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
    
      def contains(String s) {
        s.length > 0 && chars.contains(s.substring(0, 1))
      }
      
      override toString() {
        chars
      }
    
    }

    package class CharacterConsumer {
    
      static def Pair<Eoi, String> eoi(String input, Parser parser) {
        val r0 = new Eoi -> input
    
        if (input.length > 0) {
          throw new ParseException('Expected EOI', parser.location)
        }
    
        return r0
      }
    
      static def <T> terminal(String in, String str, Parser parser) {
        if (in.startsWith(str)) {
          parser.addMatch(str)
          new Terminal(str) -> in.substring(str.length)
        } else {
          throw new ParseException("Expected '" + str + "'", parser.location)
        }
      }
      
      static def <T> terminal(String in, CharacterRange range, Parser parser) {
        if (range.contains(in)) {
          val match = in.charAt(0).toString()
          parser.addMatch(match)
          new Terminal(match) -> in.substring(1)
        } else {
          throw new ParseException('Expected [' + range + ']', parser.location)
        }
      }
    
      static def <T> any(String in, Parser parser) {
        if (in.length > 0) {
          val match = in.substring(0, 1)
          parser.addMatch(match)
          new Terminal(match) -> in.substring(1)
        } else {
          throw new ParseException('Unexpected EOI', parser.location)
        }
      }
    
    }
    
  '''
  
  static def generateTypes(Collection<JType> types) '''
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
  
    class Terminal extends Result {
    
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
    this.jpeg = jpeg
    this.types = types
  }
  
  def generate() '''
    //--------------------------------------------------------------------------
    
    def «resultType.name» «name.toFirstUpper»(String in) {
      val result = «name.toFirstLower»(in)
      return 
        if (result.value.length == 0) 
          result.key 
        else 
          throw new ParseException("Unexpected end of input", location)
    }
    
    /**
     * «rule»
     */
    package def Pair<? extends «resultType.name», String> «name.toFirstLower()»(String in) {
      «IF rule.simpleRule»
        «if(true) { inSimpleChoice = true; ''}»
        val tail = in
        «rule.body.create()»
        «if(true) { inSimpleChoice = false; ''}»
      «ELSE»
        var result = new «name»
        var tail = in
        
        «rule.body.create()»
        
        «optimize()»
        result.parsed = in.substring(0, in.length - tail.length)
        return result -> tail
      «ENDIF»
    }
    
    «subFunctions.join('\n')»
  '''
  
  private def optimize() '''
    «IF types.get(name).isResultOptimizable(resultType, types)»
      «val attr = types.get(name).attributes.head.name»
      if (result.«attr».size() == 1) {
        return result.«attr».get(0) -> tail
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
    try {
      return «exprs.head.create()»
    } catch (ParseException «nextException») {
      «IF !exprs.tail.empty»
        «exprs.tail.generateSimpleChoices()»
      «ELSE»
        throw «exception»
      «ENDIF»
    }
  '''
  
  def CharSequence generateChoices(Iterable<Expression> exprs) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    val «currentBackup» = result.copy()
    val «tailBackup» = tail
    try {
      «exprs.head.create()»
    } catch (ParseException «nextException») {
      result = «currentBackup»
      tail = «tailBackup»
      «IF !exprs.tail.empty»
        «exprs.tail.generateChoices()»
      «ELSE»
        throw «exception»
      «ENDIF»
    }
  '''

  def dispatch CharSequence create(SequenceExpression expr) '''
    «FOR e : expr.expressions SEPARATOR '\n'»
      «e.create()»
    «ENDFOR»
  '''
  
  def dispatch CharSequence create(AndPredicateExpression expr) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    val «currentBackup» = result.copy()
    val «tailBackup» = tail
    try {
    «expr.expr.create()»
    } finally {
      result = «currentBackup»
      tail = «tailBackup»
    }
  '''
  
  def dispatch CharSequence create(NotPredicateExpression expr) '''
    «val currentLoop = nextLoop»
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    val «currentBackup» = result.copy()
    val «tailBackup» = tail
    var «currentLoop» = true
    try {
      «expr.expr.create()»
      «currentLoop» = false
      throw new ParseException('Expected...', location)
    } catch (ParseException «nextException») {
      if (!«currentLoop») throw «exception»
    } finally {
      result = «currentBackup»
      tail = «tailBackup»
    }
  '''
  
  def dispatch CharSequence create(OneOrMoreExpression expr) '''
    «val currentLoop = nextLoop»
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    // «expr»
    var «currentBackup» = result
    var «tailBackup» = tail
    var «currentLoop» = false
    try {
      while (true) {
        «expr.expr.create()»
        
        «currentLoop» = true
        «currentBackup» = result
        «tailBackup» = tail
      }
    } catch (ParseException «nextException») {
      if (!«currentLoop») {
        result = «currentBackup»
        tail = «tailBackup»
        throw «exception»
      }
    }
  '''
  
  def dispatch CharSequence create(ZeroOrMoreExpression expr) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    // «expr»
    var «currentBackup» = result
    var «tailBackup» = tail
    try {
      while (true) {
        «expr.expr.create()»
        «currentBackup» = result
        «tailBackup» = tail
      }
    } catch (ParseException «nextException») {
      result = «currentBackup»
      tail = «tailBackup»
    }
  '''
  
  def dispatch CharSequence create(OptionalExpression expr) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    // «expr»
    val «currentBackup» = result.copy()
    val «tailBackup» = tail
    try {
      «expr.expr.create()»
    } catch (ParseException «nextException») {
      result = «currentBackup»
      tail = «tailBackup»
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
        val «nextResult» = tail.«currentSubFunction»()
        tail = «result».value
      «ELSE»
        «expr.expr.create()»
      «ENDIF»
      «IF expr.op.multi != null»
        result.add(«result».key)
      «ELSE»
        result.«expr.propertyName» = «result».key
      «ENDIF»
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
    private def Pair<? extends «resultType.name», String> «subFunction»(String in) {
      «IF expr.expr.simpleChoiceExpression»
        «if(true) { inSimpleChoice = true; ''}»
        val tail = in
        «expr.expr.create()»
        «if(true) { inSimpleChoice = false; ''}»
      «ELSE»
        var «resultType.name» result = new «resultType.name»
        var tail = in
        
        «expr.expr.create()»
        
        result.parsed = in.substring(0, in.length - tail.length)
        return result -> tail
      «ENDIF»
    }
  '''
  
  def dispatch CharSequence create(SubExpression expr) '''
    «expr.expr.create()»
  '''
  
  def dispatch CharSequence create(RuleReferenceExpression expr) '''
    «IF inSimpleChoice»
      tail.«expr.name.parsed.toFirstLower»()
    «ELSE»
      val «nextResult» = tail.«expr.name.parsed.toFirstLower»()
      tail = «result».value
    «ENDIF»
  '''
  
  def dispatch CharSequence create(RangeExpression expr) '''
    // «expr»
    val «nextResult» = tail.terminal(
      «FOR range : expr.ranges SEPARATOR ' + '»
        «range.create()»
      «ENDFOR»
      «IF expr.dash != null»«IF !expr.ranges.empty» + «ENDIF»'-'«ENDIF»
      , this)
    tail = «result».value
  '''
  
  def dispatch CharSequence create(MinMaxRange range) '''
    ('«range.min»'..'«range.max»')
  '''
  
  def dispatch CharSequence create(CharRange range) '''
    '«range._char»'
  '''
  
  def dispatch CharSequence create(AnyCharExpression expr) '''
    // «expr»
    val «nextResult» =  tail.any(this)
    tail = «result».value
  '''
  
  def dispatch CharSequence create(TerminalExpression expr) '''
    // «expr»
    val «nextResult» =  tail.terminal('«expr.value.parsed»', this)
    tail = «result».value
  '''
  
  def dispatch CharSequence create(EndOfInputExpression expr) '''
    // «expr»
    val «nextResult» = tail.eoi(this)
    tail = «result».value
  '''
  
  private def getName() {
    rule.name.parsed
  }
  
  private def getResultType() {
    types.get(rule?.returns?.name?.parsed ?: name)
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
