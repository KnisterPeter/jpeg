package de.matrixweb.jpeg.internal

import java.util.List
import java.util.Map

import static extension de.matrixweb.jpeg.internal.AstNodeHelper.*
import static extension de.matrixweb.jpeg.internal.ExpressionTypeEvaluator.*
import static extension de.matrixweb.jpeg.internal.GeneratorHelper.*

class AstToTypeConverter {

  static def createTypes(Jpeg jpeg) {
    val map = newHashMap
    val list = newArrayList
    list += jpeg.rules.map [
      val t = new JType
      t.internal = isInternal(jpeg)
      t.generate = true
      t.name = name.parsed
      return t
    ]
    list.addPredefinedTypes().forEach[map.put(it.name, it)]
    jpeg.rules.forEach [
      val type = map.get(name.parsed)
      type.attributes = getAttributes(jpeg, map)
      type.supertype = map.get(returns?.parsed ?: 'Node')
    ]
    return map
  }

  private static def addPredefinedTypes(List<JType> list) {
    val object = new JType
    object.internal = true
    object.generate = false
    object.name = Object.simpleName
    object.supertype = null
    list += object

    val result = new JType
    result.internal = true
    result.generate = false
    result.name = 'Node'
    result.supertype = object
    list += result

    val terminal = new JType
    terminal.internal = true
    terminal.generate = false
    terminal.name = 'Terminal'
    terminal.supertype = result
    list += terminal

    return list
  }

  private static def getAttributes(Rule rule, Jpeg jpeg, Map<String, JType> map) {
    rule.findNodesByType(AssignableExpression).filter[property != null].toMap[property.parsed].values.map [
      val a = new JAttribute
      a.name = property.parsed
      if (op.bool) {
        a.type = new JType
        a.type.name = 'boolean'
      } else if (op.multi) {
        a.type = new JType
        a.type.name = List.name
        a.typeParameter = expr.evaluateType(jpeg, map)
      } else {
        a.type = expr.evaluateType(jpeg, map)
      }
      return a
    ].toList
  }

}

class AstNodeHelper {

  static def <T> Iterable<T> findNodesByType(Rule rule, Class<T> clazz) {
    rule.body.findNodes(clazz) as Iterable<T>
  }

  static def <T> Iterable<T> findNodesByType(Expression expr, Class<T> clazz) {
    expr.findNodes(clazz) as Iterable<T>
  }

  private static def dispatch Iterable<?> findNodes(Body body, Class<?> clazz) {
    body.expressions.map[findNodes(clazz)].flatten
  }

  private static def dispatch Iterable<?> findNodes(ChoiceExpression expr, Class<?> clazz) {
    expr.choices.map[findNodes(clazz)].flatten
  }

  private static def dispatch Iterable<?> findNodes(SequenceExpression expr, Class<?> clazz) {
    expr.expressions.map[findNodes(clazz)].flatten
  }

  private static def dispatch Iterable<?> findNodes(NotPredicateExpression expr, Class<?> clazz) {
    expr.expr.findNodes(clazz)
  }

  private static def dispatch Iterable<?> findNodes(AndPredicateExpression expr, Class<?> clazz) {
    expr.expr.findNodes(clazz)
  }

  private static def dispatch Iterable<?> findNodes(OneOrMoreExpression expr, Class<?> clazz) {
    expr.expr.findNodes(clazz)
  }

  private static def dispatch Iterable<?> findNodes(ZeroOrMoreExpression expr, Class<?> clazz) {
    expr.expr.findNodes(clazz)
  }

  private static def dispatch Iterable<?> findNodes(OptionalExpression expr, Class<?> clazz) {
    expr.expr.findNodes(clazz)
  }

  private static def dispatch Iterable<?> findNodes(AssignableExpression expr, Class<?> clazz) {
    val List<Object> list = newArrayList
    if (clazz == AssignableExpression) {
      list += expr
    }
    list += expr.expr.findNodes(clazz) as Iterable<Object>
    return list
  }

  private static def dispatch Iterable<?> findNodes(GroupExpression expr, Class<?> clazz) {
    expr.expr.findNodes(clazz)
  }

  private static def dispatch Iterable<?> findNodes(RuleReferenceExpression expr, Class<?> clazz) {
    val List<Object> list = newArrayList
    if (clazz == RuleReferenceExpression) {
      list += expr
    }
    return list
  }

  private static def dispatch Iterable<?> findNodes(AnyCharExpression any, Class<?> clazz) {
    #[]
  }

  private static def dispatch Iterable<?> findNodes(RangeExpression range, Class<?> clazz) {
    #[]
  }

  private static def dispatch Iterable<?> findNodes(TerminalExpression terminal, Class<?> clazz) {
    #[]
  }

  private static def dispatch Iterable<?> findNodes(ActionExpression action, Class<?> clazz) {
    #[]
  }

}

class ExpressionTypeEvaluator {

  def static dispatch JType evaluateType(Object o, Jpeg jpeg, Map<String, JType> map) {
    map.get('Object')
  }

  def static dispatch JType evaluateType(RuleReferenceExpression expr, Jpeg jpeg, Map<String, JType> map) {
    val rule = jpeg.rules.findFirst[it.name.parsed == expr.name.parsed]

    // Required to use returns type to widening the resulting attribute type
    return map.get(rule?.returns?.parsed ?: rule.name.parsed)
  }

