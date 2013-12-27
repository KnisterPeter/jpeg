package types

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

 class ExprA extends Expr {
  
  override ExprA copy() {
    new ExprA().copyAttributes()
  }
  
  protected def copyAttributes(ExprA type) {
    super.copyAttributes(type)
    return type
  }
  
  
}

 class ExprB extends Expr {
  
  override ExprB copy() {
    new ExprB().copyAttributes()
  }
  
  protected def copyAttributes(ExprB type) {
    super.copyAttributes(type)
    return type
  }
  
  
}

 class Rule extends Node {
  
  java.util.List<Expr> attrExpr
  
  def getExpr() { attrExpr }
  def setExpr(java.util.List<Expr> attrExpr) { this.attrExpr = attrExpr }
  
  def dispatch void add(Expr __expr) {
    this.attrExpr = this.attrExpr ?: newArrayList
    this.attrExpr += __expr
  }
  
  override Rule copy() {
    new Rule().copyAttributes()
  }
  
  protected def copyAttributes(Rule type) {
    super.copyAttributes(type)
    type.attrExpr = this.attrExpr
    return type
  }
  
  
}

 class Expr extends Node {
  
  override Expr copy() {
    new Expr().copyAttributes()
  }
  
  protected def copyAttributes(Expr type) {
    super.copyAttributes(type)
    return type
  }
  
  
}

