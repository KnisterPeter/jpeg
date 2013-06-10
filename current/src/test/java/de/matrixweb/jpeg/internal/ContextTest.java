package de.matrixweb.jpeg.internal;

import org.junit.Test;

import de.matrixweb.jpeg.internal.GrammarParser.Context;
import de.matrixweb.jpeg.internal.GrammarParser.Context.RuleContext;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public class ContextTest {

  /**
   * 
   */
  @Test
  public void testRuleContextReadUntil() {
    final Context context = new Context("abcdefgh".toCharArray());
    RuleContext rc = context.getRuleContext();
    assertThat(rc.readUntil('z'), is(nullValue()));
    assertThat(rc.readUntil('d'), is("abcd"));
    assertThat(rc.readUntil('d'), is(nullValue()));
    rc.consume();
    rc = context.getRuleContext();
    assertThat(rc.readUntil('h'), is("efgh"));
  }

}
