package types

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

 class ExprA extends Expr {
  
  override ExprA copy() {
    val r = new ExprA
    return r
  }
  
}

 class ExprB extends Expr {
  
  override ExprB copy() {
    val r = new ExprB
    return r
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
    val r = new Rule
    r.attrExpr = this.attrExpr
    return r
  }
  
}

abstract class Expr extends Node {
  
  override Expr copy()
  
}

