abstract class AbstractRuleAnnotation {
	
  public boolean filter(ParsingNode node) { return false; }

}
class HiddenRuleAnnotation extends AbstractRuleAnnotation {

  private final List<String> names;

  public HiddenRuleAnnotation(String[] names) {
    this.names = Arrays.asList(names);
  }

  public boolean filter(ParsingNode node) {
    return node.isRuleNode() && names.contains(node.getValue());
  }

}
class ReturnsRuleAnnotation extends AbstractRuleAnnotation {
}
class InternalRuleAnnotation extends AbstractRuleAnnotation {

  public boolean filter(ParsingNode node) {
    return false;
  }

}
