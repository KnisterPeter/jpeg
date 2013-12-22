package de.matrixweb.jpeg.internal

import java.util.List

/**
 * @author markusw
 */
class JType {

  /**
   * The internal flag defines if the rule which declares this type is generated.
   * Internal types are just for type hierarchy.
   */
  @Property
  boolean internal

  /**
   * If false this type is not generated but predefined.
   */
  @Property
  boolean generate

  /**
   * The type name
   */
  @Property
  String name

  /**
   * This types supertype
   */
  @Property
  JType supertype

  /**
   * The type attributes
   */
  @Property
  List<JAttribute> attributes

}

class JAttribute {

  /**
   * The attribute name
   */
  @Property
  String name

  /**
   * The attribute type
   */
  @Property
  JType type

  /**
   * The attribute type parameter if the attribute type is a generic one
   */
  @Property
  JType typeParameter

}
