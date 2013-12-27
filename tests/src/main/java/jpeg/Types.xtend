package jpeg

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
  
  def dispatch void add(Node node) {
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

 class AssignableExpressionExpressions extends Expression {
  
  override AssignableExpressionExpressions copy() {
    new AssignableExpressionExpressions().copyAttributes()
  }
  
  protected def copyAttributes(AssignableExpressionExpressions type) {
    super.copyAttributes(type)
    return type
  }
  
  
}

 class OptionalExpression extends Expression {
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override OptionalExpression copy() {
    new OptionalExpression().copyAttributes()
  }
  
  protected def copyAttributes(OptionalExpression type) {
    super.copyAttributes(type)
    type.attrExpr = this.attrExpr
    return type
  }
  
  
}

 class ActionExpression extends Expression {
  
  ID attrType
  
  def getType() { attrType }
  def setType(ID attrType) { this.attrType = attrType }
  
  ID attrProperty
  
  def getProperty() { attrProperty }
  def setProperty(ID attrProperty) { this.attrProperty = attrProperty }
  
  ActionOperator attrOp
  
  def getOp() { attrOp }
  def setOp(ActionOperator attrOp) { this.attrOp = attrOp }
  
  override ActionExpression copy() {
    new ActionExpression().copyAttributes()
  }
  
  protected def copyAttributes(ActionExpression type) {
    super.copyAttributes(type)
    type.attrType = this.attrType
    type.attrProperty = this.attrProperty
    type.attrOp = this.attrOp
    return type
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
    new SequenceExpression().copyAttributes()
  }
  
  protected def copyAttributes(SequenceExpression type) {
    super.copyAttributes(type)
    type.attrExpressions = this.attrExpressions
    return type
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
    new AssignableExpression().copyAttributes()
  }
  
  protected def copyAttributes(AssignableExpression type) {
    super.copyAttributes(type)
    type.attrProperty = this.attrProperty
    type.attrOp = this.attrOp
    type.attrExpr = this.attrExpr
    return type
  }
  
  
}

 class RangeExpression extends Expression {
  
  Terminal attrDash
  
  def getDash() { attrDash }
  def setDash(Terminal attrDash) { this.attrDash = attrDash }
  
  java.util.List<Node> attrRanges
  
  def getRanges() { attrRanges }
  def setRanges(java.util.List<Node> attrRanges) { this.attrRanges = attrRanges }
  
  override dispatch void add(Node __node) {
    this.attrRanges = this.attrRanges ?: newArrayList
    this.attrRanges += __node
  }
  
  override RangeExpression copy() {
    new RangeExpression().copyAttributes()
  }
  
  protected def copyAttributes(RangeExpression type) {
    super.copyAttributes(type)
    type.attrDash = this.attrDash
    type.attrRanges = this.attrRanges
    return type
  }
  
  
}

 class AnyCharExpression extends Expression {
  
  Terminal attrChar
  
  def getChar() { attrChar }
  def setChar(Terminal attrChar) { this.attrChar = attrChar }
  
  override AnyCharExpression copy() {
    new AnyCharExpression().copyAttributes()
  }
  
  protected def copyAttributes(AnyCharExpression type) {
    super.copyAttributes(type)
    type.attrChar = this.attrChar
    return type
  }
  
  
}

 class ID extends Node {
  
  override ID copy() {
    new ID().copyAttributes()
  }
  
  protected def copyAttributes(ID type) {
    super.copyAttributes(type)
    return type
  }
  
  
}

 class _ extends Node {
  
  override _ copy() {
    new _().copyAttributes()
  }
  
  protected def copyAttributes(_ type) {
    super.copyAttributes(type)
    return type
  }
  
  
}

 class EOI extends Node {
  
  override EOI copy() {
    new EOI().copyAttributes()
  }
  
  protected def copyAttributes(EOI type) {
    super.copyAttributes(type)
    return type
  }
  
  
}

 class Expression extends Node {
  
  override Expression copy() {
    new Expression().copyAttributes()
  }
  
  protected def copyAttributes(Expression type) {
    super.copyAttributes(type)
    return type
  }
  
  
}

 class TerminalExpression extends Expression {
  
  InTerminalChar attrValue
  
  def getValue() { attrValue }
  def setValue(InTerminalChar attrValue) { this.attrValue = attrValue }
  
  override TerminalExpression copy() {
    new TerminalExpression().copyAttributes()
  }
  
  protected def copyAttributes(TerminalExpression type) {
    super.copyAttributes(type)
    type.attrValue = this.attrValue
    return type
  }
  
  
}

 class AndPredicateExpression extends Expression {
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override AndPredicateExpression copy() {
    new AndPredicateExpression().copyAttributes()
  }
  
  protected def copyAttributes(AndPredicateExpression type) {
    super.copyAttributes(type)
    type.attrExpr = this.attrExpr
    return type
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
    new Body().copyAttributes()
  }
  
  protected def copyAttributes(Body type) {
    super.copyAttributes(type)
    type.attrExpressions = this.attrExpressions
    return type
  }
  
  
}

 class ZeroOrMoreExpression extends Expression {
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override ZeroOrMoreExpression copy() {
    new ZeroOrMoreExpression().copyAttributes()
  }
  
  protected def copyAttributes(ZeroOrMoreExpression type) {
    super.copyAttributes(type)
    type.attrExpr = this.attrExpr
    return type
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
    new AssignmentOperator().copyAttributes()
  }
  
  protected def copyAttributes(AssignmentOperator type) {
    super.copyAttributes(type)
    type.attrSingle = this.attrSingle
    type.attrMulti = this.attrMulti
    type.attrBool = this.attrBool
    return type
  }
  
  
}

 class SequenceExpressionExpressions extends Expression {
  
  override SequenceExpressionExpressions copy() {
    new SequenceExpressionExpressions().copyAttributes()
  }
  
  protected def copyAttributes(SequenceExpressionExpressions type) {
    super.copyAttributes(type)
    return type
  }
  
  
}

 class WS extends Node {
  
  override WS copy() {
    new WS().copyAttributes()
  }
  
  protected def copyAttributes(WS type) {
    super.copyAttributes(type)
    return type
  }
  
  
}

 class CharRange extends Node {
  
  Terminal attrChar
  
  def getChar() { attrChar }
  def setChar(Terminal attrChar) { this.attrChar = attrChar }
  
  override CharRange copy() {
    new CharRange().copyAttributes()
  }
  
  protected def copyAttributes(CharRange type) {
    super.copyAttributes(type)
    type.attrChar = this.attrChar
    return type
  }
  
  
}

 class Comment extends Node {
  
  override Comment copy() {
    new Comment().copyAttributes()
  }
  
  protected def copyAttributes(Comment type) {
    super.copyAttributes(type)
    return type
  }
  
  
}

 class SubExpression extends Expression {
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override SubExpression copy() {
    new SubExpression().copyAttributes()
  }
  
  protected def copyAttributes(SubExpression type) {
    super.copyAttributes(type)
    type.attrExpr = this.attrExpr
    return type
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
    new Rule().copyAttributes()
  }
  
  protected def copyAttributes(Rule type) {
    super.copyAttributes(type)
    type.attrName = this.attrName
    type.attrReturns = this.attrReturns
    type.attrBody = this.attrBody
    return type
  }
  
  
}

 class RuleReturns extends Node {
  
  ID attrName
  
  def getName() { attrName }
  def setName(ID attrName) { this.attrName = attrName }
  
  override RuleReturns copy() {
    new RuleReturns().copyAttributes()
  }
  
  protected def copyAttributes(RuleReturns type) {
    super.copyAttributes(type)
    type.attrName = this.attrName
    return type
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
    new MinMaxRange().copyAttributes()
  }
  
  protected def copyAttributes(MinMaxRange type) {
    super.copyAttributes(type)
    type.attrMin = this.attrMin
    type.attrMax = this.attrMax
    return type
  }
  
  
}

 class NotPredicateExpression extends Expression {
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override NotPredicateExpression copy() {
    new NotPredicateExpression().copyAttributes()
  }
  
  protected def copyAttributes(NotPredicateExpression type) {
    super.copyAttributes(type)
    type.attrExpr = this.attrExpr
    return type
  }
  
  
}

 class RuleReferenceExpression extends Expression {
  
  ID attrName
  
  def getName() { attrName }
  def setName(ID attrName) { this.attrName = attrName }
  
  override RuleReferenceExpression copy() {
    new RuleReferenceExpression().copyAttributes()
  }
  
  protected def copyAttributes(RuleReferenceExpression type) {
    super.copyAttributes(type)
    type.attrName = this.attrName
    return type
  }
  
  
}

 class ActionOperator extends Node {
  
  boolean attrMulti
  
  def getMulti() { attrMulti }
  def setMulti(boolean attrMulti) { this.attrMulti = attrMulti }
  
  boolean attrSingle
  
  def getSingle() { attrSingle }
  def setSingle(boolean attrSingle) { this.attrSingle = attrSingle }
  
  override ActionOperator copy() {
    new ActionOperator().copyAttributes()
  }
  
  protected def copyAttributes(ActionOperator type) {
    super.copyAttributes(type)
    type.attrMulti = this.attrMulti
    type.attrSingle = this.attrSingle
    return type
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
    new Jpeg().copyAttributes()
  }
  
  protected def copyAttributes(Jpeg type) {
    super.copyAttributes(type)
    type.attrRules = this.attrRules
    return type
  }
  
  
}

 class OneOrMoreExpression extends Expression {
  
  Expression attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(Expression attrExpr) { this.attrExpr = attrExpr }
  
  override OneOrMoreExpression copy() {
    new OneOrMoreExpression().copyAttributes()
  }
  
  protected def copyAttributes(OneOrMoreExpression type) {
    super.copyAttributes(type)
    type.attrExpr = this.attrExpr
    return type
  }
  
  
}

 class InTerminalChar extends Node {
  
  override InTerminalChar copy() {
    new InTerminalChar().copyAttributes()
  }
  
  protected def copyAttributes(InTerminalChar type) {
    super.copyAttributes(type)
    return type
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
    new ChoiceExpression().copyAttributes()
  }
  
  protected def copyAttributes(ChoiceExpression type) {
    super.copyAttributes(type)
    type.attrChoices = this.attrChoices
    return type
  }
  
  
}

