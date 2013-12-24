package de.matrixweb.jpeg;

import java.io.File;

import org.junit.Test;
import org.junit.rules.ExpectedException;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

import de.matrixweb.jpeg.helper.AbstractCompilationTest;

/**
 * @author markusw
 */
@SuppressWarnings("javadoc")
public class GeneratedGrammarTest extends AbstractCompilationTest {

  @org.junit.Rule
  public ExpectedException exception = ExpectedException.none();

  @Test
  public void testFailLeftRecursion() throws Throwable {
    this.exception.expectMessage("Detected left-recursion");

    compileAndRun("Rule: Rule 'a';", "Rule", "aaa");
  }

  @Test
  public void testEscapedBracketInRangeExpression() throws Throwable {
    compileAndRun("Rule: [\\]];", "Rule", "]");
  }

  @Test
  public void testEscapedUnicodeInRangeExpression() throws Throwable {
    compileAndRun("Rule: [\\u000A];", "Rule", "\n");
  }

  @Test
  public void testEscapedBackslashInRangeExpression() throws Throwable {
    compileAndRun("Rule: [\\\\];", "Rule", "\\");
  }

  @Test
  public void testEcmaScriptGrammar() throws Throwable {
    compileAndRun(Files.toString(
        new File("src/test/resources/ecmascript.jpeg"), Charsets.UTF_8),
        "Program", Files.toString(new File("src/test/resources/underscore.js"),
            Charsets.UTF_8), true);
  }

  @Test
  public void testEcmaScriptGrammarRunOnly() throws Throwable {
    final testEcmaScriptGrammar.Parser parser = new testEcmaScriptGrammar.Parser();
    parser.Program(Files.toString(new File("src/test/resources/underscore.js"),
        Charsets.UTF_8));
  }

}
