package de.matrixweb.jpeg.helper;

import java.io.IOException;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import org.eclipse.xtend.core.XtendInjectorSingleton;
import org.eclipse.xtend.core.compiler.batch.XtendCompilerTester;
import org.eclipse.xtend.core.macro.ProcessorInstanceForJvmTypeProvider;
import org.eclipse.xtext.util.IAcceptor;
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper;
import org.eclipse.xtext.xbase.compiler.CompilationTestHelper.Result;
import org.eclipse.xtext.xbase.lib.Pair;

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

  public void compile(final Map<String, CharSequence> files,
      final CompilerCallback callback) throws IOException {
    final Pair<String, CharSequence>[] pairs = new Pair[files.size()];
    files.entrySet();
    int i = 0;
    final Iterator<Entry<String, CharSequence>> it = files.entrySet()
        .iterator();
    while (it.hasNext()) {
      final Entry<String, CharSequence> file = it.next();
      pairs[i] = new Pair<String, CharSequence>(file.getKey(), file.getValue());
      i++;
    }

    this.compilationTestHelper.compile(
        this.compilationTestHelper.resourceSet(pairs),
        new IAcceptor<CompilationTestHelper.Result>() {
          @Override
          public void accept(final Result r) {
            callback.done(r);
          }
        });
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
