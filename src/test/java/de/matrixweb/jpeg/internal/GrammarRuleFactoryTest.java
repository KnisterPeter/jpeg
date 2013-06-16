package de.matrixweb.jpeg.internal;

import org.junit.Test;

import de.matrixweb.jpeg.RuleDescription;
import de.matrixweb.jpeg.internal.GrammarParser.Context;

import static org.junit.Assert.*;

import static org.hamcrest.CoreMatchers.*;

/**
 * @author markusw
 */
public class GrammarRuleFactoryTest {

  /** */
  @Test
  public void readRule() {
    final Context context = new GrammarParser.Context(
        "name:body;".toCharArray());
    final RuleDescription rule = GrammarRuleFactory.create(context
        .getRuleContext());
    assertThat(rule, is(not(nullValue())));
    assertThat(rule.getName(), is("name"));
    assertThat(rule.getNodes().length, is(1));
  }

  /** */
  @Test
  public void readRuleWithoutName() {
    final Context context = new GrammarParser.Context("body;".toCharArray());
    final RuleDescription rule = GrammarRuleFactory.create(context
        .getRuleContext());
    assertThat(rule, is(nullValue()));
  }

  /** */
  @Test
  public void readRuleWithoutBody() {
    final Context context = new GrammarParser.Context("name:".toCharArray());
    final RuleDescription rule = GrammarRuleFactory.create(context
        .getRuleContext());
    assertThat(rule, is(nullValue()));
  }

  /** */
  @Test
  public void readRuleWithBodyParts() {
    final Context context = new GrammarParser.Context(
        "name:body1 ';' body2;".toCharArray());
    final RuleDescription rule = GrammarRuleFactory.create(context
        .getRuleContext());
    assertThat(rule, is(not(nullValue())));
    assertThat(rule.getName(), is("name"));
    assertThat(rule.getNodes().length, is(3));
  }

  /** */
  @Test
  public void readTerminalRuleWithEscapedQuote() {
    final Context context = new GrammarParser.Context(
        "name:'\\\'';".toCharArray());
    final RuleDescription rule = GrammarRuleFactory.create(context
        .getRuleContext());
    assertThat(rule, is(not(nullValue())));
    assertThat(rule.getName(), is("name"));
    assertThat(rule.getNodes().length, is(1));
    assertThat(rule.getNodes()[0].getPlainValue(), is("'"));
  }

  /** */
  @Test
  public void readTerminalRuleWithEscapedEscape() {
    final Context context = new GrammarParser.Context(
        "name:'\\\\';".toCharArray());
    final RuleDescription rule = GrammarRuleFactory.create(context
        .getRuleContext());
    assertThat(rule, is(not(nullValue())));
    assertThat(rule.getName(), is("name"));
    assertThat(rule.getNodes().length, is(1));
    assertThat(rule.getNodes()[0].getPlainValue(), is("\\"));
  }

}
