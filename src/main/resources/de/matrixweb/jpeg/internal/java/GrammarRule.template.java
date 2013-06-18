class GrammarRule {

  private final String name;

  private final AbstractRuleAnnotation[] annotations;

  private final GrammarNode[] grammarNodes;

  public GrammarRule(final String name, final AbstractRuleAnnotation[] annotations, final GrammarNode[] grammarNodes) {
    this.name = name;
    this.annotations = annotations;
    this.grammarNodes = grammarNodes;
  }

  /**
   * @return the name
   */
  public String getName() {
    return this.name;
  }

  /**
   * @return the grammarNodes
   */
  public GrammarNode[] getGrammarNodes() {
    return this.grammarNodes;
  }

  public ParsingNode match(final JavaParser parser, final Input input) {
    final RuleMatchingContext context = new RuleMatchingContext(parser);
    String tail = input.getChars();
    while (hasNodes(context.getGrammarRuleIndex(), this.grammarNodes)) {
      final Input newInput = new Input(tail);
      GrammarNode next = getNextNode(context);
      context.setMatch(next.matches(context, newInput));
      if (context.isMatch()) {
        tail = newInput.getChars();
      } else if (hasNodes(context.getGrammarRuleIndex(), this.grammarNodes)) {
        tail = input.getChars();
        context.setGrammarRuleIndex(nextChoiceNode(this.grammarNodes,
            context.getGrammarRuleIndex()));
        context.clearParsingNodes();
      }
    }
    ParsingNode result = null;
    if (context.isMatch()) {
      result = new ParsingNode(true, this.name, filterParsingNodes(context.getParsingNodes()));
      input.setChars(tail);
    }
    return result;
  }

  private ParsingNode[] filterParsingNodes(ParsingNode[] nodes) {
    if (nodes == null) { return null; }
    List<ParsingNode> list = new ArrayList<ParsingNode>();
    for (ParsingNode node : nodes) {
      if (!isFiltered(node)) {
        list.add(node);
      }
    }
    return list.toArray(new ParsingNode[list.size()]);
  }

  private boolean isFiltered(ParsingNode node) {
    boolean result = false;
    for (AbstractRuleAnnotation annotation : annotations) {
      result |= annotation.filter(node);
    }
    return result;
  }

  private GrammarNode getNextNode(final RuleMatchingContext context) {
    return this.grammarNodes[context.incGrammarRuleIndex()];
  }

  private boolean hasNodes(final int n, final GrammarNode[] grammarNodes) {
    return n < grammarNodes.length;
  }

  private int nextChoiceNode(final GrammarNode[] grammarNodes, int n) {
    GrammarNode grammarNode = grammarNodes[n];
    while (grammarNode.getMatcher() != GrammarNodeMatcher.CHOICE
        && n + 1 < grammarNodes.length) {
      grammarNode = grammarNodes[++n];
    }
    return grammarNode.getMatcher() == GrammarNodeMatcher.CHOICE ? n
        : grammarNodes.length;
  }

  @Override
  public String toString() {
    return getName() + '{' + Arrays.toString(getGrammarNodes()) + '}';
  }

}
