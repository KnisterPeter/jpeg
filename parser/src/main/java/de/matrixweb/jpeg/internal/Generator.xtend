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
    
    import java.util.Set
    
    import static extension «packageName».CharacterRange.*
    import static extension «packageName».Parser.*

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

      «FOR rule : rules»
        «new RuleGenerator(rule, jpeg, types).generateRuleMethod()»
      «ENDFOR»
      
    }
    
    «FOR rule : rules»
      «new RuleGenerator(rule, jpeg, types).generateRuleClass()»
    «ENDFOR»
      
    package class Derivation {
      
      Parser parser
      
      int idx
      
      val (Derivation)=>Result<Character> dvfChar
      
      «FOR rule : rules»
        Result<? extends «rule.getResultType(types).name»> dv«rule.name.parsed.toFirstUpper»
      «ENDFOR»
      Result<Character> dvChar
      
      new(Parser parser, int idx, (Derivation)=>Result<Character> dvfChar) {
        this.parser = parser
        this.idx = idx
        this.dvfChar = dvfChar
      }
      
      def getIndex() {
        idx
      }
      
      «FOR rule : rules»
        «val uname = rule.name.parsed.toFirstUpper»
        def getDv«uname»() {
          if (dv«uname» == null) {
            // Fail LR upfront
            dv«uname» = new Result<«uname»>(null, this, new ParseInfo(index, 'Detected left-recursion in «uname»'))
            dv«uname» = «uname»Rule.match«uname»(parser, this)
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
    
  '''
  
  static def generateTypes(Collection<JType> types, String packageName) '''
    package «packageName»
    
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
    
    «FOR type : types»
      «type.generateType()»
    «ENDFOR»
  '''
  
  private static def generateType(JType type) '''
    «IF type.generate»
      «IF type.internal»abstract«ENDIF» class «type.name»«IF type.supertype != null» extends «type.supertype.name»«ENDIF» {
        
        «FOR attribute : type.attributes»
          «attribute.generateAttribute(type)»
        «ENDFOR»
        «type.attributes.generateAttributeMethods(type)»
        
      }
      
    «ENDIF»
  '''
  
  private static def generateAttribute(JAttribute attribute, JType type) '''
    «val name = attribute.name.toFirstUpper»
    «val typeName = attribute.type.name + if (attribute.typeParameter != null) '<' + attribute.typeParameter.name + '>' else ''»
    «typeName» attr«name»
    
    def get«name»() { attr«name» }
    def set«name»(«typeName» attr«name») { this.attr«name» = attr«name» }
    
    «val typeParameter = attribute.typeParameter»
    «IF typeParameter != null»
      def dispatch void add(«typeParameter.name» __«typeParameter.name.toFirstLower») {
        this.attr«name» = this.attr«name» ?: newArrayList
        this.attr«name» += __«typeParameter.name.toFirstLower»
      }
      
    «ENDIF»
  '''
  
  private static def generateAttributeMethods(List<JAttribute> attributes, JType type) '''
    «IF type.internal»
      override «type.name» copy()
    «ELSE»
      override «type.name» copy() {
        val r = new «type.name»
        «FOR attribute : attributes»
          r.attr«attribute.name.toFirstUpper» = this.attr«attribute.name.toFirstUpper»
        «ENDFOR»
        return r
      }
    «ENDIF»
  '''

}

class RuleGenerator {
  
  Rule rule
  
  JType type
  
  JType resultType
  
  Jpeg jpeg
  
  Map<String, JType> types
  
  List<String> subFunctions = newArrayList
  
  int resultCounter = -1
  
  int loopCounter = -1
  
  int backupCounter = -1
  
  int subCounter = -1
  
  boolean inPredicate = false
  
  new(Rule rule, Jpeg jpeg, Map<String, JType> types) {
    this.rule = rule
    this.type = rule.getType(types)
    this.resultType = rule.getResultType(types)
    this.jpeg = jpeg
    this.types = types
  }
  
  def generateRuleMethod() '''
    def «resultType.name» «name.toFirstUpper»(String in) {
      this.chars = in.toCharArray()
      val result = «name.toFirstUpper»Rule.match«name.toFirstUpper»(this, parse(0))
      return
        if (result.derivation.dvChar.node == null) result.node
        else throw new ParseException(result.info.position.lineAndColumn, result.info.messages)
    }
    
  '''
  
  def generateRuleClass() '''
    package class «name.toFirstUpper»Rule {
    
      /**
       * «rule.escapeJavadoc.escaped»
       */
      package static def Result<? extends «resultType.name»> match«name.toFirstUpper»(Parser parser, Derivation derivation) {
          var Result<?> result = null
          var node = new «name»
          var d = derivation
          
          «rule.body.create()»
          
          if (result.node != null) {
            «optimize()»
            node.index = derivation.index
            node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
            return new Result<«resultType.name»>(node, d, result.info)
          }
          return new Result<«resultType.name»>(null, derivation, result.info)
      }
      
      «subFunctions.join('\n')»
      
    }
  '''
  
  private def escapeJavadoc(Rule rule) {
    rule.toString().replace('*/', '*&#47;')
  }
  
  private def optimize() '''
    «IF type.isResultOptimizable(resultType, types)»
      «val attr = type.attributes.head.name»
      if (node.«attr».size() == 1) {
        return new Result<«resultType.name»>(node.«attr».get(0), d, result.info)
      }
    «ENDIF»
  '''
  
  def dispatch CharSequence create(Object o) '''
    throw new IllegalArgumentException('Unable to create ' + o.name)
  '''
  
  def dispatch CharSequence create(Body body) '''
    «FOR expr : body.expressions»
      «expr.create()»
    «ENDFOR»
  '''
  
  def dispatch CharSequence create(ChoiceExpression expr) '''
    // «expr.parsed.escaped»
    «expr.choices.generateChoices()»
  '''
  
  def CharSequence generateChoices(Iterable<Expression> exprs) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    val «currentBackup» = node?.copy()
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
    «if (inPredicate = true) '' else ''»
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    val «currentBackup» = node?.copy()
    val «tailBackup» = d
    «expr.expr.create()»
    node = «currentBackup»
    d = «tailBackup»
    «if (inPredicate = false) '' else ''»
  '''
  
  def dispatch CharSequence create(NotPredicateExpression expr) '''
    «if (inPredicate = true) '' else ''»
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    val «currentBackup» = node?.copy()
    val «tailBackup» = d
    «expr.expr.create()»
    node = «currentBackup»
    d = «tailBackup»
    if (result.node != null) {
      result = BREAK.joinErrors(result, «inPredicate»)
    } else {
      result = CONTINUE.joinErrors(result, «inPredicate»)
    }
    «if (inPredicate = false) '' else ''»
  '''
  
  def dispatch CharSequence create(OneOrMoreExpression expr) '''
    «val currentLoop = nextLoop»
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    // «expr.parsed.escaped»
    var «currentBackup» = node?.copy()
    var «tailBackup» = d
    var «currentLoop» = false
    
    do {
      «expr.expr.create()»
      
      if (result.node != null) {
        «currentLoop» = true
        «currentBackup» = node?.copy()
        «tailBackup» = d
      }
    } while(result.node != null)
    if (!«currentLoop») {
      node = «currentBackup»
      d = «tailBackup»
    } else {
      result = CONTINUE.joinErrors(result, «inPredicate»)
    }
  '''
  
  def dispatch CharSequence create(ZeroOrMoreExpression expr) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    // «expr.parsed.escaped»
    var «currentBackup» = node?.copy()
    var «tailBackup» = d
    
    do {
      «expr.expr.create()»
      if (result.node != null) {
        «currentBackup» = node?.copy()
        «tailBackup» = d
      }
    } while (result.node != null)
    node = «currentBackup»
    d = «tailBackup»
    result = CONTINUE.joinErrors(result, «inPredicate»)
  '''
  
  def dispatch CharSequence create(OptionalExpression expr) '''
    «val currentBackup = nextBackup»
    «val tailBackup = nextBackup»
    // «expr.parsed.escaped»
    val «currentBackup» = node?.copy()
    val «tailBackup» = d
    
    «expr.expr.create()»
    if (result.node == null) {
      node = «currentBackup»
      d = «tailBackup»
      result = CONTINUE.joinErrors(result, «inPredicate»)
    }
  '''
  
  def dispatch CharSequence create(AssignableExpression expr) '''
    // «expr.parsed.escaped»
    «IF expr.property != null»
      «IF expr.expr instanceof SubExpression»
        «val currentSubFunction = nextSubFunction + 'Match' + name.toFirstUpper»
        «if(subFunctions += (expr.expr as SubExpression).createAssignedSubExpressionFunction(currentSubFunction)) '' else ''»
        val «nextResult» = d.«currentSubFunction»(parser)
        d = «result».derivation
        result = «result».joinErrors(result, «inPredicate»)
      «ELSE»
        «expr.expr.create()»
      «ENDIF»
      if (result.node != null) {
        «IF expr.op.bool»
          node.set«expr.property.parsed.toFirstUpper»(«result».node != null)
        «ELSEIF expr.op.multi»
          node.add(«result».node)
        «ELSE»
          node.set«expr.property.parsed.toFirstUpper»(«result».node)
        «ENDIF»
      }
    «ELSE»
      «expr.expr.create()»
    «ENDIF»
  '''
  
  private def String createAssignedSubExpressionFunction(SubExpression expr, String subFunction) '''
    «val resultType = expr.evaluateType(jpeg, types)»
    private static def Result<? extends «resultType.name»> «subFunction»(Derivation derivation, Parser parser) {
        var Result<?> result = null
        var «resultType.name» node = «IF resultType.internal»null«ELSE»new «resultType.name»«ENDIF»
        var d = derivation
        
        «expr.expr.create()»
        
        return result as Result<? extends «resultType.name»>
    }
  '''
  
  def dispatch CharSequence create(SubExpression expr) '''
    «expr.expr.create()»
  '''
  
  def dispatch CharSequence create(RuleReferenceExpression expr) '''
    val «nextResult» = d.dv«expr.name.parsed.toFirstUpper»
    d = «result».derivation
    result = «result».joinErrors(result, «inPredicate»)
  '''
  
  def dispatch CharSequence create(RangeExpression expr) '''
    // «expr.parsed.escaped»
    val «nextResult» = d.__oneOfThese(
      «expr.ranges.createRanges()»
      «IF expr.dash != null»«IF !expr.ranges.empty» + «ENDIF»'-'«ENDIF»
      )
    d = «result».derivation
    result = «result».joinErrors(result, «inPredicate»)
  '''
  
  private def createRanges(List<Node> nodes) {
    val list = newArrayList
    
    var lastWasCharRange = false
    val sb = new StringBuilder
    for (Node node : nodes) {
      if (node instanceof MinMaxRange) {
        if (lastWasCharRange) {
          sb.append("'")
          list.add(sb.toString)
          sb.length = 0
        }
        val range = node as MinMaxRange
        list.add("('" + range.min.parsed + "'..'" + range.max.parsed + "')")
        lastWasCharRange = false
      } else {
        if (!lastWasCharRange) {
          sb.append("'")
        }
        val range = node as CharRange
        sb.append(range.char.parsed.escaped)
        lastWasCharRange = true
      }
    }
    if (sb.length > 0) {
      sb.append("'")
      list.add(sb.toString)
    }
    
    return list.join(' + ')
  }
  
  def dispatch CharSequence create(MinMaxRange range) '''
    ('«range.min.parsed»'..'«range.max.parsed»')
  '''
  
  def dispatch CharSequence create(CharRange range) '''
    '«range.char.parsed.escaped»'
  '''
  
  def dispatch CharSequence create(AnyCharExpression expr) '''
    // «expr»
    val «nextResult» =  d.__any()
    d = «result».derivation
    result = «result».joinErrors(result, «inPredicate»)
  '''
  
  def dispatch CharSequence create(TerminalExpression expr) '''
    val «nextResult» =  d.__terminal('«expr.value.parsed»')
    d = «result».derivation
    result = «result».joinErrors(result, «inPredicate»)
  '''
  
  private def getName() {
    rule.name.parsed
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
