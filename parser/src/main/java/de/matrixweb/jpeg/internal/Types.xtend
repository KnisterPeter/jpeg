package de.matrixweb.jpeg.internal

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
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override OptionalExpression copy() {
    val r = new OptionalExpression
    r.attrExpr = this.attrExpr
    return r
  }
  
}

 class ActionExpression extends Expression {
  
  ID attrProperty
  
  def getProperty() { attrProperty }
  def setProperty(ID attrProperty) { this.attrProperty = attrProperty }
  
  AssignmentOperator attrOp
  
  def getOp() { attrOp }
  def setOp(AssignmentOperator attrOp) { this.attrOp = attrOp }
  
  ID attrName
  
  def getName() { attrName }
  def setName(ID attrName) { this.attrName = attrName }
  
  override ActionExpression copy() {
    val r = new ActionExpression
    r.attrProperty = this.attrProperty
    r.attrOp = this.attrOp
    r.attrName = this.attrName
    return r
  }
  
}

 class SequenceExpression extends Expression {
  
  java.util.List<Expression> attrExpressions
  
  def getExpressions() { attrExpressions }
  def setExpressions(java.util.List<Expression> attrExpressions) { this.attrExpressions = attrExpressions }
  
  def dispatch void add(Expression __expression) {
    this.attrExpressions = this.attrExpressions ?: newArrayList
    this.attrExpressions += __expression
  }
  
  override SequenceExpression copy() {
    val r = new SequenceExpression
    r.attrExpressions = this.attrExpressions
    return r
  }
  
}

 class AssignableExpression extends Expression {
  
  ID attrProperty
  
  def getProperty() { attrProperty }
  def setProperty(ID attrProperty) { this.attrProperty = attrProperty }
  
  AssignmentOperator attrOp
  
  def getOp() { attrOp }
  def setOp(AssignmentOperator attrOp) { this.attrOp = attrOp }
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override AssignableExpression copy() {
    val r = new AssignableExpression
    r.attrProperty = this.attrProperty
    r.attrOp = this.attrOp
    r.attrExpr = this.attrExpr
    return r
  }
  
}

 class RangeExpression extends Expression {
  
  Terminal attrDash
  
  def getDash() { attrDash }
  def setDash(Terminal attrDash) { this.attrDash = attrDash }
  
  java.util.List<Node> attrRanges
  
  def getRanges() { attrRanges }
  def setRanges(java.util.List<Node> attrRanges) { this.attrRanges = attrRanges }
  
  def dispatch void add(Node __node) {
    this.attrRanges = this.attrRanges ?: newArrayList
    this.attrRanges += __node
  }
  
  override RangeExpression copy() {
    val r = new RangeExpression
    r.attrDash = this.attrDash
    r.attrRanges = this.attrRanges
    return r
  }
  
}

 class AnyCharExpression extends Expression {
  
  Terminal attrChar
  
  def getChar() { attrChar }
  def setChar(Terminal attrChar) { this.attrChar = attrChar }
  
  override AnyCharExpression copy() {
    val r = new AnyCharExpression
    r.attrChar = this.attrChar
    return r
  }
  
}

 class ID extends Node {
  
  override ID copy() {
    val r = new ID
    return r
  }
  
}

 class _ extends Node {
  
  override _ copy() {
    val r = new _
    return r
  }
  
}

 class EOI extends Node {
  
  override EOI copy() {
    val r = new EOI
    return r
  }
  
}

abstract class Expression extends Node {
  
