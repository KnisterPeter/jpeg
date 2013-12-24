package testEcmaScriptGrammar

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

 class ExpressionStatement extends Node {
  
  Expression attrExpression
  
  def getExpression() { attrExpression }
  def setExpression(Expression attrExpression) { this.attrExpression = attrExpression }
  
  override ExpressionStatement copy() {
    val r = new ExpressionStatement
    r.attrExpression = this.attrExpression
    return r
  }
  
}

 class SourceCharacter extends Node {
  
  override SourceCharacter copy() {
    val r = new SourceCharacter
    return r
  }
  
}

 class RegularExpressionChar extends Node {
  
  override RegularExpressionChar copy() {
    val r = new RegularExpressionChar
    return r
  }
  
}

 class Punctuator extends Node {
  
  override Punctuator copy() {
    val r = new Punctuator
    return r
  }
  
}

 class BitwiseXORExpression extends Node {
  
  override BitwiseXORExpression copy() {
    val r = new BitwiseXORExpression
    return r
  }
  
}

 class SourceElements extends Node {
  
  override SourceElements copy() {
    val r = new SourceElements
    return r
  }
  
}

 class VariableDeclaration extends Node {
  
  Identifier attrIdentifier
  
  def getIdentifier() { attrIdentifier }
  def setIdentifier(Identifier attrIdentifier) { this.attrIdentifier = attrIdentifier }
  
  Initialiser attrInitialiser
  
  def getInitialiser() { attrInitialiser }
  def setInitialiser(Initialiser attrInitialiser) { this.attrInitialiser = attrInitialiser }
  
  override VariableDeclaration copy() {
    val r = new VariableDeclaration
    r.attrIdentifier = this.attrIdentifier
    r.attrInitialiser = this.attrInitialiser
    return r
  }
  
}

 class LabelledStatement extends Node {
  
  Identifier attrIdentifier
  
  def getIdentifier() { attrIdentifier }
  def setIdentifier(Identifier attrIdentifier) { this.attrIdentifier = attrIdentifier }
  
  Statement attrStatement
  
  def getStatement() { attrStatement }
  def setStatement(Statement attrStatement) { this.attrStatement = attrStatement }
  
  override LabelledStatement copy() {
    val r = new LabelledStatement
    r.attrIdentifier = this.attrIdentifier
    r.attrStatement = this.attrStatement
    return r
  }
  
}

 class InitialiserNoIn extends Node {
  
  AssignmentExpressionNoIn attrAssignmentExpressionNoIn
  
  def getAssignmentExpressionNoIn() { attrAssignmentExpressionNoIn }
  def setAssignmentExpressionNoIn(AssignmentExpressionNoIn attrAssignmentExpressionNoIn) { this.attrAssignmentExpressionNoIn = attrAssignmentExpressionNoIn }
  
  override InitialiserNoIn copy() {
    val r = new InitialiserNoIn
    r.attrAssignmentExpressionNoIn = this.attrAssignmentExpressionNoIn
    return r
  }
  
}

 class Identifier extends Node {
  
  override Identifier copy() {
    val r = new Identifier
    return r
  }
  
}

 class Finally extends Node {
  
  Block attrBlock
  
  def getBlock() { attrBlock }
  def setBlock(Block attrBlock) { this.attrBlock = attrBlock }
  
  override Finally copy() {
    val r = new Finally
    r.attrBlock = this.attrBlock
    return r
  }
  
}

 class FunctionExpression extends Node {
  
  Identifier attrIdentifier
  
  def getIdentifier() { attrIdentifier }
  def setIdentifier(Identifier attrIdentifier) { this.attrIdentifier = attrIdentifier }
  
  FormalParameterList attrFormalParameterList
  
  def getFormalParameterList() { attrFormalParameterList }
  def setFormalParameterList(FormalParameterList attrFormalParameterList) { this.attrFormalParameterList = attrFormalParameterList }
  
  FunctionBody attrFunctionBody
  
  def getFunctionBody() { attrFunctionBody }
  def setFunctionBody(FunctionBody attrFunctionBody) { this.attrFunctionBody = attrFunctionBody }
  
  override FunctionExpression copy() {
    val r = new FunctionExpression
    r.attrIdentifier = this.attrIdentifier
    r.attrFormalParameterList = this.attrFormalParameterList
    r.attrFunctionBody = this.attrFunctionBody
    return r
  }
  
}

 class Lu extends Node {
  
  override Lu copy() {
    val r = new Lu
    return r
  }
  
}

 class Lt extends Node {
  
  override Lt copy() {
    val r = new Lt
    return r
  }
  
}

 class AssignmentOperator extends Node {
  
  override AssignmentOperator copy() {
    val r = new AssignmentOperator
    return r
  }
  
}

 class FunctionDeclaration extends Node {
  
  Identifier attrIdentifier
  
  def getIdentifier() { attrIdentifier }
  def setIdentifier(Identifier attrIdentifier) { this.attrIdentifier = attrIdentifier }
  
  FormalParameterList attrFormalParameterList
  
  def getFormalParameterList() { attrFormalParameterList }
  def setFormalParameterList(FormalParameterList attrFormalParameterList) { this.attrFormalParameterList = attrFormalParameterList }
  
  FunctionBody attrFunctionBody
  
  def getFunctionBody() { attrFunctionBody }
  def setFunctionBody(FunctionBody attrFunctionBody) { this.attrFunctionBody = attrFunctionBody }
  
  override FunctionDeclaration copy() {
    val r = new FunctionDeclaration
    r.attrIdentifier = this.attrIdentifier
    r.attrFormalParameterList = this.attrFormalParameterList
    r.attrFunctionBody = this.attrFunctionBody
    return r
  }
  
}

 class BreakStatement extends Node {
  
  Identifier attrIdentifier
  
  def getIdentifier() { attrIdentifier }
  def setIdentifier(Identifier attrIdentifier) { this.attrIdentifier = attrIdentifier }
  
  override BreakStatement copy() {
    val r = new BreakStatement
    r.attrIdentifier = this.attrIdentifier
    return r
  }
  
}

 class Lm extends Node {
  
  override Lm copy() {
    val r = new Lm
    return r
  }
  
}

 class Comment extends Node {
  
  override Comment copy() {
    val r = new Comment
    return r
  }
  
}

 class Ll extends Node {
  
  override Ll copy() {
    val r = new Ll
    return r
  }
  
}

 class Lo extends Node {
  
  override Lo copy() {
    val r = new Lo
    return r
  }
  
}

 class UnicodeLetter extends Node {
  
  override UnicodeLetter copy() {
    val r = new UnicodeLetter
    return r
  }
  
}

 class RegularExpressionFlags extends Node {
  
  override RegularExpressionFlags copy() {
    val r = new RegularExpressionFlags
    return r
  }
  
}

 class NewExpression extends Node {
  
  override NewExpression copy() {
    val r = new NewExpression
    return r
  }
  
}

 class CallExpression extends Node {
  
  override CallExpression copy() {
    val r = new CallExpression
    return r
  }
  
}

 class ReturnStatement extends Node {
  
  Expression attrExpression
  
  def getExpression() { attrExpression }
  def setExpression(Expression attrExpression) { this.attrExpression = attrExpression }
  
  override ReturnStatement copy() {
    val r = new ReturnStatement
    r.attrExpression = this.attrExpression
    return r
  }
  
}

 class WhiteSpace extends Node {
  
  override WhiteSpace copy() {
    val r = new WhiteSpace
    return r
  }
  
}

 class VariableDeclarationListNoIn extends Node {
  
  override VariableDeclarationListNoIn copy() {
    val r = new VariableDeclarationListNoIn
    return r
  }
  
}

 class RelationalExpression extends Node {
  
  override RelationalExpression copy() {
    val r = new RelationalExpression
    return r
  }
  
}

 class Initialiser extends Node {
  
  AssignmentExpression attrAssignmentExpression
  
  def getAssignmentExpression() { attrAssignmentExpression }
  def setAssignmentExpression(AssignmentExpression attrAssignmentExpression) { this.attrAssignmentExpression = attrAssignmentExpression }
  
  override Initialiser copy() {
    val r = new Initialiser
    r.attrAssignmentExpression = this.attrAssignmentExpression
    return r
  }
  
}

 class UnaryExpression extends Node {
  
  override UnaryExpression copy() {
    val r = new UnaryExpression
    return r
  }
  
}

 class MultiLineNotForwardSlashOrAsteriskChar extends Node {
  
  override MultiLineNotForwardSlashOrAsteriskChar copy() {
    val r = new MultiLineNotForwardSlashOrAsteriskChar
    return r
  }
  
}

 class AdditiveExpression extends Node {
  
  override AdditiveExpression copy() {
    val r = new AdditiveExpression
    return r
  }
  
}

 class Mc extends Node {
  
  override Mc copy() {
    val r = new Mc
    return r
  }
  
}

 class MultiplicativeExpression extends Node {
  
  override MultiplicativeExpression copy() {
    val r = new MultiplicativeExpression
    return r
  }
  
}

 class FormalParameterList extends Node {
  
  override FormalParameterList copy() {
    val r = new FormalParameterList
    return r
  }
  
}

 class TryStatement extends Node {
  
  Block attrBlock
  
  def getBlock() { attrBlock }
  def setBlock(Block attrBlock) { this.attrBlock = attrBlock }
  
  Catch attrCatch
  
  def getCatch() { attrCatch }
  def setCatch(Catch attrCatch) { this.attrCatch = attrCatch }
  
  Finally attrFinally
  
  def getFinally() { attrFinally }
  def setFinally(Finally attrFinally) { this.attrFinally = attrFinally }
  
  override TryStatement copy() {
    val r = new TryStatement
    r.attrBlock = this.attrBlock
    r.attrCatch = this.attrCatch
    r.attrFinally = this.attrFinally
    return r
  }
  
}

 class UnicodeCombiningMark extends Node {
  
  override UnicodeCombiningMark copy() {
    val r = new UnicodeCombiningMark
    return r
  }
  
}

 class UnicodeDigit extends Node {
  
  override UnicodeDigit copy() {
    val r = new UnicodeDigit
    return r
  }
  
}

