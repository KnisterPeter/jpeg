package de.matrixweb.jpeg;

/**
 * This specifies the generated parser.
 * 
 * @author markusw
 */
public interface Parser {

  /**
   * @param startRule
   * @param input
   * @return Returns the parsing result of the input with the given startRule
   */
  ParsingResult parse(String startRule, String input);

}
