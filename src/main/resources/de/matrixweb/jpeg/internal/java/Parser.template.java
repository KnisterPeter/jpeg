package {{$package}};

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author markusw
 */
public class {{$name}} {

  private static final Map<String, Type> types = new HashMap<String, Type>();
  static {
    types.put("MetaString", new MetaString());
  }
  
  private static final Map<String, GrammarRule> rules = new HashMap<String, GrammarRule>();
  static {
    {{for rule in rules}}
    rules.put("{{$rule.name}}", new GrammarRule("{{$rule.name}}", "{{$rule.type}}", new GrammarNode[] {
        {{for node in rule.Nodes}}
        new GrammarNode(GrammarNodeMatcher.{{$node.matcher}}, "{{$node.value}}"),
        {{/for}}
      }));
    {{/for}}
  }

  /**
   * @param startRule
   * @param input
   * @return ...
   */
  ParsingNode parse(final String startRule, final Input input) {
    final GrammarRule rule = {{$name}}.rules.get(startRule);
    if (rule == null) {
      throw new JPEGParserException("Rule '" + startRule + "' is unknown");
    }
    return rule.match(this, input);
  }

  {{for rule in publicRules}}
  /**
   * @param input
   * @return Returns the parsing result of this operation
   */
  public static ParsingResult {{$rule.name}}(final String input) {
    return new ParsingResult(new {{$name}}().parse("{{$rule.name}}", new Input(input)));
  }
  
  {{/for}}
  
  Type getType(String name) {
    return types.get(name);
  }

  // {{reference ParsingResult.template.java}}
  // {{reference Utils.template.java}}
  // {{reference JPEGParserException.template.java}}
  // {{reference types/MetaClass.template.java}}
  // {{reference types/MetaString.template.java}}
  // {{reference types/Type.template.java}}

}
// {{reference ParsingNode.template.java}}
// {{reference GrammarNode.template.java}}
// {{reference GrammarRule.template.java}}
// {{reference Input.template.java}}
// {{reference RuleMatchingContext.template.java}}
// {{reference matcher/AbstractPredicateMatcher.template.java}}
// {{reference matcher/AndPredicateMatcher.template.java}}
// {{reference matcher/AnyCharMatcher.template.java}}
// {{reference matcher/ChoiceMatcher.template.java}}
// {{reference matcher/EndOfInputMatcher.template.java}}
// {{reference matcher/GrammarNodeMatcher.template.java}}
// {{reference matcher/NotPredicateMatcher.template.java}}
// {{reference matcher/OneOrMoreMatcher.template.java}}
// {{reference matcher/OptionalMatcher.template.java}}
// {{reference matcher/RuleMatcher.template.java}}
// {{reference matcher/TerminalMatcher.template.java}}
// {{reference matcher/ZeroOrMoreMatcher.template.java}}
