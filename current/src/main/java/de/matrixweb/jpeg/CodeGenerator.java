package de.matrixweb.jpeg;

import java.util.List;

/**
 * @author markusw
 */
public interface CodeGenerator {

  Parser buildInterpreter(List<RuleDescription> rules);

  /**
   * @param rules
   *          The parsed rules to build into the parser
   * @return Returns the parser source code
   */
  String build(List<RuleDescription> rules);

}