  def static dispatch JType evaluateType(SequenceExpression expr, Jpeg jpeg, Map<String, JType> map) {
    if(expr.expressions.size == 1) return expr.expressions.head.evaluateType(jpeg, map)
    if(expr.expressions.forall[evaluateType(jpeg, map).name == 'Terminal']) return map.get('Terminal')
    map.get('Node')
  }

  def static dispatch JType evaluateType(ChoiceExpression expr, Jpeg jpeg, Map<String, JType> map) {
    var type = expr.choices.head.evaluateType(jpeg, map)
    while (type != null) {
      val finalType = type
      if(expr.choices.forall[evaluateType(jpeg, map).isAssignableTo(finalType, map)]) return finalType
      type = map.get(type.supertype)
    }
    map.get('Node')
  }

  def static boolean isAssignableTo(JType test, JType to, Map<String, JType> map) {
    var type = test
    while (type != null) {
      if(type == to) return true
      type = map.get(type.supertype)
    }
    return false
  }

  def static dispatch JType evaluateType(GroupExpression expr, Jpeg jpeg, Map<String, JType> map) {
    expr.expr.evaluateType(jpeg, map)
  }

  def static dispatch JType evaluateType(TerminalExpression expr, Jpeg jpeg, Map<String, JType> map) {
    map.get('Terminal')
  }

  def static dispatch JType evaluateType(AnyCharExpression expr, Jpeg jpeg, Map<String, JType> map) {
    map.get('Terminal')
  }

  def static dispatch JType evaluateType(AssignableExpression expr, Jpeg jpeg, Map<String, JType> map) {
    expr.expr.evaluateType(jpeg, map)
  }

}

class GeneratorHelper {

  /**
   * A simple rule is a rule which contains exactly one simple ChoiceExpression.
   */
  static def isSimpleRule(Rule rule) {
    return rule.body.expressions.size == 1 && rule.body.expressions.head.simpleChoiceExpression
  }

  /**
   * A simple ChoiceExpression is defined by having no assigned expressions and 
   * only one rule reference per choice.
   */
  static def isSimpleChoiceExpression(Expression expr) {
    var simple = false
    if (expr instanceof ChoiceExpression) {
      val choiceExpr = expr as ChoiceExpression
      simple = choiceExpr.choices.forall [
        if (it instanceof AssignableExpression) {
          val assignExpr = choiceExpr.choices.head as AssignableExpression
          return assignExpr.property == null && assignExpr.expr instanceof RuleReferenceExpression
        }
        return false
      ]
    }
    return simple
  }

  /**
   * A rule is defined as internal if and only if
   * <ul>
   * <li>It is a simple rule</li>
   * <li>No other rule as a rule-reference to this rule</li>
   * </ul>
   */
  static def isInternal(Rule rule, Jpeg jpeg) {
    return rule.simpleRule && jpeg.rules.forall [
      body.expressions.map [
        findNodesByType(RuleReferenceExpression).map[name.parsed != rule.name.parsed]
      ].flatten.fold(true, [a, b|a && b])
    ]
  }

  /**
   * Returns the type of the given rule.
   */
  static def getType(Rule rule, Map<String, JType> types) {
    types.get(rule.name.parsed)
  }

  /**
   * Returns the result type of the given rule (either the type of the rule or 
   * a more widening type).
   */
  static def getResultType(Rule rule, Map<String, JType> types) {
    types.get(rule?.returns?.parsed ?: rule.name.parsed)
  }

  static def String unescaped(String str) {
    val escape = '\\'.charAt(0)
    val u = 'u'.charAt(0)
    
    val buf = str.toCharArray
    val len = buf.length
    val sb = new StringBuilder(str.length)
    var i = 0
    while (i < len) {
      var c = buf.get(i)
      i = i + 1
      if (c === escape) {
        if (i < len && buf.get(i) === u) {
            i = i + 1
            c = Integer.parseInt(str.substring(i, i + 4), 16) as char
            i = i + 4
        }
      }
      sb.append(c);
    }
    return sb.toString()
  }

  static def String escapedTerminal(String str) {
    val sb = new StringBuilder(str.length)
    for (char c : str.toCharArray()) {
      if (c.printable)
        sb.append(c) 
      else
        sb.append(c.unicodeEscaped)
    }
    return sb.toString()
  }

  static def String escaped(String str) {
    val escape = '\\'.charAt(0)
    val sb = new StringBuilder
    for (char c : str.toCharArray()) {
      if (c.printable)
        if (c === escape)
          sb.append(c).append(c)
        else
          sb.append(c) 
      else
        sb.append(c.unicodeEscaped)
    }
    return sb.toString()
  }

  /**
   * Returns true if the given character is defined as printable which means its
   * between ascii codes 32 (space) and 127 (del).
   */
  static def boolean isPrintable(char ch) {
      return ch >= 32 && ch < 127;
  }

  static def String unicodeEscaped(char ch) {
    return 
      if (ch<0x10) "\\u000" + Integer.toHexString(ch)
      else if (ch < 0x100) "\\u00" + Integer.toHexString(ch)
      else if (ch < 0x1000) "\\u0" + Integer.toHexString(ch)
      else "\\u" + Integer.toHexString(ch)
  }

}

class AstValidator {

  static def validate(Jpeg jpeg, extension Parser parser) {
    jpeg.rules.forEach [ rule |
      rule.findNodesByType(RuleReferenceExpression).forEach [ ref |
        if (!jpeg.rules.exists[name.parsed == ref.name.parsed]) {
          throw new ParseException(ref.index.lineAndColumn, "Reference '" + ref.name.parsed + "' undefined")
        }
      ]
    ]
  }

}
