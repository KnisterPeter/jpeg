package de.matrixweb.jpeg.internal

import java.util.List
import java.util.Map

import static extension de.matrixweb.jpeg.internal.AstNodeHelper.*
import static extension de.matrixweb.jpeg.internal.ExpressionTypeEvaluator.*
import static extension de.matrixweb.jpeg.internal.GeneratorHelper.*

/**
 * @author markusw
 */
class AstOptimizer {
  
  /**
   * A parser result is optimizable if the following conditions are met:
   * <ul>
   * <li>There is only one attribute in the concrete type</li>
   * <li>The attribute type is a list type</li>
   * <li>There attribute list element type is assignable to the result type</li>
   * </ul>
   */
  static def isResultOptimizable(JType type, JType resultType, Map<String, JType> types) {
    if (type.attributes.size == 1) {
      val attr = type.attributes.head
      return attr.typeParameter != null && attr.typeParameter.isAssignableTo(resultType, types)
    }
    return false
  }

  static def getOptimizableAttribute(JType type) {
    type.attributes.head
  }
  
}

class TypeGenerator {
  
  static def createTypes(Jpeg jpeg) {
    val map = newHashMap
    val list = newArrayList
    list += jpeg.rules.map[
      val t = new JType
      t.internal = isInternal(jpeg)
      t.generate = true
      t.name = name.parsed
      return t
    ]
    list.addPredefinedTypes().forEach[map.put(it.name, it)]
    jpeg.rules.forEach[
      val type = map.get(name.parsed)
      type.attributes = getAttributes(jpeg, map)
      type.supertype = map.get(if (isTerminal()) 'Terminal' else (returns?.name?.parsed ?: 'Result'))
    ]
    return map
  }
  
  private static def addPredefinedTypes(List<JType> list) {
    val object = new JType
    object.internal = true
    object.generate = false
    object.name = 'Object'
    object.supertype = null
    list += object
    
    val result = new JType
    result.internal = true
    result.generate = false
    result.name = 'Result'
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
    rule.findNodesByType(AssignableExpression).filter[property != null].toMap[property.parsed].values.map[
      val a = new JAttribute
      a.name = if (property.parsed.isKeyword()) '_' + property.parsed else property.parsed
      if (op.multi != null) {
        a.type = new JType
        a.type.name = 'java.util.List'
        a.typeParameter = expr.evaluateType(jpeg, map)
      } else {
        a.type = expr.evaluateType(jpeg, map)
      }
      return a
    ].toList
  }
  
  private static def isKeyword(String name) {
    #['char'].contains(name)
  }
  
  private static def isTerminal(Rule rule) {
      rule.name.parsed.toUpperCase == rule.name.parsed
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
  
  private static def dispatch Iterable<?> findNodes(SubExpression expr, Class<?> clazz) {
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
  
  private static def dispatch Iterable<?> findNodes(EndOfInputExpression eoi, Class<?> clazz) {
    #[]
  }
  
  private static def dispatch Iterable<?> findNodes(TerminalExpression terminal, Class<?> clazz) {
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
    return map.get(rule?.returns?.name?.parsed ?: rule.name.parsed)
  }

  def static dispatch JType evaluateType(SequenceExpression expr, Jpeg jpeg, Map<String, JType> map) {
    if (expr.expressions.size == 1) return expr.expressions.head.evaluateType(jpeg, map)
    if (expr.expressions.forall[evaluateType(jpeg, map).name == 'Terminal']) return map.get('Terminal')
    map.get('Result')
  }
  
  def static dispatch JType evaluateType(ChoiceExpression expr, Jpeg jpeg, Map<String, JType> map) {
    var type = expr.choices.head.evaluateType(jpeg, map)
    while (type != null) {
      val finalType = type
      if (expr.choices.forall[evaluateType(jpeg, map).isAssignableTo(finalType, map)]) return finalType
      type = map.get(type.supertype)
    }
    map.get('Result')
  }
  
  def static boolean isAssignableTo(JType test, JType to, Map<String, JType> map) {
    var type = test
    while (type != null) {
      if (type == to) return true
      type = map.get(type.supertype)
    }
    return false
  }
  
  def static dispatch JType evaluateType(SubExpression expr, Jpeg jpeg, Map<String, JType> map) {
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
    return rule.body.expressions.size == 1
      && rule.body.expressions.head.simpleChoiceExpression
  }
  
  /**
   * A simple ChoiceExpression is defined by having no assigned expressions and 
   * only one rule reference per choice.
   */
  static def isSimpleChoiceExpression(Expression expr) {
    return 
      expr instanceof ChoiceExpression
      && (expr as ChoiceExpression).choices.map[findNodesByType(AssignableExpression).forall[property == null]].fold(true, [a, b | a && b])
      && (expr as ChoiceExpression).choices.map[findNodesByType(RuleReferenceExpression).size == 1].fold(true, [a, b | a && b])
  }
  
  /**
   * A rule is defined as internal if and only if
   * <ul>
   * <li>It is a simple rule</li>
   * <li>No other rule as a rule-reference to this rule</li>
   * </ul>
   */
  static def isInternal(Rule rule, Jpeg jpeg) {
    return 
      rule.simpleRule 
      && jpeg.rules.forall[
            body.expressions.map[
              findNodesByType(RuleReferenceExpression).map[name.parsed != rule.name.parsed]
            ].flatten.fold(true, [a, b | a && b])
          ]
  }

}

class AstValidator {
  
  static def validate(Jpeg jpeg) {
    jpeg.rules.forEach[ rule |
      rule.findNodesByType(RuleReferenceExpression).forEach[ ref |
        if (!jpeg.rules.exists[name.parsed == ref.name.parsed]) {
          throw new ParseException("Reference '" + ref.name.parsed + "' undefined")
        }
      ]
    ]
  }
  
}
