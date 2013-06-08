package de.matrixweb.jpeg.internal.java;

import java.util.ArrayList;
import java.util.List;

import de.matrixweb.jpeg.internal.GrammarParser;

/**
 * @author markusw
 */
public class RuleMatchingContext {

  private final GrammarParser parser;

  private boolean match = true;

  private int grammarRuleIndex = 0;

  private List<ParsingNode> parsingNodes;

  /**
   * @param parser
   */
  public RuleMatchingContext(final GrammarParser parser) {
    this.parser = parser;
  }

  /**
   * @return the parser
   */
  public GrammarParser getParser() {
    return this.parser;
  }

  /**
   * @return the match
   */
  public boolean isMatch() {
    return this.match;
  }

  /**
   * @param match
   *          the match to set
   */
  public void setMatch(final boolean match) {
    this.match = match;
  }

  /**
   * @return the grammarRuleIndex
   */
  public int getGrammarRuleIndex() {
    return this.grammarRuleIndex;
  }

  /**
   * @return the next grammarRuleIndex
   */
  int incGrammarRuleIndex() {
    return this.grammarRuleIndex++;
  }

  /**
   * @param grammarRuleIndex
   *          the grammarRuleIndex to set
   */
  public void setGrammarRuleIndex(final int grammarRuleIndex) {
    this.grammarRuleIndex = grammarRuleIndex;
  }

  /**
   * 
   */
  public void endRuleMatching() {
    this.grammarRuleIndex = Integer.MAX_VALUE;
  }

  /**
   * @return Returns the parsed child nodes
   */
  public ParsingNode[] getParsingNodes() {
    return this.parsingNodes != null ? this.parsingNodes
        .toArray(new ParsingNode[this.parsingNodes.size()]) : null;
  }

  /**
   * @param node
   */
  public void addParsingNode(final ParsingNode node) {
    if (this.parsingNodes == null) {
      this.parsingNodes = new ArrayList<ParsingNode>();
    }
    this.parsingNodes.add(node);
  }

  void clearParsingNodes() {
    this.parsingNodes = null;
  }

}
