static interface Type {

  Type create(ParsingNode node);

  MetaClass getMClass();

  Object getValue();

}
