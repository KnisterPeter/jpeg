package de.matrixweb.jpeg;

import java.io.IOException;

import org.eclipse.xtend.core.XtendInjectorSingleton;
import org.eclipse.xtend.core.compiler.batch.XtendCompilerTester;
import org.eclipse.xtend.core.macro.ProcessorInstanceForJvmTypeProvider;
import org.eclipse.xtext.util.IAcceptor;
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper;
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper.Result;

import com.google.inject.Inject;

/**
 * @author markusw
 */
@SuppressWarnings("all")
public class XtendCompilerUtil {

  @Inject
  CompilationTestHelper compilationTestHelper;

  public static XtendCompilerUtil newXtendCompilerUtil(
      final Class<?>... classesOnClassPath) {
    final XtendCompilerUtil instance = XtendInjectorSingleton.INJECTOR
        .getInstance(XtendCompilerUtil.class);
    instance.setJavaCompilerClassPath(classesOnClassPath);
    final ProcessorInstanceForJvmTypeProvider processorProvider = XtendInjectorSingleton.INJECTOR
        .getInstance(ProcessorInstanceForJvmTypeProvider.class);
    processorProvider
        .setClassLoader(XtendCompilerTester.class.getClassLoader());
    return instance;
  }

  public void setJavaCompilerClassPath(final Class<?>[] classesOnClassPath) {
    this.compilationTestHelper.setJavaCompilerClassPath(classesOnClassPath);
  }

  public void compile(final CharSequence source, final CompilerCallback callback)
      throws IOException {
    this.compilationTestHelper.configureFreshWorkspace();
    this.compilationTestHelper.compile(source,
        new IAcceptor<CompilationTestHelper.Result>() {
          @Override
          public void accept(final Result r) {
            callback.done(r);
          }
        });
  }

  public static interface CompilerCallback {

    void done(Result result);

  }

}
