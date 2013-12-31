package de.matrixweb.djeypeg;

import java.io.File;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

import de.matrixweb.djeypeg.helper.AbstractCompilationTest;

/**
 * @author markusw
 */
@SuppressWarnings("javadoc")
public class GeneratedGrammarTest extends AbstractCompilationTest {

  @org.junit.Rule
  public ExpectedException exception = ExpectedException.none();

  @Test
  public void testLeftRecursion() throws Throwable {
    compileAndRun("Rule <- Rule 'a' / 'a';", "Rule", "aaaa");
  }

  @Test
  public void testFailLeftRecursion() throws Throwable {
    this.exception.expectMessage("Detected non-terminating left-recursion");
    compileAndRun("Rule <- Rule 'a';", "Rule", "aaaa");
  }

  @Ignore
  @Test
  public void testIndirectLeftRecursion() throws Throwable {
    compileAndRun("X <- Expr; Expr <- X '-' '1'|'1';", "X", "1-1");
  }

  @Test
  public void testEscapedBracketInRangeExpression() throws Throwable {
    compileAndRun("Rule <- [\\]];", "Rule", "]");
  }

  @Test
  public void testEscapedUnicodeInRangeExpression() throws Throwable {
    compileAndRun("Rule <- [\\u000A];", "Rule", "\n");
  }

  @Test
  public void testEscapedBackslashInRangeExpression() throws Throwable {
    compileAndRun("Rule <- [\\\\];", "Rule", "\\");
  }

  @Ignore
  @Test
  public void testEcmaScriptGrammar() throws Throwable {
    compileAndRun(Files.toString(new File(
        "src/test/resources/ecmascript.djeypeg"), Charsets.UTF_8), "Program",
        Files.toString(new File("src/test/resources/underscore.js"),
            Charsets.UTF_8), true);
  }

  @Ignore
  @Test
  public void testEcmaScriptGrammarRunOnly() throws Throwable {
    // final testEcmaScriptGrammar.Parser parser = new
    // testEcmaScriptGrammar.Parser();
    // parser.Program(Files.toString(new
    // File("src/test/resources/underscore.js"),
    // Charsets.UTF_8));
  }

}
