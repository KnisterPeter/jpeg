package de.matrixweb.jpeg.internal

import java.util.List

/**
 * @author markusw
 */
class JType {
  
  @Property
  boolean internal
  
  @Property
  String name
  
  @Property
  JType supertype
  
  @Property
  List<JAttribute> attributes
  
}

class JAttribute {
  
  @Property
  String name
  
  @Property
  JType type
  
  @Property
  JType typeParameter
  
}
