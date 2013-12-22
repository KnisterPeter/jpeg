package de.matrixweb.jpeg

import java.io.File

import static com.google.common.base.Charsets.*

import static extension com.google.common.io.Files.*
import static extension de.matrixweb.jpeg.internal.Generator.*
import static extension de.matrixweb.jpeg.internal.Parser.*
import static extension de.matrixweb.jpeg.internal.RuleWalker.*

class JPEG {

  def generate(File file, String packageName) {
    if(file == null) throw new IllegalArgumentException('file must not be null')
    file.toString(UTF_8).generate(packageName)
  }
  
  def generate(String grammar, String packageName) {
    grammar.parseAndGenerate(packageName)
  }

  private def parseAndGenerate(String grammar, String packageName) {
    var pair = grammar.jpeg()
    
    val jpeg = pair.key
    val types = jpeg.createTypes()
    
    val sb = new StringBuilder
    sb.append(jpeg.generateParser(types, packageName))
    sb.append(types.values.generateTypes())
    return sb.toString
  }
  
}
