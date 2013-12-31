package de.matrixweb.djeypeg.internal

import java.util.Collection
import java.util.List
import java.util.Map

import static extension de.matrixweb.djeypeg.internal.ExpressionTypeEvaluator.*
import static extension de.matrixweb.djeypeg.internal.GeneratorHelper.*

/**
 * @author markusw
 */
class Generator {
  
  static def generateParser(Djeypeg djeypeg, Map<String, JType> types, String packageName) '''
    «val rules = djeypeg.rules.filter[!types.get(name.parsed).internal]»
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

      «FOR rule : rules»
        «new RuleGenerator(rule, djeypeg, types).generateRuleMethod()»
      «ENDFOR»
      
    }
    
    «FOR rule : rules»
      «new RuleGenerator(rule, djeypeg, types).generateRuleClass()»
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
            val lr = new Result<«uname»>(false, this, new ParseInfo(index, "Detected non-terminating left-recursion in '«uname»'"))
            dv«uname» = lr
            dv«uname» = «uname»Rule.match«uname»(parser, this)
            if (lr.leftRecursive && dv«uname».node != null) {
              growDv«uname»()
            }
          } if (dv«uname».leftRecursive != null) {
            dv«uname».setLeftRecursive()
          }
          return dv«uname»
        }
        
        private def growDv«uname»() {
          while(true) {
            val temp = «uname»Rule.match«uname»(parser, this)
            if (temp.node == null || temp.derivation.idx <= dv«uname».derivation.idx) return
            else dv«uname» = temp
          }
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
    
  '''
  
  static def generateTypes(Collection<JType> types, String packageName) '''
    package «packageName»
    
    package class Node {
      
      @Property
      int index
      
      @Property
      String parsed
      
      def Node copy() {
        new Node().copyAttributes()
      }
      
      protected def copyAttributes(Node node) {
        node._index = _index
        node._parsed = _parsed
        return node
      }
      
      def void add(Node node) {
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
        new Terminal().copyAttributes()
      }
      
      protected def copyAttributes(Terminal terminal) {
        super.copyAttributes(terminal)
        return terminal
      }
      
    }
    
    «FOR type : types»
      «new TypeGenerator(type).generateType()»
    «ENDFOR»
  '''

}

class TypeGenerator {
  
  JType type
  
  new(JType type) {
    this.type = type
  }
  
  package def generateType() '''
    «IF type.generate»
      «IF type.internal»abstract«ENDIF» class «type.name»«IF type.supertype != null» extends «type.supertype.name»«ENDIF» {
        
        «FOR attribute : type.attributes»
          «attribute.generateAttribute()»
        «ENDFOR»
        «type.attributes.generateAttributeMethods()»
        
      }
      
    «ENDIF»
  '''
  
  private def generateAttribute(JAttribute attribute) '''
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
  
  private def generateAttributeMethods(List<JAttribute> attributes) '''
    «IF type.internal»
      override «type.name» copy()
    «ELSE»
      override «type.name» copy() {
        new «type.name»().copyAttributes()
      }
      
      protected def copyAttributes(«type.name» type) {
        super.copyAttributes(type)
        «FOR attribute : attributes»
          «val attrName = attribute.name.toFirstUpper»
          type.attr«attrName» = this.attr«attrName»
        «ENDFOR»
        return type
      }
      
    «ENDIF»
  '''

}

class RuleGenerator {
  
  Rule rule
  
  JType type
  
  JType resultType
  
  JType nodeType
  
  Djeypeg djeypeg
  
  Map<String, JType> types
  
  List<String> subFunctions = newArrayList
  
  int resultCounter = -1
  
  int loopCounter = -1
  
  int backupCounter = -1
  
  int subCounter = -1
  
  boolean inPredicate = false
  
  boolean isAssignment = false
  
  new(Rule rule, Djeypeg djeypeg, Map<String, JType> types) {
    this.rule = rule
    this.type = rule.getType(types)
    this.resultType = rule.getResultType(types)
    this.djeypeg = djeypeg
    this.types = types
  }
  
  def generateRuleMethod() '''
    def «resultType.name» «name.toFirstUpper»(String in) {
      this.chars = in.toCharArray()
      val result = parse(0).dv«name.toFirstUpper»
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
        var «resultType.name» node = null
        var d = derivation
        val ParseInfo info = new ParseInfo(derivation.index)
        
        «rule.body.create()»
        
        result.info = info
        if (result.node != null) {
          if (node == null) {
            node = new «type.name»()
          }
          node.index = derivation.index
          node.parsed = new String(parser.chars, derivation.index, d.index - derivation.index);
          return new Result<«resultType.name»>(node, d, result.info)
        }
        return new Result<«resultType.name»>(null, derivation, result.info)
      }
      
