class GrammarRule {

  private final String name;

  private final String resultType;

  private final GrammarNode[] grammarNodes;

  public GrammarRule(final String name, final String resultType,
      final GrammarNode[] grammarNodes) {
    this.name = name;
    this.resultType = resultType;
    this.grammarNodes = grammarNodes;
  }

  public ParsingNode match(final JavaParser parser, final Input input) {
    final RuleMatchingContext context = new RuleMatchingContext(parser);
    String tail = input.getChars();
    while (hasNodes(context.getGrammarRuleIndex())) {
      final Input newInput = new Input(tail);
      GrammarNode next = getNextNode(context);
      context.setMatch(next.exec(context, newInput));
      if (context.isMatch()) {
        tail = newInput.getChars();
      } else if (hasNodes(context.getGrammarRuleIndex())) {
        tail = input.getChars();
        context.setGrammarRuleIndex(nextChoiceNode(context
            .getGrammarRuleIndex()));
        context.clearParsingNodes();
      }
    }
    ParsingNode result = null;
    if (context.isMatch()) {
      ParsingNode[] children = this.removeInternalParsingNodes(
          context.getParsingNodes()).toArray(new ParsingNode[0]);

      result = new ParsingNode(true, this.name, children);
      JavaParser.Type type = parser.getType(this.resultType);
      if (type != null) {
        // TODO: Cleanup AST generation and do not use ParsingNode here
        result = new ParsingNode(true, this.name, children, type.create(result));
      }
      input.setChars(tail);
    }
    return result;
  }

  private List<ParsingNode> removeInternalParsingNodes(ParsingNode[] nodes) {
    List<ParsingNode> children = new ArrayList<ParsingNode>();
    for (ParsingNode node : nodes) {
      if (node.getValue().startsWith("internal_")) {
        children.addAll(this.removeInternalParsingNodes(node.getChildren()));
      } else {
        children.add(node);
      }
    }
    return children;
  }

  private GrammarNode getNextNode(final RuleMatchingContext context) {
    return this.grammarNodes[context.incGrammarRuleIndex()];
  }

  private boolean hasNodes(final int n) {
    return n < this.grammarNodes.length;
  }

  private int nextChoiceNode(int n) {
    GrammarNode grammarNode = this.grammarNodes[n];
    while (grammarNode.getMatcher() != GrammarNodeMatcher.CHOICE
        && n + 1 < this.grammarNodes.length) {
      grammarNode = this.grammarNodes[++n];
    }
    return grammarNode.getMatcher() == GrammarNodeMatcher.CHOICE ? n
        : this.grammarNodes.length;
  }

  @Override
  public String toString() {
    return this.name + '{' + Arrays.toString(this.grammarNodes) + '}';
  }

}
