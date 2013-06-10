package de.matrixweb.jpeg;

/**
 * @author markusw
 */
public interface Parser {

  ParsingResult parse(final String rule, final String input);

}