      «subFunctions.join('\n')»
      
    }
  '''
  
  private def escapeJavadoc(Object o) {
    rule.toString().replace('*/', '*&#47;')
  }
  
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
    if (result.node != null) {
      result = CONTINUE
      info.join(result, «inPredicate»)
    } else {
      result = BREAK
      info.join(result, «inPredicate»)
    }
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
      result = BREAK
      info.join(result, «inPredicate»)
    } else {
      result = CONTINUE
      info.join(result, «inPredicate»)
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
      result = CONTINUE
      info.join(result, «inPredicate»)
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
    result = CONTINUE
    info.join(result, «inPredicate»)
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
      result = CONTINUE
      info.join(result, «inPredicate»)
    }
  '''
  
  def dispatch CharSequence create(AssignableExpression expr) '''
    // «expr.parsed.escaped»
    «IF expr.property != null»
      «if (isAssignment = true) '' else ''»
      «IF expr.expr instanceof GroupExpression»
        «val currentSubFunction = nextSubFunction + 'Match' + name.toFirstUpper»
        «if(subFunctions += (expr.expr as GroupExpression).createAssignedGroupExpressionFunction(currentSubFunction)) '' else ''»
        val «nextResult» = d.«currentSubFunction»(parser)
        d = «result».derivation
        result = «result»
        info.join(«result», «inPredicate»)
      «ELSE»
        «expr.expr.create()»
      «ENDIF»
      if (result.node != null) {
        if (node == null) {
          «if (true) { nodeType = type; '' }»
          node = new «type.name»
        }
        «IF expr.op.bool»
          «nodeCast».set«expr.property.parsed.toFirstUpper»(«result».node != null)
        «ELSEIF expr.op.multi»
          «nodeCast».add(«result».node)
        «ELSE»
          «nodeCast».set«expr.property.parsed.toFirstUpper»(«result».node)
        «ENDIF»
      }
      «if (isAssignment = false) '' else ''»
    «ELSE»
      «expr.expr.create()»
    «ENDIF»
  '''
  
  private def String createAssignedGroupExpressionFunction(GroupExpression expr, String subFunction) '''
    «val resultType = expr.evaluateType(djeypeg, types)»
    private static def Result<? extends «resultType.name»> «subFunction»(Derivation derivation, Parser parser) {
        var Result<? extends «resultType.name»> result = null
        var «resultType.name» node = «IF resultType.internal»null«ELSE»new «resultType.name»«ENDIF»
        var d = derivation
        val ParseInfo info = new ParseInfo(derivation.index)
        
        «expr.expr.create()»
        
        result.info = info
        return result
    }
  '''
  
  def dispatch CharSequence create(GroupExpression expr) '''
    «expr.expr.create()»
  '''
  
  def dispatch CharSequence create(RuleReferenceExpression expr) '''
    «val ruleRefResultType = expr.evaluateType(djeypeg, types)»
    val «nextResult» = d.dv«expr.name.parsed.toFirstUpper»
    d = «result».derivation
    «IF !isAssignment && ruleRefResultType.isAssignableTo(resultType, types)»
      if (node == null) {
        «if (true) { nodeType = ruleRefResultType; '' }»
        node = «result».node
      }
    «ENDIF»
    result = «result»
    info.join(«result», «inPredicate»)
  '''
  
  def dispatch CharSequence create(RangeExpression expr) '''
    // «expr.parsed.escaped»
    val «nextResult» = d.__oneOfThese(
      «expr.ranges.createRanges()»
      «IF expr.dash != null»«IF !expr.ranges.empty» + «ENDIF»'-'«ENDIF»
      )
    d = «result».derivation
    result = «result»
    info.join(«result», «inPredicate»)
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
    result = «result»
    info.join(«result», «inPredicate»)
  '''
  
  def dispatch CharSequence create(TerminalExpression expr) '''
    val «nextResult» =  d.__terminal('«expr.value.parsed.escapedTerminal»')
    d = «result».derivation
    result = «result»
    info.join(«result», «inPredicate»)
  '''
  
  def dispatch CharSequence create(ActionExpression action) '''
    val current = node
    «if (true) { nodeType = types.get(action.type.parsed); '' }»
    node = new «action.type»()
    «IF action.property != null»
      «IF action.op.multi»
        «nodeCast».add(current)
      «ELSE»
        «nodeCast».set«action.property.parsed.toFirstUpper»(current)
      «ENDIF»
    «ENDIF»
    result = CONTINUE
  '''
  
  private def getName() {
    rule.name.parsed
  }
  
  private def getNodeCast() {
    return 
      if (nodeType == resultType) 'node'
      else '''(node as «nodeType.name»)'''
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
