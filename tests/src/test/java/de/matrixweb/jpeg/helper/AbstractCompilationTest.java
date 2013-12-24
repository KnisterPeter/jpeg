package de.matrixweb.jpeg.helper;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import org.eclipse.xtend.lib.Data;
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper.Result;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.junit.rules.TestName;

import com.google.common.base.Charsets;
import com.google.common.base.Objects;
import com.google.common.io.Files;

import de.matrixweb.jpeg.JPEG;
import de.matrixweb.jpeg.helper.XtendCompilerUtil.CompilerCallback;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
@SuppressWarnings("javadoc")
public abstract class AbstractCompilationTest {

  @org.junit.Rule
  public TestName name = new TestName();

  private final XtendCompilerUtil compiler = XtendCompilerUtil
      .newXtendCompilerUtil(Objects.class, Exceptions.class, Data.class);

  protected void compile(final String packageName, final String... inputs)
      throws IOException {
    final Map<String, CharSequence> files = new HashMap<String, CharSequence>();

    final File base = new File("src/main/java", packageName);
    for (final String input : inputs) {
      final File file = new File(base, input);
      files
          .put(packageName + '/' + input, Files.toString(file, Charsets.UTF_8));
    }

    this.compiler.compile(files, new CompilerCheck(packageName));
  }

  protected void compileAndRun(final String grammar, final String startRule,
      final String input) throws Throwable {
    compileAndRun(grammar, startRule, input, false);
  }

  protected void compileAndRun(final String grammar, final String startRule,
      final String input, final boolean printSource) throws Throwable {
    final String packageName = this.name.getMethodName();
    System.out.println("Starting generation, compilation and execution of "
        + packageName);
    final Map<String, CharSequence> files = JPEG.generate(grammar, packageName);
    System.out.println("\t...generated parser");
    final File file = new File("src/main/java/", packageName);
    if (printSource) {
      file.mkdirs();
      for (final Entry<String, CharSequence> entry : files.entrySet()) {
        Files.write(entry.getValue(), new File(file, entry.getKey()),
            Charsets.UTF_8);
      }
    }
    try {
      final CompilerCheck cc = new CompilerCheck(packageName);
      cc.startRule = startRule;
      cc.input = input;
      this.compiler.compile(files, cc);
    } catch (final Throwable t) {
      unwrap(t);
    }
  }

  private static class CompilerCheck implements CompilerCallback {

    private final String packageName;

    String startRule;

    String input;

    public CompilerCheck(final String packageName) {
      this.packageName = packageName;
    }

    @Override
    public void done(final Result result) {
      System.out.println("\t...compiled parser");
      try {
        final Class<?> clazz = result.getCompiledClass(this.packageName
            + ".Parser");
        final Object parser = clazz.newInstance();
        assertThat(parser, is(notNullValue()));

        if (this.startRule != null && this.input != null) {
          final Method method = clazz.getMethod(this.startRule, String.class);
          method.invoke(parser, this.input);
          System.out.println("\t...executed parser");
        }
      } catch (final Throwable t) {
        throw new WrapException(t);
      }
    }

  }

  private void unwrap(final Throwable t) throws Throwable {
    Throwable parse = t;
    while (parse != null
        && !parse.getClass().getSimpleName().equals("ParseException")) {
      parse = parse.getCause();
    }
    if (parse != null
        && parse.getClass().getSimpleName().equals("ParseException")) {
      throw parse;
    }
    throw t;
  }

  private static class WrapException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public WrapException(final Throwable cause) {
      super(cause);
    }

  }

}
