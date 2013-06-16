package de.matrixweb.jpeg.internal;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.tools.FileObject;
import javax.tools.ForwardingJavaFileManager;
import javax.tools.JavaCompiler;
import javax.tools.JavaFileManager;
import javax.tools.JavaFileObject;
import javax.tools.JavaFileObject.Kind;
import javax.tools.SimpleJavaFileObject;
import javax.tools.StandardJavaFileManager;

import org.eclipse.jdt.internal.compiler.tool.EclipseCompiler;

import de.matrixweb.jpeg.CodeGenerator;
import de.matrixweb.jpeg.JPEGParserException;
import de.matrixweb.jpeg.RuleDescription;

/**
 * @author markusw
 */
public class JavaGenerator implements CodeGenerator {

  private final String name;

  /**
   * @param name
   */
  public JavaGenerator(final String name) {
    this.name = name;
  }

  /**
   * @see de.matrixweb.jpeg.CodeGenerator#build(java.util.List)
   */
  @Override
  public String build(final List<RuleDescription> rules) {
    final Template tmpl = new Template();
    final String packageName = this.name.substring(0,
        this.name.lastIndexOf('.'));
    final String className = this.name
        .substring(this.name.lastIndexOf('.') + 1);

    final Map<String, Object> parameters = new HashMap<String, Object>();
    parameters.put("package", packageName);
    parameters.put("name", className);
    parameters.put("rules", rules);
    return tmpl.render("de/matrixweb/jpeg/internal/java",
        "Parser.template.java", parameters).replace("JavaParser", className);
  }

  /**
   * @param target
   * @param source
   */
  public void compile(final File target, final String source) {
    final JavaCompiler compiler = new EclipseCompiler();
    final StandardJavaFileManager sjfm = compiler.getStandardFileManager(null,
        null, null);
    try {
      final List<JavaFileObject> cu = new ArrayList<JavaFileObject>();
      cu.add(new SimpleJavaFileObject(URI.create("file:///"
          + this.name.replace('.', '/') + Kind.SOURCE.extension), Kind.SOURCE) {
        @Override
        public CharSequence getCharContent(final boolean ignoreEncodingErrors) {
          return source;
        }
      });
      compiler.getTask(null, new TargetFileManager(sjfm, target), null, null,
          null, cu).call();
    } finally {
      try {
        sjfm.close();
      } catch (final IOException e) {
        throw new JPEGParserException("Failed to close compiler file manager",
            e);
      }
    }
  }

  @SuppressWarnings({ "rawtypes", "unchecked" })
  private static class TargetFileManager extends ForwardingJavaFileManager {

    private final File target;

    /**
     * @param fileManager
     */
    TargetFileManager(final JavaFileManager fileManager, final File target) {
      super(fileManager);
      this.target = target;
    }

    @Override
    public JavaFileObject getJavaFileForOutput(final Location location,
        final String className, final Kind kind, final FileObject sibling)
        throws IOException {
      final File dir = new File(this.target, className.substring(0,
          className.lastIndexOf('/')));
      if (!dir.exists() && !dir.mkdirs()) {
        throw new IOException("Failed to create parent directories " + dir);
      }
      return new SimpleJavaFileObject(URI.create("file:///" + className
          + Kind.CLASS.extension), Kind.CLASS) {
        @Override
        public OutputStream openOutputStream() throws IOException {
          return new FileOutputStream(new File(TargetFileManager.this.target,
              className + Kind.CLASS.extension));
        }
      };
    }
  }

}
