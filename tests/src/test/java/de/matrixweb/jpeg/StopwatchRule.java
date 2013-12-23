package de.matrixweb.jpeg;

import org.junit.rules.TestRule;
import org.junit.runner.Description;
import org.junit.runners.model.Statement;

/**
 * @author markusw
 */
public class StopwatchRule implements TestRule {

  /**
   * @see org.junit.rules.TestRule#apply(org.junit.runners.model.Statement,
   *      org.junit.runner.Description)
   */
  @Override
  public Statement apply(final Statement base, final Description description) {
    return new Statement() {
      @Override
      public void evaluate() throws Throwable {
        final long start = System.nanoTime();
        try {
          base.evaluate();
        } finally {
          final long end = System.nanoTime();
          final float ms = (end - start) / 1000000f;
          System.out.println(description + " took " + ms + "ms");
        }
      }
    };
  }

}