abstract class InputElementRegExp extends Node {
  
  override InputElementRegExp copy()
  
}

 class AssignmentExpression extends Node {
  
  override AssignmentExpression copy() {
    val r = new AssignmentExpression
    return r
  }
  
}

 class SourceElement extends Node {
  
  FunctionDeclaration attrFunctionDeclaration
  
  def getFunctionDeclaration() { attrFunctionDeclaration }
  def setFunctionDeclaration(FunctionDeclaration attrFunctionDeclaration) { this.attrFunctionDeclaration = attrFunctionDeclaration }
  
  Statement attrStatement
  
  def getStatement() { attrStatement }
  def setStatement(Statement attrStatement) { this.attrStatement = attrStatement }
  
  override SourceElement copy() {
    val r = new SourceElement
    r.attrFunctionDeclaration = this.attrFunctionDeclaration
    r.attrStatement = this.attrStatement
    return r
  }
  
}

 class __ extends Node {
  
  override __ copy() {
    val r = new __
    return r
  }
  
}

 class ConditionalExpression extends Node {
  
  override ConditionalExpression copy() {
    val r = new ConditionalExpression
    return r
  }
  
}

 class Mn extends Node {
  
  override Mn copy() {
    val r = new Mn
    return r
  }
  
}

 class Nl extends Node {
  
  override Nl copy() {
    val r = new Nl
    return r
  }
  
}

 class IdentifierStart extends Node {
  
  override IdentifierStart copy() {
    val r = new IdentifierStart
    return r
  }
  
}

 class BitwiseANDExpression extends Node {
  
  override BitwiseANDExpression copy() {
    val r = new BitwiseANDExpression
    return r
  }
  
}

 class SwitchStatement extends Node {
  
  Expression attrExpression
  
  def getExpression() { attrExpression }
  def setExpression(Expression attrExpression) { this.attrExpression = attrExpression }
  
  CaseBlock attrCaseBlock
  
  def getCaseBlock() { attrCaseBlock }
  def setCaseBlock(CaseBlock attrCaseBlock) { this.attrCaseBlock = attrCaseBlock }
  
  override SwitchStatement copy() {
    val r = new SwitchStatement
    r.attrExpression = this.attrExpression
    r.attrCaseBlock = this.attrCaseBlock
    return r
  }
  
}

 class Nd extends Node {
  
  override Nd copy() {
    val r = new Nd
    return r
  }
  
}

 class _ extends Node {
  
  override _ copy() {
    val r = new _
    return r
  }
  
}

 class Expression extends Node {
  
  override Expression copy() {
    val r = new Expression
    return r
  }
  
}

 class VariableDeclarationNoIn extends Node {
  
  Identifier attrIdentifier
  
  def getIdentifier() { attrIdentifier }
  def setIdentifier(Identifier attrIdentifier) { this.attrIdentifier = attrIdentifier }
  
  InitialiserNoIn attrInitialiserNoIn
  
  def getInitialiserNoIn() { attrInitialiserNoIn }
  def setInitialiserNoIn(InitialiserNoIn attrInitialiserNoIn) { this.attrInitialiserNoIn = attrInitialiserNoIn }
  
  override VariableDeclarationNoIn copy() {
    val r = new VariableDeclarationNoIn
    r.attrIdentifier = this.attrIdentifier
    r.attrInitialiserNoIn = this.attrInitialiserNoIn
    return r
  }
  
}

 class ThrowStatement extends Node {
  
  Expression attrExpression
  
  def getExpression() { attrExpression }
  def setExpression(Expression attrExpression) { this.attrExpression = attrExpression }
  
  override ThrowStatement copy() {
    val r = new ThrowStatement
    r.attrExpression = this.attrExpression
    return r
  }
  
}

 class RegularExpressionClassChar extends Node {
  
  override RegularExpressionClassChar copy() {
    val r = new RegularExpressionClassChar
    return r
  }
  
}

 class Block extends Node {
  
  override Block copy() {
    val r = new Block
    return r
  }
  
}

 class ContinueStatement extends Node {
  
  Identifier attrIdentifier
  
  def getIdentifier() { attrIdentifier }
  def setIdentifier(Identifier attrIdentifier) { this.attrIdentifier = attrIdentifier }
  
  override ContinueStatement copy() {
    val r = new ContinueStatement
    r.attrIdentifier = this.attrIdentifier
    return r
  }
  
}

 class BitwiseORExpressionNoIn extends Node {
  
  override BitwiseORExpressionNoIn copy() {
    val r = new BitwiseORExpressionNoIn
    return r
  }
  
}

 class RegularExpressionFirstChar extends Node {
  
  override RegularExpressionFirstChar copy() {
    val r = new RegularExpressionFirstChar
    return r
  }
  
}

 class RegularExpressionBackslashSequence extends Node {
  
  override RegularExpressionBackslashSequence copy() {
    val r = new RegularExpressionBackslashSequence
    return r
  }
  
}

 class RegularExpressionBody extends Node {
  
  override RegularExpressionBody copy() {
    val r = new RegularExpressionBody
    return r
  }
  
}

 class DebuggerStatement extends Node {
  
  override DebuggerStatement copy() {
    val r = new DebuggerStatement
    return r
  }
  
}

 class ConditionalExpressionNoIn extends Node {
  
  override ConditionalExpressionNoIn copy() {
    val r = new ConditionalExpressionNoIn
    return r
  }
  
}

 class EqualityExpression extends Node {
  
  override EqualityExpression copy() {
    val r = new EqualityExpression
    return r
  }
  
}

 class LeftHandSideExpression extends Node {
  
  override LeftHandSideExpression copy() {
    val r = new LeftHandSideExpression
    return r
  }
  
}

 class MemberExpression extends Node {
  
  override MemberExpression copy() {
    val r = new MemberExpression
    return r
  }
  
}

 class PostfixExpression extends Node {
  
  override PostfixExpression copy() {
    val r = new PostfixExpression
    return r
  }
  
}

 class BooleanLiteral extends Node {
  
  override BooleanLiteral copy() {
    val r = new BooleanLiteral
    return r
  }
  
}

 class UnicodeConnectorPunctuation extends Node {
  
  override UnicodeConnectorPunctuation copy() {
    val r = new UnicodeConnectorPunctuation
    return r
  }
  
}

 class ArgumentList extends Node {
  
  override ArgumentList copy() {
    val r = new ArgumentList
    return r
  }
  
}

 class CaseClause extends Node {
  
  Expression attrExpression
  
  def getExpression() { attrExpression }
  def setExpression(Expression attrExpression) { this.attrExpression = attrExpression }
  
  StatementList attrStatementList
  
  def getStatementList() { attrStatementList }
  def setStatementList(StatementList attrStatementList) { this.attrStatementList = attrStatementList }
  
  override CaseClause copy() {
    val r = new CaseClause
    r.attrExpression = this.attrExpression
    r.attrStatementList = this.attrStatementList
    return r
  }
  
}

 class LogicalANDExpressionNoIn extends Node {
  
  override LogicalANDExpressionNoIn copy() {
    val r = new LogicalANDExpressionNoIn
    return r
  }
  
}

 class NullLiteral extends Node {
  
  override NullLiteral copy() {
    val r = new NullLiteral
    return r
  }
  
}

 class ShiftExpression extends Node {
  
  override ShiftExpression copy() {
    val r = new ShiftExpression
    return r
  }
  
}

 class SingleLineComment extends Node {
  
  override SingleLineComment copy() {
    val r = new SingleLineComment
    return r
  }
  
}

 class StatementList extends Node {
  
  override StatementList copy() {
    val r = new StatementList
    return r
  }
  
}

 class VariableStatement extends Node {
  
  VariableDeclarationList attrVariableDeclarationList
  
  def getVariableDeclarationList() { attrVariableDeclarationList }
  def setVariableDeclarationList(VariableDeclarationList attrVariableDeclarationList) { this.attrVariableDeclarationList = attrVariableDeclarationList }
  
  override VariableStatement copy() {
    val r = new VariableStatement
    r.attrVariableDeclarationList = this.attrVariableDeclarationList
    return r
  }
  
}

 class RegularExpressionLiteral extends Node {
  
  override RegularExpressionLiteral copy() {
    val r = new RegularExpressionLiteral
    return r
  }
  
}

 class RegularExpressionClass extends Node {
  
  override RegularExpressionClass copy() {
    val r = new RegularExpressionClass
    return r
  }
  
}

 class VariableDeclarationList extends Node {
  
  override VariableDeclarationList copy() {
    val r = new VariableDeclarationList
    return r
  }
  
}

 class BitwiseANDExpressionNoIn extends Node {
  
  override BitwiseANDExpressionNoIn copy() {
    val r = new BitwiseANDExpressionNoIn
    return r
  }
  
}

 class ExpressionNoIn extends Node {
  
  override ExpressionNoIn copy() {
    val r = new ExpressionNoIn
    return r
  }
  
}

 class Program extends Node {
  
  SourceElements attrSourceElements
  
  def getSourceElements() { attrSourceElements }
  def setSourceElements(SourceElements attrSourceElements) { this.attrSourceElements = attrSourceElements }
  
  override Program copy() {
    val r = new Program
    r.attrSourceElements = this.attrSourceElements
    return r
  }
  
}

 class PostAsteriskCommentChars extends Node {
  
  override PostAsteriskCommentChars copy() {
    val r = new PostAsteriskCommentChars
    return r
  }
  
}

 class BitwiseORExpression extends Node {
  
  override BitwiseORExpression copy() {
    val r = new BitwiseORExpression
    return r
  }
  
}

 class IterationStatement extends Node {
  
  override IterationStatement copy() {
    val r = new IterationStatement
    return r
  }
  
}

 class RegularExpressionNonTerminator extends Node {
  
  override RegularExpressionNonTerminator copy() {
    val r = new RegularExpressionNonTerminator
    return r
  }
  
}

 class Arguments extends Node {
  
  override Arguments copy() {
    val r = new Arguments
    return r
  }
  
}

 class DivPunctuator extends Node {
  
  override DivPunctuator copy() {
    val r = new DivPunctuator
    return r
  }
  
}

 class Pc extends Node {
  
  override Pc copy() {
    val r = new Pc
    return r
  }
  
}

 class CaseClauses extends Node {
  
  java.util.List<CaseClause> attrCaseClause
  
  def getCaseClause() { attrCaseClause }
  def setCaseClause(java.util.List<CaseClause> attrCaseClause) { this.attrCaseClause = attrCaseClause }
  
  def dispatch void add(CaseClause __caseClause) {
    this.attrCaseClause = this.attrCaseClause ?: newArrayList
    this.attrCaseClause += __caseClause
  }
  
  override CaseClauses copy() {
    val r = new CaseClauses
    r.attrCaseClause = this.attrCaseClause
    return r
  }
  
}

 class MultiLineComment extends Node {
  
  override MultiLineComment copy() {
    val r = new MultiLineComment
    return r
  }
  
}

 class IdentifierPart extends Node {
  
  override IdentifierPart copy() {
    val r = new IdentifierPart
    return r
  }
  
}

 class LogicalORExpressionNoIn extends Node {
  
  override LogicalORExpressionNoIn copy() {
    val r = new LogicalORExpressionNoIn
    return r
  }
  
}

 class Keyword extends Node {
  
  override Keyword copy() {
    val r = new Keyword
    return r
  }
  
}

 class ReservedWord extends Node {
  
  override ReservedWord copy() {
    val r = new ReservedWord
    return r
  }
  
}

 class FunctionBody extends Node {
  
  SourceElements attrSourceElements
  
  def getSourceElements() { attrSourceElements }
  def setSourceElements(SourceElements attrSourceElements) { this.attrSourceElements = attrSourceElements }
  
  override FunctionBody copy() {
    val r = new FunctionBody
    r.attrSourceElements = this.attrSourceElements
    return r
  }
  
}

 class RegularExpressionChars extends Node {
  
  override RegularExpressionChars copy() {
    val r = new RegularExpressionChars
    return r
  }
  
}

 class Statement extends Node {
  
  override Statement copy() {
    val r = new Statement
    return r
  }
  
}

 class Catch extends Node {
  
  Identifier attrIdentifier
  
  def getIdentifier() { attrIdentifier }
  def setIdentifier(Identifier attrIdentifier) { this.attrIdentifier = attrIdentifier }
  
  Block attrBlock
  
  def getBlock() { attrBlock }
  def setBlock(Block attrBlock) { this.attrBlock = attrBlock }
  
  override Catch copy() {
    val r = new Catch
    r.attrIdentifier = this.attrIdentifier
    r.attrBlock = this.attrBlock
    return r
  }
  
}

 class DefaultClause extends Node {
  
  StatementList attrStatementList
  
  def getStatementList() { attrStatementList }
  def setStatementList(StatementList attrStatementList) { this.attrStatementList = attrStatementList }
  
  override DefaultClause copy() {
    val r = new DefaultClause
    r.attrStatementList = this.attrStatementList
    return r
  }
  
}

 class LogicalANDExpression extends Node {
  
  override LogicalANDExpression copy() {
    val r = new LogicalANDExpression
    return r
  }
  
}

 class AssignmentExpressionNoIn extends Node {
  
  override AssignmentExpressionNoIn copy() {
    val r = new AssignmentExpressionNoIn
    return r
  }
  
}

 class MultiLineCommentChars extends Node {
  
  override MultiLineCommentChars copy() {
    val r = new MultiLineCommentChars
    return r
  }
  
}

 class LogicalORExpression extends Node {
  
  override LogicalORExpression copy() {
    val r = new LogicalORExpression
    return r
  }
  
}

 class CaseBlock extends Node {
  
  CaseClauses attrCaseClauses
  
  def getCaseClauses() { attrCaseClauses }
  def setCaseClauses(CaseClauses attrCaseClauses) { this.attrCaseClauses = attrCaseClauses }
  
  DefaultClause attrDefaultClause
  
  def getDefaultClause() { attrDefaultClause }
  def setDefaultClause(DefaultClause attrDefaultClause) { this.attrDefaultClause = attrDefaultClause }
  
  override CaseBlock copy() {
    val r = new CaseBlock
    r.attrCaseClauses = this.attrCaseClauses
    r.attrDefaultClause = this.attrDefaultClause
    return r
  }
  
}

 class PrimaryExpression extends Node {
  
  override PrimaryExpression copy() {
    val r = new PrimaryExpression
    return r
  }
  
}

 class FutureReservedWord extends Node {
  
  override FutureReservedWord copy() {
    val r = new FutureReservedWord
    return r
  }
  
}

 class SingleLineCommentChar extends Node {
  
  override SingleLineCommentChar copy() {
    val r = new SingleLineCommentChar
    return r
  }
  
}

 class Token extends Node {
  
  override Token copy() {
    val r = new Token
    return r
  }
  
}

 class EmptyStatement extends Node {
  
  override EmptyStatement copy() {
    val r = new EmptyStatement
    return r
  }
  
}

