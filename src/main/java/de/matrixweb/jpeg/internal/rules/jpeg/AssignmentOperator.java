package de.matrixweb.jpeg.internal.rules.jpeg;

import de.matrixweb.jpeg.internal.io.InputReader;
import de.matrixweb.jpeg.internal.rules.ParserRule;
import de.matrixweb.jpeg.internal.rules.RuleCallback;
import de.matrixweb.jpeg.internal.rules.RuleMismatchException;
import de.matrixweb.jpeg.internal.type.String;
import de.matrixweb.jpeg.internal.type.Type;
import static de.matrixweb.jpeg.internal.matcher.Shortcuts.*;
import static de.matrixweb.jpeg.internal.rules.RuleHelper.*;

/**
 * @author markusw
 */
public class AssignmentOperator implements Type<AssignmentOperator> {

  private String single;

  private String multi;

  /**
   * @see de.matrixweb.jpeg.internal.type.Type#copy()
   */
  @Override
  public AssignmentOperator copy() {
    final AssignmentOperator copy = new AssignmentOperator();
    copy.single = this.single != null ? this.single.copy() : null;
    copy.multi = this.multi != null ? this.multi.copy() : null;
    return copy;
  }

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
    @SuppressWarnings("unchecked")
    @Override
    protected AssignmentOperator consume(final InputReader reader)
        throws RuleMismatchException {
      AssignmentOperator operator = new AssignmentOperator();

      // @formatter:off
      // single='=' | multi='+='
      operator = Choice(operator, reader, new RuleCallback<AssignmentOperator>() {
        @Override
        public AssignmentOperator run(final AssignmentOperator assignmentOperator, final InputReader reader) throws RuleMismatchException {
          // single='='
          assignmentOperator.setSingle(T("=").match(reader));
          return assignmentOperator;
        }
      }, new RuleCallback<AssignmentOperator>() {
        @Override
        public AssignmentOperator run(final AssignmentOperator assignmentOperator, final InputReader reader) throws RuleMismatchException {
          // multi='+='
          assignmentOperator.setMulti(T("+=").match(reader));
          return assignmentOperator;
        }
      });
      
      // @formatter:on

      return operator;
    }

  }

}
