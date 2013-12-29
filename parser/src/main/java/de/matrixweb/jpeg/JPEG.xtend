package de.matrixweb.jpeg

import de.matrixweb.jpeg.internal.Parser
import java.io.File

import static com.google.common.base.Charsets.*

import static extension com.google.common.io.Files.*
import static extension de.matrixweb.jpeg.internal.AstToTypeConverter.*
import static extension de.matrixweb.jpeg.internal.AstValidator.*
import static extension de.matrixweb.jpeg.internal.Generator.*
import static extension de.matrixweb.jpeg.internal.GeneratorHelper.*

class JPEG {

  static def generate(File file, String packageName) {
    if(file == null) throw new IllegalArgumentException('file must not be null')
    file.toString(UTF_8).generate(packageName)
  }

  static def generate(String grammar, String packageName) {
    grammar.parseAndGenerate(packageName)
  }

  static private def parseAndGenerate(String grammar, String packageName) {
    extension val parser = new Parser
    var jpeg = grammar.unescaped.Jpeg()
    jpeg.validate(parser)
    
    val types = jpeg.createTypes()

    return #{
      'Parser.xtend' -> jpeg.generateParser(types, packageName),
      'Types.xtend' -> types.values.generateTypes(packageName)
    }
  }

  static def main(String... args) {
    if (args.length < 3) {
      println('''
        Usage:
          java -jar jpeg.jar <input-grammar> <target-package> <output-folder>
      ''')
    }
    val sources = generate(new File(args.get(0)), args.get(1));
    for (file : sources.entrySet) {
      file.value.write(new File(args.get(2), file.key), UTF_8);
    }
  }

}