  override Expression copy()
  
}

 class TerminalExpression extends Expression {
  
  InTerminalChar attrValue
  
  def getValue() { attrValue }
  def setValue(InTerminalChar attrValue) { this.attrValue = attrValue }
  
  override TerminalExpression copy() {
    val r = new TerminalExpression
    r.attrValue = this.attrValue
    return r
  }
  
}

 class AndPredicateExpression extends Expression {
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override AndPredicateExpression copy() {
    val r = new AndPredicateExpression
    r.attrExpr = this.attrExpr
    return r
  }
  
}

 class ZeroOrMoreExpression extends Expression {
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override ZeroOrMoreExpression copy() {
    val r = new ZeroOrMoreExpression
    r.attrExpr = this.attrExpr
    return r
  }
  
}

 class Body extends Node {
  
  java.util.List<Expression> attrExpressions
  
  def getExpressions() { attrExpressions }
  def setExpressions(java.util.List<Expression> attrExpressions) { this.attrExpressions = attrExpressions }
  
  def dispatch void add(Expression __expression) {
    this.attrExpressions = this.attrExpressions ?: newArrayList
    this.attrExpressions += __expression
  }
  
  override Body copy() {
    val r = new Body
    r.attrExpressions = this.attrExpressions
    return r
  }
  
}

 class AssignmentOperator extends Node {
  
  boolean attrSingle
  
  def getSingle() { attrSingle }
  def setSingle(boolean attrSingle) { this.attrSingle = attrSingle }
  
  boolean attrMulti
  
  def getMulti() { attrMulti }
  def setMulti(boolean attrMulti) { this.attrMulti = attrMulti }
  
  boolean attrBool
  
  def getBool() { attrBool }
  def setBool(boolean attrBool) { this.attrBool = attrBool }
  
  override AssignmentOperator copy() {
    val r = new AssignmentOperator
    r.attrSingle = this.attrSingle
    r.attrMulti = this.attrMulti
    r.attrBool = this.attrBool
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
  
  Terminal attrChar
  
  def getChar() { attrChar }
  def setChar(Terminal attrChar) { this.attrChar = attrChar }
  
  override CharRange copy() {
    val r = new CharRange
    r.attrChar = this.attrChar
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
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override SubExpression copy() {
    val r = new SubExpression
    r.attrExpr = this.attrExpr
    return r
  }
  
}

 class Rule extends Node {
  
  ID attrName
  
  def getName() { attrName }
  def setName(ID attrName) { this.attrName = attrName }
  
  RuleReturns attrReturns
  
  def getReturns() { attrReturns }
  def setReturns(RuleReturns attrReturns) { this.attrReturns = attrReturns }
  
  Body attrBody
  
  def getBody() { attrBody }
  def setBody(Body attrBody) { this.attrBody = attrBody }
  
  override Rule copy() {
    val r = new Rule
    r.attrName = this.attrName
    r.attrReturns = this.attrReturns
    r.attrBody = this.attrBody
    return r
  }
  
}

 class RuleReturns extends Node {
  
  ID attrName
  
  def getName() { attrName }
  def setName(ID attrName) { this.attrName = attrName }
  
  override RuleReturns copy() {
    val r = new RuleReturns
    r.attrName = this.attrName
    return r
  }
  
}

 class MinMaxRange extends Node {
  
  Terminal attrMin
  
  def getMin() { attrMin }
  def setMin(Terminal attrMin) { this.attrMin = attrMin }
  
  Terminal attrMax
  
  def getMax() { attrMax }
  def setMax(Terminal attrMax) { this.attrMax = attrMax }
  
  override MinMaxRange copy() {
    val r = new MinMaxRange
    r.attrMin = this.attrMin
    r.attrMax = this.attrMax
    return r
  }
  
}

 class NotPredicateExpression extends Expression {
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override NotPredicateExpression copy() {
    val r = new NotPredicateExpression
    r.attrExpr = this.attrExpr
    return r
  }
  
}

 class RuleReferenceExpression extends Expression {
  
  ID attrName
  
  def getName() { attrName }
  def setName(ID attrName) { this.attrName = attrName }
  
  override RuleReferenceExpression copy() {
    val r = new RuleReferenceExpression
    r.attrName = this.attrName
    return r
  }
  
}

 class Jpeg extends Node {
  
  java.util.List<Rule> attrRules
  
  def getRules() { attrRules }
  def setRules(java.util.List<Rule> attrRules) { this.attrRules = attrRules }
  
  def dispatch void add(Rule __rule) {
    this.attrRules = this.attrRules ?: newArrayList
    this.attrRules += __rule
  }
  
  override Jpeg copy() {
    val r = new Jpeg
    r.attrRules = this.attrRules
    return r
  }
  
}

 class OneOrMoreExpression extends Expression {
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override OneOrMoreExpression copy() {
    val r = new OneOrMoreExpression
    r.attrExpr = this.attrExpr
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
  
  java.util.List<Expression> attrChoices
  
  def getChoices() { attrChoices }
  def setChoices(java.util.List<Expression> attrChoices) { this.attrChoices = attrChoices }
  
  def dispatch void add(Expression __expression) {
    this.attrChoices = this.attrChoices ?: newArrayList
    this.attrChoices += __expression
  }
  
  override ChoiceExpression copy() {
    val r = new ChoiceExpression
    r.attrChoices = this.attrChoices
    return r
  }
  
}
