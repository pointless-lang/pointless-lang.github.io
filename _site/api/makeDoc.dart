
import "dart:io";
import "dart:core";

// ---------------------------------------------------------------------------
// https://bugzilla.mozilla.org/show_bug.cgi?id=1362154
// (can't use named groups in js - highlight.js uses getExports)

var namesPattern = r"^\s*export\s*{([a-zA-Z0-9,\s]*)}";

Set<String> getExports(String exportsText) {
  var namesExpr = RegExp(namesPattern, multiLine: true);
  // groups are 1 indexed
  var nameStr = namesExpr.firstMatch(exportsText)?.group(1) ?? "";

  return {
    for (var name in nameStr.split(","))
    if (name.trim().isNotEmpty)
    name.trim()
  };
}

// ---------------------------------------------------------------------------

var pattern = r"^-{10,}\n(?<doc>(?:^--.*\s)*)(?:(?:[ ]*--.*)?\s)*\n(?<def>[a-zA-Z0-9]+(?:\([ a-zA-Z0-9,]*\))?)\s*=";

getDocs(String path, String exportsPath) {
  var exportsText = File(exportsPath).readAsStringSync();
  var names = getExports(exportsText);

  var text = File(path).readAsStringSync();
  var expr = RegExp(pattern, multiLine: true);
  var matches = expr.allMatches(text);

  var startDocLine = RegExp(r"-- ?");
  var entries = [];

  for (var match in matches) {
    var doc = match.namedGroup("doc");
    var def = match.namedGroup("def");

    var defName = def.split("(").first;
    if (names.isNotEmpty && !names.contains(defName)) {
      continue;
    }

    var docText = [
      for (var line in doc.split("\n"))
      line.replaceFirst(startDocLine, "")
    ].join("\n");

    entries.add("<hr>");
    entries.add("<strong id='$defName'>$def</strong>");
    entries.add("<a href='#$defName' class='anchor'>link</a>");

    if (docText != "") {
      entries.add("<pre class='doc'>$docText</pre>");
    }
  }

  return entries.join("\n");
}
  
// ---------------------------------------------------------------------------

main(List<String> args) {
  var path = args[0];
  var exportsPath = args[1];  

  var fileName = path.split("/").last;
  var sourceLink = """
    (<a href='https://github.com/pointless-lang/pointless/tree/master/prelude/$fileName'>source</a>)""";

  print("""
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Pointless API Docs: $path</title>
    <link rel="stylesheet" type="text/css" href="../docStyle.css">
  </head>

  <body>
    <main>
      <h1>Pointless API Docs</h1>
      <h2>$path $sourceLink</h2>

      ${getDocs(path, exportsPath)}
    </main>
  </body>
</html>
  """);
}
