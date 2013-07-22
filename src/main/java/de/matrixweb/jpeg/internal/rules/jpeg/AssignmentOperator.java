package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.Mutable;
import de.matrixweb.jpeg.internal.type.String;
import de.matrixweb.jpeg.internal.type.Type;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;

/**
 * @author markusw
 */
public class AssignmentOperator implements Type {

  private String single;

  private String multi;

  /**
   * @return the single
   */
  public String getSingle() {
    return this.single;
  }

  /**
   * @param single
   *          the single to set
   */
  public void setSingle(final String single) {
    this.single = single;
  }

  /**
   * @return the multi
   */
  public String getMulti() {
    return this.multi;
  }

  /**
   * @param multi
   *          the multi to set
   */
  public void setMulti(final String multi) {
    this.multi = multi;
  }

  /** */
  public static class GrammarRule extends ParserRule<AssignmentOperator> {

    /**
     * @see de.matrixweb.jpeg.internal.rules.ParserRule#consume(de.matrixweb.jpeg.internal.io.InputReader)
     */
    @Override
    protected AssignmentOperator consume(final InputReader reader)
        throws RuleMismatchException {
      final Mutable<String> single = new Mutable<String>(new String());
      final Mutable<String> multi = new Mutable<String>(new String());

      // @formatter:off
      // single='=' | multi='+='
      Choice(reader, new RuleCallback() {
        @Override
        public void run(final InputReader reader) throws RuleMismatchException {
          // single='='
          single.getValue().add(T("=").match(reader));
        }
      }, new RuleCallback() {
        @Override
        public void run(final InputReader reader) throws RuleMismatchException {
          // multi='+='
          multi.getValue().add(T("+=").match(reader));
        }
      });
      
      // @formatter:on

      final AssignmentOperator operator = new AssignmentOperator();
      operator.setSingle(single.getValue());
      operator.setMulti(multi.getValue());
      return operator;
    }

  }

}
