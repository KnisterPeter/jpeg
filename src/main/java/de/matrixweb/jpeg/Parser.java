package de.matrixweb.jpeg;

/**
 * @author markusw
 */
public interface Parser {

  /**
   * @param startRule
   * @param input
   * @return
   */
  ParsingResult parse(String startRule, String input);

}
