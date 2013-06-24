static class MetaString implements Type {

  // TODO: Is this required?
  private final MetaClass mclass;
  
  private final String value;
  
  public MetaString create(ParsingNode node) {
    final StringBuilder str = new StringBuilder();
    for (final ParsingNode child : node.getChildren()) {
      if (child.getChildren().length == 0) {
        str.append(child.getValue());
      } else {
        str.append(create(child).getValue());
      }
    }
    return new MetaString(str.toString());
  }

  /**
   * Type Factory Constructor
   */
  MetaString() {
    this.mclass = null;
    this.value = null;
  }
  
  /**
   * @param value
   */
  private MetaString(String value) {
    this.mclass = new MetaClass("MetaString");
    this.value = value;
  }
  
  /**
   * @return the mclass
   */
  public MetaClass getMClass() {
    return this.mclass;
  }
  
  /**
   * @return the value
   */
  public String getValue() {
    return this.value;
  }
  
}