abstract class InputElementDiv extends Node {
  
  override InputElementDiv copy()
  
}

 class EqualityExpressionNoIn extends Node {
  
  override EqualityExpressionNoIn copy() {
    val r = new EqualityExpressionNoIn
    return r
  }
  
}

 class LineTerminator extends Node {
  
  override LineTerminator copy() {
    val r = new LineTerminator
    return r
  }
  
}

 class MultiLineNotAsteriskChar extends Node {
  
  override MultiLineNotAsteriskChar copy() {
    val r = new MultiLineNotAsteriskChar
    return r
  }
  
}

 class MultiLineCommentNoLineTerminator extends Node {
  
  override MultiLineCommentNoLineTerminator copy() {
    val r = new MultiLineCommentNoLineTerminator
    return r
  }
  
}

 class RegularExpressionClassChars extends Node {
  
  override RegularExpressionClassChars copy() {
    val r = new RegularExpressionClassChars
    return r
  }
  
}

 class LineTerminatorSequence extends Node {
  
  override LineTerminatorSequence copy() {
    val r = new LineTerminatorSequence
    return r
  }
  
}

 class RelationalExpressionNoIn extends Node {
  
  override RelationalExpressionNoIn copy() {
    val r = new RelationalExpressionNoIn
    return r
  }
  
}

 class IfStatement extends Node {
  
  Expression attrExpression
  
  def getExpression() { attrExpression }
  def setExpression(Expression attrExpression) { this.attrExpression = attrExpression }
  
  Statement attrIfStatement
  
  def getIfStatement() { attrIfStatement }
  def setIfStatement(Statement attrIfStatement) { this.attrIfStatement = attrIfStatement }
  
  Statement attrElseStatement
  
  def getElseStatement() { attrElseStatement }
  def setElseStatement(Statement attrElseStatement) { this.attrElseStatement = attrElseStatement }
  
  override IfStatement copy() {
    val r = new IfStatement
    r.attrExpression = this.attrExpression
    r.attrIfStatement = this.attrIfStatement
    r.attrElseStatement = this.attrElseStatement
    return r
  }
  
}

 class SingleLineCommentChars extends Node {
  
  override SingleLineCommentChars copy() {
    val r = new SingleLineCommentChars
    return r
  }
  
}

 class IdentifierName extends Node {
  
  override IdentifierName copy() {
    val r = new IdentifierName
    return r
  }
  
}

 class BitwiseXORExpressionNoIn extends Node {
  
  override BitwiseXORExpressionNoIn copy() {
    val r = new BitwiseXORExpressionNoIn
    return r
  }
  
}

 class Zs extends Node {
  
  override Zs copy() {
    val r = new Zs
    return r
  }
  
}

 class WithStatement extends Node {
  
  Expression attrExpression
  
  def getExpression() { attrExpression }
  def setExpression(Expression attrExpression) { this.attrExpression = attrExpression }
  
  Statement attrStatement
  
  def getStatement() { attrStatement }
  def setStatement(Statement attrStatement) { this.attrStatement = attrStatement }
  
  override WithStatement copy() {
    val r = new WithStatement
    r.attrExpression = this.attrExpression
    r.attrStatement = this.attrStatement
    return r
  }
  
}

