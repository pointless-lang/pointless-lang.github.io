
import "dart:io";
import "dart:convert";

import "package:pointless/pointless.dart";

// ---------------------------------------------------------------------------

void main() {
  var preludeList = [];
  for (var path in PreludeFile.preludeFiles) {
    var basePath = "pointless/" + path.replaceFirst("../", "");
    var chars = SourceFile.getChars(basePath);
    var escapedChars = json.encode(chars).replaceAll("\$", "\\\$");
    preludeList.add(['"$basePath"', escapedChars]);
  }

  print("""var preludeList = $preludeList;""");
}
